setMode -bs
setMode -bs
setMode -bs
setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/GAMEBOY_TOP_SIMPLE/lcd_top.bit"
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/cpu/cpusynth/bootstrap_real.mcs"
attachflash -position 5 -bpi "28F256P30"
Program -p 5 -dataWidth 16 -rs1 NONE -rs0 NONE -bpionly -e -v 
Program -p 5 -bpi 
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/GAMEBOY_TOP_SIMPLE/hello_world_full.mcs"
Program -p 5 -dataWidth 16 -rs1 NONE -rs0 NONE -bpionly -e -v 
Program -p 5 -bpi 
assignFile -p 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/GAMEBOY_TOP_SIMPLE/lcd_top_flashcart.bit"
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/GAMEBOY_TOP_SIMPLE/hello_world_full.mcs"
Program -p 5 -dataWidth 16 -rs1 NONE -rs0 NONE -bpionly -e -v 
Program -p 5 
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
