// Compile with: g++ -std=c++17 test.cc -o test -pthread
#include "rapidjson/document.h"
#include "rapidjson/fdreadstream.h"
#include "rapidjson/filereadstream.h"
#include "rapidjson/istreamwrapper.h"
#include "rapidjson/reader.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <cerrno>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <fcntl.h>
#include <fstream>
#include <iostream>
#include <map>
#include <optional>
#include <sstream>
#include <string.h>
#include <string>
#include <string_view>
#include <sys/file.h>
#include <sys/poll.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <time.h>
#include <tuple>
#include <unistd.h>
#include <vector>

using std::array;
using std::cerr;
using std::endl;
using std::map;
using std::string;
using std::string_view;
using std::vector;

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
    constexpr string_view deleted_suff = " (deleted)";
    if (path.size() > deleted_suff.size() and
        string_view{
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
        cerr << "Done." << endl;
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

int create_and_open_fifo() {
    auto fifo_path = executable_path_without_deleted_suffix(getpid()) + ".pipe";
    (void)unlink(fifo_path.c_str());
    if (mkfifo(fifo_path.c_str(), 0644)) {
        die("mkfifo()");
    }
    int fd = open(fifo_path.c_str(), O_RDWR);
    if (fd < 0) {
        die("open()");
    }
    return fd;
}

int main(int argc, char** argv) {
    ExclusiveFileLock sync{(executable_path_without_deleted_suffix(getpid()) + ".cc").data()};
    recompile_and_exec_if_source_file_or_executable_has_changed(sync, argv);

    int fifo_fd = create_and_open_fifo();

    PopenedFile swaymsg{"swaymsg --monitor --type subscribe '[\"workspace\"]' --raw"};
    std::array<char, 8192> buff;
    std::optional<rapidjson::FdReadStream> is;
    rapidjson::Document d;

    auto workspace_name_to_num = [&](string_view name) {
        uint64_t num = 0;
        for (char c : name) {
            if ('0' <= c and c <= '9') {
                num = num * 10 + (c - '0');
            } else {
                break;
            }
        }
        return num;
    };

    string focused_workspace_name;
    map<string, vector<string>> output_to_workspaces;
    map<string, string> output_to_visible_workspace;
    map<string, string> workspace_to_output;
    auto print_workspaces = [&] {
        cerr << "{\n";
        cerr << "    workspace_to_output: {\n";
        for (auto [name, output] : workspace_to_output) {
            cerr << "        " << name << " -> " << output << '\n';
        }
        cerr << "    }\n";
        cerr << "    output_to_workspaces: {\n";
        for (auto [output, workspaces] : output_to_workspaces) {
            cerr << "        " << output << " -> [";
            bool first = true;
            for (auto name : workspaces) {
                if (first) {
                    first = false;
                } else {
                    cerr << ", ";
                }
                cerr << name;
            }
            cerr << "]\n";
        }
        cerr << "    }\n";
        cerr << "    output_to_visible_workspace: {\n";
        for (auto [output, name] : output_to_visible_workspace) {
            cerr << "        " << output << " -> " << name << "\n";
        }
        cerr << "    }\n";
        cerr << "    focused_workspace_name: " << focused_workspace_name << "\n";
        cerr << "}\n";
    };
    auto reinit_workspaces = [&] {
        PopenedFile swaymsg_get_workspaces{"swaymsg --type get_workspaces --raw"};
        rapidjson::FileReadStream is{swaymsg_get_workspaces, buff.data(), buff.size()};
        d.ParseStream(is);
        if (d.HasParseError()) {
            die("rapidjson::Document::ParseStream()", nullptr);
        }
        for (auto const& m : d.GetArray()) {
            string name = m["name"].GetString();
            string output = m["output"].GetString();
            workspace_to_output[name] = output;
            output_to_workspaces[output].emplace_back(name);
            if (m["visible"].GetBool()) {
                output_to_visible_workspace[output] = name;
            }
            if (m["focused"].GetBool()) {
                focused_workspace_name = name;
            }
        }
        if (focused_workspace_name.empty()) {
            die("workspace reinit failed: no focused workspace", nullptr);
        }
        if (workspace_to_output.empty()) {
            die("workspace reinit failed: no workspaces", nullptr);
        }
        if (output_to_workspaces.empty()) {
            die("workspace reinit failed: no outputs", nullptr);
        }
    };
    reinit_workspaces();
    print_workspaces();

    auto handle_swaymsg_events = [&]() {
        if (not is) {
            is = rapidjson::FdReadStream{fileno(swaymsg), buff.data(), buff.size()};
        }
        d.ParseStream<rapidjson::kParseStopWhenDoneFlag>(*is);
        if (d.HasParseError()) {
            die("rapidjson::Document::ParseStream()", nullptr);
        }
        cerr << d.GetObj()["change"].GetString() << endl;
        // TODO: parse what the needed data
        // TODO: update data structures
    };

    auto handle_fifo_events = [&, buff = array<char, 128>{}, beg = static_cast<size_t>(0), end = static_cast<size_t>(0)]() mutable {
        // Move remaining data to the buffer beginning
        memmove(buff.data(), buff.data() + beg, end - beg);
        end = end - beg;
        beg = 0;
        // Read more data
        auto rc = read(fifo_fd, buff.data() + end, buff.size() - end);
        if (rc < 0) {
            die("read()");
        }
        end += rc;
        // Process commands
        for (;;) {
            // std::cerr << "[" << beg << ", " << end << "]: " << string_view{buff.data() + beg, end - beg} << ";\n";
            enum CommandsCheckResult {
                NONE_MATCHES,
                NEEDS_MORE_DATA,
            } cmds_check_result = NONE_MATCHES;
            bool some_command_matched = false;
            auto match_cmd = [&](string_view cmd) {
                size_t i = 0;
                for (; i < std::min(end - beg, cmd.size()); ++i) {
                    if (cmd[i] != buff[beg + i]) {
                        return false;
                    }
                }
                if (i < cmd.size()) {
                    cmds_check_result = NEEDS_MORE_DATA;
                    return false;
                }
                some_command_matched = true;
                beg += cmd.size();
                return true;
            };
            if (match_cmd("go left\n")) {
                cerr << "<-\n";
            }
            if (match_cmd("go right\n")) {
                cerr << "->\n";
            }
            if (match_cmd("go up\n")) {
                cerr << "^\n";
            }
            if (match_cmd("go down\n")) {
                cerr << "v\n";
            }
            if (some_command_matched) {
                continue;
            }
            switch (cmds_check_result) {
                case NONE_MATCHES: ++beg; break;
                case NEEDS_MORE_DATA: return;
            }
        }
    };

    constexpr size_t p_swaymsg_idx = 0;
    constexpr size_t p_fifo_idx = 1;
    std::array<pollfd, 2> pfds = {
        pollfd{
            .fd = fileno(swaymsg),
            .events = POLLIN,
            .revents = 0,
        },
        pollfd{
            .fd = fifo_fd,
            .events = POLLIN,
            .revents = 0,
        },
    };
    for (;;) {
        pfds[p_swaymsg_idx].revents = 0;
        pfds[p_fifo_idx].revents = 0;
        int rc = poll(pfds.data(), pfds.size(), -1);
        if (rc == -1 and errno == EINTR) {
            continue;
        }
        if (rc == -1) {
            die("poll()");
        }

        if (pfds[p_swaymsg_idx].revents & POLLIN) {
            handle_swaymsg_events();
        }

        if (pfds[p_fifo_idx].revents & POLLIN) {
            handle_fifo_events();
        }
    }

    return 0;
}
