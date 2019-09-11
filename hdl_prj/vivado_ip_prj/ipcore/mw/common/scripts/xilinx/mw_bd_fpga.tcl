proc mw_default_bd_pcie { {core_freq 50.0} } {
    set curdir [pwd]
    cd [mw_get_proj_dir]
    # create board design
    create_bd_design "system"

    global sys_pcie

    global pcie_int_input
    global pcie_core
    global pcie_perst_n
    global pcie_axi_clk
    global pcie_m_axi
    global pcie_s_axi
    global pcie_s_axi_ctl

    global commonDir
	
	global BOARD_DEBUG
    
    
    # Add the pcie contraints (if they exist)
    set pcie_constr [mw_project_get boardDir]/xdc/pcie.xdc
    if { [file exists $pcie_constr] } {
        add_files -norecurse -fileset sources_1 $pcie_constr
    }
    
    # load the board data
    source [mw_project_get boardDir]/tcl/board_bd.tcl

    # GND and VCC nets
    set const_vcc_inst [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:* const_vcc_inst]
    connect_bd_net -net const_vcc [get_bd_pins const_vcc_inst/dout] 

    set const_gnd_inst [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:* const_gnd_inst]
    set_property -dict [list CONFIG.CONST_VAL {0}] $const_gnd_inst
    connect_bd_net -net const_gnd [get_bd_pins const_gnd_inst/dout] 

    # Create PCIe core

    set sys_pcie [board_setup_pcie]
    
    mw_project_set sys_cpu $sys_pcie
    
    # Create the fixed 100/200 MHz clocks
    set sys_clkwiz [mw_create_clockwiz sys $pcie_axi_clk pcie_axi_resetn 100.0]
    set_property -dict [list CONFIG.CLKOUT2_USED {true}] $sys_clkwiz
    set_property -dict [list CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.0}] $sys_clkwiz
    connect_bd_net -net sys_100m_clk [get_bd_pins sys_clkwiz/clk_out1]
    connect_bd_net -net sys_200m_clk [get_bd_pins sys_clkwiz/clk_out2]

    set sys_100m_rstgen [mw_rstsync sys_100m sys_100m_clk $pcie_perst_n sys_clkwiz/locked]
    set sys_200m_rstgen [mw_rstsync sys_200m sys_200m_clk $pcie_perst_n sys_clkwiz/locked]


    # Create the core clock
    set core_clkwiz [mw_create_clockwiz core $pcie_axi_clk pcie_axi_resetn $core_freq]
    set sys_core_clk_source [get_bd_pins core_clkwiz/clk_out1]
    connect_bd_net -net sys_core_clk $sys_core_clk_source
    mw_project_set ipcore_clk_net [get_bd_nets sys_core_clk]

    set sys_core_rstgen [mw_rstsync sys_core sys_core_clk $pcie_perst_n core_clkwiz/locked]
    mw_project_set ipcore_rstn_net [get_bd_nets sys_core_resetn]
    mw_project_set ipcore_rst_net [get_bd_nets sys_core_reset]

    # Create interrupt controller
    set axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:* axi_intc ]
    set_property -dict [ list CONFIG.C_IRQ_IS_LEVEL {0} ] $axi_intc
    set_property CONFIG.C_KIND_OF_EDGE.VALUE_SRC PROPAGATED $axi_intc
	set_property CONFIG.C_KIND_OF_LVL.VALUE_SRC PROPAGATED $axi_intc
	set_property CONFIG.C_KIND_OF_INTR.VALUE_SRC PROPAGATED $axi_intc
	set_property CONFIG.C_IRQ_CONNECTION 1 $axi_intc
	connect_bd_net -net $pcie_int_input [get_bd_pins axi_intc/irq]
    connect_bd_net -net $pcie_axi_clk [get_bd_pins axi_intc/s_axi_aclk]
    connect_bd_net -net pcie_axi_resetn [get_bd_pins axi_intc/s_axi_aresetn]

    # interrupt concat
    set intr_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:* intr_concat]
    set_property -dict [list CONFIG.NUM_PORTS {32}] $intr_concat
    mw_create_const "intr_concat_gnd" 1 0
    for {set i 0} {$i < 32} {incr i} {
        connect_bd_net -net const_intr_concat_gnd [get_bd_pins intr_concat/In${i}]
    }
    connect_bd_net -net intr_concat_dout [get_bd_pins axi_intc/intr] [get_bd_pins intr_concat/dout]
    mw_project_set intr_concat $intr_concat
    
    
    # Create the CPU Interconnect
    set axi_cpu_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* axi_cpu_interconnect]
    set_property -dict [list CONFIG.NUM_MI {1}] $axi_cpu_interconnect
    set_property -dict [list CONFIG.S00_HAS_REGSLICE {4}] $axi_cpu_interconnect
    mw_project_set axi_cpu_interconnect $axi_cpu_interconnect


    # interface connections  
    board_connect

    connect_bd_net -net /sys_core_clk [get_bd_pins axi_cpu_interconnect/M00_ACLK]
    connect_bd_net -net /sys_core_resetn [get_bd_pins axi_cpu_interconnect/M00_ARESETN]

    mw_add_cpu_slave axi_intc 0x1000000

	if { [info exists BOARD_DEBUG] && $BOARD_DEBUG } {
		board_enable_debug
	}
	
    cd $curdir
}

