%ifndef SNAKE_ASM
%define SNAKE_ASM
%include "definitions.asm"
%include "globals.asm"
%include "food.asm"
%include "print.asm"
%include "controls.asm"
%include "util.asm"

%define baseScore 0

section .data ; initialized variables
    debugMsg db `Got here`, 10, 0

    snakeX dd gridSize dup (0) ; x coordinates for the snake
    snakeY dd gridSize dup (0) ; y coordinates for the snake
    
    snakeChar db ` `, 0

section .bss ; uninitialized variables
    outputSnakeX: resd 1
    outputSnakeY: resd 1
    direction: resb 1

    snakeColour: equ WHITE

section .text

%macro getSnakeX 1 ; takes index as param and returns snakes x
    pushad ; push all registers to the stack

    multiply %1, 4 ; multiply index by sizeof dword(4 bytes)
    mov eax, [multiplyResult] ; move multiply result to eax

    mov eax, [snakeX + eax] ; set eax to snakeX[index]
    mov [outputSnakeX], eax ; set outputSnakeY to snakeX[index]

    popad ; pop all registers from the stack
%endmacro

%macro getSnakeY 1 ; takes index as param and returns snakes y
    pushad ; push all registers to the stack

    multiply %1, 4 ; multiply index by sizeof dword(4 bytes)
    mov eax, [multiplyResult] ; move multiply result to eax

    mov eax, [snakeY + eax] ; set eax to snakeY[index]
    mov [outputSnakeY], eax ; set outputSnakeY to snakeY[index]

    popad ; pop all registers from the stack
%endmacro

%macro getSnakeXY 1 ; takes index as param and returns snakes xy
    getSnakeX %1
    getSnakeY %1
%endmacro


%macro setSnakeX 2 ; takes index and value as param and sets snakes x
    pushad ; push all registers to the stack

    multiply %1, 4 ; multiply index by sizeof dword(4 bytes)
    mov eax, [multiplyResult] ; move multiply result to eax

    mov ebx, %2 ; set ebx to %2
    mov [snakeX + eax], ebx ; set snakeX[index] to %2

    popad ; pop all registers from the stack
%endmacro

%macro setSnakeY 2 ; takes index as param and returns snakes y
    pushad ; push all registers to the stack

    multiply %1, 4 ; multiply index by sizeof dword(4 bytes)
    mov eax, [multiplyResult] ; move multiply result to eax

    mov ebx, %2 ; set ebx to %2
    mov [snakeY + eax], ebx ; set snakeY[index] to %2

    popad ; pop all registers from the stack
%endmacro

%macro setSnakeXY 3 ; takes index as param and returns snakes xy
    setSnakeX %1, %2
    setSnakeY %1, %3
%endmacro


%macro setSnakeDirection 1
    pushad ; push all registers to the stack

    getSnakeXY 0 ; get snakexy at index 0
    mov ebx, [outputSnakeX] ; set ebx to outputsnakex
    mov ecx, [outputSnakeY] ; set ecx to outputsnakey
    

    mov eax, %1 ; set eax to first parameter


    cmp eax, leftKeyLower ; if first param is a go to leftKey function
    je %%leftKey

    cmp eax, leftKeyUpper ; if first param is A go to leftKey function
    je %%leftKey


    cmp eax, rightKeyLower ; if first param is d go to rightKey function
    je %%rightKey

    cmp eax, rightKeyUpper ; if first param is D go to rightKey function
    je %%rightKey


    cmp eax, forwardKeyLower ; if first param is w go to forwardKey function
    je %%forwardKey

    cmp eax, forwardKeyUpper ; if first param is W go to forwardKey function
    je %%forwardKey


    cmp eax, backKeyLower ; if first param is s go to backKey function
    je %%backKey

    cmp eax, backKeyUpper ; if first param is S go to backKey function
    je %%backKey


    cmp eax, exitGameKey ; compare eax with exit key
    jne %%exit ; jump to exit if eax != exitkey

    mov eax, 1 ; set eax to 1
    mov [exitGame], eax ; set exitgame to 1
    jmp %%exit ; jump to exit
