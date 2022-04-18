section .data
    array_int  dd 10, 20, 30, 40, 50, 10, 20, 30, 40, 50, 10, 20, 30, 40, 50, 10

global _start

section .text
_start:

    mov esi, array_int
    mov edx, 0
    
loop:
    movsxd r13, [esi + edx*4]
    push r13
    add edx, 1
    cmp edx, 15
    jne loop

loopSum:
    pop r15
    add r14, r15
    sub edx, 1
    cmp edx, 0
    jne loopSum

    push r14
    mov     rax, 60             ; sys_exit() es 60
    mov     rdi, 0              ; rdi lleva el código de retorno
    syscall                     ; llama al exit

; El tamaño del stack es de 64 bytes porque eso es lo que está alineado todo