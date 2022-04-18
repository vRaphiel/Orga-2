AS := nasm 
ASFLAGS := -f elf64 -F DWARF -g -Wall 
LD := ld 
LDFLAGS := -g 
TARGET := ejercicio1 

.PHONY : all clean 
all : $(TARGET) 

# assembly 
ejercicio1.o : ejercicio1.asm 
	$(AS) $(ASFLAGS) $< 
	
# linking 
$(TARGET) : ejercicio1.o 
	$(LD) $(LDFLAGS) $< -o $@ 
clean : 
	rm -rf *.o $(TARGET)