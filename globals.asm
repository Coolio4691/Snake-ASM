%ifndef GLOBALS_ASM
%define GLOBALS_ASM

%define snake_usec_movespeed 80000    

; attributes
%define RESETATTR    0
%define BRIGHT       1
%define DIM          2
%define UNDERSCORE   4
%define BLINK        5           ; May not work on all displays.
%define REVERSE      7
%define HIDDEN       8

; colors for text and background
%define BLACK        0x0
%define RED          0x1
%define GREEN        0x2
%define BROWN        0x3
%define BLUE         0x4
%define MAGENTA      0x5
%define CYAN         0x6
%define LIGHTGREY    0x7

%define DARKGREY     0x10
%define LIGHTRED     0x11
%define LIGHTGREEN   0x12
%define YELLOW       0x13
%define LIGHTBLUE    0x14
%define LIGHTMAGENTA 0x15
%define LIGHTCYAN    0x16
%define WHITE        0x17

%define maxGridWidth 70
%define maxGridHeight 30
%define maxGridSize maxGridWidth * maxGridHeight

section .data ; initialized variables

section .bss ; uninitialized variables
    score: resd 1 ; score variable for the snake (also length)

    gridWidth: resd 1
    gridHeight: resd 1
    gridSize: resd 1

section .text

%macro calcGridSize 0
    pushad ; push all registers to the stack

    mov eax, [gridWidth] ; gridsize = gridwidth
    imul eax, [gridHeight] ; gridsize *= gridheight

    mov [gridSize], eax ; gridsize = gridwidth * gridheight

    popad ; pop all registers from the stack
%endmacro

%endif
