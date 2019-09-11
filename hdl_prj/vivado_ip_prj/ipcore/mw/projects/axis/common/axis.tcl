set axis_common [file normalize [file dirname [info script]]]
source ${axis_common}/axis_bd.tcl

proc ila_probe_intf {ila_name ila_port intf_pin_name} {
	set intf_pin [get_bd_intf_pins $intf_pin_name]
	set ila_intf_pin [get_bd_intf_pins ${ila_name}/SLOT_${ila_port}_*]	
	connect_bd_intf_net -intf_net [get_bd_intf_nets -of_objects $intf_pin] $intf_pin $ila_intf_pin
}

proc dma_debug {s2mm_dma  mm2s_dma {depth 2048}} {
	# Check if a fifo is being used
	set s2mm_intf [get_bd_intf_nets -of_objects [get_bd_intf_pins ${s2mm_dma}/S_AXIS_S2MM]]
	set mm2s_intf [get_bd_intf_nets -of_objects [get_bd_intf_pins ${mm2s_dma}/M_AXIS_MM2S]]
	if {$s2mm_intf == $mm2s_intf } {
		set fifo_enable false
	} else {
		set fifo_enable true
	}
	
	# Create the ILA
	set nProbe 2
	set nAXIMMProbe 4
	set nAXISProbe 1
	if {$fifo_enable } {
		set nAXISProbe [expr $nAXISProbe + 1]
	}
	set nIFProbe [expr $nAXIMMProbe + $nAXISProbe]
	
	set ila_name dma_ila
	set ila_obj [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:* $ila_name ]
	set_property -dict [ list \
				CONFIG.C_DATA_DEPTH $depth \
				CONFIG.C_EN_STRG_QUAL {1} \
				CONFIG.C_INPUT_PIPE_STAGES {4} \
				CONFIG.C_MON_TYPE {MIX} \
				CONFIG.C_NUM_MONITOR_SLOTS $nIFProbe \
				CONFIG.C_NUM_OF_PROBES $nProbe \
				 ] $ila_obj
	
	for {set i 0} {$i < $nAXIMMProbe} {incr i} {
		set_property CONFIG.C_SLOT_${i}_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} $ila_obj
	}
	
	for {set i [expr $nAXIMMProbe]} {$i < $nIFProbe} {incr i} {
		set_property CONFIG.C_SLOT_${i}_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} $ila_obj
	}
	
	for {set i 0} {$i < $nProbe} {incr i} {
		set_property CONFIG.C_PROBE${i}_MU_CNT {2} $ila_obj
	}
	
	set_property CONFIG.ALL_PROBE_SAME_MU {true} $ila_obj
	set_property CONFIG.ALL_PROBE_SAME_MU_CNT {2} $ila_obj
	
	# Connect the ILA
	ila_probe_intf $ila_name 0 ${mm2s_dma}/M_AXI_SG
	ila_probe_intf $ila_name 1 ${mm2s_dma}/M_AXI_MM2S
	ila_probe_intf $ila_name 2 ${s2mm_dma}/M_AXI_SG
	ila_probe_intf $ila_name 3 ${s2mm_dma}/M_AXI_S2MM
	ila_probe_intf $ila_name 4 ${mm2s_dma}/M_AXIS_MM2S
	if {$fifo_enable} {
		ila_probe_intf $ila_name 5 ${s2mm_dma}/S_AXIS_S2MM
	}
	
	mw_connect_pin ${mm2s_dma}/mm2s_introut ${ila_name}/probe0
	mw_connect_pin ${s2mm_dma}/s2mm_introut ${ila_name}/probe1
	
	# Connect the clock
	connect_bd_net -net [get_bd_nets -of_objects [get_bd_pins ${s2mm_dma}/m_axi_s2mm_aclk]] [get_bd_pins ${ila_name}/clk]
	
	regenerate_bd_layout
	
	return $ila_name
}

set curdir [pwd]
cd [mw_get_proj_dir]

if { ![info exists stream_width] } {
	set stream_width 32
}

if { [info exists DMA_DEBUG] && $DMA_DEBUG } {
	global BOARD_DEBUG
	if { ![info exists BOARD_DEBUG] } {
		set BOARD_DEBUG 1
	}
}

global PT_FIFO
if { ! [info exists PT_FIFO] } {
	set PT_FIFO true
}

mw_default_bd

set mm2s_dma [setup_dma [dma_config mm2s $stream_width]]
set s2mm_dma [setup_dma [dma_config s2mm $stream_width]]

mw_cleanup_orphans

mw_bd_export system_axistream.tcl

mw_create_dummy_slave
set fifo [mw_stream_passthrough $stream_width $PT_FIFO]

if { [info exists DMA_DEBUG] && $DMA_DEBUG } {
	if { [info exists ILA_DEPTH] } {
		dma_debug $s2mm_dma $mm2s_dma $ILA_DEPTH
	} else {
		dma_debug $s2mm_dma $mm2s_dma
	}
}

cd $curdir

regenerate_bd_layout 
save_bd_design
validate_bd_design

mw_create_wrapper

mw_project_run