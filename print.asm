%ifndef PRINT_ASM
%define PRINT_ASM
%include "definitions.asm"
%include "globals.asm"
%include "strlen.asm"

section .data ; constant variables
    debugStr db `Got here.`,newline,nullchar ; add 10(\n) and \0 for escape char

section .bss
    negativeChar resb 45
    c resb 1 ; character buffer
    numberLen resq 1
    setCursorStr resw 1

section .text

%macro printwithlen 2
    pushad ; push all registers to the stack

    mov eax, sys_write ; set eax to sys_write code
    mov ebx, stdout ; set ebx to stdout code
    mov ecx, %1 ; set ecx to the message 
    mov edx, %2 ; set edx to the length

    execute ; call system to execute sys_write

    popad ; pop all registers back from the start
%endmacro

%macro print 1
    pushad ; push all registers to the stack
    
    strlen %1 ; call strlen
    printwithlen %1, [stringLength] ; print with the length
    
    popad ; pop all registers back from the start
%endmacro

%macro print_singleint 1 ; print single digit character
    pushad ; push all registers to the stack

    mov eax, %1 ; move eax to the number
    add eax, '0' ; add the code for '0' as an offset 

    mov [c], eax ; move eax to the character buffer

    printwithlen c, 1 ; print 1 character with c as the character

    popad ; pop all registers back from the stack
%endmacro

%macro print_int 1 ; print full integer by looping through each digit
    pushad ; push all registers to the stack

    mov [numberLen], dword 0 ; set number length to 0
    mov eax, %1 ; move eax to the number to print

    test eax, eax ; test eax with eax
    jns %%print_loop
    
    printwithlen negativeChar, 1
    
    neg eax

%%print_loop:
    mov edx, 0 ; modulo result

    mov ebx, 10 ; value to divide and modulo by
    div ebx ; divides eax by 10

    push edx ; push edx onto the stack

    mov ecx, [numberLen] ; set ecx to the numbers length
    inc ecx ; increment the number length
    mov [numberLen], ecx ; set the number length variable back

    cmp eax, 0 ; compare eax with 0
    jne %%print_loop ; reset loop if not equal to 0

    ; after loop
    mov eax, [numberLen] ; set eax to the numbers length

%%print_loop2:
    cmp eax, 0 ; compare eax with 0
    jz %%print_exit ; jump to exit if eax is equal to 0

    dec eax ; decrement eax

    pop ebx ; remove number from the stack
    print_singleint ebx ; print number from stack

    jmp %%print_loop2 ; jump back to the start of the loop

%%print_exit:
    popad ; restore the registers from the stack
%endmacro

%macro input 2
    pushad ; push all registers to the stack

    mov eax, sys_read ; set eax to sys_read code
    mov ebx, stdin ; set ebx to stdin for user input
    mov ecx, %1 ; set ecx to input characters variable
    mov edx, %2 ; set edx to input length variable
     
    execute ; call system to execute sys_read 
    
    popad ; pop all registers from the stack
%endmacro

%macro printTimeVal 1
    print_int [%1]
    printwithlen comma, 2
    print_int [%1 + 8]
    printwithlen comma, 2
    print_int [%1 + 16]
    printwithlen comma, 2
    print_int [%1 + 24]
    printwithlen newLine, 2
%endmacro

%endif