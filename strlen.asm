%ifndef STRLEN_ASM
%define STRLEN_ASM

%include "definitions.asm"

section .bss
    global stringLength
    stringLength: resd 1 ; reserve 1 dword

section .text

%macro strlen 1
    pushad ; push all registers to the stack
    mov [stringLength], dword 0

    mov edi, %1 ; set edi to the first parameter
    mov ebx, edi ; move edi to ebx

    xor al, al ; exclusive or on al(al = least significant of ax = least significant of eax) (set al to 0)
    mov ecx, 0xffffffff ; move ecx to -1

    repne scasb ; repeat while first byte of edi is not equal to al 
    sub edi, ebx ; length becomes offset of edi – ebx

    mov [stringLength], edi ; move edi to the string length variable
    popad ; pop all registers from the stack
%endmacro
%endif