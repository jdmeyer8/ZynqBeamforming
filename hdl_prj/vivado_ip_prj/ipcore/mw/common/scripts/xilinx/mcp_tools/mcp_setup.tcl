set mcpSrc [file dirname [info script]]
set mcpDir [mw_get_proj_dir]/mcp_scripts

file delete -force $mcpDir
file mkdir $mcpDir

file copy -force $mcpSrc/mcp_report.tcl $mcpDir/mcp_report.tcl
file copy -force $mcpSrc/mcp_tools.tcl $mcpDir/mcp_tools.tcl
file copy -force $mcpSrc/mcp_constraints.tcl $mcpDir/mcp_constraints.tcl

add_files -norecurse -fileset sources_1 "$mcpDir/mcp_constraints.tcl"
set_property STEPS.WRITE_BITSTREAM.TCL.PRE $mcpDir/mcp_report.tcl [get_runs impl_1]
