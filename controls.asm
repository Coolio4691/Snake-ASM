%ifndef CONTROLS_ASM
%define CONTROLS_ASM

section .data ; initialized variables

section .bss ; uninitialized variables
    leftKeyLower: equ 'a'
    leftKeyUpper: equ 'A'

    rightKeyLower: equ 'd'
    rightKeyUpper: equ 'D'

    forwardKeyLower: equ 'w'
    forwardKeyUpper: equ 'W'

    backKeyLower: equ 's'
    backKeyUpper: equ 'S'


    exitGameKey: equ 27

section .text

%endif