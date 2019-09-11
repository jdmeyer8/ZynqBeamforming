proc mw_project_create {project_name {boardName_in ""}} {

    if {$boardName_in == ""} {
        puts "==> Deriving board name from project name"    
        if [regexp "_zed$" $project_name] {
            set boardName_in "zed"
        }
        if [regexp "_zc702$" $project_name] {
            set boardName_in "zc702"
        }
        if [regexp "_zc706$" $project_name] {
            set boardName_in "zc706"
        }

        if [regexp "_uzed_7020$" $project_name] {
            set boardName_in "uzed7020"
        }

        if [regexp "_uzed_7010$" $project_name] {
            set boardName_in "uzed7010"
        }
    
        if [regexp "_mmp100$" $project_name] {
            set boardName_in "mmp100"
        }
        
        if [regexp "_mmp045$" $project_name] {
            set boardName_in "mmp045"
        }

        puts "==> Setting board name to $boardName_in"
    }

    mw_load_board_tcl $boardName_in
    mw_set_board_info $boardName_in
    mw_init_project $project_name
    mw_setup_libs
    mw_config_project  
}

proc mw_config_project {} {
    set buildAny [expr [mw_get_build_target "handoff"] || [mw_get_build_target "fsbl"]]
    switch [mw_project_get cpu_type] {
        kintex7_pcie {
            mw_set_build_target "fsbl" 0
            mw_set_build_target "handoff" 0
        }
        zynqmp_arm {
           mw_set_build_target "fsbl" 0
           mw_set_build_target "handoff" $buildAny
           mw_project_set xsdk_proc "mw_create_zynqmp_fsbl"
           mw_project_set xsdk_binaries [list fsbl/executable.elf pmufw/executable.elf pmufw/executable.bin]
        }
        zynq7_arm {
           mw_set_build_target "fsbl" 0
           mw_set_build_target "handoff" $buildAny
           mw_project_set xsdk_proc "mw_create_zynq_fsbl"
           mw_project_set xsdk_binaries [list fsbl/executable.elf]
        }
    }
}

proc mw_project_set {configItem value} {
    global mw_project_info
    if { ![info exists mw_project_info] } {
        set mw_project_info [dict create]
    }
    
    dict set mw_project_info $configItem $value
}

proc mw_project_get {configItem} {
    global mw_project_info
    if { ![info exists mw_project_info] } {
        return ""
    }
    if { [dict exists $mw_project_info $configItem] } {
        return [dict get $mw_project_info $configItem]
    } else {
        return ""
    }
}

proc mw_set_board_info {boardName_in} {
    # defaults
    mw_project_set "mw_ip_baseaddr" 0x40010000
    mw_project_set "boardName" $boardName_in 
    mw_project_set "cpu_type" "zynq7_arm"

    if { [info procs board_set_board_info] == "board_set_board_info" } {
        board_set_board_info
    } else {
        switch $boardName_in {
            zed {
                mw_project_set project_part "xc7z020clg484-1"
                mw_project_set project_board "em.avnet.com:zed:part0:1.0"
                mw_project_set mw_ip_baseaddr 0x400D0000
            }
            zc702 {
                mw_project_set project_part "xc7z020clg484-1"
                mw_project_set project_board "xilinx.com:zc702:part0:1.0"
            }
            zc706 {
                mw_project_set project_part "xc7z045ffg900-2"
                mw_project_set project_board "xilinx.com:zc706:part0:1.0"
            }

            uzed7020 {
                mw_project_set project_part "xc7z020clg400-1"
                mw_project_set project_board "em.avnet.com:MicroZed_7020:part0:1.0"
            }

            uzed7010 {
                mw_project_set project_part "xc7z010clg400-1"
                mw_project_set project_board "em.avnet.com:MicroZed_7010:part0:1.1"
            }

            mmp100 {
                mw_project_set project_part "xc7z100ffg900-2"
                mw_project_set project_board "em.avnet.com:mini_module_plus_7z100_rev_c:part0:1.0"
            }

            mmp045 {
                mw_project_set project_part "xc7z045ffg900-1"
                mw_project_set project_board "em.avnet.com:mini_module_plus_7z045_rev_c:part0:1.0"
            }
            default {
                mw_error "Board not found: $boardName_in"
            }
        }
    }
    puts [format "==> Using Board %s" [mw_project_get boardName]]
}

