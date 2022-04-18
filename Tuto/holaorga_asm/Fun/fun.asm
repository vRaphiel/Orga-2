global sum

section .text
; uint32_t sum(uint32_t a, uint32_t b)

; edi -> a
; esi -> b
sum:
    push rbp
    mov rbp, rsp

    add edi, esi
    mov eax, edi

    pop rbp
    ret