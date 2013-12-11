18-545
======

18-545 Fighting Meerkats
Project: The Game Boy
Elon Bauer
Joseph Carlos
Alice Tsai


==========================
This is our 18-545 project, a mostly working original Game Boy on an FPGA.
If you have cloned this repo you probably want to know something about how it works, so we will explain that.
==========================

==========
Structure
==========
The main piece of documentation for our system is the final project writeup,
which is (shockingly and amazingly) Gameboy_Final_Report.pdf.

There are two top-level ISE projects. GAMEBOY_TOP works with the actual 
cartridge, and GAMEBOY_TOP_SIMPLE works with a "flashcart" which is a ROM with
the bootstrap code appended to the front of it.

The actual top-level verilog module is lcd_top.v which is located in 
cpu/cpusynth for GAMEBOY_TOP, and in GAMEBOY_TOP_SIMPLE for that project. 
This is called lcd_top because we were using the code given in Lab 1 to 
control the LCD screen and never got around to changing the name. And it 
would break everything if we did it now.

lcd_top instantiates all the modules that make up the Game Boy, including
the CPU, the GPU, the DVI module, the audio interface, the cartridge interface,
the NES controller, the rotary controller, timers, DMA, clock dividers,
and the link cable.

The code for the cpu is located in the cpu folder. Everything relating to the
CPU is located here except the header file cpu.vh which had to be in the top-
level directory. The auto_testbench is also included here, along with the 
bootstrap flash files and some Perl scripts to convert hex files.

The code for the GPU is located in the fpgaboy_files folder. Everything
relating to the GPU including the DVI module is located here, except for the
block RAM IP cores, which are located in the GPU_IP/ipcore_dir folder.

The code for the audio interface is located in the sound_src folder. Everything
relating to sound production including the setup of the AC97 codec is located
here, except for the rotary controller which is a top level file.

All other modules are located at the top level. These include the rotary
controller, the NES controller, the cartridge interface, the clock divider,
the tristate module, and the link cable.


=================
Testing Utilities
=================
Most unit test projects are located in the top-level directory in a folder 
ending in _test. The CPU uses the auto_testbench as well as roms in the roms
folder and dmg_emu folder.

The automatic testbench is found in auto_testbench and relies on the config.bat
batch file to setup the Xilinx toolchain and gbdk. It sets the path to include
gbdk and calls the Xilinx setup batch file. Unfortunately, I don't know where
these things are on anyone else's system so you'll have to edit the gbdk and
Xilinx setup script paths in the config.bat file for it to work on your system.

After running config.bat, you can use the ROM generation batch file found in
roms/gb or run the automatic testbench. Running the automatic testbench
can be done with run_all_sub.bat, which takes a single assembly file as an
argument. It creates a new directory for the test. It can be run multiple
times on an assembly file from the top directory and it won't overwrite the
test directory but simply re-run the test in that directory. In the created test
directory there should be a compiled executable and a waveform preferences file
copied from util so that you can look at all the useful CPU signals when
something goes awry.


==============
ROM Generation
==============
Generating Xilinx .mcs files for the board is somewhat of an adventure. In
roms/gb there are three scripts, dat2hex.pl, gb2flashcart.bat, and hex2dat.pl.

dat2hex.pl converts Verilog-readable memory list files (bytes followed by
newlines) to "hex" files, which are just memory list files with the bytes
repeated (because our flash was 16 bits and we didn't want to deal with doing
anything smarter than just reading the bottom 8 bits of each address).

hex2dat.pl converts binary files to Verilog-readable machine code list files.

gb2flashcart.bat takes a .gb file as input and spits out a .mcs file. It does
this by converting the .gb binary file to a machine code list file, then
appending bootstrap.dat (the machine code list for the bootstrap) to that. It
then converts that long file into a "hex" file (each byte of machine code
repeated twice for each 16-bit word of the flash). It takes that and generates
a .mcs file that can be loaded onto the board.

The resulting flash ROM will look something like

0x0000: 3131
0x0001: FEFE
0x0002: FFFF
...

This is so we can just hook up the address bus to the flash address lines
without having to address the top or bottom byte of the flash address based on
whether the address is odd or not. We basically just treat the flash as having
8-bit-wide data rather than having 16-bit-data.

This is memory-inefficient, but we did it like this initially to save headaches,
and never got around to changing it.