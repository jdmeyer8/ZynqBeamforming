set prjDir [regsub {/\w+.runs.*} [pwd] ""]
set mcpDir $prjDir/mcp_scripts
source $mcpDir/mcp_tools.tcl

if { $tcFound > 0 } {
  set fp [open "mcp_report.txt" w]
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
      puts $fp "========================================================"
      puts $fp "= Multi Cycle Report for $enbnet"
      puts $fp "========================================================"
      set this_report [report_timing -from $enbcells -to $enbcells -return_string]
      puts $fp $this_report
    }
  }
  close $fp
} else {
    puts "============>WARNING:  Failed to locate timing controller"
}
