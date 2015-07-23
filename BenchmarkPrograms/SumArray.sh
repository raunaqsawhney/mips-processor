#!/bin/bash
FILE=SumArray
FLAGS='-nostartfiles -EB '
mips-sde-elf-gcc -mips32 $FLAGS -o $FILE.elf $FILE.c -T ece429.ld 
mips-sde-elf-gcc -mips32 $FLAGS -S $FILE.c -T ece429.ld 
mips-sde-elf-objdump -D $FILE.elf > $FILE.dmp
# SREC files are no longer used
#mips-sde-elf-objcopy -O srec $FILE.elf $FILE.srec
mips-sde-elf-objcopy -O binary $FILE.elf $FILE.bin
od -Ax -tx $FILE.bin > $FILE.raw 
./mk-bin.py $FILE.raw  > $FILE.x
