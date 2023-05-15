
global strArrayNew
global strArrayGetSize
global strArrayAddLast
global strArraySwap
global strArrayDelete

extern malloc
extern strLen
extern strClone

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; str_array_t* strArrayNew(uint8_t capacity)
strArrayNew:
    push rbp
    mov rbp, rsp
    push r15
    push r14
    push r13
    push r12

    ; Reservo en memoria el capacity. Este indica cuantos datos se pueden almacenar
    ; No tengo en cuenta acá cuanto voy a almacenar como alineamiento porque no se cuanto
    ; va a medir cada String interno
    mov r15, rdi

    ; Creo el malloc del struct
    xor r14, r14
    xor r13, r13

    mov rdi, 0x10
    call malloc
    mov r14, rax    ; En r14 tengo la dirección del struct

    mov r12, 0
    mov [r14], r12
    mov [r14 + 0x01], r15   ; Guardo el capacity
    ; Creo el malloc del arreglo


cycleArrayNew:

    add r13, 0x08
    sub r15, 1
    cmp r15, 0
    jne cycleArrayNew

    mov rdi, r13
    call malloc
    ; Aca el rax tiene el tamaño del arreglo

    ; Armo las cosas
    mov [r14 + 0x08], rax

    mov rax, r14

    pop r12
    pop r13
    pop r14
    pop r15
    pop rbp

    ret


; uint8_t  strArrayGetSize(str_array_t* a)
;  str_array_t[rdi]
;  registros auxiliares:
;  capacity: rsi
;  tamanio: vendrá dado por el primer byte del struct

strArrayGetSize:
    push rbp
    mov rbp, rsp

    ; En rdi tengo la dirección de donde inicia el array
    ; Como es un array donde guardo un struct, tengo en cuenta su tamaño
    ; tengo 2 elementos uint8_t, que son size y capacity
    ; El puntero "data" me dice donde está el String, y el size me dice la longitud
    ; AL ser un arreglo de char, tengo un arreglo donde cada posición mide 1 byte (8 bits)
    ; Razonamiento:
    ;   Empiezo en posición 0
    ;   Recorro size * 8 que es la longitud por 8 bits cada uno, que es size * 1 byte. size * 0x08
    ;   Tengo en todo este momento un contador que me dice cuando estoy en posición 0 o no
    ;   Al llegar a contador == capacity - 1 se que llegué al final
    ;   La alineación a tener en cuenta depende de size y capacity, el char solo me indica la posición en la que está, que es como recorrerlo
    ;   E ir a la siguiente posición

    ; Accedo a lo que hay en primer posición y pruebo
 
    mov rax, [rdi]
    pop rbp
    ret

; void  strArrayAddLast(str_array_t* a, char* data)
; str_array_t[rdi], data[rsi]
strArrayAddLast:
    push rbp
    mov rbp, rsp

    sub rsp, 0x8
    push r15

    mov r15, rdi ; Hago un backup de rdi en r15
    mov rdx, [r15] ; Accedo a size

    add r15, 0x08
    mov rcx, [r15] ; Accedo a capacity

    add r15, 0x10  ; r15 queda apuntando al inicio de data

    cmp rdx, rcx
    ; Si son iguales no hago nada porque ya completé todo el arreglo
    je endStrArrayAddLast

    ; Si no son iguales, es decir, si rdx < rcx => size < capacity
    ; entonces tengo que agregar al final, esto significa, una copia y correr
    ; los datos

    ; Ahora tengo lo siguiente, el puntero apunta a la primera posición, entonces:
    ; Tengo que tener un contador que me recorra el arreglo desde 0 hasta size - 1
    ; Esto será teniendo en cuenta lo siguiente:
    ; Acceder al char**, esto es en posición rdi + 0x10, porque allí esta
    ; Entonces accedo en, rdi + 0x10, luego en rdi + 0x18, etc.
    ; Esto lo tomo de ej1.c donde, para recorrer todo, va incrementando en 1 el char, es decir
    ; accede a a->data[i]. Eso significa que en data[i] está lo que necesito
    ; Cuando data[i] sea null, es decir, 0x00, es porque acá ya puedo agregar el string
    ; Esto se traduce en ir iterando sobre el char** teniendo en cuenta que, la posición que voy a
    ; recorrer depende del valor ubicado entre 0 y rdx que es allí donde tengo el a->size

    xor r9, r9 ; Limpio R9 que será alli donde tenga mi contador
    ; r9 es 0, entonces tengo que iterar hasta que sea size (Usaré esto para saber que tengo en mi posición)
    ; pidiendo que rdi 0x10 sea siempre nulo

    ; Itero sobre data. Tengo que fijarme que despues de recorrer todo el string, tengo que fijarme si el siguiente
    ; elemento no es nulo

    ; Voy a necesitar dos ciclos
    ; Uno para data
    ; Otro para cada elemento en data

