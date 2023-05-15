; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "print.mac"

global start


; COMPLETAR - Agreguen declaraciones extern según vayan necesitando
extern C_FG_RED
extern A20_enable
extern GDT_DESC
extern print_text_rm
extern GDT_CODE_0_SEL
extern GDT_DATA_0_SEL

; COMPLETAR - Definan correctamente estas constantes cuando las necesiten
;%define CS_RING_0_SEL ??   
;%define DS_RING_0_SEL ??   

%define CS_RING_0_SEL 8
%define DS_RING_0_SEL 24

BITS 16
;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; COMPLETAR - Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO REAL 
    ; (revisar las funciones definidas en print.mac y los mensajes se encuentran en la
    ; sección de datos)
    print_text_rm start_rm_msg, start_rm_len, 0x4, 0, 0
    ; Ver que no funciona el define en el .h acá

    ; COMPLETAR - Habilitar A20
    ; (revisar las funciones definidas en a20.asm)
    call A20_enable

    ;xcgh = Exchanges the contents of the destination (first) and source (second) operands.
    ; COMPLETAR - Cargar la GDT
    lgdt [GDT_DESC]
    
    ; COMPLETAR - Setear el bit PE del registro CR0
    
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
    ; COMPLETAR - Saltar a modo protegido (far jump)
    ; (recuerden que un far jmp se especifica como jmp CS_selector:address)
    jmp CS_RING_0_SEL:modo_protegido; Tiene que ser un jmp far.
    ; Pueden usar la constante CS_RING_0_SEL definida en este archivo

    
BITS 32
modo_protegido:
    ; COMPLETAR - A partir de aca, todo el codigo se va a ejectutar en modo protegido
    ; Establecer selectores de segmentos DS, ES, GS, FS y SS en el segmento de datos de nivel 0
    ; Pueden usar la constante DS_RING_0_SEL definida en este archivo
    mov ax, DS_RING_0_SEL
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov fs, ax
    mov ss, ax

    ; COMPLETAR - Establecer el tope y la base de la pila
    mov esp, 0x25000
    mov ebp, 0x25000
    
    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO PROTEGIDO
    print_text_pm start_pm_msg, start_pm_len, 0x4, 0, 0

    xchg bx,bx

    ; COMPLETAR - Inicializar pantalla

    ; Ciclar infinitamente 
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
