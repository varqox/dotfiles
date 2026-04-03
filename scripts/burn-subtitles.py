#!/usr/bin/python3
import my_script_utils

my_script_utils.enter_pid_namespace()

import argparse
import sys

parser = argparse.ArgumentParser(
    prog=sys.argv[0],
    description='Transcode with subtitles burned in'
)
parser.add_argument('-i', required=True, metavar='INPUT_FILE', help='Input file')
parser.add_argument('-s', required=True, metavar='SUBTITLES_FILE', help='Subtitles file (in SRT format)')
parser.add_argument('-o', required=True, metavar='OUTPUT_FILE', help='Output file')
parser.add_argument('-v', metavar='NUM', help='Use ffmpeg stream NUM as video')
parser.add_argument('-a', metavar='NUM', help='Use ffmpeg stream NUM as audio')
parser.add_argument('-d', '--debug', action='store_true')
args = parser.parse_args()

import math

MIN_SEGMENT_SIZE_SEC = 10

TMP_VIDEO_TIME_BASE_DENOMINATOR = math.lcm(24000, 25000, 30000, 60000, 1000000)

AUDIO_SAMPLING_RATE = 48000
# TMP_AUDIO_TIME_BASE_DENOMINATOR = math.lcm(AUDIO_SAMPLING_RATE, 1000000) # TODO: unneeded?
AUDIO_CHANNELS = 6 # 5.1 surround
AUDIO_BITRATE = "384k"
# AUDIO_CHANNELS = 2
# AUDIO_BITRATE = "192k"

def print_debug(msg):
    print(f"\x1b[0;33m{msg}\x1b[0m", file=sys.stderr)

def print_info(msg):
    print(f"\x1b[0;1m{msg}\x1b[0m", file=sys.stderr)

def print_error(msg):
    print(f"\x1b[0;1;31m{msg}\x1b[0m", file=sys.stderr)

def print_warning(msg):
    print(f"\x1b[0;1;33m{msg}\x1b[0m", file=sys.stderr)

def exit_error(msg):
    print_error(msg)
    sys.exit(1)

from pathlib import Path
import subprocess
import json

def get_stream_start_time(file_path, stream_spec):
    return float(json.loads(subprocess.check_output([
        "ffprobe",
        "-v", "error",
        "-i",
        file_path,
        "-select_streams", stream_spec,
        "-show_entries",
        "stream=start_time",
        "-of", "json",
    ]))["streams"][0]["start_time"])

class Options:
    def __init__(self):
        self.options = []

    def add_option(self, name, value=None):
        self.options.append(name)
        if value is not None:
            self.options.append(str(value))

ffmpeg_global_options = Options()
ffmpeg_global_options.add_option("-y") # Overwrite the output files without asking.
ffmpeg_global_options.add_option("-hide_banner")
ffmpeg_global_options.add_option("-loglevel", "info") # TODO: warning and progress parsing with ETA
# ffmpeg_global_options.add_option("-progress", "pipe:2") # TODO: check if progress works
# ffmpeg_global_options.add_option("-debug_ts") # TODO

# Prepare working directory
workdir = Path('workdir') # TODO: workdir somewhere e.g. alongside output dir
workdir.mkdir(exist_ok=True)

video_segment_dir_name = "video_segments"
Path(workdir, video_segment_dir_name).mkdir(exist_ok=True)
audio_segment_dir_name = "audio_segments"
Path(workdir, audio_segment_dir_name).mkdir(exist_ok=True)

def collect_done_segments(segment_dir_name):
    done_segments = []
    while True:
        segment_path = Path(segment_dir_name, f"{len(done_segments)}.mp4")
        if not Path(workdir, segment_path).exists():
            break

        done_segments.append(segment_path)
    return done_segments

def save_ffconcat_file_of_segments(ffconcat_file_path, segments):
    global workdir
    with ffconcat_file_path.open(mode='w') as f:
        print('ffconcat version 1.0', file=f)
        for path in segments:
            print(f"file {path}", file=f)

def get_resume_timestamp(stream_start_time, done_segments):
    if len(done_segments) == 0:
        return stream_start_time

    lowest_pts_time = None
    highest_resume_pts_time = None
    global workdir
    ffconcat_file_path = Path(workdir, "resuming.ffconcat")
    save_ffconcat_file_of_segments(ffconcat_file_path, done_segments)
    for packet in json.loads(subprocess.check_output([
        "ffprobe",
        "-v", "error",
        "-f", "concat",
        "-i", f"{ffconcat_file_path}",
        "-select_streams", "0",
        "-show_entries", "packet=pts_time,duration_time",
        "-of", "json"
    ]))["packets"]:
        pts_time = float(packet["pts_time"])
        duration_time = float(packet["duration_time"])

        if lowest_pts_time is None or pts_time < lowest_pts_time:
            lowest_pts_time = pts_time

        resume_pts_time = pts_time + duration_time * 2 / 3 # Leave some gap for rounding errors inside input file
        if highest_resume_pts_time is None or resume_pts_time > highest_resume_pts_time:
            highest_resume_pts_time = resume_pts_time

    return video_stream_start_time + (highest_resume_pts_time - lowest_pts_time)

