setMode -bs
setMode -bs
setMode -bs
setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 5 -file "/Gameboy/dvi_test/DVI_Test/Framebuffer.bit"
Program -p 5 
Program -p 5 
Program -p 5 
Program -p 5 
assignFile -p 5 -file "/Gameboy/dvi_test/DVI_Test/Framebuffer.bit"
ReadIdcode -p 5 
Program -p 5 
assignFile -p 5 -file "/Gameboy/AC97_work/AC97.bit"
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
