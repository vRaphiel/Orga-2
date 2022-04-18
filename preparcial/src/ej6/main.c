#include <stdio.h>

int main() {
    
}

char convCesar(char c, int x){
    int orden = ord(c) + x;
    // Si la letra es mayuscula se encuentra entre 65 y 90 inclusives
    orden = orden % 91;

    if(orden < 65){
        orden += 64;
    }

    char d = chr(orden);
    return d;
}