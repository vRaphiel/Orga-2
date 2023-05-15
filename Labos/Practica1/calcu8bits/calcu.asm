
%define SYS_WRITE 1
%define SYS_EXIT 60
%define STDOUT 1
section .data

global _start

section .text
_start:
    mov     rax, SYS_WRITE  ; llamada al sistema
    mov     al, 0xFF
    mov     bl, 0xFF
    add     bl, al
              
    mov     rax, SYS_EXIT   ; exit
    mov     rdi, 0
    
    syscall