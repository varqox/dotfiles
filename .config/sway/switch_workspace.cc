// Compile with: g++ -std=c++17 switch_workspace.cc -o switch_workspace -pthread
#include "rapidjson/include/rapidjson/document.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <cerrno>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <fcntl.h>
#include <iostream>
#include <sstream>
#include <string.h>
#include <string>
#include <string_view>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <time.h>
#include <tuple>
#include <unistd.h>

using std::cerr;
using std::endl;

[[noreturn]] void exit_group(int status) {
    syscall(SYS_exit_group, status);
    _exit(status); // in case syscall(SYS_exit_group) failed
}

[[noreturn]] void die(const char* str) noexcept {
    fprintf(
        stderr, "error on %s - %s = %s\n", str, strerrorname_np(errno),
        strerrordesc_np(errno));
    exit_group(1);
}

[[noreturn]] void die(const char* str, const char* description) noexcept {
    if (description != nullptr) {
        fprintf(stderr, "error on %s: %s\n", str, description);
    } else {
        fprintf(stderr, "error on %s\n", str);
    }
    exit_group(1);
}

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

// ExclusiveFileLock parameter is used to synchronize with other processes. Only one process
// at a time can recompile, others need to wait, so that every process ends up using the
// recompiled executable)
void recompile_and_exec_if_source_file_or_executable_has_changed(
    const ExclusiveFileLock&, char* const* argv) {
    auto exe_path = executable_path_without_deleted_suffix(getpid());
    auto source_path = exe_path + ".cc";
    auto recompile = [&] {
        cerr << "Recompiling..." << endl;
        if (system(("g++ -std=c++17 -pthread -O2 '" + source_path + "' -o '" + exe_path + "'")
                       .c_str()))
        {
            die("Compilation failed.", nullptr);
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

class PopenedFile {
    FILE* f;

public:
    explicit PopenedFile(const char* command, const char* type = "re")
    : f{popen(command, type)} {
        if (f == nullptr) {
            die("popen()");
        }
    }

    PopenedFile(const PopenedFile&) = delete;
    PopenedFile(PopenedFile&&) noexcept = delete;
    PopenedFile& operator=(const PopenedFile&) = delete;
    PopenedFile& operator=(PopenedFile&&) noexcept = delete;

    operator FILE*() noexcept { return f; }

    ~PopenedFile() { (void)pclose(f); }
};

int get_focused_workspace_num() {
    PopenedFile swaymsg{"swaymsg --type get_workspaces --raw"};
    std::string output;
    std::array<char, 4096> buff;
    for (;;) {
        int rc = fread(buff.data(), 1, buff.size(), swaymsg);
        if (rc == 0) {
            break;
        }
        output.append(buff.data(), rc);
    }
    if (ferror(swaymsg)) {
        die("fread()", nullptr);
    }

    rapidjson::Document d;
    d.Parse(output.data(), output.size());
    if (d.HasParseError()) {
        die("rapidjson::Document::Parse()", nullptr);
    }

    for (auto const& m : d.GetArray()) {
        if (m["focused"].GetBool()) {
            return m["num"].GetInt();
        }
    }
    die("could not find focused workspace");
}

int main(int argc, char** argv) {
    ExclusiveFileLock sync{(executable_path_without_deleted_suffix(getpid()) + ".cc").data()};
    recompile_and_exec_if_source_file_or_executable_has_changed(sync, argv);

    if (std::clamp(argc, 2, 3) != argc) {
        cerr << "Usage: %s [move] <DIRECTION>\n"
                "Switch workspace in direction DIRECTION and move the current container if "
                "[move] is specified\n"
                "DIRECTION can one of: up, down, left, right, next_output\n";
        return 1;
    }

    int row_off = 0;
    int col_off = 0;

    std::string_view direction;
    bool move;
    if (argc == 2) {
        move = false;
        direction = argv[1];
    } else if (argc == 3) {
        if (std::string_view{argv[1]} != "move") {
            cerr << "First argument does not equal \"move\"" << endl;
            return 1;
        }
        move = true;
        direction = argv[2];
    } else {
        assert(false);
    }

    if (direction == "left") {
        col_off = -1;
    } else if (direction == "right") {
        col_off = 1;
    } else if (direction == "up") {
        row_off = -1;
    } else if (direction == "down") {
        row_off = 1;
    } else {
        cerr << "Invalid direction: " << direction << endl;
        return 1;
    }

    // Workspaces make 2D grid, top-left has num 11, layout is as follows:
    // +----+----+----+-----+
    // | 11 | 12 | 13 | ... |
    // +----+----+----+-----+
    // | 21 | 22 | 23 | ... |
    // +----+----+----+-----+
    // | 31 | 32 | 33 | ... |
    // +----+----+----+-----+
    // | ...................|
    // +----+----+----+-----+
    // Workspaces wrap around
    constexpr int rows = 3;
    constexpr int cols = 3;

    int curr_workspace = get_focused_workspace_num();
    static_assert(rows < 10 and cols < 10);
    int monitor = curr_workspace / 100;
    int row = (curr_workspace % 100) / 10 + row_off;
    int col = curr_workspace % 10 + col_off;

    row = (row + rows - 1) % rows + 1;
    col = (col + cols - 1) % cols + 1;

    auto workspace_num = [&] {
        std::stringstream ss;
        ss << monitor * 100 + row * 10 + col << ":" << row * 10 + col;
        return ss.str();
    }();

    auto command = "swaymsg workspace number " + workspace_num;
    if (move) {
        command =
            "swaymsg move container to workspace number " + workspace_num + " && " + command;
    }
    return system(command.data());
}
