#!/usr/bin/python3
import my_script_utils

my_script_utils.enter_pid_namespace()

import argparse
import os
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
args = parser.parse_args()

import subprocess

subprocess.run([
    "ffmpeg",
    "-hide_banner",
    "-loglevel", "info",
    # Copy input timestamps
    # "-copyts",
    # "-accurate_seek",
    # # Seek
    # "-ss", "4:00",
    # TODO: check
    # -seek_timestamp (input)
    #   This option enables or disables seeking by timestamp in input files with the -ss option. It is disabled by default. If enabled, the argument to the -ss option is considered an actual timestamp, and is not offset by the start time of the file. This matters only for files which do not start from timestamp 0, such as transport streams.

    # Input file
    "-i",
    args.i,
    # Do not copy any metadata
    "-map_metadata", "-1",
    # Set encoder time base to time base from the demuxer
    "-enc_time_base", "demux",
    # video
    "-map", "0:v:0", # TODO
    # video filters
    "-vf",
    ",".join([
        # Fix PTS (frame presentation timestamp) so that is a multiple of frame_rate as exactly as possible.
        "setpts=round(PTS*FRAME_RATE*TB)/FRAME_RATE/TB",
        # Scale video up to 4K
        "scale=3840:2160:force_original_aspect_ratio=decrease:flags=lanczos+accurate_rnd+full_chroma_int",
        # Centre it
        "pad=3840:2160:(ow-iw)/2:(oh-ih)/2",
        # Burn subtitles in 4k so that they look best after we downscale them with lanczos to 1080p - it is way better visually than rendering them directly in 1080p
        ":".join([
            # TODO: subtitles from work dir
            f"subtitles='{args.s}'",
            # Ensure the fonts are rendered in 4K without renderer guessing the video size.
            "original_size=3840x2160",
            "force_style='FontName=Ubuntu-R,Outline=0.6'",
        ]),
        # Scale down with lanczos to FHD
        "scale=1920:1080:flags=lanczos+accurate_rnd+full_chroma_int",
    ]),
    # Video codec
    "-c:v", "libx264",
    # Video codec params
    "-crf", "18",
    "-profile:v", "high",
    "-level", "4.1",
    "-pix_fmt", "yuv420p",
    # For x264 faster produces smaller size than fast, medium and slow
    "-preset", "faster",
    "-tune", "film",
    # Audio
    "-map", "0:a:0", # TODO
    # Audio codec
    "-c:a", "aac",
    # Audio channels
    "-ac", "2",
    # Audio bitrate
    "-b:a", "192k",
    # Audio sampling rate
    "-ar", "48000",
    # Output container flags for mp4
    "-movflags", "+faststart",
    args.o,
], check=True)

# from collections import OrderedDict
# import json
# import select
# import socket
# import time

# subprocess.run([
#     'swaymsg',
#     '--quiet',
    
# ])
