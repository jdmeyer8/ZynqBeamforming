# ip

source ../scripts/mw_env.tcl
source $mw_hdl_dir/library/scripts/mw_ip.tcl

mw_ip_create util_mw_gpio_mux
mw_ip_files util_mw_gpio_mux [list \
    "util_mw_gpio_mux_core.v" \
    "util_mw_gpio_mux.v" ]

mw_ip_properties_lite util_mw_gpio_mux


set_property driver_value 0 [ipx::get_ports *mux_sel* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *port_*_o* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *port_*_t* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *GPIO_IN_o* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *GPIO_IN_t* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *GPIO_OUT_i* -of_objects [ipx::current_core]]

mw_add_bus "GPIO_IN" "slave" \
	"mathworks.com:interface:gpio_rtl:1.0" \
	"mathworks.com:interface:gpio:1.0" \
	[list \
	  {"GPIO_IN_i" "TRI_I"} \
	  {"GPIO_IN_t" "TRI_T"} \
	  {"GPIO_IN_o" "TRI_O"} ]      

mw_add_bus "GPIO_OUT" "master" \
	"mathworks.com:interface:gpio_rtl:1.0" \
	"mathworks.com:interface:gpio:1.0" \
	[list \
	  {"GPIO_OUT_i" "TRI_I"} \
	  {"GPIO_OUT_t" "TRI_T"} \
	  {"GPIO_OUT_o" "TRI_O"} ]


set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
	"value_validation_range_maximum" "256" \
	] \
	[ipx::get_user_parameters GPIO_IO_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
	"value_validation_range_maximum" "8" \
	] \
	[ipx::get_user_parameters NUM_PORTS -of_objects [ipx::current_core]]    

set_property display_name {Main} [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core] ]
set_property tooltip {} [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core] ]
    
for {set idx 0} {$idx < 8} {incr idx} {
    
    set pg [ipgui::add_page -name "PORT_${idx}" -component [ipx::current_core] -display_name "Port ${idx}"]
    
    ipgui::move_param -component [ipx::current_core] -order 0 -parent $pg \
        [ipgui::get_guiparamspec -name "PORT_${idx}_WIDTH" -component [ipx::current_core]]

    ipgui::move_param -component [ipx::current_core] -order 1 -parent $pg \
        [ipgui::get_guiparamspec -name "PORT_${idx}_OFFSET" -component [ipx::current_core]]    
    
    ipgui::move_param -component [ipx::current_core] -order 2 -parent $pg \
        [ipgui::get_guiparamspec -name "PORT_${idx}_TYPE" -component [ipx::current_core]]
    
    mw_add_bus "PORT_${idx}" "slave" \
        "mathworks.com:interface:gpio_rtl:1.0" \
        "mathworks.com:interface:gpio:1.0" \
        [list \
          [list "port_${idx}_i" "TRI_I"] \
          [list "port_${idx}_t" "TRI_T"] \
          [list "port_${idx}_o" "TRI_O"] ]
    
    set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "1" \
        "value_validation_range_maximum" "256" \
        "enablement_tcl_expr" "\$NUM_PORTS > ${idx}" \
        ] \
        [ipx::get_user_parameters PORT_${idx}_WIDTH -of_objects [ipx::current_core]]
    
    set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "255" \
        "enablement_tcl_expr" "\$NUM_PORTS > ${idx}" \
        ] \
        [ipx::get_user_parameters PORT_${idx}_OFFSET -of_objects [ipx::current_core]]

    set_property -dict [list \
		"value_validation_type" "pairs" \
        "value_validation_pairs" { \
            "Dynamic Mux" "0" \
            "Static Output" "1" \
            "Static Input"  "2" \
            "Static I/O"  "3" \
            "Bypass"  "4" \
            } \
        "enablement_tcl_expr" "\$NUM_PORTS > ${idx}" \
        ] \
        [ipx::get_user_parameters PORT_${idx}_TYPE -of_objects [ipx::current_core]]   

    mw_set_bus_dependency "PORT_${idx}" port_${idx} \
        "((spirit:decode(id('MODELPARAM_VALUE.NUM_PORTS')) > ${idx}) && ((spirit:decode(id('MODELPARAM_VALUE.PORT_${idx}_TYPE')) != 4)))"
    
    mw_set_ports_dependency port_${idx}_mux_sel \
        "((spirit:decode(id('MODELPARAM_VALUE.NUM_PORTS')) > ${idx}) && ((spirit:decode(id('MODELPARAM_VALUE.PORT_${idx}_TYPE')) == 0)))"
}  
      
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

