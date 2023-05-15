AS		:= nasm
ASFLAGS	:= -f elf64 -F DWARF -g -Wall

LD		:= ld
LDFLAGS := -g

TARGET 	:= calcu

.PHONY: all
all: $(TARGET)

# Compilar Assembly
calcu.o: calcu.asm
	$(AS) $(ASFLAGS) $<

# Crear ejecutable
$(TARGET): calcu.o
	$(LD) $(LDFLAGS) $< -o $@

# Clean directorio
.PHONY: clean
clean:
	rm -rf *.o $(TARGET)