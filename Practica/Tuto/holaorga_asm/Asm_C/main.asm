extern sum
extern printf

global main

section .data
msg:
    db      'Suma %d + %d = %d', 0x0a, 0x00

section .text
main:
    push rbp
    mov rbp, rsp
    push rbx
    push r12    ; stack alineado :)

    mov ebx, 21
    mov r12d, 79

    mov edi, ebx
    mov esi, r12d

    call sum

    mov rdi, msg    ; 'Suma %d + %d = %d'
    mov esi, ebx    ;       ^
    mov edx, r12d   ;            ^
    mov ecx, eax    ;                 ^
    call printf

    xor eax, eax

    pop r12
    pop rbx
    pop rbp
    ret
