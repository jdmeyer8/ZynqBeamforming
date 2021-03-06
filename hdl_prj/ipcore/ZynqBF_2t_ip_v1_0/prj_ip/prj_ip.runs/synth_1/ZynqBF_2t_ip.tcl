# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z045ffg900-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.cache/wt [current_project]
set_property parent.project_path /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0 [current_project]
set_property ip_output_repo /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/vivado_ip_prj/data/gsram1_32.coe
add_files /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/vivado_ip_prj/data/gsram2_32.coe
add_files /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/vivado_ip_prj/data/gsram3_32.coe
add_files /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/vivado_ip_prj/data/gsram4_32.coe
add_files /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/vivado_ip_prj/data/gsram5_32.coe
read_vhdl -library xil_defaultlib {
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_addr_decoder.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_axi_lite_module.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_axi_lite.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_goldSequences.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_gs_selector.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_data_in.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_correlation_config.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_get_bit.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_SimpleDualPortRAM_generic.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_rx_ram_i.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_goldSeq1.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_goldSeq2.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_shift_rx.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_correlator_i.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_correlator_en.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_sum_elements_i.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_all_u.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_correlator_wrapper.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_peak_fsm.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_running_max.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_store_index.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_peakdetect.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_select_inputs.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_ram_rd_counter.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_ram_counter.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_state_machine.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_in_fifo.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_Detect_Change.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_nr_reciprocal.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_local_fsm.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_update_csi.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_ch_est.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_sync_csi.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_rx_bram.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_goldSeq_ram.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_goldSeq.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_rx_gs_mult_core.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_rx_gs_mult.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_ch_est_mac.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_ch_est2.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_correlators.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_channel_estimator.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_src_ZynqBF_2tx_fpga.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip_dut.vhd
  /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/hdl/vhdl/ZynqBF_2t_ip.vhd
}
read_ip -quiet /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram1_1/gsram1.xci
set_property used_in_implementation false [get_files -all /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram1_1/gsram1_ooc.xdc]

read_ip -quiet /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram2_1/gsram2.xci
set_property used_in_implementation false [get_files -all /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram2_1/gsram2_ooc.xdc]

read_ip -quiet /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram3_1/gsram3.xci
set_property used_in_implementation false [get_files -all /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram3_1/gsram3_ooc.xdc]

read_ip -quiet /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram4_1/gsram4.xci
set_property used_in_implementation false [get_files -all /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram4_1/gsram4_ooc.xdc]

read_ip -quiet /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram5_1/gsram5.xci
set_property used_in_implementation false [get_files -all /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram5_1/gsram5_ooc.xdc]

read_ip -quiet /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/rx_ram_core_1/rx_ram_core.xci
set_property used_in_implementation false [get_files -all /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/rx_ram_core_1/rx_ram_core_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}

synth_design -top ZynqBF_2t_ip -part xc7z045ffg900-2


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef ZynqBF_2t_ip.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file ZynqBF_2t_ip_utilization_synth.rpt -pb ZynqBF_2t_ip_utilization_synth.pb"
