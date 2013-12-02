
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name controller_test -dir "/Gameboy/rotary_controller/controller_test/planAhead_run_4" -part xc5vlx110tff1136-1
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "rotary_test.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {../rotary_controller.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top rotary_test $srcset
add_files [list {rotary_test.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc5vlx110tff1136-1
