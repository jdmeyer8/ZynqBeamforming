package require cmdline

proc mw_parse_cmdline {} {
    global mw_project_params
    global mw_project_usage
    global mw_project_options

    if { [info exists mw_project_options] } {
        return
    }

    set mw_targets [list "bitstream" "fsbl" "wrapper" "bd"]
    set mw_targets_help_str [join [list "Choose the build target:" [join $mw_targets ","]]]

    set tvar_help_str "Set tcl vars in the format VARNAME1:VALUE1 VARNAME2:VALUE2 ..."
    
    set mw_project_params [list \
        [list "target.arg" "bitstream" $mw_targets_help_str] \
        [list "tvar.arg" "" $tvar_help_str] \
    ]

    set mw_project_usage "MathWorks Vivado Build Options"
    if {[catch {array set options [cmdline::getoptions ::argv $mw_project_params $mw_project_usage]}]} {
        puts [cmdline::usage $mw_project_params $mw_project_usage]
        exit 0
    } 
    
    set mw_project_options [array get options]
    mw_check_cmdline_arg "target" $mw_targets
    mw_set_tcl_vars
}

proc mw_set_tcl_vars {} {
    set varlist [split [mw_get_opt tvar] " "]
    foreach var $varlist {
        set avpair [split $var ":"]
        set name [lindex $avpair 0]
        set val [lindex $avpair 1]
        global $name
        set $name $val
    }
}

proc mw_check_cmdline_arg {argname {legal_vals [list]}} {
    global mw_project_params
    global mw_project_usage

    set arg_val [mw_get_opt $argname]

    if {[llength $legal_vals] != 0} {
        if {[lsearch -exact $legal_vals $arg_val] == -1 } {
            puts "Error: Invalid setting for '$argname': $arg_val"
            puts [cmdline::usage $mw_project_params $mw_project_usage]
            exit -1
        }
    }
    return $arg_val
}

proc mw_get_opt {option} {
    global mw_project_options
    return [dict get $mw_project_options $option]
}

proc mw_set_build_target {tgt mode} {
    if { $mode } {
        mw_project_set "build_target_${tgt}" 1
    } else {
        mw_project_set "build_target_${tgt}" 0
    }
}

proc mw_get_build_target {tgt} {
    return [mw_project_get "build_target_${tgt}"]
}

proc mw_init_build_target {} {
    global mw_project_build_target

    mw_set_build_target "bitstream" 0
    mw_set_build_target "fsbl" 0
    mw_set_build_target "wrapper" 0
    mw_set_build_target "bdgen" 0
    mw_set_build_target "handoff" 0
}

proc mw_config_build_target {} {
    if  { [mw_get_build_target "bitstream"] == "" } {
        mw_init_build_target

        set tgt [mw_get_opt "target"]
        switch $tgt {
            "bitstream" {
                mw_set_build_target "bitstream" 1
                mw_set_build_target "fsbl" 0
                mw_set_build_target "handoff" 1
                mw_set_build_target "wrapper" 1
                mw_set_build_target "bdgen" 1
            }    
            "fsbl" {
                mw_set_build_target "bitstream" 0
                mw_set_build_target "fsbl" 0
                mw_set_build_target "handoff" 1
                mw_set_build_target "wrapper" 1
                mw_set_build_target "bdgen" 1
            }    
            "wrapper" {
                mw_set_build_target "bitstream" 0
                mw_set_build_target "fsbl" 0
                mw_set_build_target "handoff" 0
                mw_set_build_target "wrapper" 1
                mw_set_build_target "bdgen" 1
            }
            "bd" {
                mw_set_build_target "bitstream" 0
                mw_set_build_target "fsbl" 0
                mw_set_build_target "handoff" 0
                mw_set_build_target "wrapper" 0
                mw_set_build_target "bdgen" 0
            }        
        }
    }
}

mw_parse_cmdline
mw_config_build_target