proc mw_add_board_repo {repoPath} {
    set repoPath [file normalize $repoPath]
    set repoPaths [get_param board.repoPaths]
    lappend repoPaths $repoPath
    set repoPaths [lsort -unique $repoPaths]
    set_param board.repoPaths $repoPaths
}

proc mw_init_project {project_name} {
    global commonDir
    
    # Setup the build directory
    set buildDir [file normalize ./build]
    file delete -force -- $buildDir
    file mkdir $buildDir
    mw_project_set buildDir $buildDir

    # Add the board directory to the repo paths
    mw_add_board_repo ${commonDir}/boards

    mw_project_set boardDir ${commonDir}/boards/[mw_project_get boardName]

    if { [mw_project_get project_part] == "" } {
        if { [mw_project_get project_board] ne "" } {
            # Set the part based on the board
            mw_project_set project_part [get_property PART_NAME [get_board_parts [mw_project_get project_board]]]
        } else {
            mw_error "project_part or project_board must be defined"
        }
    }

    create_project $project_name $buildDir -part [mw_project_get project_part] -force
    file mkdir [mw_get_output_dir]

     if {[mw_project_get project_board] ne ""} {
        set_property board_part [mw_project_get project_board] [current_project]
    }

    if { [info procs board_init_project] == "board_init_project" } {
        board_init_project
    }
}

proc mw_load_board_tcl {boardName_in} {
    global commonDir

    set board_tcl $commonDir/boards/$boardName_in/tcl/board_project.tcl
    if { [file exists $board_tcl] } {
        source $board_tcl
    }
}

proc mw_setup_libs {} {
    global mw_hdl_dir

    # cleanup local lib
    set local_lib [mw_get_proj_dir]/lib
    file delete -force $local_lib
    file mkdir $local_lib

    mw_add_libdir $local_lib
    mw_add_libdir $mw_hdl_dir/library
    
}

proc mw_add_libdir { libdir } {
    set proj_libs [get_property ip_repo_paths [current_fileset]]
    lappend proj_libs $libdir
    set proj_libs [lsort -unique $proj_libs]
    set_property ip_repo_paths $proj_libs [current_fileset]
    update_ip_catalog
}

proc mw_create_wrapper { {makeTop true} } {
    if {[mw_get_build_target "wrapper"]} {
        set BDFILEPATH [get_files -quiet system.bd]
        make_wrapper -files $BDFILEPATH -top
        # Try adding Block design filepath to naviagate & generate top wrapper
        regsub -all "system.bd" [get_files -quiet system.bd] "hdl" TOPFILEPATH
        catch {
            add_files -norecurse $TOPFILEPATH
            update_compile_order -fileset sources_1
            }
        if { $makeTop } {
            set_property top system_wrapper [current_fileset]
        }
    }
}

proc mw_build_all {} {
    mw_create_wrapper
    mw_project_run
}

proc mw_project_run {} {
    if {[mw_get_build_target "bdgen"]} {
        mw_bd_generate
    }
    if {[mw_get_build_target "handoff"]} {
        mw_gen_ps_init
    }
    if {[mw_get_build_target "fsbl"]} {
        mw_create_fsbl
    }
    if {[mw_get_build_target "bitstream"]} {
        mw_build_bit
    }
}

proc mw_bd_generate {} {
    set BDFILEPATH [get_files -quiet system.bd]
    generate_target all $BDFILEPATH
}

proc mw_build_bit {} {

    set curdir [pwd]
    cd [mw_get_proj_dir]
    set project_name [get_property name [current_project]]
    set top [get_property top [current_fileset]]
    set bit_file ./${project_name}.runs/impl_1/${top}.bit

    launch_runs synth_1
    wait_on_run synth_1
    open_run synth_1
    report_timing_summary -file timing_synth.log

    launch_runs impl_1 -to_step write_bitstream
    wait_on_run impl_1
    open_run impl_1
    report_timing_summary -file timing_impl.log

    if [expr [get_property SLACK [get_timing_paths -delay_type min_max]] < 0] {
        mw_error "Timing Constraints NOT met."
    } else {
        puts "-----------------------------------------------"
        puts "SUCCESS: Bitstream generation complete."
        puts "-----------------------------------------------"    
    }

    file copy -force $bit_file [mw_get_output_dir]/system.bit
    cd $curdir
}

