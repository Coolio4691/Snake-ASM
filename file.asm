%ifndef FILE_ASM
%define FILE_ASM

%include "definitions.asm"

section .data ; initialized variables
    fileOpenErrorMsg db `Error opening file. Exiting...`,newline,nullchar ; add 10(\n) and \0 for escape char
    fileOpenSuccessMsg db `Opened file successfully`,newline,nullchar ; add 10(\n) and \0 for escape char

    fileCreateErrorMsg db `Error creating file. Exiting...`,newline,nullchar ; add 10(\n) and \0 for escape char
    fileCreateSuccessMsg db `Created file successfully`,newline,nullchar ; add 10(\n) and \0 for escape char
    
    fileWriteSuccessMsg db 'Wrote to file successfully',newline,nullchar ; add 10(\n) and \0 for escape char

section .bss ; uninitialized variables
    fC: resb 1 ; character buffer
    fNumberLen: resq 1

section .text:

%macro createfile 3
    mov eax, sys_creat ; call sys_creat
    mov ebx, %2 ; use the second parameter (const char* path)
    mov ecx, %3 ; use the third parameter (int permissions)

    execute

    cmp eax, 0 ; compare eax(result) with 0
    jl .createError ; if eax < 0 jump to error function

    mov [%1], eax ; move the result of sys_creat to the first parameter
    
    jmp .createSuccess ; return and skip error function

.createError:
    print fileCreateErrorMsg ; print error message

    mov ebx, eax ; move eax to ebx for error code
    exit ebx ; exit with ebx as error code

.createSuccess:
%endmacro

%macro openfile 3 ; needs fixing
    pushad ; push all registers to the stack

    mov eax, sys_open ; call sys_open 
    mov ebx, %2 ; use second parameter (const char* path)
    mov ecx, %3 ; use third parameter (int file access mode)

    execute ; shortcut for int 0x80 to execute

    mov [%1], eax ; move contents of eax into the first parameter

    popad ; pop all registers from the stack
%endmacro

%macro readfile 3
    pushad ; push all registers to the stack

    mov eax, sys_read ; sys_read syscode
    mov ebx, [%1] ; file descriptor
    mov ecx, %2; char* file contents
    mov edx, %3 ; file length

    execute

    popad ; pop all registers from the stack
%endmacro

%macro writefilewithlen 3
    pushad ; push all registers to the stack

    mov eax, sys_write ; set eax to sys_write code
    mov ebx, [%1] ; set ebx to file descriptor
    mov ecx, %2 ; set ecx to the message 
    mov edx, %3 ; set edx to the length

    int sys_call ; call system to execute sys_write

    popad ; pop all registers back from the stack
%endmacro

%macro writefile 2
    pushad ; push all registers to the stack

    strlen %2 ; call strlen

    mov edi, [stringLength] ; move eax(output of strlen) to esi

    sub edi, 1 ; remove \0 from the string(null terminator)

    writefilewithlen %1, %2, edi ; print with the length

    popad ; pop all registers back from the stack
%endmacro

%macro writefile_singleint 2
    pushad ; push all registers to the stack

    mov eax, %2 ; move eax to the number
    add eax, '0' ; add the code for '0' as an offset 

    mov [fC], eax ; move eax to the character buffer

    writefilewithlen %1, fC, 1 ; print 1 character with c as the character

    popad ; pop all registers back from the stack
%endmacro

%macro writefile_int 2
    pushad ; push all registers to the stack

    mov [fNumberLen], dword 0 ; set number length to 0
    mov eax, %2 ; move eax to the number to print

    test eax, eax ; test eax with eax
    jns %%writefile_loop
    
    writefilewithlen %1, negativeChar, 1
    
    neg eax

%%writefile_loop:
    
    mov edx, 0 ; modulo result

    mov ebx, 10 ; value to divide and modulo by
    div ebx ; divides eax by 10

    push edx ; push edx onto the stack

    mov ecx, [fNumberLen] ; set ecx to the numbers length
    inc ecx ; increment the number length
    mov [fNumberLen], ecx ; set the number length variable back

    cmp eax, 0 ; compare eax with 0
    jg %%writefile_loop ; jump to loop2 if equal to 0
    
    ; after loop
    mov eax, [fNumberLen] ; set eax to the numbers length

%%print_loop2:
    cmp eax, 0 ; compare eax with 0
    jz %%writefile_exit ; jump to exit if eax is equal to 0

    dec eax ; decrement eax

    pop ebx ; remove number from the stack
    writefile_singleint %1, ebx ; print number from stack

    jmp %%writefile_loop2 ; jump back to the start of the loop

%%writefile_exit:
    popad ; restore the registers from the stack
%endmacro

%macro fileseek 3
    pushad ; push the registers to the stack
    
    mov eax, sys_lseek ; lseek system code
    mov ebx, %1 ; file descriptor
    mov ecx, %2 ; offset position
    mov edx, %3 ; reference for offset

    execute ; execute lseek system call

    popad ; restore the registers from the stack
%endmacro

%macro closefile 1
    pushad ; push all registers to the stack

    mov eax, sys_close ; call sys_close
    mov ebx, [%1] ; close file descriptor

    execute ; call system to execute sys_close

    popad ; pop all registers from the stack
%endmacro
%endif