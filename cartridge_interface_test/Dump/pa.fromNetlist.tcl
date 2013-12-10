
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name Dump -dir "/Gameboy/cartridge_controller/Dump/planAhead_run_4" -part xc5vlx110tff1136-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/Gameboy/cartridge_controller/Dump/cartridge.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/Gameboy/cartridge_controller/Dump} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "cartridge.ucf" [current_fileset -constrset]
add_files [list {cartridge.ucf}] -fileset [get_property constrset [current_run]]
link_design
