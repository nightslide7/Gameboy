setMode -bs
setMode -bs
setMode -bs
setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 5 -file "/Gameboy/AC97/AC97.bit"
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "/Gameboy/AC97/dragonforcesample.mcs"
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
saveProjectFile -file "/root//auto_project.ipf"
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
setMode -bs
setMode -bs
setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 5 -file "/Gameboy/AC97/AC97.bit"
attachflash -position 5 -bpi "28F256P30"
assignfiletoattachedflash -position 5 -file "/Gameboy/AC97/dragonforcesample.mcs"
attachflash -position 5 -bpi "28F256P30"
Program -p 5 -dataWidth 16 -rs1 NONE -rs0 NONE -bpionly -e -v 
Program -p 5 -bpi 
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
