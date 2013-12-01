
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name NES -dir "/Gameboy/NES/planAhead_run_2" -part xc5vlx110tff1136-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/Gameboy/NES/NES.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/Gameboy/NES} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "NES.ucf" [current_fileset -constrset]
add_files [list {NES.ucf}] -fileset [get_property constrset [current_run]]
link_design
