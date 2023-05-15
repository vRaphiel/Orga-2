#include "funciones.h"

int main() {
    char* a = "Astronomia";
    char* b = "Astrologia";
    int lonPrex = prefijo_de(a, b);
    printf("%i\n", lonPrex);
    
    char* sin_prefijo = quitarPrefijo("Astro", a);
    printf("%s\n", sin_prefijo);
    free(sin_prefijo);
}

int prefijo_de(char* palabra1, char* palabra2){
    char* palabra1cpy = malloc(strlen(palabra1) + 1);
    char* palabra2cpy = malloc(strlen(palabra2) + 1);
    strcpy(palabra1cpy, palabra1);
    strcpy(palabra2cpy, palabra2);

    int prefijoMasLargo = 0;
    int terminaPrefijo = 0;
    int p2len = (int) strlen(palabra1cpy);

    for (int i = 0; i < p2len; i++)
    {
        if(palabra1cpy[i] != palabra2cpy[i]){
            terminaPrefijo = 1;
        }
        
        if(terminaPrefijo == 0){
            prefijoMasLargo++;
        }
    }

    free(palabra1cpy);
    free(palabra2cpy);

    return prefijoMasLargo;
}

char* quitarPrefijo(char* prefijo, char* palabra2){
    int lenPrex = strlen(prefijo);
    int lenPal2 = strlen(palabra2);

    char *palabra2sinPrefijo = malloc( lenPal2 - lenPrex + 1);
    
    for(int i = lenPrex; i < lenPal2; i++){
        palabra2sinPrefijo[i % lenPrex] = palabra2[i];
    }

    return palabra2sinPrefijo;
}