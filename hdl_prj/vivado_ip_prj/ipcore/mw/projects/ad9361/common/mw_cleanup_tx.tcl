
# Disconnect the DAC FIFO Inputs

set dac_upack_name util_ad9361_dac_upack
set dac_fifo_name axi_ad9361_dac_fifo
set HWNUMCHAN [get_property CONFIG.NUM_OF_CHANNELS [get_bd_cells ${dac_fifo_name}]]

for {set ch 0} {$ch < $HWNUMCHAN} {incr ch} {
    mw_disconnect_pin ${dac_fifo_name}/din_data_${ch}
    mw_disconnect_pin ${dac_fifo_name}/din_valid_in_${ch}
    mw_disconnect_pin ${dac_upack_name}/dac_enable_${ch}
}

# Add the DAC Latch and Bypass_tx
set dac_latch [create_bd_cell -type ip -vlnv mathworks.com:user:util_mw_dac_reg:1.0 dac_latch]
set bypass_tx [create_bd_cell -type ip -vlnv mathworks.com:user:util_mw_bypass_user_logic:1.0 bypass_tx]

ad_cpu_interconnect 0x43C20000 bypass_tx

set_property CONFIG.NUM_CHAN $HWNUMCHAN $dac_latch
set_property CONFIG.NUM_CHAN $HWNUMCHAN $bypass_tx

mw_connect_pin dac_latch/clk [mw_project_get ipcore_clk_net]
mw_connect_pin dac_latch/rst [mw_project_get ipcore_rst_net]

mw_connect_pin bypass_tx/IPCORE_CLK [mw_project_get ipcore_clk_net]
mw_connect_pin bypass_tx/IPCORE_RESETN [mw_project_get ipcore_rstn_net]

# Wire the DAC Latch and Bypass_tx
for {set ch 0} {$ch < $HWNUMCHAN} {incr ch} {
    mw_connect_pin dac_latch/dac_data_out_${ch} ${dac_fifo_name}/din_data_${ch}
	mw_connect_pin bypass_tx/mux_data_out_${ch} ${dac_latch}/dac_data_in_${ch}
}
