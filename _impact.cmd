setMode -bs
setMode -bs
setMode -bs
setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 5 -file "/Gameboy/Gameboy_git/GAMEBOY_TOP/lcd_top.bit"
Program -p 5 
Program -p 5 
Program -p 5 
Program -p 5 
setCable -port auto
Program -p 5 
Program -p 5 
Program -p 5 
assignFile -p 5 -file "/Gameboy/Gameboy_git/GAMEBOY_TOP/lcd_top_good.bit"
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
saveProjectFile -file "/root//auto_project.ipf"
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
