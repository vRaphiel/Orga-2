section .data
    array_int  dd 10, 20, 30, 40, 50, 10, 20, 30, 40, 50, 10, 20, 30, 40, 50, 10

global _start

section .text
_start:

    mov rsi, array_int
    mov rdx, 0
    xor r8, r8
    xor r9, r9
loop:

    movsxd r9,  [rsi + rdx*4]
    add r8, r9 

    add rdx, 1
    cmp rdx, 10
    jne loop

    mov     rax, 60             ; sys_exit() es 60
    mov     rdi, 0              ; rdi lleva el código de retorno
    syscall                     ; llama al exit

; Ahora tenemos un problema, los datos son de 32 bits pero usamos registros de 64 bits.
; rsi es correcto, las direcciones a memoria son de 64 bits, pero los datos de 32
; Para esto podemos usar la parte baja de los registros que es trabajar en 32 bits como antes
; Otra forma es "castear" de 32 a 64 bits.
; Movemos el valor a un registro de 64 bits usando la instrucción MOVSX o MOVSCD (En AMD)
; De esta forma, se hace la extensión de signo

; Si el registro previamente está completo con 1, lo mejor es limpiarlo con un xor y posteriormente,
; hacer el casteo en otro registro y luego hacer la suma, de tal forma podemos asegurarnos
; que se pueda hacer la suma correctamente, en caso de que esto no se pueda, mejor usar la parte
; baja de los registros