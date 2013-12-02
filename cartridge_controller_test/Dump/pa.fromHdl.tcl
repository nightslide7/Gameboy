
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Dump -dir "/Gameboy/cartridge_controller/Dump/planAhead_run_2" -part xc5vlx110tff1136-1
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "cartridge.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {../ROM_dump.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top cartridge $srcset
add_files [list {cartridge.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc5vlx110tff1136-1
