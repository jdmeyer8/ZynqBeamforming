# Disconnect the ADC Pack inputs
set adc_pack_name util_ad9361_adc_pack
set adc_fifo_name util_ad9361_adc_fifo
set HWNUMCHAN [get_property CONFIG.NUM_OF_CHANNELS [get_bd_cells ${adc_fifo_name}]]

set bypass_rx [create_bd_cell -type ip -vlnv mathworks.com:user:util_mw_bypass_user_logic:1.0 bypass_rx]
ad_cpu_interconnect 0x43C50000 bypass_rx
set_property CONFIG.NUM_CHAN $HWNUMCHAN $bypass_rx

mw_connect_pin bypass_rx/IPCORE_CLK [mw_project_get ipcore_clk_net]
mw_connect_pin bypass_rx/IPCORE_RESETN [mw_project_get ipcore_rstn_net]

for {set ch 0} {$ch < $HWNUMCHAN} {incr ch} {
    mw_disconnect_pin ${adc_pack_name}/adc_data_${ch}
    mw_disconnect_pin ${adc_pack_name}/adc_valid_${ch}
    mw_disconnect_pin ${adc_pack_name}/adc_enable_${ch}
}
