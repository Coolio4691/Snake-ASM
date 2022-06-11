%include "definitions.asm"
%include "globals.asm"
%include "math.asm"
%include "splitmix32.asm"
%include "print.asm"
%include "escapeHandlers.asm"
%include "file.asm"
%include "termios.asm"
%include "grid.asm"
%include "snake.asm"
%include "food.asm"

%include "signal.asm"

section .data ; initialized variables
    newLine db 10, 0
    gameOverMessage: db `\n#######    #    #     # #######    ####### #     # ####### ######\n#     #   # #   ##   ## #          #     # #     # #       #     #\n#        #   #  # # # # #          #     # #     # #       #     #\n#  #### #     # #  #  # #####      #     # #     # #####   ######\n#     # ####### #     # #          #     #  #   #  #       #   #\n#     # #     # #     # #          #     #   # #   #       #    #\n #####  #     # #     # #######    #######    #    ####### #     # \n\n\n                           Score: `, 0

section .bss ; uninitialized variables
    output: resb 1
    exitGame: resb 1

section .text
global _start

%macro printGameOver 0
    pushad ; push all registers to the stack

    setCursor 0, 0 ; set cursor xy to 0, 0
    
    setTextColour 0 ; couldnt figure out how to disable bg colour but this does it
    setTextColour WHITE ; set text colour to white
    clearConsole ; clear console

    print gameOverMessage ; print gameover file contents

    print_int [score] ; print score
    printwithlen newLine, 1 ; print newline

    popad ; pop all registers from the stack
%endmacro

_start:
    clearConsole
    
    mov eax, 1 ; set eax to 1
    mov [cursorActive], eax ; set cursor active to eax(1)
    

    clockGetTime CLOCK_REALTIME_COARSE ; get realtime
    mov ebx, [clockResult + 4] ; ebx = realtimens
    
    clockGetTime CLOCK_BOOTTIME ; get uptime
    add ebx, [clockResult + 4] ; ebx += boottimens

    imul ebx, [clockResult] ; ebx *= boottimeseconds

    splitmix32_seed ebx ; set splitmix32 seed to realtimens + boottimens


    echo_off ; disable writing char back to stdout
    canonical_off ; set to single char input 
    
    setVTime 0 ; set vtime to 0 for instant char input
    setVMin 1 ; set char min count to 1


    toggleCursor ; set cursor to hidden


    createSnake ; create snake
    gridInit ; initialize grid (food pos)
    

    setSignalHandler SIGALRM, alarmHandler ; set signal handler for alarm signal to alarm handler
    ualarm snake_usec_movespeed, snake_usec_movespeed ; start alarm with 200ms delay

    mov eax, 1 ; set eax to 1
.inputLoop:
    input output, eax ; get single char input into output variable 

    cmp [exitGame], eax ; compare exitgame with 1
    jne .inputLoop
.inputExit:
    printGameOver ; print gameover message

    toggleCursor ; show cursor

    canonical_on ; enable canonical mode (multiple char inputs)
    echo_on ; enable termios echo characters back
    exit success