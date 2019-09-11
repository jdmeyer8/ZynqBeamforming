proc dma_create_config {direction {stream_width 32}} {
    set config [dict create \
        "direction"    $direction \
        "stream_width" $stream_width \
        "addr_seg"     "" \
        "intr"         "" \
        "port"        "" \
        "addr"       "0" \
        "ic_sg_port" "" \
        "ic_mm_port" "" \
        "m_clk"      "sys_core_clk" \
        "m_rstn"      "sys_core_resetn" \
        "s_clk"      "sys_core_clk" \
        "s_rstn"      "sys_core_resetn" \
        ]
    
    return $config
}


proc dma_config {direction {stream_width 32}} {

    set config [dma_create_config $direction $stream_width]
    
    switch [mw_project_get cpu_type] {
        zynq7_arm {
            set config [zynq_dma_config $config]
        }
        kintex7_pcie {
            set config [fpga_dma_config $config]
        }
		zynqmp_arm {
			set config [zynqmp_dma_config $config]
		}
    }
    
    return $config
}

proc zynqmp_dma_config {config} {
    set direction [dict get $config "direction"]
    if {$direction == "mm2s"} {
        dict set config "port" 0
        dict set config "intr" 0
        dict set config "addr" 0xA0020000
    } else {
        dict set config "port" 2
        dict set config "intr" 1
        dict set config "addr" 0xA0030000
    }
    
    return [ps_common_dma_config $config]
}

proc zynq_dma_config {config} {
    set direction [dict get $config "direction"]
    if {$direction == "mm2s"} {
        dict set config "port" 0
        dict set config "intr" 0
        dict set config "addr" 0x40020000
    } else {
        dict set config "port" 2
        dict set config "intr" 1
        dict set config "addr" 0x40030000
    }
    
    return [ps_common_dma_config $config]
}

proc ps_common_dma_config {config} {
    set direction [dict get $config "direction"]
	set port [dict get $config "port"]
    set s_clk [dict get $config "s_clk"]
    set s_rstn [dict get $config "s_rstn"]
    set m_clk [dict get $config "m_clk"]
    set m_rstn [dict get $config "m_rstn"]
	
    set slave_info [mw_add_cpu_axi_slave $port axi_dma_${direction}_cpu_ic $s_clk $s_rstn]
	set ic [lindex $slave_info 0]
	set addr_seg [lindex $slave_info 1]
    set ic_name [get_property Name $ic]
    set_property -dict [list CONFIG.NUM_SI {2}] $ic
    set_property -dict [list CONFIG.S01_HAS_REGSLICE {4}] $ic
    mw_connect_pin $m_clk ${ic_name}/S00_ACLK
    mw_connect_pin $m_clk ${ic_name}/S01_ACLK
    mw_connect_pin $m_rstn ${ic_name}/S00_ARESETN
    mw_connect_pin $m_rstn ${ic_name}/S01_ARESETN
        
    dict set config "ic_sg_port" ${ic_name}/S00_AXI
    dict set config "ic_mm_port" ${ic_name}/S01_AXI
    dict set config "addr_seg" $addr_seg
    return $config
}


proc fpga_dma_config {config} {
    set direction [dict get $config "direction"]
    if {$direction == "mm2s"} {
        set intr 0
        set addr 0x1010000
    } else {
        set intr 1
        set addr 0x1020000
    }
    set ic [mw_get_pcie_slave_ic]
    set ic_name [get_property Name $ic]    
    
    set slave_ports [mw_get_pcie_axi_slave_ports 2 sys_core]
    set sg_port [lindex $slave_ports 0]
    set mm_port [lindex $slave_ports 1]
    
    dict set config "ic_sg_port" $sg_port
    dict set config "ic_mm_port" $mm_port
    dict set config "addr" $addr
    dict set config "intr" $intr
    dict set config "addr_seg" [get_bd_addr_segs axi_pcie_0/S_AXI/BAR0]
    return $config
}

