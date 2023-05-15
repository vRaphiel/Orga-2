AS := nasm 
ASFLAGS := -f elf64 -F DWARF -g -Wall 
LD := ld 
LDFLAGS := -g 
TARGET := ejercicio2 

.PHONY : all clean 
all : $(TARGET) 

# assembly 
ejercicio2.o : ejercicio2.asm 
	$(AS) $(ASFLAGS) $< 
	
# linking 
$(TARGET) : ejercicio2.o 
	$(LD) $(LDFLAGS) $< -o $@ 
clean : 
	rm -rf *.o $(TARGET)