set adi_xil_dir [file dirname [info script]]
source $adi_xil_dir/mw_adi_env.tcl

proc mw_adi_setup_libs {} {
    global ad_hdl_dir
    
    mw_add_libdir $ad_hdl_dir/library
}

proc mw_adi_add_axi_dma {name {src_mode 0} {dst_mode 0}} {
    set axi_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:* $name ]
    set_property -dict [ list CONFIG.c_sg_include_stscntrl_strm {0}  ] $axi_dma

    # Modes
    # 0 = AXI MM
    # 1 = AXIS
    # 2 = FIFO
    
    set_property CONFIG.DMA_TYPE_DEST $dst_mode $axi_dma
    set_property CONFIG.DMA_TYPE_SRC $src_mode $axi_dma
    if { $dst_mode == 0} {
        # Set to full AXI4 mode
        set_property CONFIG.DMA_AXI_PROTOCOL_DEST {0} $axi_dma
    }
    if { $src_mode == 0} {
        # Set to full AXI4 mode
        set_property CONFIG.DMA_AXI_PROTOCOL_SRC {0} $axi_dma
        set_property CONFIG.CYCLIC {true} $axi_dma
    }
    
    return $axi_dma
}

proc setup_adi_dma {config} {
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
        set src_mode 0
        set dst_mode 1
        set MM_direction src
        set S_mode m
    } else {
        set src_mode 1
        set dst_mode 0
        set MM_direction dest
        set S_mode s
    }

    set dma [mw_adi_add_axi_dma axi_dma_${direction} $src_mode $dst_mode]
    set dma_name [get_property Name $dma]
    # Connect the AXI4 Lite interface
    mw_connect_pin $m_clk ${dma_name}/s_axi_aclk
    mw_connect_pin $m_rstn ${dma_name}/s_axi_aresetn
    mw_add_cpu_slave ${dma_name} $addr
    
    # Connect the MM interface
    mw_connect_pin ${dma_name}/m_${MM_direction}_axi $ic_mm_port
    mw_connect_pin $m_clk ${dma_name}/m_${MM_direction}_axi_aclk
    mw_connect_pin $m_rstn ${dma_name}/m_${MM_direction}_axi_aresetn
    # Connect the AXIS clock
    mw_connect_pin $m_clk ${dma_name}/${S_mode}_axis_aclk
    # Connect the interrupt
    mw_connect_intr ${dma_name}/irq $intr
    
    #Configure the DMA Engine
    if {$direction == "mm2s"} {
        set_property CONFIG.DMA_DATA_WIDTH_DEST $stream_width $dma
        set_property CONFIG.DMA_DATA_WIDTH_SRC 64 $dma
    } else {
        set_property CONFIG.DMA_DATA_WIDTH_DEST 64 $dma
        set_property CONFIG.DMA_DATA_WIDTH_SRC $stream_width $dma
    }
    
    set_property CONFIG.DMA_LENGTH_WIDTH 24 $dma
    
    # Assign the address space
    assign_bd_address $addr_seg
	return $dma_name
}