%%leftKey:
    mov eax, leftKeyLower ; set eax to left key lower
    cmp eax, [direction] ; check if snake direction is already left
    je %%exit ; jump to exit if true

    
    getSnakeXY 1 ; get snakexy at index 1

    dec ebx ; decrement snakex[0]
    cmp ebx, [outputSnakeX] ; compare snakex[0] - 1 with snakex[1]
    jne %%setLeftKey ; if snakex[0] - 1 != snakey[1] set leftkey


    cmp ecx, [outputSnakeY] ; compare snakey[0] with snakey[1]
    jne %%setLeftKey ; if snakey[0] != snakey[1] set leftkey 


    jmp %%exit ; exit since cant go back into body 
%%setLeftKey:
    mov [direction], eax ; set snake direction to left
    jmp %%exit ; exit after setting direction
%%rightKey:
    mov eax, rightKeyLower ; set eax to right key lower
    cmp eax, [direction] ; check if snake direction is already right
    je %%exit ; jump to exit if true


    getSnakeXY 1 ; get snakexy at index 1

    inc ebx ; increment snakex[0]
    cmp ebx, [outputSnakeX] ; compare snakex[0] + 1 with snakex[1]
    jne %%setRightKey ; if snakex[0] + 1 != snakey[1] set rightkey


    cmp ecx, [outputSnakeY] ; compare snakey[0] with snakey[1]
    jne %%setRightKey ; if snakey[0] != snakey[1] set rightkey 


    jmp %%exit ; exit since cant go back into body 
%%setRightKey:
    mov [direction], eax ; set snake direction to right
    jmp %%exit ; exit after setting direction
%%forwardKey:
    mov eax, forwardKeyLower ; set eax to forward key lower
    cmp eax, [direction] ; check if snake direction is forward
    je %%exit ; jump to exit if true


    getSnakeXY 1 ; get snakexy at index 1

    cmp ebx, [outputSnakeX] ; compare snakex[0] with snakex[1]
    jne %%setForwardKey ; if snakex[0] != snakey[1] set forwardkey


    dec ecx ; decrement ecx
    cmp ecx, [outputSnakeY] ; compare snakey[0] - 1 with snakey[1]
    jne %%setForwardKey ; if snakey[0] - 1 != snakey[1] set forwardkey 


    jmp %%exit ; exit since cant go back into body 
%%setForwardKey:
    mov [direction], eax ; set snake direction to forward
    jmp %%exit ; exit after setting direction
%%backKey:
    mov eax, backKeyLower ; set eax to back key lower
    cmp eax, [direction] ; check if snake direction is already back
    je %%exit ; jump to exit if true
    

    getSnakeXY 1 ; get snakexy at index 1

    cmp ebx, [outputSnakeX] ; compare snakex[0] with snakex[1]
    jne %%setBackKey ; if snakex[0] != snakey[1] set backkey


    inc ecx ; increment ecx
    cmp ecx, [outputSnakeY] ; compare snakey[0] + 1 with snakey[1]
    jne %%setBackKey ; if snakey[0] + 1 != snakey[1] set backkey 


    jmp %%exit ; exit since cant go back into body 
%%setBackKey:
    mov [direction], eax ; set snake direction to back
    jmp %%exit ; exit after setting direction
%%exit:
    popad ; pop all registers from the stack
%endmacro

%macro createSnake 0
    pushad ; push all registers to the stack
    
    mov ebx, dword baseScore
    mov [score], ebx

    setSnakeXY 0, 5, 5 ; set snakexy at index 0

    popad ; pop all registers from the stack
%endmacro

%macro incSnakeScore 0 ; score += 1
    pushad ; push all registers to the stack

    mov eax, [score]
    inc eax
    mov [score], eax

    popad ; pop all registers from the stack    
%endmacro

