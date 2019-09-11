# Cleanup script to be called from HDL Coder
set thisDir [file normalize [file dirname [info script]]]

if { ! [info exists mw_hdl_dir] } {
    set mw_hdl_dir ${thisDir}/ipcore/mw
}

source $mw_hdl_dir/common/scripts/xilinx/mw_project.tcl

if { [llength [current_bd_design -quiet]] == 0 } {
    set BDFILEPATH [get_files -quiet system.bd]
    open_bd_design $BDFILEPATH
}

source $mw_hdl_dir/projects/ad9361/common/mw_cleanup_io.tcl

source $mw_hdl_dir/projects/ad9361/common/mw_cleanup_bd_gpio.tcl

validate_bd_design
save_bd_design

source $mw_hdl_dir/projects/ad9361/common/gen_wrapper.tcl
