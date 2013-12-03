setMode -bs
setMode -bs
setMode -bs
setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/GAMEBOY_TOP_SIMPLE/lcd_top_flashcart.bit"
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "C:/Users/Joseph/Documents/F13/18545/programs/test_roms/07_lol.mcs"
Program -p 5 -dataWidth 16 -rs1 NONE -rs0 NONE 
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "C:/Users/Joseph/Documents/F13/18545/programs/test_roms/soundtest.mcs"
Program -p 5 -dataWidth 16 -rs1 NONE -rs0 NONE 
assignFile -p 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/GAMEBOY_TOP/lcd_top.bit"
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/cpu/cpusynth/bootstrap_real.mcs"
Program -p 5 -dataWidth 16 -rs1 NONE -rs0 NONE -bpionly -e -v 
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "C:/Users/Joseph/Documents/F13/18545/programs/test_roms/soundtest.mcs"
assignFile -p 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/GAMEBOY_TOP_SIMPLE/lcd_top_flashcart.bit"
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "C:/Users/Joseph/Documents/F13/18545/programs/test_roms/soundtest.mcs"
Program -p 5 -dataWidth 16 -rs1 NONE -rs0 NONE -bpionly -e -v 
setMode -bs
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs
saveProjectFile -file "C:\Users\Joseph\Documents\F13\18545\labs\2\chipscope\\auto_project.ipf"
setMode -bs
setMode -bs
deleteDevice -position 1
deleteDevice -position 1
deleteDevice -position 1
deleteDevice -position 1
deleteDevice -position 1
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