cicloParaData:
    ; Aca pregunto si lo que hay en data[i] tiene longitud distinta de 0

    mov rdi, [r15]
    call strLen
    cmp rax, 0
    ; Si rax es 0, entonces puedo agregar el elemeneto
    je agregarItem

    ; Si rax no es 0, entonces itero, como lo hago?
    ; Para esto accedo a lo que hay en r8, que es data[i]
    ; Entonces me muevo rax*0x08 posiciones y luego actualizo r8

cycleByStrLen:
    
    add r15, 0x08 ; Muevo r15 un byte mas para poder seguir como me corresponde

    sub rax, 1 ; Decremento en 1 la longitud de rax. Considero acá el caracter de finalización en C
    cmp rax, 0 ; Si la longitud es 0, significa que terminé de iterar ese string
    
    je cicloParaData

    jmp cycleByStrLen

agregarItem:    

    mov rdi, rsi
    call strClone
    ; La copia está en rax
    mov [r8], rax
    ; Ahora la copia está en r8, que es la posición del char

    jmp endStrArrayAddLast

endStrArrayAddLast:

    pop r15
    pop rbp
    ret

; void  strArraySwap(str_array_t* a, uint8_t i, uint8_t j)
; a [rdi], i [rsi], j [rdx]
strArraySwap:
    push rbp
    mov rbp, rsp

    cmp [rdi + 0x08], rsi ; comparo capacity con rsi. Si rsi > capacity entonces es invalido. Si no, es válido
    ; Idea, comparar los i y j con el capacity
    ; CMP op1, op2 hace op2 - op1 y mira los flags
    ; SI tomamos op1 como capacity y op2 como i o j entonces:
    ; si i - capacity es negativo, es porque i está en rango, si i es positivo distinto de 0, entonces estamos en una posición mayor
    ; y por ende no es valido
    ; si i es 0 es el ultimo elemento y lo consideramos valido
    ; lo mismo con j
    ; comparamos los valores, si está en rango accedo al char.
    ; Para hacer el swap hay que tener muy en cuenta a donde apuntar
    ; Para esto podemos hacer que el puntero en la posición i ahora apunte a donde está j y viceversa
    ; de tal manera no hay que hacer un reajuste de datos porque supongamos
    ; si lo que haya en i tiene tamaño 4 y lo que haya en j tieme tamaño 8, si i < j entonces nos va a ocurrir
    ; que si queremos mover j a i entonces ahora en i habrá un string de 8 de longitud, lo que hará que se nos tenga o:
    ; - que correr todos los datos
    ; - si no se corren los datos, overflow, porque no entra un string de 8 en un tamaño de 4
    ; por tal motivo, lo mejor a hacer es hacer que ahora los punteros apunten a lo correspondiente
    ; para eso utilizo el accedo a memoria y cambio la posicion

    pop rbp
    ret

; void  strArrayDelete(str_array_t* a)
strArrayDelete:
    ; Recorro cada posición y hago un free de cada char, ya que char** es un puntero de puntero, entonces tenemos
    ; que cada char* es un puntero, entonces se puede hacer un free
    ; para esto se va de final a inicio
    ; al finalizar todo, hacemos un free de a
    ; con eso terminamos la iteración




;Tuve problemas al definir el tamaño del struct
;Probe con el calculo a mano que vimos
;Haciendo pruebas a mano
;Midiendo los tipos de dato y nada
;El tamaño reservado en malloc teóricamente no coincide con lo visto ya que
;es un struct que no es packed, sin embargo, el programa funciona cuando el 
;tamaño reservado está para un struct packed;

;Estuve casi todo el examen con ese problema, los demas ejercicios los codifiqué como pude por cuestion de tiempo
;me quedaron 10 minutos antes de entregar el examen para poder ponerme a resolver lo restante por
;el problema del calculo del tamaño del malloc para el struct
;Gracias