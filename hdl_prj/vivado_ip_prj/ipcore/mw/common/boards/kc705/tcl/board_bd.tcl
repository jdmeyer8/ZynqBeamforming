proc board_setup_pcie {} {
    global pcie_int_input
    global pcie_core
    global pcie_perst_n
    global pcie_axi_clk
    global pcie_axi_ctl_clk
    global pcie_m_axi
    global pcie_s_axi
    global pcie_s_axi_ctl

    # Create interface ports
    set pcie_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt ]

    # Create ports
    set emcclk [ create_bd_port -dir I emcclk ]
    set pcie_perst_n [ create_bd_port -dir I -type rst pcie_perst_n ]
    set refclk_n [ create_bd_port -dir I -type clk refclk_n ]
    set_property -dict [ list CONFIG.FREQ_HZ {100000000}  ] $refclk_n
    set refclk_p [ create_bd_port -dir I -type clk refclk_p ]
    set_property -dict [ list CONFIG.FREQ_HZ {100000000}  ] $refclk_p

    # Create instance: axi_pcie_0, and set properties
    set pcie_core [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:* axi_pcie_0 ]
    set_property -dict [ list CONFIG.AXIBAR2PCIEBAR_0 {0x00000000} \
        CONFIG.AXIBAR_0 {0x00000000} CONFIG.AXIBAR_AS_0 {true} \
        CONFIG.AXIBAR_HIGHADDR_0 {0xFFFFFFFF} CONFIG.AXIBAR_NUM {1} \
        CONFIG.BAR0_SCALE {Megabytes} CONFIG.BAR0_SIZE {256} \
        CONFIG.BAR1_ENABLED {true} CONFIG.BAR1_SCALE {Kilobytes} \
        CONFIG.BAR1_SIZE {16} CONFIG.BAR1_TYPE {Memory} \
        CONFIG.BAR_64BIT {true} CONFIG.DEVICE_ID {0x7022} \
        CONFIG.INCLUDE_BAROFFSET_REG {true} CONFIG.MAX_LINK_SPEED {5.0_GT/s} \
        CONFIG.M_AXI_DATA_WIDTH {128} CONFIG.NO_OF_LANES {X4} \
        CONFIG.NUM_MSI_REQ {1} CONFIG.PCIEBAR2AXIBAR_1 {0xF0000000} \
        CONFIG.S_AXI_DATA_WIDTH {128} CONFIG.S_AXI_SUPPORTS_NARROW_BURST {true} \
        CONFIG.XLNX_REF_BOARD {KC705_REVC} CONFIG.en_ext_clk {false} \
        CONFIG.en_ext_gt_common {false} CONFIG.shared_logic_in_core {false} \
     ] $pcie_core

    set pcie_int_input [create_bd_net pcie_int_input]
    connect_bd_net -net pcie_int_input [get_bd_pins axi_pcie_0/INTX_MSI_Request]

    set pcie_axi_clk [create_bd_net pcie_axi_clk]
    connect_bd_net -net pcie_axi_clk [get_bd_pins axi_pcie_0/axi_aclk_out]

    set pcie_axi_ctl_clk [create_bd_net pcie_axi_ctl_clk]
    connect_bd_net -net pcie_axi_ctl_clk [get_bd_pins axi_pcie_0/axi_ctl_aclk_out]

    connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins axi_pcie_0/pcie_7x_mgt]

    # Create instance: util_ds_buf_0, and set properties
    set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:* util_ds_buf_0 ]
    set_property -dict [ list CONFIG.C_BUF_TYPE {IBUFDSGTE}  ] $util_ds_buf_0
    connect_bd_net -net refclk_n_1 [get_bd_ports refclk_n] [get_bd_pins util_ds_buf_0/IBUF_DS_N]
    connect_bd_net -net refclk_p_1 [get_bd_ports refclk_p] [get_bd_pins util_ds_buf_0/IBUF_DS_P]
    connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins axi_pcie_0/REFCLK] [get_bd_pins util_ds_buf_0/IBUF_OUT]

    # Create the reset sync for the pcie axi clock
    set pcie_axi_rstgen [mw_rstsync pcie_axi $pcie_axi_clk $pcie_perst_n axi_pcie_0/mmcm_lock]

    # Create the reset sync for the pcie axi ctl clock
    set pcie_axi_ctl_rstgen [mw_rstsync pcie_axi_ctl $pcie_axi_ctl_clk $pcie_perst_n axi_pcie_0/mmcm_lock]

    set pcie_m_axi [get_bd_intf_pins axi_pcie_0/M_AXI]
    set pcie_s_axi [get_bd_intf_pins axi_pcie_0/S_AXI]
    set pcie_s_axi_ctl [get_bd_intf_pins axi_pcie_0/S_AXI_CTL]

    mw_project_set sys_addr_cntrl_space [get_bd_addr_spaces axi_pcie_0/M_AXI]
  
    return $pcie_core
}

proc board_connect {} {
    global pcie_int_input
    global pcie_core
    global pcie_perst_n
    global pcie_axi_clk
    global pcie_axi_ctl_clk
    global pcie_m_axi
    global pcie_s_axi
    global pcie_s_axi_ctl

    set axi_cpu_interconnect [mw_project_get axi_cpu_interconnect]

    # Connect the Ctl Port
    set_property -dict [list CONFIG.NUM_MI 2] $axi_cpu_interconnect
    set_property -dict [list CONFIG.M01_HAS_REGSLICE 4] $axi_cpu_interconnect
    set_property -dict [list CONFIG.M01_HAS_DATA_FIFO 0] $axi_cpu_interconnect
    connect_bd_net -net $pcie_axi_ctl_clk [get_bd_pins axi_cpu_interconnect/M01_ACLK]
    connect_bd_net -net /pcie_axi_ctl_resetn [get_bd_pins axi_cpu_interconnect/M01_ARESETN]

    connect_bd_intf_net -intf_net pcie_core_ctl_interconnect [get_bd_intf_pins axi_cpu_interconnect/M01_AXI] $pcie_s_axi_ctl

    create_bd_addr_seg -range 0x1000 -offset 0xF0000000 [mw_get_sys_addr_cntrl_space] [get_bd_addr_segs /axi_pcie_0/S_AXI_CTL/CTL0]  SEG_data_PCIe_AXI_CTL

    # Interconnect
    connect_bd_net -net $pcie_axi_clk [get_bd_pins axi_cpu_interconnect/ACLK]
    connect_bd_net -net /pcie_axi_interconnect_resetn [get_bd_pins axi_cpu_interconnect/ARESETN]

    connect_bd_intf_net -intf_net axi_cpu_interconnect_s00_axi [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] $pcie_m_axi
    connect_bd_net -net $pcie_axi_clk [get_bd_pins axi_cpu_interconnect/S00_ACLK]
    connect_bd_net -net /pcie_axi_resetn [get_bd_pins axi_cpu_interconnect/S00_ARESETN]
    connect_bd_net -net /pcie_axi_resetn [get_bd_pins axi_pcie_0/axi_aresetn]
}

proc board_enable_debug {} {
	set vio_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:vio:* vio_reset]
	connect_bd_net -net sys_core_clk [get_bd_pins vio_reset/clk]
	connect_bd_net [get_bd_pins vio_reset/probe_out0] [get_bd_pins sys_core_rstgen/mb_debug_sys_rst]
	connect_bd_net -net sys_core_reset [get_bd_pins vio_reset/probe_in0]
}