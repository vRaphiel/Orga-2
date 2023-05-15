#include "student.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>


void printStudent()
{
    /* Imprime por consola una estructura de tipo student_t
    */
    // Obtengo al student 1
    uint32_t stud1v2 = stack->pop(stack);
    uint32_t stud1v1 = stack->pop(stack);
    uint64_t stud164 = ((uint64_t)stud1v2) << 32 | stud1v1;
    student_t *dirStud1 = (student_t*) stud164;

    //Obtengo el valor random pusheado. 42 
    imprimirEstudiante(dirStud1); // La funcion es para no repetir codigo.

}

void printStudentp()
{
    uint32_t valor = stack->pop(stack);
    /* Imprime por consola una estructura de tipo studentp_t
    */
    // Obtengo al student 2
    uint32_t stud2v2 = stack->pop(stack);
    uint32_t stud2v1 = stack->pop(stack);
    uint64_t stud264 = ((uint64_t)stud2v2) << 32 | stud2v1;
    studentp_t *dirStud2 = (studentp_t *)stud264;

    printf("Valor: %d\n", valor);
    imprimirEstudianteDos(dirStud2);
}

void imprimirEstudiante(student_t *studDir){
    printf("Nombre: %s\n",studDir->name);
    printf("dni: %d\n",studDir->dni);
    printf("Calificaciones: ");
    for (size_t i = 0; i < sizeof(studDir->califications); i++)
    {
        printf("%d",studDir->califications[i]);
        printf(",");
    }
    printf("\n");
    printf("Concepto: %d\n",studDir->concept);
    printf("----------\n");
}

void imprimirEstudianteDos(studentp_t *studDir)
{
    printf("Nombre: %s\n", studDir->name);
    printf("dni: %d\n", studDir->dni);
    printf("Calificaciones: ");
    for (size_t i = 0; i < sizeof(studDir->califications); i++)
    {
        printf("%d", studDir->califications[i]);
        printf(",");
    }
    printf("\n");
    printf("Concepto: %d\n", studDir->concept);
    printf("----------\n");
}