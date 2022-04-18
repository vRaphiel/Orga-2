AS := nasm 
ASFLAGS := -f elf64 -F DWARF -g -Wall 
LD := ld 
LDFLAGS := -g 
TARGET := ejercicio4 

.PHONY : all clean 
all : $(TARGET) 

# assembly 
ejercicio4.o: ejercicio4.asm 
	$(AS) $(ASFLAGS) $< 
	
# linking 
$(TARGET) : ejercicio4.o 
	$(LD) $(LDFLAGS) $< -o $@ 
clean : 
	rm -rf *.o $(TARGET)