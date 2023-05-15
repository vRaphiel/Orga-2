#include <stdio.h>
#include <stdlib.h>

#include "stack.h"
#include "student.h"

stack_t *stack;

int main()
{
    stack = createStack(100);

    student_t stud1 = {
        .name = "Steve Balmer",
        .dni = 12345678,
        .califications = {3,2,1},
        .concept = -2,
    };

    studentp_t stud2 = {
        .name = "Linus Torvalds",
        .dni = 23456789,
        .califications = {9,7,8},
        .concept = 1,
    };

    
    // Push student stud2
    studentp_t *stud2p = &stud2;
    uint64_t stud264 = (uint64_t) stud2p;
    uint32_t stud2v1= (uint32_t)((stud264 & 0xFFFFFFFF00000000LL) >> 32); //Entender esto mejor(PREGUNTAR). Pero hace un shift de bits. Hay otra forma mejor de hacerlo?
    uint32_t stud2v2 = (uint32_t)(stud264 & 0xFFFFFFFFLL);

    stack->createFrame(stack);
    /**
     * Al hacer create frame se está tomando la dirección en memoria del ebp. Esto son 64 bits, al dividirlo por 32 tenemos un numero 2
     * Esto se hace para tener la dirección del ebp dividida en 2 secciones de 32 bits cada una, luego se hace un ciclo for donde se ingresan
     * esas 2 direcciones, dejando en la pila como inicio la direccion del EBP ocupando 2 espacios
     * Utiliza este EBP como "separador" ???
     * A modo ilustrativo, la pila tiene ahora 2 elementos
    */
    stack->push(stack, stud2v2);
    stack->push(stack, stud2v1);
   

    // Push random value
    uint32_t value = 42;
    stack->push(stack,value);

    // Push student stud1
    student_t *stud1p = &stud1;
    uint64_t stud164 = (uint64_t) stud1p;
    uint32_t stud1v1 = (uint32_t)((stud164 & 0xFFFFFFFF00000000LL) >> 32); //Entender esto mejor. Pero hace un shift de bits.
    uint32_t stud1v2 = (uint32_t)(stud164 & 0xFFFFFFFFLL);

    stack->createFrame(stack);
    stack->push(stack, stud1v2);
    stack->push(stack, stud1v1);

    /**
     * A este momento, tenemos 7 elementos en la pila. 2 del ebp dividido en 2 partes de 32 bits
     * 5 elementos que son, 1 del valor 42 y los otros 4, 2 y 2 de los estudiantes pusheados
    */

    void (*prStudpt)() = printStudent;
    myCall(stack, prStudpt);

    prStudpt = printStudentp;
    myCall(stack, prStudpt);
    /**
     * Al hacer myCall tenemos los 5 pop de los valores de los estudiantes
     * Luego, se hace el pop de 2 direcciones mas, esas son las direcciones originales del ebp
     * Finalmente, tenemos 7 - 5 - 2 = 0
     * La pila (stack) queda vacia
    */
    // A qué apunta el esp???

    free(stack->_stackMem);
    free(stack); // Alcanza?  NO!!!!

    return 0;
}