%macro checkSnakeCollision 0
    pushad ; push all registers to the stack

    mov eax, 1 ; set eax to 1
    
    
    getIndex [snakeX], [snakeY] ; get grid index at snakeX[0], snakeY[0] 
    isOnBorder [gridIndex] ; check if index at snake[0], snakey[0] is on border

    cmp [outputIsOnBorder], eax ; compare outputisonborder with 1
    je %%collided ; if outputisonborder == 1 jump to collided
    
    
    add eax, 2 ; add 2 to eax to make it 3


    cmp [score], eax ; compare score with 2 (impossible to collide if <= 3)
    jle %%checkFood ; if score is less than or equal to 3 jump to exit

    getSnakeXY 0 ; get snakexy at head
    mov ebx, [outputSnakeX] ; set ebx to outputsnakex
    mov ecx, [outputSnakeY] ; set ecx to outputsnakey

    inc eax ; set eax to 4
%%snakeLoop:
    getSnakeXY eax ; get snakexy at eax

    cmp ebx, [outputSnakeX] ; compare snakeX[0] with snakeX[eax]
    jne %%doNextSnake ; if snakeX[0] != snakeX[eax] do next snake

    cmp ecx, [outputSnakeY] ; compare snakeY[0] with snakeY[eax]
    je %%collided ; if snakeY[0] == snakeY[eax] jump to collided
%%doNextSnake:
    inc eax ; incremenet eax
    cmp eax, [score] ; compare eax with score
    jle %%snakeLoop ; jump if eax <= score

%%checkFood:    
    indexOnFood [gridIndex] ; check if snakeX[0], snakeY[0] is on food

    mov eax, 1 ; set eax to 1
    
    cmp [indexOnFoodOutput], eax ; compare indexonfoodoutput with 1
    je %%collidedWithFood ; jump to collidedwithfood if indexonfoodoutput == 1

    jmp %%exit ; else jump to exit
%%collided:
    mov eax, 1 ; set eax to 1

    mov [exitGame], eax ; set exit game to 1
    jmp %%exit ; jump to exit
%%collidedWithFood:
    generateFoodPosition

    incSnakeScore
%%exit:
    popad ; pop all the registers from the stack
%endmacro

%macro snakeMove 0 
    pushad ; push all registers to the stack

    mov eax, [score] ; set eax to snakescore
%%shiftSnake:
    cmp eax, 0 ; compare eax with 0
    jle %%moveInDir ; if eax is less than or equal to 0 get out of shiftsnake

    mov ebx, eax ; set ebx to eax
    dec ebx ; set ebx to eax - 1

    getSnakeXY ebx ; get snakexy at eax - 1
    setSnakeXY eax, [outputSnakeX], [outputSnakeY] ; set snake[eax] to snake[eax - 1]

    dec eax ; decrement eax
    jmp %%shiftSnake ; jump back to start of loop
%%moveInDir:
    getSnakeXY 0 ; get snakexy at index 0 (head) 

    mov eax, [outputSnakeX] ; set eax to outputsnakex
    mov ebx, [outputSnakeY] ; set ebx to outputsnakey


    mov ecx, [direction] ; set ecx to direction


    cmp ecx, leftKeyLower ; compare ecx with leftkey
    je %%moveLeft ; jump to moveleft if ecx == leftkey


    cmp ecx, rightKeyLower ; compare ecx with leftkey
    je %%moveRight ; jump to moveleft if ecx == leftkey


    cmp ecx, forwardKeyLower ; compare ecx with leftkey
    je %%moveForward ; jump to moveleft if ecx == leftkey


    cmp ecx, backKeyLower ; compare ecx with leftkey
    je %%moveBack ; jump to moveleft if ecx == leftkey


    jmp %%exit ; default to exit
%%moveLeft:
    dec eax ; snakeX -= 1
    mov [snakeX], eax ; set snakeX at index 0 to snakeX - 1

    jmp %%exit
%%moveRight:
    inc eax ; snakeX += 1
    mov [snakeX], eax ; set snakeX at index 0 to snakeX + 1

    jmp %%exit
%%moveForward:
    dec ebx ; snakeY -= 1
    mov [snakeY], ebx ; set snakeX at index 0 to snakeY - 1

    jmp %%exit
%%moveBack:
    inc ebx ; snakeY += 1
    mov [snakeY], ebx ; set snakeY at index 0 to snakeY + 1

    jmp %%exit
%%exit:
    popad ; pop all registers from the stack
%endmacro

%endif  