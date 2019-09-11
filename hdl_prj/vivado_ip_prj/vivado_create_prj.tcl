create_project vivado_prj {} -part xc7z045ffg900-2 -force
set_property board_part xilinx.com:zc706:part0:1.0 [current_project]
set_property target_language VHDL [current_project]
set defaultRepoPath {./ipcore}
set_property ip_repo_paths $defaultRepoPath [current_fileset]
update_ip_catalog
set ipList [glob -nocomplain -directory $defaultRepoPath *.zip]
foreach ipCore $ipList {
  set folderList [glob -nocomplain -directory $defaultRepoPath -type d *]
  if {[lsearch -exact $folderList [file rootname $ipCore]] == -1} {
    catch {update_ip_catalog -add_ip $ipCore -repo_path $defaultRepoPath}
  }
}
update_ip_catalog
set boardName {zc706}
set project {fmcomms2}
set mw_hdl_dir {ipcore/mw}
set ad_hdl_dir {ipcore/adi}
set variant {rx}
source vivado_custom_block_design.tcl
# Use global synthesis for this project
set_property synth_checkpoint_mode None [get_files system.bd]
set_property -dict [list CONFIG.CLKOUT0_REQUESTED_OUT_FREQ {61.440}] [get_bd_cells util_mw_clkconstr]
save_bd_design
close_project
exit
