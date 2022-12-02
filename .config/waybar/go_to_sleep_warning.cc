// Compile with: g++ -std=c++17 go_to_sleep_warning.cc -o go_to_sleep_warning -pthread -O2
#include <array>
#include <chrono>
#include <csignal>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <fcntl.h>
#include <iostream>
#include <optional>
#include <string.h>
#include <string>
#include <sys/file.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <time.h>
#include <unistd.h>
#include <utility>

using std::cout;
using std::endl;

void exit_group(int status) { syscall(SYS_exit_group, status); }

void die(const char* str) noexcept {
    fprintf(
        stderr, "error on %s - %s = %s\n", str, strerrorname_np(errno),
        strerrordesc_np(errno));
    exit_group(1);
}

template <class T>
constexpr T round_up_to_multiple_of(T num, T multiple) {
    auto rem = num % multiple;
    return rem == 0 ? num : num - rem + multiple;
};
static_assert(round_up_to_multiple_of(0, 4) == 0);
static_assert(round_up_to_multiple_of(1, 4) == 4);
static_assert(round_up_to_multiple_of(2, 4) == 4);
static_assert(round_up_to_multiple_of(3, 4) == 4);
static_assert(round_up_to_multiple_of(4, 4) == 4);
static_assert(round_up_to_multiple_of(5, 4) == 8);
static_assert(round_up_to_multiple_of(70, 15) == 75);
static_assert(round_up_to_multiple_of(75, 15) == 75);
static_assert(round_up_to_multiple_of(76, 15) == 90);

tm time_to_tm(time_t time) noexcept {
    tm tm_time;
    if (localtime_r(&time, &tm_time) == nullptr) {
        die("localtime_r()");
    }
    return tm_time;
}

time_t tm_to_time(tm tm_time) noexcept {
    errno = 0;
    auto res = mktime(&tm_time);
    if (errno != 0) {
        die("mktime()");
    }
    return res;
}

void sleep_until(time_t time) noexcept {
    timespec tp{.tv_sec = time, .tv_nsec = 0};
    if (clock_nanosleep(CLOCK_REALTIME, TIMER_ABSTIME, &tp, nullptr)) {
        die("clock_nanosleep()");
    }
}

time_t time_now() {
    return std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
}

constexpr auto deadline_hour = 2;
constexpr auto deadline_minute = 30;
constexpr auto deadline_second = 0;

constexpr auto enable_before_deadline_in_seconds = 20 * 60;
constexpr auto disable_after_deadline_in_seconds = 5 * 60 * 60;

constexpr auto after_deadline_repeat_interval_in_seconds = 90;

void print_message(const char* str) { cout << "{\"text\": \"" << str << "\"}" << endl; }

void commence_shutdown() { system("systemctl suspend&"); }

std::string executable_path(pid_t pid) {
    std::array<char, 4096> buff{};
    std::string path = "/proc/" + std::to_string(pid) + "/exe";

    ssize_t rc = readlink(path.c_str(), buff.data(), buff.size());
    if ((rc == -1 && errno == ENAMETOOLONG) || rc >= static_cast<int>(buff.size())) {
        std::array<char, 65536> buff2{};
        rc = readlink(path.c_str(), buff2.data(), buff2.size());
        if (rc == -1 || rc >= static_cast<int>(buff2.size())) {
            die("readlink()");
        }

        return std::string(buff2.data(), rc);
    }
    if (rc == -1) {
        die("readlink()");
    }
    return std::string(buff.data(), rc);
}

std::string executable_path_without_deleted_suffix(pid_t pid) {
    auto path = executable_path(pid);
    constexpr std::string_view deleted_suff = " (deleted)";
    if (path.size() > deleted_suff.size() and
        std::string_view{
            path.data() + (path.size() - deleted_suff.size()), deleted_suff.size()} ==
            deleted_suff)
    {
        path.erase(path.end() - deleted_suff.size(), path.end());
    }
    return path;
}

constexpr std::chrono::nanoseconds to_duration(const timespec& ts) noexcept {
    return std::chrono::seconds(ts.tv_sec) + std::chrono::nanoseconds(ts.tv_nsec);
}

// Returns file modification time (with second precision) as a time_point
inline std::chrono::system_clock::time_point
get_modification_time(const struct stat64& st) noexcept {
    return std::chrono::system_clock::time_point(to_duration(st.st_mtim));
}

// Returns file modification time (with second precision) as a time_point
inline std::chrono::system_clock::time_point get_modification_time(const std::string& file) {
    struct stat64 st {};
    if (stat64(file.c_str(), &st)) {
        die("stat()");
    }
    return get_modification_time(st);
}

class FileLock {
    int fd = -1;

public:
    explicit FileLock(const char* path, int lock_kind = LOCK_EX)
    : fd{open(path, O_RDONLY | O_CLOEXEC)} {
        if (fd == -1) {
            die("open()");
        }
        int rc;
        do {
            rc = flock(fd, lock_kind);
        } while (rc == -1 and errno == EINTR);
        if (rc != 0) {
            die("flock()");
        }
    }

    FileLock(const FileLock&) = delete;
    FileLock(FileLock&&) noexcept = delete;
    FileLock& operator=(const FileLock&) = delete;
    FileLock& operator=(FileLock&&) noexcept = delete;

    virtual ~FileLock() { (void)close(fd); }
};

