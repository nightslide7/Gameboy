
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name DRAM -dir "/Gameboy/DRAM/planAhead_run_1" -part xc5vlx110tff1136-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/Gameboy/DRAM/tb.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/Gameboy/DRAM} {ipcore_dir} }
add_files [list {ipcore_dir/dram.ncf}] -fileset [get_property constrset [current_run]]
set_param project.pinAheadLayout  yes
set_property target_constrs_file "tb.ucf" [current_fileset -constrset]
add_files [list {tb.ucf}] -fileset [get_property constrset [current_run]]
link_design