proc setup_dma {config} {
    # Add the DMA Engine

    set stream_width [dict get $config "stream_width"]
    set direction [dict get $config "direction"]
    set intr [dict get $config "intr"]
    set addr_seg [dict get $config "addr_seg"]
    set addr [dict get $config "addr"]
    set ic_sg_port [dict get $config "ic_sg_port"]
    set ic_mm_port [dict get $config "ic_mm_port"]
    set m_clk [dict get $config "m_clk"]
    set m_rstn [dict get $config "m_rstn"]
    
    if {$direction == "mm2s"} {
        set rd_en 1
        set wr_en 0
        set MM_port M_AXI_MM2S
    } else {
        set rd_en 0
        set wr_en 1
        set MM_port M_AXI_S2MM
    }

    set dma [mw_add_axi_dma axi_dma_${direction} $rd_en $wr_en]
    set dma_name [get_property Name $dma]
    # Connect the AXI4 Lite interface
    mw_connect_pin $m_clk ${dma_name}/s_axi_lite_aclk
    mw_connect_pin $m_rstn ${dma_name}/axi_resetn
    mw_add_cpu_slave ${dma_name} $addr
    
    # Connect the SG interface
    mw_connect_pin ${dma_name}/M_AXI_SG $ic_sg_port
    mw_connect_pin $m_clk ${dma_name}/m_axi_sg_aclk
    # Connect the MM interface
    mw_connect_pin ${dma_name}/${MM_port} $ic_mm_port
    mw_connect_pin $m_clk ${dma_name}/m_axi_${direction}_aclk
    # Connect the interrupt
    mw_connect_intr ${dma_name}/${direction}_introut $intr
    
    #Configure the DMA Engine
    if {$direction == "mm2s"} {
        set_property -dict [list CONFIG.c_m_axi_mm2s_data_width {64}] $dma
        set_property -dict [list CONFIG.c_mm2s_burst_size {256}] $dma
        set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width $stream_width] $dma
    } else {
        set_property -dict [list CONFIG.c_m_axi_s2mm_data_width.VALUE_SRC USER] $dma
        set_property -dict [list CONFIG.c_m_axi_s2mm_data_width {64}] $dma
        set_property -dict [list CONFIG.c_s2mm_burst_size {256}] $dma
    }
    set_property -dict [list CONFIG.c_sg_length_width {23}] $dma
    
    # Assign the address space
    assign_bd_address $addr_seg
	return $dma_name
}

proc mw_stream_passthrough {{stream_width 32} {fifo_enable true}} {
	
    set dma_mm2s [get_bd_cells axi_dma_mm2s]
    set mm2s_axis [get_bd_intf_pins -of_objects $dma_mm2s -filter {VLNV==xilinx.com:interface:axis_rtl:1.0}]
    
    set dma_s2mm [get_bd_cells axi_dma_s2mm]
    set s2mm_axis [get_bd_intf_pins -of_objects $dma_s2mm -filter {VLNV==xilinx.com:interface:axis_rtl:1.0}]
    
	if { $fifo_enable } {
		set tdata_bytes [expr $stream_width / 8]
		set fifo_name passthrough_fifo
		set fifo [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:* $fifo_name]
		set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM}] $fifo
		set_property -dict [list CONFIG.TDATA_NUM_BYTES $tdata_bytes] $fifo 
		set_property -dict [list CONFIG.TUSER_WIDTH {0}] $fifo 
		set_property -dict [list CONFIG.Enable_TLAST {true}] $fifo 
	  
		connect_bd_net -net sys_core_clk [get_bd_pins ${fifo_name}/s_aclk]
		connect_bd_net -net sys_core_resetn [get_bd_pins ${fifo_name}/s_aresetn]
      
		connect_bd_intf_net $mm2s_axis [get_bd_intf_pins ${fifo_name}/S_AXIS]
		connect_bd_intf_net $s2mm_axis [get_bd_intf_pins ${fifo_name}/M_AXIS]
		
		return $fifo_name
	} else {
		connect_bd_intf_net $mm2s_axis $s2mm_axis
		return {}
	}
}