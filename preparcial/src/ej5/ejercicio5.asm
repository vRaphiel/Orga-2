global _start

section .text
_start:

    push rbp
    mov rbp, rsp

    call llamadora

    pop rbp

    mov     rax, 60             ; sys_exit() es 60
    mov     rdi, 0              ; rdi lleva el código de retorno
    syscall                     ; llama al exit

llamadora:
    push rbp
    mov rbp, rsp

    xor rax, rax

    mov rsi, 5
    ; El valro entrante está en RSI y, como se llama a Invocada, el valor sigue allí pues
    ; no hace falta cambiarlo ya que, RSI es el campo usado como referencia
    call invocada
    ; En rax vuelve el valor de retorno
    add rsi, [rax]
    mov rax, rsi

    pop rbp
    ret

invocada:
    push rbp
    mov rbp, rsp

    push rsi

    xor rax, rax
    add rax, rbp
    add rax, 0x10

    pop rbp
    ret