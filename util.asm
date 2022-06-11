%ifndef UTIL_ASM
%define UTIL_ASM
%include "definitions.asm"
%include "math.asm"

section .data ; initialized variables

section .bss ; uninitialized variables
    outputX: resd 1
    outputY: resd 1

    outputIsOnBorder: resd 1

    timeResult: resd 1
    
    clockResult: 
        clock_tv_sec resd 1
        clock_tv_nsec resd 1


section .text

%macro getIndex 2 ; get 1d index from 2d coords
    pushad ; push all registers to the stack
    
    mov eax, %2 ; set eax to y

    imul eax, gridWidth ; multiply y with gridwidth

    add eax, %1 ; add x to y * gridwidth
    mov [gridIndex], eax ; set index to result (gridwidth * y + x)

    popad ; pop all registers from the stack
%endmacro

%macro indexTo2D 1 ; get 2d coords from index
    pushad ; push all registers to the stack
    
    mov eax, %1 ; set eax to %1
    dividemodulo eax, gridWidth ; output x = %1 % gridwidth
                                ; output y = %1 / gridwidth
    
    mov eax, [moduloResult] ; set eax to modulo result
    mov [outputX], eax ; set outputx to modulo result
    mov eax, [divideResult] ; set eax to divide result 
    mov [outputY], eax ; set outputy to divide result
    
    popad ; pop all registers from the stack
%endmacro

%macro isOnBorder 1
    pushad ; push all registers to the stack

    indexTo2D %1 ; get position from index

    mov ecx, 0 ; set ecx to 0
    mov ebx, [outputX] ; set ebx to position x
    cmp ebx, ecx ; compare position x with 0
    je %%setIsOnBorder ; set onborder to 1 if ebx == ecx

    mov ecx, gridWidth ; set ecx to gridwidth
    dec ecx ; decrement ecx by one

    cmp ebx, ecx ; compare position x with gridwidth - 1
    je %%setIsOnBorder ; set onborder to 1 if ebx == ecx


    mov ecx, 0 ; set ecx to 0
    mov ebx, [outputY] ; set ebx to position y
    cmp ebx, ecx ; compare position y with 0
    je %%setIsOnBorder ; set onborder to 1 if ebx == ecx

    mov ecx, gridHeight ; set ecx to gridheight
    dec ecx ; decrement ecx by one

    cmp ebx, ecx ; compare position y with gridheight - 1
    je %%setIsOnBorder ; set onborder to 1 if ebx == ecx

    xor eax, eax ; set eax to 0
    mov [outputIsOnBorder], eax ; set output to 0
    jmp %%exit ; jump to exit
%%setIsOnBorder:
    mov eax, 1 ; set eax to 1
    mov [outputIsOnBorder], eax ; set output to 1
%%exit:
    popad ; pop all registers from the stack
%endmacro

%macro getTime 0
    pushad ; push all registers to the stack

    mov eax, sys_time ; sys_time syscall
    xor ebx, ebx ; set ebx to NULL so it returns to eax

    execute ; call system to execute sys_time

    mov [timeResult], eax ; set time result to eax

    popad ; pop all registers from the stack
%endmacro

%macro clockGetTime 1
    pushad ; push all registers to the stack

    mov eax, sys_clock_gettime ; sys_clock_gettime syscall
    mov ebx, %1 ; set ebx to given clock type id
    lea ecx, clockResult ; load ecx to address of clockResult

    execute ; call system to execute sys_clock_gettime

    popad ; pop all registers from the stack
%endmacro
%endif