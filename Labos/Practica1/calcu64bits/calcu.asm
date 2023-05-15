
%define SYS_WRITE 1
%define SYS_EXIT 60
%define STDOUT 1
section .data

global _start

section .text
_start:
    mov     rax, SYS_WRITE  ; llamada al sistema
    mov     rdi, STDOUT 
    mov     rax, 0xFFFF
    mov     rbx, 0xFFFF
    add     rbx, rax
              
    mov     rax, SYS_EXIT   ; exit
    mov     rdi, 0
    
    syscall