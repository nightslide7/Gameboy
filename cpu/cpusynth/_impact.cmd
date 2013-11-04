setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
loadProjectFile -file "C:\Users\Joseph\Documents\F13\18545\labs\2\chipscope\auto_project.ipf"
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs
setMode -bs
attachflash -position 5 -bpi "28F256P30"
setMode -bs
setMode -bs
setMode -bs
setMode -bs
assignFile -p 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/cpu/cpusynth/lcd_top.bit"
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "C:/Users/Joseph/Documents/GitHub/Gameboy/cpu/cpusynth/bootstrap.mcs"
Program -p 5 -dataWidth 16 -rs1 NONE -rs0 NONE -bpionly -e -v 
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
