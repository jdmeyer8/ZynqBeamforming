proc get_phase { file_data enbnet} {
  # Parse the Verilog / VHDL file to determine what drives the clock enable
  set pat [subst -nocommands -nobackslashes {(?:assign)?\s*${enbnet}\s+<?=\s+(phase(?:_\d)+)}]
  regexp -all $pat $file_data -> phase_net
  return ${phase_net}
}

proc get_enb_cells { phase_net tcNode} {
  # Find the clock enable register net
  set enbreg [get_cells * -hierarchical -regexp -filter [subst -nobackslashes -nocommands {NAME =~ "${tcNode}/${phase_net}(_reg)?"}]]
  if { [llength $enbreg] > 0 } {
    set enbregnet [get_nets -of_objects [get_pins -of_objects $enbreg -filter {DIRECTION == OUT}]] 
  } else {
    return [list]
  }
  if { [llength $enbregnet] > 0 } {
    # Get all of the cells enabled by the clock enable
    set enbcells [get_cells -of [filter [all_fanout -flat -endpoints_only $enbregnet] IS_ENABLE]]
    return $enbcells
  } else {
    return [list]
  }
}

proc get_tc_data {} {
    # Find the timing controller file
    set prjDir [regsub {/\w+.runs.*} [pwd] ""]
    set tc_paths [glob -nocomplain ${prjDir}/ipcore/*/hdl/*/*_tc.vhd]
    if { [llength $tc_paths] < 1 } {
      # No VHDL files found, try verilog
      set tc_paths [glob -nocomplain ${prjDir}/ipcore/*/hdl/*/*_tc.v]
    }
    # From the list of candidate TC files, verify that we actually have the timing controller
    set tcFound 0
    set file_data ""
    set tcName ""
    foreach {tc_path} $tc_paths {
      set fp [open $tc_path]
      set file_data [read $fp]
      close $fp
      # Extract the tc name
      regexp -all ${prjDir}/ipcore/.*/hdl/.*/(.*)_tc.v $tc_path -> tcName

      # Search for the string
      set tcFound [regexp {Master clock enable input} $file_data]
      if { $tcFound > 0 } {
        break
      }
    }

    # Get the TC node
    set tcNode [get_cells * -hierarchical -regexp -filter [subst -nobackslashes -nocommands {REF_NAME =~ ".*${tcName}_tc" }]]
    
    return [list $tcFound $file_data $tcNode]
}

# return the data
set tc_data [get_tc_data]
set tcFound [lindex $tc_data 0]
set file_data [lindex $tc_data 1]
set tcNode [lindex $tc_data 2]


