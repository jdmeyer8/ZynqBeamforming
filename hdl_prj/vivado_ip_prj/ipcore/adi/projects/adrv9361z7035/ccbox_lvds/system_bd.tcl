
source ../common/adrv9361z7035_bd.tcl
source ../common/ccbox_bd.tcl

cfg_ad9361_interface LVDS

set_property CONFIG.ADC_INIT_DELAY 29 [get_bd_cells axi_ad9361]

