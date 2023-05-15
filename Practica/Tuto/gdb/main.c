#include <stdio.h>
#include <stdlib.h>

#include "utils.h"

int main(){

    int mi_array[] = {1098, 6, 17, 2, 1, 24, 5, 21, 12, 12, 225, -2000};
    
    size_t max_pos, min_pos;
    size_t length = sizeof(mi_array) / sizeof(int);

    int minimum = min(mi_array, length, &min_pos);
    int maximum = max(mi_array, length, &max_pos);

    printf("El mínimo es: %d [%ld]\n", minimum, min_pos);
    printf("El máximo es: %d [%ld]\n", maximum, max_pos);

    printf("mi_array:\n");
    print(mi_array, length);

    int* reversed = reverse(mi_array, length);
    printf("mi_array invertido:\n");
    print(reversed, length);
    free(reversed);
}