proc mw_create_hdf {} {
    set project_dir [mw_get_proj_dir]
    set project_name [get_property name [current_project]]
    set workspace ${project_dir}/${project_name}.sdk/
    set hwdef $workspace/system.hdf

    file delete -force -- $workspace
    file mkdir $workspace

    write_hwdef  -file $hwdef

    return $hwdef
}

proc mw_gen_ps_init {} {
    set curdir [pwd]
    set handoff_dir [mw_get_output_dir]/handoff

    file delete -force -- $handoff_dir
    file mkdir $handoff_dir

    set hdfpath [mw_create_hdf]
    set workspace [file dirname $hdfpath]
    set hdf [file tail $hdfpath]

    cd $workspace

    # Generate the ps init files
    hsi::open_hw_design $hdf
    hsi::close_hw_design [hsi::current_hw_design]

    cd $curdir

    # Copy to the handoff dir
    file copy {*}[glob ${workspace}/*gpl*] $handoff_dir/
}

proc mw_create_fsbl {} {

    global commonDir  

    set hdfpath [mw_create_hdf]
    set workspace [file dirname $hdfpath]
    set hdf [file tail $hdfpath]

    set elf_file $workspace/fsbl/executable.elf
    set XSDK_PATH $::env(XILINX_SDK)
    
    set curdir [pwd]
    
    cd $workspace
    hsi::open_hw_design $hdf
    hsi::set_repo_path ${XSDK_PATH}/data/embeddedsw
    [mw_project_get xsdk_proc]
    
    cd $curdir
    
    
    foreach bin [mw_project_get xsdk_binaries] {
        set binFile ${workspace}/${bin}
        set outFile [string map {/ _} $bin]
        file copy -force $binFile [mw_get_output_dir]/${outFile}
    }
}

proc mw_create_zynq_fsbl {} {
    set procs [hsi::get_cells -filter {IP_TYPE==PROCESSOR}] 
    hsi::generate_app -hw [hsi::current_hw_design] -proc [lindex $procs 0] -app zynq_fsbl -os standalone -sw fsbl -dir fsbl -compile
}

proc mw_create_zynqmp_fsbl {} {
    set procs [hsi::get_cells -filter {IP_TYPE==PROCESSOR && NAME =~ "*a53*"}] 
    hsi::generate_app -hw [hsi::current_hw_design] -proc [lindex $procs 0] -app zynqmp_fsbl -os standalone -sw fsbl -dir fsbl -compile
    hsi::generate_app -hw [hsi::current_hw_design] -proc psu_pmu_0 -app zynqmp_pmufw -os standalone -sw pmufw -dir pmufw -compile
    exec mb-objcopy -O binary pmufw/executable.elf pmufw/executable.bin
}

proc mw_env_path_var {varname envname} {
    global $varname
 
    if { ! [info exist $varname] } {
        if  { [info exists ::env($envname)] } {
            set $varname $::env($envname)
        } else {
            mw_error "Neither tcl variable $varname or environment variable $envname are set"
        }   
    }
    set $varname [file normalize [set $varname]]
}

proc mw_get_proj_dir {} {
    return [get_property DIRECTORY [current_project]]
}

proc mw_get_output_dir {} {
    return [mw_get_proj_dir]/output
}

proc mw_error { msg } {
    puts "-----------------------------------------------"
    puts "ERROR: ${msg}"
    puts "-----------------------------------------------"
    error_on_bad_command
}

# ########################################################################
# Variable and common source files
# ########################################################################

# Setup some global variables
global mw_hdl_dir
global commonDir

set commonDir [file normalize [file dirname [file dirname [file dirname [info script]]]]]
set mw_hdl_dir [file normalize [file dirname $commonDir]]


# Other scripts to include
source $commonDir/scripts/xilinx/mw_project_config.tcl
source $commonDir/scripts/xilinx/mw_bd.tcl
