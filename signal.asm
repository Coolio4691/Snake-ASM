%ifndef SIGNAL_ASM
%define SIGNAL_ASM
%include "definitions.asm"
%include "globals.asm"
%include "snake.asm"

section .data ; initialized variables

section .bss ; uninitialized variables
    timer:
        it_interval: ; Value to put into `it_value' when the timer expires
            tv_sec resd 1 ; long seconds
            tv_usec resd 1 ; long microseconds
        it_value: ; Time to the next timer expiration.
            tv_sec2 resd 1 ; long seconds
            tv_usec2 resd 1 ; long microseconds
    oldtimer:
        old_it_interval: ; Value to put into `it_value' when the timer expires
            old_tv_sec resd 1 ; long seconds
            old_tv_usec resd 1 ; long microseconds
        old_it_value: ; Time to the next timer expiration.
            old_tv_sec2 resd 1 ; long seconds
            old_tv_usec2 resd 1 ; long microseconds
    backupSnakeScore: resd 1


section .text

%macro setSignalHandler 2
    pushad ; push all registers to the stack

    mov eax, sys_signal ; sys_signal sycall code
    mov ebx, %1 ; set signal code
    mov ecx, %2 ; set signal callback
    
    execute ; execute sys_signal

    popad ; pop all registers from the stack
%endmacro

%macro sendAlarm 1
    pushad ; push all registers to the stack

    mov eax, sys_alarm ; sys_signal sycall code
    mov ebx, %1 ; set signal code

    execute ; execute sys_signal

    popad ; pop all registers from the stack
%endmacro

%macro setITimer 3 ; sets itimer
    pushad ; push all registers to the stack

    mov eax, sys_setitimer ; set itimer syscode
    mov ebx, %1 ; set itimer type to first param
    mov ecx, %2 ; set itimer to the second param
    mov edx, %3 ; set old timer to third param

    execute ; execute setitimer

    popad ; pop all registers from the stack
%endmacro

%macro getITimer 2 ; gets itimer
    pushad ; push all registers to the stack

    mov eax, sys_getitimer ; set itimer syscode
    mov ebx, %1 ; get itimer with type of first param
    mov ecx, %2 ; sets returned itimer to the second param

    execute ; execute setitimer

    popad ; pop all registers from the stack
%endmacro

%macro ualarm 2
    pushad ; push all registers to the stack

    mov [it_interval], dword 0
    mov [it_interval + 4], dword %2

    mov [it_value], dword 0
    mov [it_value + 4], dword %1

    setITimer ITIMER_REAL, timer, oldtimer

    popad ; pop all registers from the stack
%endmacro

alarmHandler:
    pushad ; push all registers to the stack
    setSignalHandler SIGALRM, alarmHandler
    
    setSnakeDirection [output] ; set the snake direction from the inputted char
    snakeMove ; move snake

    mov eax, [direction]
    checkSnakeCollision
    mov [direction], eax

    printGrid
    
    popad ; pop all registers from the stack
    ret

%endif