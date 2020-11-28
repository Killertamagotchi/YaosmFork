#
# Makefile for to make stuffs

# cross compiler
# CHANGE THIS TO YOUR COMPILER'S BINARY DIRECTORY AND CROSS COMPILER PREFIX
CROSS_COMPILE_PATH = 
CROSS_COMPILE_PREFIX = mn10200-
#CROSS_COMPILE_PREFIX = mn10200-elf-

#If your compilers are called something different change these...
LD = $(CROSS_COMPILE_PATH)$(CROSS_COMPILE_PREFIX)ld
AS = $(CROSS_COMPILE_PATH)$(CROSS_COMPILE_PREFIX)as

#These sections below define the different make types
# for instance make sys will only make the system files, make ram only makes the 
# ram files, make clean will erase all compiled files

# make everythng
all : asm link

#stuff thats coded in asm
asm:
	$(AS) --defsym _D2A=1 yaosm.S -o yaosm_d2a.o
	$(AS) --defsym _D2B=1 yaosm.S -o yaosm_d2b.o

#link it all together
link: 
	$(LD) -Ttext 0x40807a -e 0x40807a --just-symbols d2a.jsym yaosm_d2a.o -o d2a.elf
	$(LD) -Ttext 0x40807a -e 0x40807a --just-symbols d2a.jsym --oformat binary d2a.elf -o d2a.bin

	$(LD) -Ttext 0x40807c -e 0x40807c --just-symbols d2b.jsym yaosm_d2b.o -o d2b.elf
	$(LD) -Ttext 0x40807c -e 0x40807c --just-symbols d2b.jsym --oformat binary d2b.elf -o d2b.bin

# ofc a make clean, very handy
clean:
	rm -f *.o *.elf d2a.bin d2b.bin
	