video_stream_start_time = get_stream_start_time(args.i, "v:0") # TODO: stream spec
if args.debug:
    print_debug(f"video_stream_start_time: {video_stream_start_time}")

done_video_segments = collect_done_segments(video_segment_dir_name)
video_resume_timestamp = get_resume_timestamp(video_stream_start_time, done_video_segments)

if args.debug:
    print_debug(f"video_resume_timestamp: {video_resume_timestamp}")

ffmpeg_input_options = Options()
# Ensure seeking is accurate.
ffmpeg_input_options.add_option("-accurate_seek")
# Seek by PTS.
ffmpeg_input_options.add_option("-seek_timestamp", 1)
# Use absolute timestamps when seeking instead of relative from start_pts.
ffmpeg_input_options.add_option("-copyts")
ffmpeg_input_options.add_option("-ss", video_resume_timestamp)
ffmpeg_input_options.add_option("-i", args.i)

# Copy subtitles to workdir so that we don't need to escape the path
safe_subtitles_path = Path(workdir, 'subs')
Path(args.s).copy(safe_subtitles_path)

ffmpeg_output_options = Options()
# Do not copy any metadata
ffmpeg_output_options.add_option("-map_metadata", -1)
# Do not change the frame stream
ffmpeg_output_options.add_option("-fps_mode", "passthrough")
# Set the video stream to transcode
ffmpeg_output_options.add_option("-map", "0:v:0") # TODO: stream spec
# Set encoder time base
ffmpeg_output_options.add_option("-vf", ",".join([
    # Increase timestamp precision.
    f"settb=expr=1/{TMP_VIDEO_TIME_BASE_DENOMINATOR}",
    # Subtract start_pts from pts so that PTS is multiple of frame rate.
    f"setpts=PTS-{round(video_stream_start_time * TMP_VIDEO_TIME_BASE_DENOMINATOR)}",
    # Fix frames' PTS imprecision coming from the input container by rounding the PTS to the nearest
    # frame_rate multiple. We do that with fps filter because it also fixes duration of the frame
    # to be correct -- especially the last one.
    "fps=fps=source_fps:round=near",
    # Scale video up to 4K
    "scale=3840:2160:force_original_aspect_ratio=decrease:flags=lanczos+accurate_rnd+full_chroma_int",
    # Centre it
    "pad=3840:2160:(ow-iw)/2:(oh-ih)/2",
    # Burn subtitles in 4k so that they look best after we downscale them with lanczos to 1080p - it is way better visually than rendering them directly in 1080p
    ":".join([
        f"subtitles={safe_subtitles_path}",
        # Ensure the fonts are rendered in 4K without renderer guessing the video size.
        "original_size=3840x2160",
        "force_style='FontName=Ubuntu-R,Outline=0.6'", # TODO: ensure the font is installed
    ]),
    # Scale down with lanczos to FHD
    "scale=1920:1080:flags=lanczos+accurate_rnd+full_chroma_int",
]))
# Video codec
ffmpeg_output_options.add_option("-c:v", "libx264"),
# Video codec params
ffmpeg_output_options.add_option("-crf", 18)
ffmpeg_output_options.add_option("-profile:v", "high")
ffmpeg_output_options.add_option("-level", "4.1")
ffmpeg_output_options.add_option("-pix_fmt", "yuv420p")
# For x264 faster produces smaller size than fast, medium and slow
ffmpeg_output_options.add_option("-preset", "faster")
ffmpeg_output_options.add_option("-tune", "film")
# Output as segments
ffmpeg_output_options.add_option("-f", "segment")
ffmpeg_output_options.add_option("-segment_time", MIN_SEGMENT_SIZE_SEC)
ffmpeg_output_options.add_option("-segment_format", "mp4")
# Realign segment timestamps to start at 0
ffmpeg_output_options.add_option("-reset_timestamps", "1")
ffmpeg_output_options.add_option("-segment_start_number", len(done_video_segments))
ffmpeg_output_options.add_option("--", f"{Path(workdir, video_segment_dir_name)}/%d.mp4")

