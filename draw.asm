
.data
Rectangle STRUCT
    x dword ?
    y dword ?
    w dword ?
    h dword ?
Rectangle ENDS
Color STRUCT
    r BYTE ?
    g BYTE ?
    b BYTE ?
    a BYTE ?
Color ENDS
externdef snake:Rectangle
externdef apple:Rectangle
externdef red: Color
externdef green: Color
externdef direction: byte


.code
externdef InitWindow:proc, SetTargetFPS:proc, BeginDrawing:proc, ClearBackground:proc, EndDrawing:proc, CloseWindow:proc, WindowShouldClose:proc
externdef IsKeyDown:proc, DrawRectangle:proc, DrawFPS: proc


draw proc
push rbp
mov rbp,rsp

sub rsp,48
mov ecx,snake.x
mov edx,snake.y
mov r8d,snake.w
mov r9d,snake.h
mov eax,green
mov dword ptr [rsp+32], eax
call DrawRectangle
add rsp,48

sub rsp,48
mov ecx,apple.x
mov edx,apple.y
mov r8d,apple.w
mov r9d,apple.h
mov eax,red
mov dword ptr [rsp+32],eax
call DrawRectangle
add rsp,48

sub rsp,48
mov ecx,10
mov edx,10
call DrawFPS
add rsp,48

pop rbp
ret
draw endp

END