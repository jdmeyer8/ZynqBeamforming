# ip

source ../scripts/mw_env.tcl
source $mw_hdl_dir/library/scripts/mw_ip.tcl

mw_ip_create util_mw_led_driver
mw_ip_files util_mw_led_driver [list \
    "led_driver.vhd"] 

mw_ip_properties_lite util_mw_led_driver

ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

