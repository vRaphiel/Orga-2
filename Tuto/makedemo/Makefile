CC := gcc   # Compilador a usar
CFLAGS := -wall -Wextra -pedantic

.PHONY: all
all: ff100

ff100: main.o juego.o personaje.o #Archivo ejecutable de nombre ff100. Para generar el ejecutable necesito esos 3 .o
# La regla para generar es:
	$(CC) $(CFLAGS) $^ -o $@
# $^ significa "todos"

personaje.o: personaje.c personaje.h
# gcc -c personaje.c -o personaje.o 
# $(CC) $(CFLAGS) -c personaje.c -o personaje.o
	$(CC) $(CFLAGS) -c $< -o $@
# $< y $@ son las variables automaticas
# $< nombre de .c y $@ nombre de .o

juego.o: juego.c juego.h
	$(CC) $(CFLAGS) -c $< -o $a

main.o: main.c juego.h personaje.h
	$(CC) $(CFLAGS) -c $< -o $a

.PHONY: clean
clean:
	rm -f *.o
	rm -f ff100