def run_ffmpeg(*options):
    ffmpeg_command = ["ffmpeg"]
    for opts in options:
        ffmpeg_command.extend(opts.options)

    global args
    if args.debug:
        print_debug(f"running: {" ".join([f'"{x}"' for x in ffmpeg_command])}")

    subprocess.run(ffmpeg_command, check=True)

run_ffmpeg(ffmpeg_global_options, ffmpeg_input_options, ffmpeg_output_options)

audio_stream_start_time = get_stream_start_time(args.i, "a:0") # TODO: stream spec
if args.debug:
    print_debug(f"audio_stream_start_time: {audio_stream_start_time}")

done_audio_segments = collect_done_segments(audio_segment_dir_name)
audio_resume_timestamp = get_resume_timestamp(audio_stream_start_time, done_audio_segments)

if args.debug:
    print_debug(f"audio_resume_timestamp: {audio_resume_timestamp}")

ffmpeg_input_options = Options()
# Ensure seeking is accurate.
ffmpeg_input_options.add_option("-accurate_seek")
# Seek by PTS.
ffmpeg_input_options.add_option("-seek_timestamp", 1)
# Use absolute timestamps when seeking instead of relative from start_pts.
ffmpeg_input_options.add_option("-copyts")
ffmpeg_input_options.add_option("-ss", audio_resume_timestamp)
ffmpeg_input_options.add_option("-i", args.i)

ffmpeg_output_options = Options()
# Do not copy any metadata
ffmpeg_output_options.add_option("-map_metadata", -1)
# Set the audio stream to transcode
ffmpeg_output_options.add_option("-map", "0:a:0") # TODO: stream spec
# Set encoder time base
ffmpeg_output_options.add_option("-af", ",".join([
    # Resample the audio
    f"aresample={AUDIO_SAMPLING_RATE}:{":".join([
        # fill holes with silence and trim overlaps
        "async=1",
    ])}",
]))
# Audio codec
ffmpeg_output_options.add_option("-c:a", "aac")
# Audio channels
ffmpeg_output_options.add_option("-ac", AUDIO_CHANNELS)
# Audio bitrate
ffmpeg_output_options.add_option("-b:a", AUDIO_BITRATE)
# Audio sampling rate
ffmpeg_output_options.add_option("-ar", AUDIO_SAMPLING_RATE)
# Output as segments
ffmpeg_output_options.add_option("-f", "segment")
ffmpeg_output_options.add_option("-segment_time", MIN_SEGMENT_SIZE_SEC)
ffmpeg_output_options.add_option("-segment_format", "mp4")
# Realign segment timestamps to start at 0
ffmpeg_output_options.add_option("-reset_timestamps", "1")
ffmpeg_output_options.add_option("-segment_start_number", len(done_audio_segments))
ffmpeg_output_options.add_option("--", f"{Path(workdir, audio_segment_dir_name)}/%d.mp4")

run_ffmpeg(ffmpeg_global_options, ffmpeg_input_options, ffmpeg_output_options)

# Compose the final file
common_start_time = min(video_stream_start_time, audio_stream_start_time)
done_video_segments = collect_done_segments(video_segment_dir_name)
done_audio_segments = collect_done_segments(audio_segment_dir_name)

video_ffconcat_file_path = Path(workdir, "video.ffconcat")
save_ffconcat_file_of_segments(video_ffconcat_file_path, done_video_segments)

audio_ffconcat_file_path = Path(workdir, "audio.ffconcat")
save_ffconcat_file_of_segments(audio_ffconcat_file_path, done_audio_segments)

input_video_options = Options()
input_video_options.add_option("-f", "concat")
input_video_options.add_option("-itsoffset", video_stream_start_time - common_start_time)
input_video_options.add_option("-i", video_ffconcat_file_path)

input_audio_options = Options()
input_audio_options.add_option("-f", "concat")
input_audio_options.add_option("-itsoffset", audio_stream_start_time - common_start_time)
input_audio_options.add_option("-i", audio_ffconcat_file_path)

# video_transient_output_options = Options()
# video_transient_output_options.add_option("-map", "0:v:0")
# video_transient_output_options.add_option("-c", "copy")
# video_transient_output_options.add_option("-output_ts_offset", video_stream_start_time - common_start_time)
# video_transient_output_options.add_option("-f", "null")
# video_transient_output_options.add_option("-")

# audio_transient_output_options = Options()
# audio_transient_output_options.add_option("-map", "1:a:0")
# audio_transient_output_options.add_option("-c", "copy")
# audio_transient_output_options.add_option("-output_ts_offset", audio_stream_start_time - common_start_time)
# audio_transient_output_options.add_option("-f", "null")
# audio_transient_output_options.add_option("-")

