AS		:= nasm
ASFLAGS	:= -f elf64 -F DWARF -g -Wall

LD		:= ld
LDFLAGS := -g

TARGET 	:= holaorga

.PHONY: all
all: $(TARGET)

# Compilar Assembly
holaorga.o: holaorga.asm
	$(AS) $(ASFLAGS) $<

# Crear ejecutable
$(TARGET): holaorga.o
	$(LD) $(LDFLAGS) $< -o $@

# Clean directorio
.PHONY: clean
clean:
	rm -rf *.o $(TARGET)