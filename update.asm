includelib legacy_stdio_definitions.lib


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
CollisionText byte 'Collisio Detectada!!',10,0
externdef screenWidth:qword
externdef screenHeigth:qword
externdef snake:Rectangle
externdef apple:Rectangle
externdef red: Color
externdef green: Color
externdef direction: byte
externdef snakeArray:Rectangle
externdef apple:Rectangle

.code
externdef InitWindow:proc, SetTargetFPS:proc, BeginDrawing:proc, ClearBackground:proc, EndDrawing:proc, CloseWindow:proc, WindowShouldClose:proc
externdef IsKeyDown:proc, DrawRectangle:proc, printf:proc

appleCollision proc
    mov eax,apple.x
    mov ecx,apple.y
    mov r8d,[snakeArray].x
    mov r9d,[snakeArray].y

    cmp eax,r8d
    jne end_appleCollision

    cmp ecx,r9d
    jne end_appleCollision

    mov rax,1
    ret

end_appleCollision:
    mov rax,0
    ret
appleCollision endp

input proc
    push rbp
    push rdi
    mov rbp,rsp

    mov rdi,rcx

    mov rcx,87
    call IsKeyDown
    cmp rax,1
    je adalt

    mov rcx,65
    call IsKeyDown
    cmp rax,1
    je esquerra

    mov rcx,68
    call IsKeyDown
    cmp rax,1
    je dreta

    mov rcx,83
    call IsKeyDown
    cmp rax,1
    je abaix
    jmp end_i
   
adalt:
    cmp rdi,4
    je end_i
    mov rdi,1
    jmp end_i

esquerra:
    cmp rdi,3
    je end_i
    mov rdi,2
    jmp end_i

dreta:
    cmp rdi,2
    je end_i
    mov rdi,3
    jmp end_i
abaix:
    cmp rdi,1
    je end_i
    mov rdi,4

end_i:
    mov rax,rdi
    pop rdi
    pop rbp
    ret
input endp

update proc
    push rbp
    push rdi
    mov rbp,rsp
    call appleCollision
    test al,al
    jz notDetectedCollision
collisionDeteced:
    sub rsp,40
    lea rcx,CollisionText
    call printf
    add rsp,40

notDetectedCollision:
    movzx rcx,direction ; move with zero extend
    call input 
    cmp rbx,20
    jne end_update
    mov rbx,0

    cmp rax,1
    je moure_adalt
    cmp rax,2
    je moure_esquerra
    cmp rax,3
    je moure_dreta
    cmp rax,4
    je moure_abaix

moure_adalt:
    cmp [snakeArray].y,0
    je end_update
    sub [snakeArray].y,25
    jmp end_update

moure_esquerra:
    cmp [snakeArray].x,0
    je end_update
    sub [snakeArray].x,25
    jmp end_update

moure_dreta:
    mov rdi, [screenWidth]
    sub rdi,25
    cmp edi,[snakeArray].x
    je end_update
    add [snakeArray].x,25
    jmp end_update

moure_abaix:
    mov rdi, [screenHeigth]
    sub rdi,25
    cmp edi,[snakeArray].y
    je end_update
    add [snakeArray].y,25
   
end_update:
    mov direction,al
    pop rdi
    pop rbp
    ret
update endp

end