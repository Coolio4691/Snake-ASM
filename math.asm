%ifndef MATH_ASM
%define MATH_ASM
%include "definitions.asm"

section .data

section .bss
    divideResult resd 1
    moduloResult resd 1
    multiplyResult resd 1
    powerResult resd 1
    

section .text

%macro divide 2
    pushad ; push all registers to the stack

    mov eax, %1 ; value to divide
    xor edx, edx ; set xor result to 0

    mov ebx, %2 ; value to divide by

    div ebx ; divide eax by ebx

    mov [divideResult], eax ; move the quotient of the division into divide result

    popad ; pop all registers from the stack
%endmacro

%macro modulo 2
    pushad ; push all registers to the stack

    mov eax, %1 ; value to divide
    xor edx, edx ; set xor result to 0

    mov ebx, %2 ; value to divide by

    div ebx ; divide eax by ebx

    mov [moduloResult], edx ; move the remainder of the division into modulo result

    popad ; pop all registers from the stack
%endmacro

%macro dividemodulo 2
    pushad ; push all registers to the stack

    mov eax, %1 ; value to divide
    xor edx, edx ; set xor result to 0

    mov ebx, %2 ; value to divide by

    div ebx ; divide eax by ebx

    mov [divideResult], eax ; move the quotient of the division into divide result
    mov [moduloResult], edx ; move the remainder of the division into modulo result

    popad ; pop all registers from the stack
%endmacro

%macro multiply 2
    pushad ; push all registers to the stack

    mov eax, %1 ; set eax to %1
    imul eax, %2 ; multiply %1 by %2

    mov [multiplyResult], eax ; move the result of the multiplication into multiplyresult 

    popad ; pop all registers from the stack
%endmacro

%macro power 2
    pushad ; push all registers to the stack

    mov eax, 1 ; set eax to 1
    mov ebx, %1
    mov ecx, %1
%%powerLoop:
    imul ebx, ecx

    inc eax

    cmp eax, %2
    jl %%powerLoop
    ; out of loop

    mov [powerResult], ebx

    popad ; pop all registers from the stack
%endmacro

%endif