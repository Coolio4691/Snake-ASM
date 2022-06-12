%ifndef TERMINAL_ASM
%define TERMINAL_ASM

section .data ; initialized variables
    testWS db `test: `, 10, 0

section .bss ; uninitialized variables
    terminalWidthOutput: resd 1
    terminalHeightOutput: resd 1

    winSize:
        ws_row resw 1
        ws_col resw 1
        ws_xpixel resw 1
        ws_ypixel resw 1

section .text

%macro getTerminalWidth 0
    pushad ; push all registers to the stack
 
    ioctl stdout_fd, TIOCGWINSZ, winSize ; run ioctl with winsize as output

    mov eax, [ws_col] ; set eax to ws_row
    and eax, 65535 ; and eax to get rid of 131072(not sure why this is being added)

    mov [terminalWidthOutput], eax ; set terminalwidthoutput to eax 

    popad ; pop all registers from the stack
%endmacro

%macro getTerminalHeight 0
    pushad ; push all registers to the stack
 
    ioctl stdout_fd, TIOCGWINSZ, winSize ; run ioctl with winsize as output

    mov eax, [ws_row] ; set eax to ws_col
    and eax, 65535 ; and eax to get rid of 131072(not sure why this is being added)

    mov [terminalHeightOutput], eax ; set terminalheightoutput to eax 

    popad ; pop all registers from the stack
%endmacro

%macro getTerminalSize 0
    getTerminalWidth
    getTerminalHeight
%endmacro

%endif