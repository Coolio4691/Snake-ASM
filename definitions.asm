%ifndef DEFINITIONS_ASM
%define DEFINITIONS_ASM

section .bss

%define sys_exit 1
; exits the program with given code
; reads ebx as the exit code

%define sys_fork 2 
; creates thread(new process) of same file
; outputs ebx to struct pt_regs

%define sys_read 3 
; reads from stdin or file 
; ebx as unsigned int (stdin or file descriptor)
; ecx as char* (message/buffer in/out)
; edx as size_t (message/buffer size)

%define sys_write 4 
; writes to stdout stderr or file 
; ebx as unsigned int (stdout, stderr or file descriptor)
; ecx as const char* (message/buffer in/out)
; edx as size_t (message/buffer size)

%define sys_open 5
; opens file from name/path
; ebx as const char* (file name/path). returns file descriptor to ebx
; ecx as int (file access mode)
; edx as int (file permissions)

%define sys_close 6
; closes file descriptor
; has ebx as unsigned int (file descriptor)

%define sys_creat 8
; creates file
; has ebx as const char* (file name/path)
; ecx as int (file permissions)

%define sys_time 13
; gets the current time in seconds since epoch
; returns ebx as time_t* (tloc)

%define sys_lseek 19 
; moves the current file position
; has ebx as unsigned int (file descriptor)
; ecx as off_t (offset value)
; edx as unsigned int (reference position for offset: 
;     beginning of file: 0,
;     current position: 1,
;     end of file: 2
; )

%define sys_alarm 27
; sends an alarm signal
; ebx as unsigned int seconds

%define sys_signal 48
; creates a signal handler
; ebx int (signal)
; ecx as void (*sighandler_t)(int) (callback)

%define sys_ioctl 54
; manipulates io device
; ebx as unsigned int (file descriptor)
; ecx as unsigned int (command)
; edx as unsigned long (arg)

%define sys_setitimer 104
; sets the itimer
; ebx as int (what type of time, realtime 0, virtual(only when executing) 1, prof(only when executing or system is executing on behalf of process) 2)
; ecx as struct itimerval* (new value)
; returns edx to struct itimerval* (old value)

%define sys_getitimer 105
; gets the itimer
; ebx as int (what type of time timer to get)
; returns edx to struct itimerval*

%define sys_getcwd 183
; gets the current working directory
; returns ebx as char* (path)
; returns ecx as unsigned long (path length)

%define sys_clock_gettime 265
; gets the clock time at x clock
; ebx as clockid_t (int which_clock)
; returns ecx to struct __kernel_timespec tp

%define sys_call 80h ; call using int to execute


stdin_fd: equ 0 ; STDIN_FILENO
stdout_fd: equ 1 ; STDOUT_FILENO
stderr_fd: equ 2 ; STDERR_FILENO

%define stdin 0
%define stdout 1
%define stderr 2

%define success 0 ; success code

%define newline 10 ; new line character
%define nullchar 0 ; null terminator character

%define readonly 0 ; read only file mode
%define writeonly 1 ; write only file mode
%define readwrite 2 ; read write file mode

; itimer types

%define ITIMER_REAL 0 ; timer increases in real time
%define ITIMER_VIRTUAL 1 ; timer increases as the process uses the cpu
%define ITIMER_PROF 2 ; timer increases as the process or its children use the cpu

; clock types
%define CLOCK_REALTIME 0 ; Identifier for system-wide realtime clock.
%define CLOCK_MONOTONIC 1 ; Monotonic system-wide clock.
%define CLOCK_PROCESS_CPUTIME_ID 2 ; High-resolution timer from the CPU.
%define CLOCK_THREAD_CPUTIME_ID	3 ; Thread-specific CPU-time clock.
%define CLOCK_MONOTONIC_RAW	4 ; Monotonic system-wide clock, not adjusted for frequency scaling.
%define CLOCK_REALTIME_COARSE 5 ; Identifier for system-wide realtime clock, updated only on ticks.
%define CLOCK_MONOTONIC_COARSE 6 ; Monotonic system-wide clock, updated only on ticks.
%define CLOCK_BOOTTIME 7 ; Monotonic system-wide clock that includes time spent in suspension.
%define CLOCK_REALTIME_ALARM 8 ; Like CLOCK_REALTIME but also wakes suspended system.
%define CLOCK_BOOTTIME_ALARM 9 ; Like CLOCK_BOOTTIME but also wakes suspended system.
%define CLOCK_TAI 11 ; Like CLOCK_REALTIME but in International Atomic Time.

%define TIMER_ABSTIME 1 ; Flag to indicate time is absolute.

; Signals taken from C standard library
%define	SIGHUP 1 ; Hangup.
%define SIGINT 2 ; Interactive attention signal.
%define	SIGQUIT 3 ; Quit.
%define SIGILL 4 ; Illegal instruction.
%define	SIGTRAP 5 ; Trace/breakpoint trap.
%define SIGABRT 6 ; Abnormal termination.
%define SIGBUS 7 ; Bus error.
%define SIGFPE 8 ; Erroneous arithmetic operation.
%define	SIGKILL 9 ; Killed.
%define SIGUSR1 10 ; User-defined signal 1.
%define SIGSEGV 11 ; Invalid access to storage.
%define SIGUSR2 12 ; User-defined signal 2.
%define	SIGPIPE 13 ; Broken pipe.
%define SIGALRM 14 ; Alarm
%define SIGTERM 15 ; Termination request.
%define SIGSTKFLT 16 ; Stack fault (obsolete).
%define SIGCHLD 17 ; Child terminated or stopped.
%define SIGCONT 18 ; Continue.
%define SIGSTOP 19 ; Stop, unblockable.
%define SIGTSTP 20 ; Keyboard stop.
%define SIGTTIN 21 ; Background read from control terminal.
%define SIGTTOU 22 ; Background write to control terminal.
%define SIGURG 23 ; Urgent data is available at a socket.
%define SIGXCPU 24 ; CPU time limit exceeded.
%define SIGXFSZ 25 ; File size limit exceeded.
%define SIGVTALRM 26 ; Virtual timer expired.
%define SIGPROF 27 ;Profiling timer expired.
%define SIGWINCH 28 ; Window size change (4.3 BSD, Sun).
%define SIGPOLL 29 ; Pollable event occurred (System V).
%define SIGPWR 30 ; Power failure imminent.
%define SIGSYS 31 ; Bad system call.

; ioctl

%define TIOCGWINSZ 0x5413


; calls interrupt sys_call(0x80)
%define execute int sys_call

; exits the program with the given code
%macro exit 1
    mov eax, sys_exit
    mov ebx, %1
    execute
%endmacro
%endif