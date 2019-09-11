set prjDir [regsub {/\w+.runs.*} [pwd] ""]
set mcpDir $prjDir/mcp_scripts
source $mcpDir/mcp_tools.tcl

if { $tcFound > 0 } {
  # Parse the comments that explain the clock enables
  set matchTuples [regexp -inline -all {(\w+)\s*:\s+(\d+)x\s+slower} $file_data]
  foreach {dummy enbnet factor} $matchTuples {
    # For each clock enable, determine the phase_x[_y] register that drives it
    set phase_net [get_phase $file_data $enbnet]
    # Get the registers driven by the clock enable
    set enbcells [get_enb_cells $phase_net $tcNode]
    set ncells [llength $enbcells]
    if { $ncells > 0 } {
      # Set the multicycle paths
      set_multicycle_path -setup [expr $factor] -from $enbcells -to $enbcells
      set_multicycle_path -hold  [expr $factor - 1] -from $enbcells -to $enbcells
    }
    puts "$enbnet | $phase_net => $factor ($ncells cells)"
  }
} else {
    puts "============>WARNING:  Failed to locate timing controller"
}
