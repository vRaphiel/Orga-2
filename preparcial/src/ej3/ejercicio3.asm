section .data
    array_int  dd 10, 20, 30, 40, 50, 10, 20, 30, 40, 50, 10, 20, 30, 40, 50, 10

global _start

section .text
_start:

    mov rsi, array_int
    mov rdx, 0

loop:

    movsxd r9,  [rsi + rdx*4]
    add r8, r9 

    add rdx, 1
    cmp rdx, 10
    jne loop

    mov     rax, 60             ; sys_exit() es 60
    mov     rdi, 0              ; rdi lleva el código de retorno
    syscall                     ; llama al exit
