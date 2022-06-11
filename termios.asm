%ifndef TERMIOS_ASM
%define TERMIOS_ASM

%include "definitions.asm"
%include "print.asm"

%define ICANON 2
%define ECHO 10
%define VTIME 5
%define VMIN 6

section .bss ; uninitialized variables
    termios: 
        c_iflag resd 1    ; input mode flags
        c_oflag resd 1    ; output mode flags
        c_cflag resd 1    ; control mode flags
        c_lflag resd 1    ; local mode flags
        c_line resb 1     ; line discipline
        c_cc resb 64      ; control characters

    stdin_fd: equ 0 ; STDIN_FILENO

section .text

%macro setVMin 1
    pushad ; push all registers to the stack
    
    read_stdin_termios
    
    mov eax, %1

    mov [termios + 17 + VMIN], eax

    write_stdin_termios

    popad ; pop all registers from the stack
%endmacro

%macro setVTime 1
    pushad ; push all registers to the stack

    read_stdin_termios
    
    mov eax, %1
    mov [termios + 17 + VTIME], eax

    write_stdin_termios

    popad ; pop all registers from the stack
%endmacro

%macro canonical_off 0
    pushad ; push all registers to the stack

    read_stdin_termios
    
    ; clear canonical bit in local mode flags
    and dword [termios+12], ~ICANON

    write_stdin_termios

    popad ; pop all registers from the stack
%endmacro

%macro canonical_on 0
    pushad ; push all registers to the stack

    read_stdin_termios

    ; set canonical bit in local mode flags
    or dword [termios+12], ICANON

    write_stdin_termios
%endmacro

%macro echo_off 0
    pushad ; push all registers to the stack

    read_stdin_termios

    ; clear echo bit in local mode flags
    and dword [termios+12], ~ECHO

    write_stdin_termios

    popad ; pop all registers from the stack
%endmacro

%macro echo_on 0
    pushad ; push all registers to the stack

    read_stdin_termios

    ; set echo bit in local mode flags
    or dword [termios+12], ECHO

    write_stdin_termios

    popad ; pop all registers from the stack
%endmacro


%macro read_stdin_termios 0
    pushad ; push all registers to the stack

    mov eax, 54
    mov ebx, stdin_fd
    mov ecx, 0x5401
    mov edx, termios
    
    execute ; ioctl(0, 0x5401, termios)

    popad ; pop all registers from the stack
%endmacro

%macro write_stdin_termios 0
    pushad ; push all registers to the stack

    mov eax, 54
    mov ebx, stdin_fd
    mov ecx, 0x5402
    mov edx, termios
    int 80h            ; ioctl(0, 0x5402, termios)

    popad ; pop all registers from the stack
%endmacro

%endif