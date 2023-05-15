#include<stdio.h>
#include<stdint.h>

// Esta es una declaracion, no una funcion
// Al decir extern decimos que la funcion esta en otro lado, no aca, entonces cuando llega al linking en
// el compilador deja en todos los sitios donde se definio sum un huevo
// el linker va a buscar donde esta definida la funcion, si la encuentra rellena esos agujeros
// si no la encuentra deja un error
extern uint32_t sum(uint32_t a, uint32_t b);

int main(){
    uint32_t a = 21;
    uint32_t b = 79;

    printf("SUma %d + %d = %d\n", a, b, sum(a, b));
}