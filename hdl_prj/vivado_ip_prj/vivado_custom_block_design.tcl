source $mw_hdl_dir/common/scripts/xilinx/mw_project.tcl
source $commonDir/vendor/adi/xilinx/mw_adi_proj_helper.tcl

set mw_ad9361     $mw_hdl_dir/projects/ad9361
set adi_prj_dir   $ad_hdl_dir/projects/$project
set mwIPScriptDir $mw_hdl_dir/library/scripts/ip

# Setup the project
mw_adi_setup_libs
source ${mw_ad9361}/board/${project}/${boardName}/system_project.tcl

if { ! [info exist mw_board_name] } {
    set mw_board_name $boardName
}

if { ! [info exist DUT_DATA_RATE_MHZ] } {
    set DUT_DATA_RATE_MHZ 62.5
}

mw_load_board_tcl $mw_board_name
mw_set_board_info $mw_board_name
mw_adi_proj

set curdir [pwd]
cd [mw_get_proj_dir]
create_bd_design "system"
cd $curdir

# Create the BD
set olddir [pwd]
cd [file dirname [file normalize ${system_bd_script}]]
source ${system_bd_script}
cd $olddir

switch -- $project {
    "fmcomms2" {
        set HWNUMCHAN 4
    }
    "fmcomms5" {
        set HWNUMCHAN 8
    }
}

mw_adi_bd_cleanup

source $mw_ad9361/common/mw_cleanup.tcl

save_bd_design
validate_bd_design

set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
set_property STRATEGY "Performance_Explore" [get_runs impl_1]
