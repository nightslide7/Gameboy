
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name squarewave -dir "/Gameboy/AC97_work/squarewave/planAhead_run_1" -part xc5vlx110tff1136-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/Gameboy/AC97_work/squarewave/AC97.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/Gameboy/AC97_work/squarewave} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "AC97.ucf" [current_fileset -constrset]
add_files [list {AC97.ucf}] -fileset [get_property constrset [current_run]]
link_design