class ExclusiveFileLock : public FileLock {
public:
    explicit ExclusiveFileLock(const char* path)
    : FileLock(path, LOCK_EX) {}
};

void recompile_and_exec_if_source_file_or_executable_has_changed(char* const* argv) {
    print_message("Checking for recompile...");
    auto exe_path = executable_path_without_deleted_suffix(getpid());
    auto source_path = exe_path + ".cc";

    // Synchronize with other processes. Only one process at a time can recompile, others need
    // to wait, so that every process ends up using the recompiled executable)
    ExclusiveFileLock sync{source_path.data()};
    auto recompile = [&] {
        print_message("Recompiling...");
        if (system(("g++ -std=c++17 -pthread -O2 '" + source_path + "' -o '" + exe_path + "'")
                       .c_str()))
        {
            print_message("Compilation failed.");
            pause();
        }
    };
    auto reexecute = [&] { execv(exe_path.c_str(), argv); };
    if (get_modification_time(source_path) > get_modification_time(exe_path)) {
        // Source is newer, recompile
        recompile();
        reexecute();
    }
    if (executable_path(getpid()) != exe_path) {
        // We execute an old version of the executable (e.g. because other instance recompiled
        // it while we waited for the file lock)
        reexecute();
    }
}

int main(int /*argc*/, char** argv) {
    if (prctl(PR_SET_PDEATHSIG, SIGTERM, 0, 0, 0)) {
        die("prctl(PR_SET_PDEATHSIG)");
    }
    recompile_and_exec_if_source_file_or_executable_has_changed(argv);
    print_message(""); for (;;) { pause(); }

    std::optional<time_t> due_shutdown_time;
    auto check_if_due_shutdown_time_passed = [&] {
        if (due_shutdown_time and due_shutdown_time < time_now()) {
            due_shutdown_time = std::nullopt;
            commence_shutdown();
        }
    };
    for (;;) {
        auto now = time_now();
        auto now_tm = time_to_tm(now);
        static_assert(0 <= deadline_hour and deadline_hour <= 23);
        static_assert(0 <= deadline_minute and deadline_minute <= 59);
        static_assert(0 <= deadline_second and deadline_second <= 59);
        static_assert(
            enable_before_deadline_in_seconds + disable_after_deadline_in_seconds <
                24 * 60 * 60,
            "It makes no sense to have this warning enabled all the time");

        auto past_deadline_tm = now_tm;
        if (now_tm.tm_hour > deadline_hour or
            (now_tm.tm_hour == deadline_hour and
             (now_tm.tm_min > deadline_minute or
              (now_tm.tm_min == deadline_minute and now_tm.tm_sec >= deadline_second))))
        {
            // The same day after deadline passed
        } else {
            // The day after
            past_deadline_tm.tm_mday -= 1;
        }
        past_deadline_tm.tm_hour = deadline_hour;
        past_deadline_tm.tm_min = deadline_minute;
        past_deadline_tm.tm_sec = deadline_second;

        auto next_deadline_tm = past_deadline_tm;
        next_deadline_tm.tm_mday += 1;

        auto past_deadline = tm_to_time(past_deadline_tm);
        auto next_deadline = tm_to_time(next_deadline_tm);

        auto wait_to_before_next_deadline = [&] {
            due_shutdown_time = std::nullopt;
            print_message(""); // hides warning
            sleep_until(next_deadline - enable_before_deadline_in_seconds);
        };

        decltype(next_deadline) deadline;
        if (now <= past_deadline + disable_after_deadline_in_seconds) {
            deadline = past_deadline;
        } else if (now >= next_deadline - enable_before_deadline_in_seconds) {
            deadline = next_deadline;
        } else {
            // Too far from both deadlines
            wait_to_before_next_deadline();
            continue;
        }

        check_if_due_shutdown_time_passed();
        // Display appropriate warning
        auto warn = [](time_t seconds_to_shutdown) {
            std::string str = "Shutdown in ";
            auto append_num = [&str](int num, bool lead_with_zero) {
                if (lead_with_zero and num < 10) {
                    str += '0';
                }
                str += std::to_string(num);
            };
            if (seconds_to_shutdown >= 3600) {
                append_num(seconds_to_shutdown / 3600, false);
                str += ':';
            }
            if (seconds_to_shutdown >= 60) {
                append_num((seconds_to_shutdown % 3600) / 60, seconds_to_shutdown >= 3600);
                str += ':';
            }
            append_num(seconds_to_shutdown % 60, seconds_to_shutdown >= 60);
            if (seconds_to_shutdown < 60) {
                str += " second";
                if (seconds_to_shutdown != 1) {
                    str += 's';
                }
            }
            print_message(str.c_str());
        };
        if (now <= deadline) {
            due_shutdown_time = deadline;
            warn(deadline - now);
        } else {
            auto disabling_time = deadline + disable_after_deadline_in_seconds;
            auto next_shutdown_time =
                deadline +
                round_up_to_multiple_of<time_t>(
                    now - deadline, after_deadline_repeat_interval_in_seconds);
            if (next_shutdown_time > disabling_time) {
                // No more shutdowns for now
                wait_to_before_next_deadline();
                continue;
            }

            due_shutdown_time = next_shutdown_time;
            warn(next_shutdown_time - now);
        }
        if (now == due_shutdown_time) {
            due_shutdown_time = std::nullopt;
            commence_shutdown();
        }
        sleep_until(now + 1);
    }
}
