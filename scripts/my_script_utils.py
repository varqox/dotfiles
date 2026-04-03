#!/usr/bin/python3

import ctypes
import ctypes.util
import fcntl
import os
import select
import signal
import sys

def enter_pid_namespace():

    libc = ctypes.CDLL(ctypes.util.find_library('c'), use_errno=True)

    # Enter the PID namespace so that all descendant processes die with this process
    euid = os.geteuid()
    egid = os.getegid()
    os.unshare(os.CLONE_NEWUSER | os.CLONE_NEWPID | os.CLONE_NEWNS)
    with open('/proc/self/uid_map', 'w') as f: f.write(f'{euid} {euid} 1')
    with open('/proc/self/setgroups', 'w') as f: f.write('deny')
    with open('/proc/self/gid_map', 'w') as f: f.write(f'{egid} {egid} 1')

    # Set up killing child upon parent death
    parent_pidfd = os.pidfd_open(os.getpid())

    if os.fork() != 0:
        sys.exit(os.waitstatus_to_exitcode(os.wait()[1]))

    # Ensure child is killed upon parent's death
    PR_SET_PDEATHSIG = 1
    libc.prctl.argtypes = (ctypes.c_int, ctypes.c_int)
    libc.prctl(PR_SET_PDEATHSIG, signal.SIGKILL)
    # Check if the parent died before prctl() succeeded
    poll = select.poll()
    poll.register(parent_pidfd, select.POLLIN)
    if len(poll.poll(0)) > 0:
        sys.exit(1)
    os.close(parent_pidfd)

    # Mounting proc has to be done in the child
    libc.mount.argtypes = (ctypes.c_char_p, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_ulong, ctypes.c_char_p)
    if libc.mount(None, b'/proc', b'proc', 0, None) < 0:
        errno = ctypes.get_errno()
        raise OSError(errno, f'mount failed with {os.strerror(errno)}')
