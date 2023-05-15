Make File: Archivo que permite definir como son las relaciones para compilar esos archivos a partir de ```make```

Supongamos que queremos compilar personaje.c. Queremos generar a partir de ello su correspondiente objeto personaje.o

Make File:

personaje.o: personaje.c personaje.h

Donde
 - Personaje.o es el target
 - Lo que va despues del : son sus dependencias
Luego agregamos el como se compila: 

    gcc -c personaje.c -o personaje.o

Entonces queda como
personaje.o: personaje.c personaje.h
    gcc -c personaje.c -o personaje.o

Ahora, invocamos make desde la consola
```
make
```

Si ejecutamos no crea un archivo .o
Si volvemos a ejecutar make entonces nos dice que el archivo está actualizado
El como lo hace se realiza viendo la fecha de modificacion de cada archivo. Si hay algun archivo con fecha de modificacion mas actual entonces vuelve a compilar, si no, no lo hace y sabe que todo está en la ultima version.

Convenciones:
En vez de poner el compilador se suelen hacer variables
CC := gcc   # Compilador a usar
CFLAGS := -wall -Wextra -pedantic

Variables automaticas: Toman el nombre de los pre-requisitos

touch personaje.c cambia la fecha de modificacion de personaje

Juego.c depende de personaje.h, pero juego depende de personaje, entonces indico luego 
juego.o: juego.c juego.h personaje.h

Y ahora main depende de ambas
main.o: main.c juego.h personaje.h

Ahora creamos el archivo ejecutable a partir de los 3 objetos


Make viene y se fija que debe crear ff100. Los tengo? Si entonces ejecuto eso
Si no los tengo, sigo y creo el primer objeto, si lo tengo sigo, si no lo creo
Y así con todo, luego vuelve al principio, entonces puedo ejecutar la instruccion para crear el ejecutable
Entonces creo el ejecutable


Algo util es crear targets adicionales llamados .PHONY
Ej:
.PHONY: clean
clean:

Cuando se llama el PHONY entonces es porque no se crea un archivo, simpmente se ejecutan las reglas
clean es un target phony

Podemos verlo como "crear comandos"
```
make clean 
```
Busca el metodo clean de .PHONY
Si ponemos al principio un target phony, al hacer make intentará hacer ese prncipalmente y listo en vez de ir uno por uno los comandos.
