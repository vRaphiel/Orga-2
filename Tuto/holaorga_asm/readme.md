Para compilar ejecutamos:
```
nasm -Wall -f elf64 -g -F DWARF holaorga.asm
```

-f elf64 es el formato (elf64)
Podemos agregarle flags como -Wall (warning all)
-g : debbug
-F DWARF: Formato Debug

Tenido el .o ahora linkeamos y hacemos ejecutable. Llamamos al linker

```
ld -g holaorga.o -o holaorga
```

MAKEFILE para ASM
Los .PHONY siempre estan desactualizados entonces al hacer el clean siempre se van a ejecutar

Llamar Asm desde C
LO que hacemos es que C llame a una rutina definida en assembly 

Al en asm declarar un global entonces decimos que esa función será declarada desde afuera
Ahora tendremos que hacer dos compiladores, uno para assembly y luego uno para C