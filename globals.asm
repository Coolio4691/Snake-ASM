%ifndef GLOBALS_ASM
%define GLOBALS_ASM

; define main grid
%define gridWidth 22
%define gridHeight 11
%define gridSize gridWidth * gridHeight

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

section .data ; initialized variables

section .bss ; uninitialized variables
    score: resd 1 ; score variable for the snake (also length)

%endif