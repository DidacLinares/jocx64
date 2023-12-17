includelib ucrt.lib
includelib legacy_stdio_definitions.lib
includelib msvcrt.lib
includelib raylib.lib


.data
; , 10 means line feed character (LF)
; , 0 means adding an terminating '\0' to the string,10 end line
windowTitle byte 'Snake Assembly', 0 
DirectionText byte 'Direction: %d',10,0
DirectionText2 byte 'Pos_x: %d, Pos_y: %d',10,0 ; si vols imprimir aixo per pantalla, call fer primer sprintf i guardar a un buffer amb els numeros
screenWidth qword 800
screenHeigth qword 450
direction byte 3
oldirection byte 0


Rectangle STRUCT
    x dword ?
    y dword ?
    w dword ?
    h dword ?
    active byte ? 
Rectangle ENDS
Color STRUCT
    r BYTE ?
    g BYTE ?
    b BYTE ?
    a BYTE ?
Color ENDS
snake Rectangle <100, 100, 25, 25,0> 
apple Rectangle <50, 50, 25, 25,1> 
red Color <230,41,55,255>
green Color <0, 228, 48, 255>
snakeArray Rectangle 100 dup({100,100,25,25,0})

.code
externdef _CRT_INIT:proc, exit:proc
externdef InitWindow:proc, SetTargetFPS:proc, BeginDrawing:proc, ClearBackground:proc, EndDrawing:proc, CloseWindow:proc, WindowShouldClose:proc
externdef IsKeyDown:proc, DrawRectangle:proc,printf:proc
externdef draw:proc, update:proc
externdef snake:Rectangle
externdef apple:Rectangle
externdef red: Color
externdef green: Color
externdef direction: byte
externdef printdir: proc
externdef snakeArray:Rectangle


main proc
    ;call _CRT_INIT
    push rbp
    push rbx
    push rdi
    mov rbp, rsp

    mov byte ptr [snakeArray].active,1


    mov rcx,60
    call SetTargetFPS

    mov rcx, [screenWidth]
    mov rdx, [screenHeigth]
    lea r8, windowTitle
    call InitWindow

    mov rbx,0

    call WindowShouldClose
    test al, al
    jnz exit_game  ; Exit if the window should close
game_loop:

    call BeginDrawing

    mov rcx, 0  ; RGBA in one register!
    call ClearBackground
    call update

    add rbx,1
    call draw
    
    call EndDrawing

    mov al, direction
    cmp al,oldirection
    je no_print
    lea rcx,DirectionText
    mov dl,direction
    call printf
    mov al,direction
    mov oldirection,al
no_print:
    ;lea rcx,DirectionText2
    ;mov edx,snake.x
    ;mov r8d,snake.y
    ;call printf
    
    call WindowShouldClose
    test al, al
    jz game_loop  ; Exit if the window should closeexit_game: 
exit_game:

    xor ecx, ecx ; the first argument for exit() is setting to 0
    pop rdi
    pop rbx
    pop rbp
    sub rsp,8
    call exit
main endp

end