###############################################
# Surrogate script for the HDL Coder Workflow
###############################################
source $mw_hdl_dir/common/scripts/xilinx/mw_project.tcl

if { ! [info exist mw_board_name] } {
    set mw_board_name $boardName
}

# create the project
mw_project_create ${project}_${boardName} $mw_board_name

# Add the top HDL File
add_files -norecurse -fileset sources_1 $mw_hdl_dir/projects/ad9361/board/${project}/${boardName}/system_top.v
set_property top system_top [current_fileset]

# Run the common TCL file
source [file dirname [info script]]/system.tcl

# Disable OOC synthesis
set_property GENERATE_SYNTH_CHECKPOINT 0  [get_files -quiet system.bd]

regenerate_bd_layout
save_bd_design
validate_bd_design

# Run the post-IP tcl file
source $mw_ad9361/common/system_cleanup.tcl

# Build the bitstream
mw_project_run
