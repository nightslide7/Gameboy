as-gbz80 -l asm_out.lst asm_in.s
perl raw.pl asm_out.lst mem.dat mem.x
rm asm_out.lst