# Add the files

set project_files [list \
  "${ad_hdl_dir}/library/xilinx/common/ad_iobuf.v" \
  "${ad_hdl_dir}/library/common/ad_adl5904_rst.v" \
  "$adi_prj_dir/common/adrv9361z7035_constr.xdc" \
  "$adi_prj_dir/common/adrv9361z7035_constr_lvds.xdc"]
  
add_files -norecurse -fileset sources_1 $project_files

# Set the script to be sourced
set system_bd_script ${ad_hdl_dir}/projects/adrv9361z7035/ccfmc_lvds/system_bd.tcl
set IP_AXIM 4