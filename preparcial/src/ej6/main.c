#include "funciones.h"

int main() {
    char* a = "CASA";

    char* b = cesar(a, 3);

    printf("%s", b);

    free(b);
}



char* cesar(char* palabra, int n) {
    
    int len = getSize(palabra); 

    char *string = malloc( len*sizeof(char) + 1); 
    strcpy(string, palabra);

    for(int i = 0; i < len; i++){
        string[i] = convCesar(string[i], n);
    }
    
    return string;

}

int getSize(char *s) {
    char *t; // first copy the pointer to not change the original
    int size = 0;

    for (t = s; *t != '\0'; t++) {
        size++;
    }

    return size;
}

char convCesar(char c, int x){
    int orden = ord(c) + x;
    // Si la letra es mayuscula se encuentra entre 65 y 90 inclusives
    orden = orden % 91;

    if(orden < 65){
        orden += 64;
    }

    c = chr(orden);
    return c;
}

int ord(char c) { 
    return (int)c;
}

char chr(int n) { 
    return (char)n;
}
