proc board_set_board_info {} {
    global boardRev
	
	if { ![info exists boardRev] } {
		set boardRev "1.0"
    }
	
     switch $boardRev {
        "1.0" {
            #Board Revision is updated to 3.1 from Vivado 2017.4
            set brd "xilinx.com:zcu102:part0:3.1"
        }
        D {
            set brd "xilinx.com:zcu102:part0:1.5"
            enable_beta_device*
        }
        C -
        B {
            set brd "xilinx.com:zcu102:part0:1.4"
            enable_beta_device*
        }
    }
	
	mw_project_set project_board $brd
	mw_project_set mw_ip_baseaddr 0xA0000000
	mw_project_set cpu_type "zynqmp_arm"
}