final_output_options = Options()
final_output_options.add_option("-map", "0:v:0")
final_output_options.add_option("-map", "1:a:0")
# Copy streams
final_output_options.add_option("-c", "copy")
# Ensure MOV header (mp4) is written at the file beginning.
final_output_options.add_option("-movflags", "+faststart")
final_output_options.add_option("--", args.o)

run_ffmpeg(ffmpeg_global_options, input_video_options, input_audio_options, final_output_options)

sys.exit(0)

# Output container flags for mp4

sys.exit(0)


# ffmpeg_command = [
#     "ffmpeg",
#     "-hide_banner",
#     "-loglevel", "info",
#     # Copy input timestamps, instead of changing them.
#     "-copyts",
#     # "-seek_timestamp", "1", # TODO
#     "-y", # Overwrite file if exists
# ]

# # Seek to continue transcoding
# if start_sec is not None:
#     ffmpeg_command.extend([
#         # Ensure seeking is accurate.
#         "-accurate_seek",
#         # Use absolute timestamps when seeking instead of relative from start_pts.
#         "-seek_timestamp", "1",
#         # Seek so that the
#         "-ss", f"{start_sec}",
#     ])

ffmpeg_command.extend([
    "-to", "10",
    # Input file
    "-i", args.i,
    # Do not copy any metadata
    "-map_metadata", "-1",
    # Do not change frame stream
    "-fps_mode", "passthrough",
    # Fix time base that encoder sees.
    # "-enc_time_base", "1/600000",
    # video
    "-map", "0:v:0", # TODO
    # video filters
    "-vf",
    ",".join([
        "showinfo",
        # "settb=expr=1/600000",
        "showinfo",
        # Fix PTS (frame presentation timestamp) so that is a multiple of frame_rate as exactly as possible counting from STARTPTS.
        "setpts=PTS-STARTPTS",
        "fps=fps=source_fps:round=near",
        "showinfo",
        # "showinfo",
        # Scale video up to 4K
        "scale=3840:2160:force_original_aspect_ratio=decrease:flags=lanczos+accurate_rnd+full_chroma_int",
        # Centre it
        "pad=3840:2160:(ow-iw)/2:(oh-ih)/2",
        # Burn subtitles in 4k so that they look best after we downscale them with lanczos to 1080p - it is way better visually than rendering them directly in 1080p
        ":".join([
            f"subtitles={subs_in_workdir_path}",
            # Ensure the fonts are rendered in 4K without renderer guessing the video size.
            "original_size=3840x2160",
            "force_style='FontName=Ubuntu-R,Outline=0.6'",
        ]),
        # Scale down with lanczos to FHD
        "scale=1920:1080:flags=lanczos+accurate_rnd+full_chroma_int",
        "showinfo",
    ]),
    # Video codec
    "-c:v", "libx264",
    "-bf", "0", # TODO
    # Video codec params
    "-crf", "18",
    "-profile:v", "high",
    "-level", "4.1",
    "-pix_fmt", "yuv420p",
    # For x264 faster produces smaller size than fast, medium and slow
    "-preset", "faster",
    "-tune", "film",
    # Output container flags for mp4
    # "-movflags", "+faststart", # TODO: do this when concating at the end
    # Output length limit
    # "-video_track_timescale", "600000",
    # "-f", "segment",
    # "-segment_time", "10",
    # "-segment_format", "mp4",
    # # "-segment_format_options", "movflags=+faststart",
    # # Preserve the PTS values
    # "-reset_timestamps", "0",
    # # Continue writing segments from this number
    # "-segment_start_number", "1",
    f"{video_segment_dir}/%d.mp4",
    # "-f", "framemd5", "frames.txt",
    # "-frames:v", "100000", "frames/%05d.bmp",
])
    # # Audio
    # "-map", "0:a:0", # TODO
    # # Audio codec
    # "-c:a", "aac",
    # # Audio channels
    # "-ac", "2",
    # # Audio bitrate
    # "-b:a", "192k",
    # # Audio sampling rate
    # "-ar", "48000",

# TODO: add ubuntu font dependency during installing

for x in ffmpeg_command:
    print(f' "{x}"', end='')
print()

subprocess.run(ffmpeg_command, check=True)


  # -f segment \
  #   -segment_time         "$SEG_TIME" \
  #   -segment_format       "$SEG_FMT" \
  #   -segment_start_number "$NEXT_SEG" \
  #   -reset_timestamps     0 \
  #   -segment_list         "${STREAM}_resume.ffconcat" \
  #   -segment_list_type    ffconcat \
  #   -segment_list_flags   +live \
  # "${STREAM}_%05d.${SEG_FMT}"

# from collections import OrderedDict
# import json
# import select
# import socket
# import time

# subprocess.run([
#     'swaymsg',
#     '--quiet',
    
# ])
