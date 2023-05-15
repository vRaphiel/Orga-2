extern malloc
extern free
extern fprintf

section .data
msg     db 'NULL', 10

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
    push rbp
    mov rbp, rsp

    push r15
    push r14
    push r13
    push r12
    push rbx

    ; Registros contadores
    mov r14, rdi ; r14 a dir
    mov r15, rsi ; r15 b dir

    xor r9, r9
    xor r10, r10
    
    call strLen
    mov r12, rax ; r12 tamanio de a
    mov rdi, r15
    call strLen
    mov r13, rax ; r13 tamanio de b

    cmp r12, 0
    je esR13vacio
    cmp r13, 0
    je esR12vacio
    jmp continuacion

esR13vacio:
    cmp r13, 0
    je esIgualLongitud
    jmp esMenorA

esR12vacio:
    cmp r12, 0
    je esIgualLongitud
    jmp esMenorB

continuacion:

    dec r12
    dec r13

    mov r11, -1 ; contador

    ; Buscamos cual es el menor en longitud
    cmp r12,r13
    jl menorLongitudA
    mov r8, r13 
    jmp cycleCmp

menorLongitudA:
    mov r8, r12
    jmp cycleCmp

cycleCmp:
    inc r11
    mov r9b , [r14 + r11] ; caracter i-esimo de a
    mov r10b, [r15 + r11] ; caracter i-esimo de b
    
    cmp r9b, r10b
    jl esMenorA
    jg esMenorB

    ; Ambos prefijos iguales
    cmp r11, r8
    je medirLongitud
    jmp cycleCmp
    
medirLongitud:
    cmp r12, r13
    jl esMenorA
    jg esMenorB
    jmp esIgualLongitud

esMenorA:
    mov rax, 1    
    jmp fin

esMenorB:
    mov rax,-1
    jmp fin

esIgualLongitud:
    mov rax, 0
    jmp fin

fin:

    pop rbx 
    pop r12
    pop r13
    pop r14
    pop r15


    pop rbp
    ret

; char* strClone(char* a)
strClone:

    push rbp
    mov rbp, rsp

    mov r13, rdi    ; Hacemos una copia del puntero inicial
    
    call strLen
    mov r12, rax     ; Tamanio del string

    inc rax
    mov rdi, rax    ; Copiamos el tamanio del string
    call malloc WRT ..plt
    ;call malloc
    mov r14, -1

    cmp r12, 0
    je esVacio

    dec r12
    jmp cycleClone

esVacio:
    inc r14
    mov cl, [r13 + r14]  ; Una copia de lo que hay en r13, es decir, el string
    mov [rax + r14], cl
    jmp finClone

cycleClone:

    inc r14
    mov cl, [r13 + r14]  ; Una copia de lo que hay en r13, es decir, el string
    mov [rax + r14], cl
    cmp r14, r12
    jne cycleClone

    inc r14
    mov [rax + r14], byte 0

    jmp finClone

finClone:
    pop rbp
    ret


; void strDelete(char* a)
strDelete:
    push rbp
    mov rbp, rsp

    call free

    pop rbp
    ret

; void strPrint(char* a, FILE* pFile)
strPrint:
    push rbp 
    mov rbp, rsp 

    push r15 
    push r14 
    push r13
    push r12 
    push rbx

    mov r15, rsi ; r15 = dir de pFile
    mov r14, rdi ; r14 = dir de a

    call strLen 
    mov r13, rax ; r13 = tamanio de a

    cmp r13, 0
    je esVacioChar
    
    xor rax, rax

    mov rdi, r15
    mov rsi, r14
    call fprintf
    ; fprintf(archivo, "Hola mundo")
    jmp finCopy

esVacioChar:

    xor rax, rax
    mov rdi, r15
    mov rsi, msg
    call fprintf
    jmp finCopy

finCopy:
    pop rbx 
    pop r12
    pop r13
    pop r14
    pop r15

    pop rbp
    ret

; uint32_t strLen(char* a)
strLen:
    push rbp
    mov rbp, rsp
    push r15
    
    mov rcx, -1     ; Contador de caracteres
    xor r15, r15
    
cycle:  

    inc rcx
    mov r15b, [rdi + rcx] 
    cmp r15b, 0x00 ; Preguntar cmp byte
    jne cycle

    mov rax, rcx

    pop r15
    pop rbp
    ret 