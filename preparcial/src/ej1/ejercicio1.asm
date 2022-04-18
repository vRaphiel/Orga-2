; Defino .data que es la sección donde se van a almacenar las variables inicializadas.
; El arreglo se define con el tipo dd ya que es un tipo para almacenar variables de 32 bits.
; Con eso se pueden definir los numeros correctamente.
; Como el array es dd significa que los valores son de 32 bits, por lo tanto, el movimiento de
; cada posición se hace de a 4 bytes para recorrerlo, por eso a esi, que es el inicio del array
; se le suma el contador * 4, que ese 4 representa a los 4 bytes y, por ende, se pasa a la
; siguiente posición para poder tener los datos correctos.

section .data
    array_int  dd 10, 20, 30, 40, 50, 10, 20, 30, 40, 50, 10, 20, 30, 40, 50, 10

global _start

section .text
_start:

    mov esi, array_int
    mov edx, 0
    xor ecx, ecx

loop:
    add ecx, [esi + edx*4]

    add edx, 1
    cmp edx, 15
    jne loop

    mov     rax, 60             ; sys_exit() es 60
    mov     rdi, 0              ; rdi lleva el código de retorno
    syscall                     ; llama al exit

; Es necesario el sys_exit para ejecutar directamente el programa en asm si no está llamado
; por una rutina de C