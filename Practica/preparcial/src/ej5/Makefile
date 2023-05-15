AS := nasm 
ASFLAGS := -f elf64 -F DWARF -g -Wall 
LD := ld 
LDFLAGS := -g 
TARGET := ejercicio5 

.PHONY : all clean 
all : $(TARGET) 

# assembly 
ejercicio5.o : ejercicio5.asm 
	$(AS) $(ASFLAGS) $< 
	
# linking 
$(TARGET) : ejercicio5.o 
	$(LD) $(LDFLAGS) $< -o $@ 
clean : 
	rm -rf *.o $(TARGET)