proc board_init_project {} {
	
	set boardDir [mw_project_get boardDir]
	set xdc_files [list \
	  "$boardDir/xdc/common.xdc" \
	  ]
	add_files -norecurse -fileset sources_1 $xdc_files
}

proc board_set_board_info {} {

	mw_project_set project_part "xc7k325tffg900-2"
	mw_project_set project_board "xilinx.com:kc705:part0:1.1"
	mw_project_set cpu_type "kintex7_pcie"
	mw_project_set boardName "kc705"
	mw_project_set mw_ip_baseaddr 0x0
}