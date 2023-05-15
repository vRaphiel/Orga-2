; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "print.mac"

global start

; COMPLETAR - Agreguen declaraciones extern según vayan necesitando
extern A20_enable
extern GDT_DESC
extern screen_draw_layout
extern pic_reset
extern pic_enable
extern IDT_DESC
extern idt_init
extern KERNEL_PAGE_DIR
extern mmu_init_kernel_dir
extern copy_page
extern mmu_init_task_dir
extern mmu_next_free_kernel_page
extern tss_init
extern sched_init
extern task_init


; COMPLETAR - Definan correctamente estas constantes cuando las necesiten
;%define CS_RING_0_SEL ??
;%define DS_RING_0_SEL ??

%define CS_RING_0_SEL 8
%define DS_RING_0_SEL 24

%define TASK_IDLE_SEL 96
%define GDT_TASK_A_SEL 104
     
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
    print_text_rm start_rm_msg, start_rm_len, 0xF, 0, 0
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
    jmp 0x08:modo_protegido; Tiene que ser un jmp far.
    ; Pueden usar la constante CS_RING_0_SEL definida en este archivo

    
BITS 32
modo_protegido:
    ; COMPLETAR - A partir de aca, todo el codigo se va a ejectutar en modo protegido
    ; Establecer selectores de segmentos DS, ES, GS, FS y SS en el segmento de datos de nivel 0
    ; Pueden usar la constante DS_RING_0_SEL definida en este archivo
    mov ax, 24
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov fs, ax
    mov ss, ax

    ; COMPLETAR - Establecer el tope y la base de la pila
    mov esp, 0x25000
    mov ebp, 0x25000

    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO PROTEGIDO
    print_text_pm start_pm_msg, start_pm_len, 0xF, 2, 0

    ; COMPLETAR - Inicializar pantalla
    call screen_draw_layout

    ; Proceso de paginación
    call mmu_init_kernel_dir
    mov cr3, eax

    ; En esta sección cargamos a cr3 el directorio de páginas del kernel
    ; Habilitamos la paginación seteando el bit CR0.PG en 1
    xor eax, eax
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax
    xor ebx, ebx
    mov ebx, cr3 
    push ebx ; guardar el previo cr3

    ; Hay que pasarle la direccion fisica por parametro (0x18000)

    xor eax, eax
    mov eax, 0x00018000
    push eax

    call mmu_init_task_dir

    mov cr3, eax
    pop eax 
    pop ebx ; chequear orden
    
    mov cr3, ebx

    call mmu_next_free_kernel_page
    mov ebx, 0x22223333
    mov ecx, eax
    mov [eax], ebx

    add eax, 1
    add ebx, 1
    mov [eax], ebx

    add eax, 1
    add ebx, 1
    mov [eax], ebx

    add eax, 1
    add ebx, 1
    mov [eax], ebx

    mov ebx, eax 
    call mmu_next_free_kernel_page

    push ecx
    push eax

    call copy_page
    
    pop eax
    pop ebx
    ;xchg bx,bx

    ; ================= Interrupciones ==============================
    call idt_init
    lidt [IDT_DESC]

    call pic_reset ; remapear PIC
    call pic_enable ; habilitar PIC
    ; ================= Se cargan los tss iniciales =================
    call tss_init

    ; Se llama a sched_init
    call sched_init

    xor eax, eax
    ; 0000000001011 000 
    mov ax, 0x0058
    ltr ax
    
    ;xchg bx,bx

    ; 0000 0000 0110 0000 
    ; mov ax, 0x0060

    ;Intercambiar de TSS 
    ; Con la tr actual y el descriptor de la gdt busco la tss actual

    call task_init
    ; ================= Habilitar interrupciones ==============================
    mov ax, 0x006
    sti ; habilitar interrupciones

    jmp TASK_IDLE_SEL:0


    ;xchg bx,bx
    ;int 88
    ;xchg bx,bx
    ;int 98
    ;xchg bx,bx
    ;xchg bx,bx
     
    ; Ciclar infinitamente 
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
