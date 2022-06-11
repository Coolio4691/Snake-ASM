%ifndef SPLITMIX32_ASM
%define SPLITMIX32_ASM
%include "definitions.asm"
%include "math.asm"
%include "print.asm" ; include print for debugging

section .data ; initialized variables

section .bss ; unitialized variables
    splitmix32_x: resd 1
    splitmix32Output: resd 1

%macro splitmix32_seed 1
    pushad ; push all registers to the stack

    mov eax, %1
    mov [splitmix32_x], eax
    
    popad ; pop all registers from the stack
%endmacro

%macro splitmix32 0
    pushad ; push all registers to the stack

    mov eax, [splitmix32_x] ; set eax to splitmix32 seed
    add eax, 2654435769 ; add fib hash to eax

    mov [splitmix32_x], eax ; move eax into splitmix32 seed


    mov ebx, eax ; move eax to ebx
    shr ebx, 16 ; ebx >> 16
    xor eax, ebx ; xor eax with eax >> 16


    imul eax, 0x85ebca6b ; multiply eax by 0x85ebca6b


    mov ebx, eax ; move eax to ebx
    shr ebx, 13 ; ebx >> 13
    xor eax, ebx ; xor eax with eax >> 13


    imul eax, 0xc2b2ae35 ; multiply eax by 0xc2b2ae35


    mov ebx, eax ; move eax to ebx
    shr ebx, 16 ; ebx >> 16
    xor eax, ebx ; xor eax with eax >> 16

    mov [splitmix32Output], eax

    popad ; pop all registers from the stack
%endmacro

%endif