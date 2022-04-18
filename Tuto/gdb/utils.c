#include "utils.h"
#include <stdio.h>
#include <stdlib.h>

int min(int *array, size_t lenght, size_t *pos){
    
    int current_min = array[0];
    *pos = 0;

    for (size_t i = 1; i < lenght; ++i){
        if(array[i] < current_min){
            current_min = array[i];
            *pos = i;
        }
    }
    return current_min;
}

int max(int *array, size_t lenght, size_t *pos){
    
    int current_max = array[0];
    *pos = 0;

    for (size_t i = 1; i < lenght; ++i){
        if(array[i] > current_max){
            current_max = array[i];
            *pos = i;
        }
    }
    return current_max;
}

/* Retorna un nuevo array cuyos índices se ordenan inversamente a los de array */

int* reverse(int *array, size_t length){
    int *reversed = malloc(sizeof(int)*length);

    for (size_t i = 0; i < length ; ++i){
        reversed[length - 1 - i] = array[i];
    }

    return reversed;
}

void print(int *array, size_t length){
    printf("{");
    for(size_t i = 0; i < length; ++i){
        printf("[%ld]: %d, ", i, array[i]);
    }
    printf("}\n");
}