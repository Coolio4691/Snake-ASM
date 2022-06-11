%ifndef ESCAPE_HANDLERS_ASM
%define ESCAPE_HANDLERS_ASM
%include "definitions.asm"
%include "globals.asm"
%include "print.asm"

section .data ; initialized variables
    cursorActive: db 1
    enableCursor: db `\033[?25h`, 0
    disableCursor: db `\033[?25l`, 0
    clearStr: db `\033[2J\033[1;1H\033[3J`, 0

section .bss ; uninitialized variables

section .text

%macro clearConsole 0
    pushad ; push all registers to the stack
    
    print clearStr

    popad ; pop all registers from the stack
%endmacro

%macro setCursor 2
    pushad ; push all registers to the stack
    ; print escape sequence for setting cursor xy

    mov [c], byte 27
    printwithlen c, 1


    mov [c], byte '['
    printwithlen c, 1

    print_int %2 ; y 

    mov [c], byte ';'
    printwithlen c, 1

    print_int %1 ; x

    mov [c], byte 'H'
    printwithlen c, 1

    popad ; pop all registers from the stack
%endmacro

%macro setGraphicsMode 3
    pushad ; push all registers to the stack

    mov [c], byte 27
    printwithlen c, 1

    mov [c], byte '['
    printwithlen c, 1

    mov eax, %2
    and eax, 0x10

    cmp eax, 1
    jl %%print0
%%print1:
    print_int 1
    jmp %%afterPrint10
%%print0:
    print_int 0
%%afterPrint10:
    mov [c], byte ';'
    printwithlen c, 1

    mov eax, %2
    and eax, 0xF

    add eax, %3
    print_int eax

    mov [c], byte 'm'
    printwithlen c, 1

    popad ; pop all registers from the stack
%endmacro

%macro setTextColour 1
    setGraphicsMode RESETATTR, %1, 30 
%endmacro

%macro setTextBackgroundColour 1 
    setGraphicsMode RESETATTR, %1, 40 
%endmacro

%macro toggleCursor 0
    pushad ; push all registers to the stack

    mov eax, [cursorActive] ; set eax to cursoractive

    cmp eax, 1 ; compare eax with 1
    je %%disableCursor ; jump to disablecursor if eax is 1

%%activateCursor:
    print enableCursor ; print enable cursor string

    mov eax, 1 ; set eax to 1
    mov [cursorActive], eax ; set cursor active to 1

    jmp %%exit ; jump to exit
%%disableCursor:
    print disableCursor ; print disable cursor string
    
    xor eax, eax ; set to 0
    mov [cursorActive], eax ; set cursoractive to eax

    jmp %%exit ; jump to exit
%%exit:
    popad ; pop all registers from the stack
%endmacro
%endif