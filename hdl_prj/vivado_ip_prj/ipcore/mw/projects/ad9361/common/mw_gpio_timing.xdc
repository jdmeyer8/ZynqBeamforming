# Set false paths from the user logic to the I/O clock sync registers
set_false_path -from [get_clocks clk_div_sel*] -to [get_cells -hierarchical *up_enable_int*]
set_false_path -from [get_clocks clk_div_sel*] -to [get_cells -hierarchical *up_txnrx_int*]

set_false_path -from [get_clocks clk_div_sel*] -to [get_pins {i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/enb_meta_reg_reg[0]/D}]
set_false_path -from [get_clocks clk_div_sel*] -to [get_pins {i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/u_channel_estimator/u_in_fifo/u_rx_i_fifo/v5.fifo_18_inst.fifo_18_inst/RST}]
set_false_path -from [get_clocks clk_div_sel*] -to [get_pins {i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/u_channel_estimator/u_in_fifo/u_rx_q_fifo/v5.fifo_18_inst.fifo_18_inst/RST}]
set_false_path -from [get_clocks clk_fpga*] -to [get_pins {i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/u_channel_estimator/u_in_fifo/pd_en_meta_reg_reg[0]/D}]
set_false_path -from [get_clocks clk_div_sel*] -to [get_pins i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/u_channel_estimator/u_sync_csi/u_sync_fifo/v5.fifo_36_inst.fifo_36_inst/RST]
#set_false_path -from [get_clocks clk_fpga*] -to [get_pins {i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/u_channel_estimator/u_correlators/ch1_corr_probe*}]
#set_false_path -from [get_clocks clk_fpga*] -to [get_pins {i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/u_channel_estimator/u_correlators/ch2_corr_probe*}]
#set_false_path -from [get_clocks clk_fpga*] -to [get_pins {i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/u_channel_estimator/u_correlators/ch3_corr_probe*}]
#set_false_path -from [get_clocks clk_fpga*] -to [get_pins {i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/u_channel_estimator/u_correlators/ch4_corr_probe*}]
#set_false_path -from [get_clocks clk_fpga*] -to [get_pins {i_system_wrapper/system_i/ZynqBF_2t_ip_0/U0/u_ZynqBF_2t_ip_dut_inst/u_ZynqBF_2t_ip_src_ZynqBF_2tx_fpga/u_channel_estimator/u_correlators/ch5_corr_probe*}]