proc mw_get_pcie_slave_ic {} {
    global pcie_s_axi
    global pcie_axi_clk

    set ic_name pcie_axi_slave_interconnect
    set ic [get_bd_cells -quiet $ic_name]
    if { [llength $ic] > 0 } {
        return $ic
    }

    set ic [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* $ic_name]
    set_property -dict [list CONFIG.NUM_MI {1}] $ic
    set_property -dict [list CONFIG.S00_HAS_REGSLICE {4}] $ic
    set_property -dict [list CONFIG.M00_HAS_REGSLICE {4}] $ic

    connect_bd_net -net $pcie_axi_clk [get_bd_pins ${ic_name}/ACLK] 
    connect_bd_net -net pcie_axi_interconnect_resetn [get_bd_pins ${ic_name}/ARESETN] 

    connect_bd_net -net $pcie_axi_clk [get_bd_pins ${ic_name}/M00_ACLK] 
    connect_bd_net -net pcie_axi_resetn [get_bd_pins ${ic_name}/M00_ARESETN]

    connect_bd_intf_net [get_bd_intf_pins ${ic_name}/M00_AXI] $pcie_s_axi
    
    return $ic
}

proc mw_get_pcie_axi_slave_ports { {num_ports 1} {clk_domain pcie_axi} } {

    set ic [mw_get_pcie_slave_ic]
    set ic_name [get_property NAME $ic]
    
    set ports []
    set found_ports 0
    set MAX_MASTER_PORTS 16
    
    for {set idx 0} {$idx < $MAX_MASTER_PORTS} {incr idx} {
        set SI_IDX [format %02d $idx]
        set NUM_SI [get_property CONFIG.NUM_SI $ic]
        set if_pin [get_bd_intf_pins -quiet ${ic_name}/S${SI_IDX}_AXI]
        if { [llength [get_bd_intf_nets -quiet -of_objects $if_pin]] == 0 } {
            lappend ports $if_pin
            incr found_ports
            mw_connect_pin [get_bd_pins ${ic_name}/S${SI_IDX}_ACLK] ${clk_domain}_clk
            mw_connect_pin [get_bd_pins ${ic_name}/S${SI_IDX}_ARESETN] ${clk_domain}_resetn
        }
        if {$found_ports == $num_ports} {
            break
        }
        if { $NUM_SI == [expr $SI_IDX + 1] } {
            mw_add_ic_slave_port $ic
        }
    }
    
    if { $found_ports != $num_ports } {
        mw_error "Could not find $num_ports slave ports"
    }
    return $ports
    
    return $ports
}