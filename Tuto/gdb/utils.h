#ifndef UTILS_H
#define UTILS_H

/* Retorna el primer máximo/mínimo en un array de enteros. 
 * En el argumento pos, retorna la posición de dicho máximo 
 *
 * El array debe contener al menos una posición válida */

#include <stddef.h>
#include <stdbool.h>
#include <stdint.h>

int min(int *array, size_t length, size_t *pos);
int max(int *array, size_t length, size_t *pos);

/* Devuelve un nuevo array con los índices invertidos */
int* reverse(int *array, size_t length);

/* Imprime el array en stdout */

void print(int *array, size_t length);

#endif
