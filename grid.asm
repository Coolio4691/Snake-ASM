%ifndef GRID_ASM
%define GRID_ASM
%include "definitions.asm"
%include "globals.asm"
%include "snake.asm"
%include "food.asm"
%include "print.asm"
%include "escapeHandlers.asm"
%include "math.asm"
%include "util.asm"

section .data ; initialized variables
    gridChar: db ` `
    gridBorderChar: db ` `

section .bss ; uninitialized variables
    gridIndex: resd 1

    gridColour: equ BLACK
    gridBorderColour: equ LIGHTBLUE

section .text

%macro gridInit 0
    pushad ; push all registers to the stack

    getTerminalSize ; get terminal size
    
    mov eax, [terminalHeightOutput] ; set eax to terminal height
    sub eax, 4 ; add padding of 4 to grid height

    cmp eax, maxGridHeight ; compare eax with maxgridheight
    jl %%afterGridHeightMax ; if eax < maxgridheight jump to not set to max

    mov eax, maxGridHeight ; set eax to maxgridheight
%%afterGridHeightMax:
    mov [gridHeight], eax ; set gridheight to eax


    mov eax, [terminalWidthOutput] ; set eax to terminal width

    cmp eax, maxGridWidth ; compare eax with maxgridwidth
    jl %%afterGridWidthMax ; if eax < maxgridwidth jump to not set to max

    mov eax, maxGridWidth ; set eax to max grid width
%%afterGridWidthMax:
    mov [gridWidth], eax ; set gridwidth to eax


    calcGridSize ; get new gridsize

    popad ; pop all registers from the stack
%endmacro

%macro printGrid 0
    pushad ; push all registers to the stack
   
    mov esi, 4 ; set esi to 2
    setCursor 0, esi ; set cursor y to esi (line 2)
    inc esi ; set to next line

    mov edx, [gridSize]

    setTextBackgroundColour gridColour ; set text background colour back to gridcolour
    xor eax, eax ; set eax to 0 (current grid index)
%%gridLoop:
    indexTo2D eax ; get 2d position from cur index


%%checkIfOnBorder:
    isOnBorder eax ; check if index eax is on border

    cmp [outputIsOnBorder], word 1 ; compare if eax is on border
    je %%printBorderChar ; if it is print border char

    jmp %%checkIfOnSnakeChar
%%checkIfOnSnakeChar:
    xor ebx, ebx ; set ebx to 0 (current snake index)
    jmp %%checkIfOnSnakeLoop
%%checkIfOnSnakeLoop:
    getSnakeXY ebx ; get snakexy at ebx

    mov ecx, [outputSnakeX] ; set ecx to outputsnakex
    cmp ecx, [outputX] ; compare snakex with grid position x
    jne %%toNextSnakeLoop ; if snakex != gridpositionx check next segment


    mov ecx, [outputSnakeY] ; set ecx to outputsnakey 
    cmp ecx, [outputY] ; compare snakey with grid position y
    jne %%toNextSnakeLoop ; if snakey != gridpositiony check next segment

    jmp %%printSnakeChar ; print snake char if snakex == gridx && snakey == gridy
%%toNextSnakeLoop:
    inc ebx ; increment ebx
    cmp ebx, [score] ; compare ebx with score
    jle %%checkIfOnSnakeLoop ; if ebx < score jump back to start of snakecheckloop
    ; after loop

    jmp %%checkIfOnFood
%%checkIfOnFood: 
    indexOnFood eax ; check if index is on food

    cmp [indexOnFoodOutput], word 1 ; compare indexonfoodoutput with 1
    je %%printFoodChar ; if it is on food print food char

    jmp %%printGridChar
%%printGridChar:
    printwithlen gridChar, 1 ; print gridchar if not on border

    jmp %%checkForNewLine ; check if new line is to be printed
%%printBorderChar:

    setTextBackgroundColour gridBorderColour ; set text background colour to gridbordercolour
    printwithlen gridBorderChar, 1 ; print gridborder char
    setTextBackgroundColour gridColour ; set text background colour back to gridcolour

    jmp %%checkForNewLine ; check if new line is to be printed
%%printFoodChar:

    setTextColour foodColour ; set text colour to foodcolour
    print foodChar ; print foodchar
    setTextColour gridColour ; set text colour back to gridcolour
    setTextBackgroundColour gridColour ; set text background colour back to gridcolour

    jmp %%checkForNewLine
%%printSnakeChar:

    setTextBackgroundColour snakeColour ; set text background colour to snakecolour
    printwithlen snakeChar, 1 ; print foodchar
    setTextColour gridColour ; set text colour back to gridcolour
    setTextBackgroundColour gridColour ; set text background colour back to gridcolour

    jmp %%checkForNewLine
%%printNewLine:
    setCursor 0, esi ; set cursory at esi
    inc esi ; increment esi

    jmp %%toNextLoop ; go to next spot on grid
%%checkForNewLine: 
    inc eax ; increment eax by 1
    modulo eax, [gridWidth] ; do eax % gridwidth
    dec eax ; decrement eax by 1

    cmp [moduloResult], word 0 ; compare (eax + 1) % gridwidth with 0
    je %%printNewLine ; jump to print new line if it == 0

    jmp %%toNextLoop ; go to next spot on grid
%%toNextLoop:
    inc eax ; increment eax

    cmp eax, edx ; compare eax with gridsize
    jl %%gridLoop ; check if eax < gridSize if it is redo loop
%%exit:
    popad ; pop all registers from the stack
%endmacro
%endif