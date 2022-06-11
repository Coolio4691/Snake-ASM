%ifndef FOOD_ASM
%define FOOD_ASM
%include "math.asm"
%include "globals.asm"
%include "util.asm"
%include "splitmix32.asm"

section .data ; initialized variables
    foodChar: db '●', 0

section .bss ; uninitialized variables
    foodX: resd 1
    foodY: resd 1

    indexOnFoodOutput: resb 1
    foodColour: equ LIGHTRED

section .text

%macro generateXPosition 0
    pushad ; push all registers to the stack

    splitmix32 ; food x
    mov ebx, gridWidth ; set ebx to gridwidth
    sub ebx, 2 ; remove the 2 borders from x
    modulo [splitmix32Output], ebx ; splitmix32Output %= (gridWidth - 2)

    mov ebx, [moduloResult] ; set ebx to moduloresult
    inc ebx ; add 1 to ebx to allow min 1 and max (gridWidth - 1)
    mov [foodX], ebx ; set foodx to ebx

    popad ; pop all registers from the stack
%endmacro

%macro generateYPosition 0
    pushad ; push all registers to the stack

    splitmix32 ; food y
    mov ebx, gridHeight ; set ebx to gridheight
    sub ebx, 3 ; remove the 2 borders from x
    modulo [splitmix32Output], ebx ; splitmix32Output %= (gridHeight - 2)

    mov ebx, [moduloResult] ; set ebx to moduloresult
    inc ebx ; add 1 to ebx to allow min 1 and max (gridWidth - 1)
    mov [foodY], ebx ; set foody to ebx
    
    popad ; pop all registers from the stack
%endmacro

%macro generateFoodPosition 0
    pushad ; push all registers to the stack

%%doGenerate:

    generateXPosition ; generate foodx position
    generateYPosition ; generate fooxy position 

    xor eax, eax ; set eax to 0
    mov ebx, [foodX] ; set ebx to foodx
    mov ecx, [foodY] ; set ecx to foody
%%checkSnakePos:
    cmp eax, [score] ; compare eax with score
    jg %%exit ; check if eax is greater than score and exit if it is

    getSnakeXY eax ; get snakexy at eax index

    cmp ebx, [outputSnakeX] ; compare foodx with snakex
    jne %%afterComparing ; jump to after comparing if foodx != snakex

    cmp ecx, [outputSnakeY] ; compare foody with snakey
    jne %%afterComparing ; jump to after comparing if foody != snakey


    jmp %%doGenerate ; if snakex == foodx and snakey == foody regenerate position
%%afterComparing:
    inc eax

    jmp %%checkSnakePos
%%exit:
    popad ; pop all registers from the stack
%endmacro

%macro generateFood 0
    pushad ; push all registers to the stack

    generateFoodPosition

    popad ; pop all registers from the stack
%endmacro

%macro indexOnFood 1 ; check if index is on food
    pushad ; push all registers to the stack

    indexTo2D %1 ; get position from index
    xor ebx, ebx ; set ebx to 0

    mov eax, [outputX] ; move eax to outputx
    cmp eax, [foodX] ; compare eax with foodx
    jne %%exit ; jump to exit if index x != foodx

    mov eax, [outputY] ; move eax to outputy
    cmp eax, [foodY] ; compare eax with foody
    jne %%exit ; jump to exit if index y != foody

    mov ebx, 1
%%exit:
    mov [indexOnFoodOutput], ebx

    popad ; pop all registers from the stack
%endmacro

%endif