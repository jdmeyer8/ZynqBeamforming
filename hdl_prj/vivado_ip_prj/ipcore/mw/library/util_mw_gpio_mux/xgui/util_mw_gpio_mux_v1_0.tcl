
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/util_mw_gpio_mux_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {Main}]
  ipgui::add_param $IPINST -name "GPIO_IO_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_PORTS" -parent ${Page_0}

  #Adding Page
  set PORT_0 [ipgui::add_page $IPINST -name "PORT_0" -display_name {Port 0}]
  ipgui::add_param $IPINST -name "PORT_0_WIDTH" -parent ${PORT_0}
  ipgui::add_param $IPINST -name "PORT_0_OFFSET" -parent ${PORT_0}
  ipgui::add_param $IPINST -name "PORT_0_TYPE" -parent ${PORT_0}

  #Adding Page
  set PORT_1 [ipgui::add_page $IPINST -name "PORT_1" -display_name {Port 1}]
  ipgui::add_param $IPINST -name "PORT_1_WIDTH" -parent ${PORT_1}
  ipgui::add_param $IPINST -name "PORT_1_OFFSET" -parent ${PORT_1}
  ipgui::add_param $IPINST -name "PORT_1_TYPE" -parent ${PORT_1}

  #Adding Page
  set PORT_2 [ipgui::add_page $IPINST -name "PORT_2" -display_name {Port 2}]
  ipgui::add_param $IPINST -name "PORT_2_WIDTH" -parent ${PORT_2}
  ipgui::add_param $IPINST -name "PORT_2_OFFSET" -parent ${PORT_2}
  ipgui::add_param $IPINST -name "PORT_2_TYPE" -parent ${PORT_2}

  #Adding Page
  set PORT_3 [ipgui::add_page $IPINST -name "PORT_3" -display_name {Port 3}]
  ipgui::add_param $IPINST -name "PORT_3_WIDTH" -parent ${PORT_3}
  ipgui::add_param $IPINST -name "PORT_3_OFFSET" -parent ${PORT_3}
  ipgui::add_param $IPINST -name "PORT_3_TYPE" -parent ${PORT_3}

  #Adding Page
  set PORT_4 [ipgui::add_page $IPINST -name "PORT_4" -display_name {Port 4}]
  ipgui::add_param $IPINST -name "PORT_4_WIDTH" -parent ${PORT_4}
  ipgui::add_param $IPINST -name "PORT_4_OFFSET" -parent ${PORT_4}
  ipgui::add_param $IPINST -name "PORT_4_TYPE" -parent ${PORT_4}

  #Adding Page
  set PORT_5 [ipgui::add_page $IPINST -name "PORT_5" -display_name {Port 5}]
  ipgui::add_param $IPINST -name "PORT_5_WIDTH" -parent ${PORT_5}
  ipgui::add_param $IPINST -name "PORT_5_OFFSET" -parent ${PORT_5}
  ipgui::add_param $IPINST -name "PORT_5_TYPE" -parent ${PORT_5}

  #Adding Page
  set PORT_6 [ipgui::add_page $IPINST -name "PORT_6" -display_name {Port 6}]
  ipgui::add_param $IPINST -name "PORT_6_WIDTH" -parent ${PORT_6}
  ipgui::add_param $IPINST -name "PORT_6_OFFSET" -parent ${PORT_6}
  ipgui::add_param $IPINST -name "PORT_6_TYPE" -parent ${PORT_6}

  #Adding Page
  set PORT_7 [ipgui::add_page $IPINST -name "PORT_7" -display_name {Port 7}]
  ipgui::add_param $IPINST -name "PORT_7_WIDTH" -parent ${PORT_7}
  ipgui::add_param $IPINST -name "PORT_7_OFFSET" -parent ${PORT_7}
  ipgui::add_param $IPINST -name "PORT_7_TYPE" -parent ${PORT_7}


}

proc update_PARAM_VALUE.PORT_0_OFFSET { PARAM_VALUE.PORT_0_OFFSET PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_0_OFFSET when any of the dependent parameters in the arguments change
	
	set PORT_0_OFFSET ${PARAM_VALUE.PORT_0_OFFSET}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_0_OFFSET_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_0_OFFSET
	} else {
		set_property enabled false $PORT_0_OFFSET
	}
}

proc validate_PARAM_VALUE.PORT_0_OFFSET { PARAM_VALUE.PORT_0_OFFSET } {
	# Procedure called to validate PORT_0_OFFSET
	return true
}

proc update_PARAM_VALUE.PORT_0_TYPE { PARAM_VALUE.PORT_0_TYPE PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_0_TYPE when any of the dependent parameters in the arguments change
	
	set PORT_0_TYPE ${PARAM_VALUE.PORT_0_TYPE}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_0_TYPE_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_0_TYPE
	} else {
		set_property enabled false $PORT_0_TYPE
	}
}

proc validate_PARAM_VALUE.PORT_0_TYPE { PARAM_VALUE.PORT_0_TYPE } {
	# Procedure called to validate PORT_0_TYPE
	return true
}

proc update_PARAM_VALUE.PORT_0_WIDTH { PARAM_VALUE.PORT_0_WIDTH PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_0_WIDTH when any of the dependent parameters in the arguments change
	
	set PORT_0_WIDTH ${PARAM_VALUE.PORT_0_WIDTH}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_0_WIDTH_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_0_WIDTH
	} else {
		set_property enabled false $PORT_0_WIDTH
	}
}

proc validate_PARAM_VALUE.PORT_0_WIDTH { PARAM_VALUE.PORT_0_WIDTH } {
	# Procedure called to validate PORT_0_WIDTH
	return true
}

proc update_PARAM_VALUE.PORT_1_OFFSET { PARAM_VALUE.PORT_1_OFFSET PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_1_OFFSET when any of the dependent parameters in the arguments change
	
	set PORT_1_OFFSET ${PARAM_VALUE.PORT_1_OFFSET}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_1_OFFSET_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_1_OFFSET
	} else {
		set_property enabled false $PORT_1_OFFSET
	}
}

proc validate_PARAM_VALUE.PORT_1_OFFSET { PARAM_VALUE.PORT_1_OFFSET } {
	# Procedure called to validate PORT_1_OFFSET
	return true
}

proc update_PARAM_VALUE.PORT_1_TYPE { PARAM_VALUE.PORT_1_TYPE PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_1_TYPE when any of the dependent parameters in the arguments change
	
	set PORT_1_TYPE ${PARAM_VALUE.PORT_1_TYPE}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_1_TYPE_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_1_TYPE
	} else {
		set_property enabled false $PORT_1_TYPE
	}
}

proc validate_PARAM_VALUE.PORT_1_TYPE { PARAM_VALUE.PORT_1_TYPE } {
	# Procedure called to validate PORT_1_TYPE
	return true
}

proc update_PARAM_VALUE.PORT_1_WIDTH { PARAM_VALUE.PORT_1_WIDTH PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_1_WIDTH when any of the dependent parameters in the arguments change
	
	set PORT_1_WIDTH ${PARAM_VALUE.PORT_1_WIDTH}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_1_WIDTH_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_1_WIDTH
	} else {
		set_property enabled false $PORT_1_WIDTH
	}
}

proc validate_PARAM_VALUE.PORT_1_WIDTH { PARAM_VALUE.PORT_1_WIDTH } {
	# Procedure called to validate PORT_1_WIDTH
	return true
}

proc update_PARAM_VALUE.PORT_2_OFFSET { PARAM_VALUE.PORT_2_OFFSET PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_2_OFFSET when any of the dependent parameters in the arguments change
	
	set PORT_2_OFFSET ${PARAM_VALUE.PORT_2_OFFSET}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_2_OFFSET_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_2_OFFSET
	} else {
		set_property enabled false $PORT_2_OFFSET
	}
}

proc validate_PARAM_VALUE.PORT_2_OFFSET { PARAM_VALUE.PORT_2_OFFSET } {
	# Procedure called to validate PORT_2_OFFSET
	return true
}

proc update_PARAM_VALUE.PORT_2_TYPE { PARAM_VALUE.PORT_2_TYPE PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_2_TYPE when any of the dependent parameters in the arguments change
	
	set PORT_2_TYPE ${PARAM_VALUE.PORT_2_TYPE}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_2_TYPE_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_2_TYPE
	} else {
		set_property enabled false $PORT_2_TYPE
	}
}

proc validate_PARAM_VALUE.PORT_2_TYPE { PARAM_VALUE.PORT_2_TYPE } {
	# Procedure called to validate PORT_2_TYPE
	return true
}

proc update_PARAM_VALUE.PORT_2_WIDTH { PARAM_VALUE.PORT_2_WIDTH PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_2_WIDTH when any of the dependent parameters in the arguments change
	
	set PORT_2_WIDTH ${PARAM_VALUE.PORT_2_WIDTH}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_2_WIDTH_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_2_WIDTH
	} else {
		set_property enabled false $PORT_2_WIDTH
	}
}

proc validate_PARAM_VALUE.PORT_2_WIDTH { PARAM_VALUE.PORT_2_WIDTH } {
	# Procedure called to validate PORT_2_WIDTH
	return true
}

proc update_PARAM_VALUE.PORT_3_OFFSET { PARAM_VALUE.PORT_3_OFFSET PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_3_OFFSET when any of the dependent parameters in the arguments change
	
	set PORT_3_OFFSET ${PARAM_VALUE.PORT_3_OFFSET}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_3_OFFSET_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_3_OFFSET
	} else {
		set_property enabled false $PORT_3_OFFSET
	}
}

proc validate_PARAM_VALUE.PORT_3_OFFSET { PARAM_VALUE.PORT_3_OFFSET } {
	# Procedure called to validate PORT_3_OFFSET
	return true
}

proc update_PARAM_VALUE.PORT_3_TYPE { PARAM_VALUE.PORT_3_TYPE PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_3_TYPE when any of the dependent parameters in the arguments change
	
	set PORT_3_TYPE ${PARAM_VALUE.PORT_3_TYPE}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_3_TYPE_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_3_TYPE
	} else {
		set_property enabled false $PORT_3_TYPE
	}
}

proc validate_PARAM_VALUE.PORT_3_TYPE { PARAM_VALUE.PORT_3_TYPE } {
	# Procedure called to validate PORT_3_TYPE
	return true
}

proc update_PARAM_VALUE.PORT_3_WIDTH { PARAM_VALUE.PORT_3_WIDTH PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_3_WIDTH when any of the dependent parameters in the arguments change
	
	set PORT_3_WIDTH ${PARAM_VALUE.PORT_3_WIDTH}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_3_WIDTH_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_3_WIDTH
	} else {
		set_property enabled false $PORT_3_WIDTH
	}
}

proc validate_PARAM_VALUE.PORT_3_WIDTH { PARAM_VALUE.PORT_3_WIDTH } {
	# Procedure called to validate PORT_3_WIDTH
	return true
}

proc update_PARAM_VALUE.PORT_4_OFFSET { PARAM_VALUE.PORT_4_OFFSET PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_4_OFFSET when any of the dependent parameters in the arguments change
	
	set PORT_4_OFFSET ${PARAM_VALUE.PORT_4_OFFSET}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_4_OFFSET_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_4_OFFSET
	} else {
		set_property enabled false $PORT_4_OFFSET
	}
}

proc validate_PARAM_VALUE.PORT_4_OFFSET { PARAM_VALUE.PORT_4_OFFSET } {
	# Procedure called to validate PORT_4_OFFSET
	return true
}

proc update_PARAM_VALUE.PORT_4_TYPE { PARAM_VALUE.PORT_4_TYPE PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_4_TYPE when any of the dependent parameters in the arguments change
	
	set PORT_4_TYPE ${PARAM_VALUE.PORT_4_TYPE}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_4_TYPE_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_4_TYPE
	} else {
		set_property enabled false $PORT_4_TYPE
	}
}

proc validate_PARAM_VALUE.PORT_4_TYPE { PARAM_VALUE.PORT_4_TYPE } {
	# Procedure called to validate PORT_4_TYPE
	return true
}

proc update_PARAM_VALUE.PORT_4_WIDTH { PARAM_VALUE.PORT_4_WIDTH PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_4_WIDTH when any of the dependent parameters in the arguments change
	
	set PORT_4_WIDTH ${PARAM_VALUE.PORT_4_WIDTH}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_4_WIDTH_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_4_WIDTH
	} else {
		set_property enabled false $PORT_4_WIDTH
	}
}

proc validate_PARAM_VALUE.PORT_4_WIDTH { PARAM_VALUE.PORT_4_WIDTH } {
	# Procedure called to validate PORT_4_WIDTH
	return true
}

proc update_PARAM_VALUE.PORT_5_OFFSET { PARAM_VALUE.PORT_5_OFFSET PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_5_OFFSET when any of the dependent parameters in the arguments change
	
	set PORT_5_OFFSET ${PARAM_VALUE.PORT_5_OFFSET}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_5_OFFSET_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_5_OFFSET
	} else {
		set_property enabled false $PORT_5_OFFSET
	}
}

proc validate_PARAM_VALUE.PORT_5_OFFSET { PARAM_VALUE.PORT_5_OFFSET } {
	# Procedure called to validate PORT_5_OFFSET
	return true
}

proc update_PARAM_VALUE.PORT_5_TYPE { PARAM_VALUE.PORT_5_TYPE PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_5_TYPE when any of the dependent parameters in the arguments change
	
	set PORT_5_TYPE ${PARAM_VALUE.PORT_5_TYPE}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_5_TYPE_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_5_TYPE
	} else {
		set_property enabled false $PORT_5_TYPE
	}
}

proc validate_PARAM_VALUE.PORT_5_TYPE { PARAM_VALUE.PORT_5_TYPE } {
	# Procedure called to validate PORT_5_TYPE
	return true
}

proc update_PARAM_VALUE.PORT_5_WIDTH { PARAM_VALUE.PORT_5_WIDTH PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_5_WIDTH when any of the dependent parameters in the arguments change
	
	set PORT_5_WIDTH ${PARAM_VALUE.PORT_5_WIDTH}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_5_WIDTH_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_5_WIDTH
	} else {
		set_property enabled false $PORT_5_WIDTH
	}
}

proc validate_PARAM_VALUE.PORT_5_WIDTH { PARAM_VALUE.PORT_5_WIDTH } {
	# Procedure called to validate PORT_5_WIDTH
	return true
}

proc update_PARAM_VALUE.PORT_6_OFFSET { PARAM_VALUE.PORT_6_OFFSET PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_6_OFFSET when any of the dependent parameters in the arguments change
	
	set PORT_6_OFFSET ${PARAM_VALUE.PORT_6_OFFSET}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_6_OFFSET_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_6_OFFSET
	} else {
		set_property enabled false $PORT_6_OFFSET
	}
}

proc validate_PARAM_VALUE.PORT_6_OFFSET { PARAM_VALUE.PORT_6_OFFSET } {
	# Procedure called to validate PORT_6_OFFSET
	return true
}

proc update_PARAM_VALUE.PORT_6_TYPE { PARAM_VALUE.PORT_6_TYPE PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_6_TYPE when any of the dependent parameters in the arguments change
	
	set PORT_6_TYPE ${PARAM_VALUE.PORT_6_TYPE}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_6_TYPE_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_6_TYPE
	} else {
		set_property enabled false $PORT_6_TYPE
	}
}

proc validate_PARAM_VALUE.PORT_6_TYPE { PARAM_VALUE.PORT_6_TYPE } {
	# Procedure called to validate PORT_6_TYPE
	return true
}

proc update_PARAM_VALUE.PORT_6_WIDTH { PARAM_VALUE.PORT_6_WIDTH PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_6_WIDTH when any of the dependent parameters in the arguments change
	
	set PORT_6_WIDTH ${PARAM_VALUE.PORT_6_WIDTH}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_6_WIDTH_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_6_WIDTH
	} else {
		set_property enabled false $PORT_6_WIDTH
	}
}

proc validate_PARAM_VALUE.PORT_6_WIDTH { PARAM_VALUE.PORT_6_WIDTH } {
	# Procedure called to validate PORT_6_WIDTH
	return true
}

proc update_PARAM_VALUE.PORT_7_OFFSET { PARAM_VALUE.PORT_7_OFFSET PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_7_OFFSET when any of the dependent parameters in the arguments change
	
	set PORT_7_OFFSET ${PARAM_VALUE.PORT_7_OFFSET}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_7_OFFSET_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_7_OFFSET
	} else {
		set_property enabled false $PORT_7_OFFSET
	}
}

proc validate_PARAM_VALUE.PORT_7_OFFSET { PARAM_VALUE.PORT_7_OFFSET } {
	# Procedure called to validate PORT_7_OFFSET
	return true
}

proc update_PARAM_VALUE.PORT_7_TYPE { PARAM_VALUE.PORT_7_TYPE PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_7_TYPE when any of the dependent parameters in the arguments change
	
	set PORT_7_TYPE ${PARAM_VALUE.PORT_7_TYPE}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_7_TYPE_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_7_TYPE
	} else {
		set_property enabled false $PORT_7_TYPE
	}
}

proc validate_PARAM_VALUE.PORT_7_TYPE { PARAM_VALUE.PORT_7_TYPE } {
	# Procedure called to validate PORT_7_TYPE
	return true
}

proc update_PARAM_VALUE.PORT_7_WIDTH { PARAM_VALUE.PORT_7_WIDTH PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update PORT_7_WIDTH when any of the dependent parameters in the arguments change
	
	set PORT_7_WIDTH ${PARAM_VALUE.PORT_7_WIDTH}
	set NUM_PORTS ${PARAM_VALUE.NUM_PORTS}
	set values(NUM_PORTS) [get_property value $NUM_PORTS]
	if { [gen_USERPARAMETER_PORT_7_WIDTH_ENABLEMENT $values(NUM_PORTS)] } {
		set_property enabled true $PORT_7_WIDTH
	} else {
		set_property enabled false $PORT_7_WIDTH
	}
}

proc validate_PARAM_VALUE.PORT_7_WIDTH { PARAM_VALUE.PORT_7_WIDTH } {
	# Procedure called to validate PORT_7_WIDTH
	return true
}

proc update_PARAM_VALUE.GPIO_IO_WIDTH { PARAM_VALUE.GPIO_IO_WIDTH } {
	# Procedure called to update GPIO_IO_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GPIO_IO_WIDTH { PARAM_VALUE.GPIO_IO_WIDTH } {
	# Procedure called to validate GPIO_IO_WIDTH
	return true
}

proc update_PARAM_VALUE.NUM_PORTS { PARAM_VALUE.NUM_PORTS } {
	# Procedure called to update NUM_PORTS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_PORTS { PARAM_VALUE.NUM_PORTS } {
	# Procedure called to validate NUM_PORTS
	return true
}


proc update_MODELPARAM_VALUE.GPIO_IO_WIDTH { MODELPARAM_VALUE.GPIO_IO_WIDTH PARAM_VALUE.GPIO_IO_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.GPIO_IO_WIDTH}] ${MODELPARAM_VALUE.GPIO_IO_WIDTH}
}

proc update_MODELPARAM_VALUE.NUM_PORTS { MODELPARAM_VALUE.NUM_PORTS PARAM_VALUE.NUM_PORTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_PORTS}] ${MODELPARAM_VALUE.NUM_PORTS}
}

proc update_MODELPARAM_VALUE.PORT_0_WIDTH { MODELPARAM_VALUE.PORT_0_WIDTH PARAM_VALUE.PORT_0_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_0_WIDTH}] ${MODELPARAM_VALUE.PORT_0_WIDTH}
}

proc update_MODELPARAM_VALUE.PORT_0_OFFSET { MODELPARAM_VALUE.PORT_0_OFFSET PARAM_VALUE.PORT_0_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_0_OFFSET}] ${MODELPARAM_VALUE.PORT_0_OFFSET}
}

proc update_MODELPARAM_VALUE.PORT_0_TYPE { MODELPARAM_VALUE.PORT_0_TYPE PARAM_VALUE.PORT_0_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_0_TYPE}] ${MODELPARAM_VALUE.PORT_0_TYPE}
}

proc update_MODELPARAM_VALUE.PORT_1_WIDTH { MODELPARAM_VALUE.PORT_1_WIDTH PARAM_VALUE.PORT_1_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_1_WIDTH}] ${MODELPARAM_VALUE.PORT_1_WIDTH}
}

proc update_MODELPARAM_VALUE.PORT_1_OFFSET { MODELPARAM_VALUE.PORT_1_OFFSET PARAM_VALUE.PORT_1_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_1_OFFSET}] ${MODELPARAM_VALUE.PORT_1_OFFSET}
}

proc update_MODELPARAM_VALUE.PORT_1_TYPE { MODELPARAM_VALUE.PORT_1_TYPE PARAM_VALUE.PORT_1_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_1_TYPE}] ${MODELPARAM_VALUE.PORT_1_TYPE}
}

proc update_MODELPARAM_VALUE.PORT_2_WIDTH { MODELPARAM_VALUE.PORT_2_WIDTH PARAM_VALUE.PORT_2_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_2_WIDTH}] ${MODELPARAM_VALUE.PORT_2_WIDTH}
}

proc update_MODELPARAM_VALUE.PORT_2_OFFSET { MODELPARAM_VALUE.PORT_2_OFFSET PARAM_VALUE.PORT_2_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_2_OFFSET}] ${MODELPARAM_VALUE.PORT_2_OFFSET}
}

proc update_MODELPARAM_VALUE.PORT_2_TYPE { MODELPARAM_VALUE.PORT_2_TYPE PARAM_VALUE.PORT_2_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_2_TYPE}] ${MODELPARAM_VALUE.PORT_2_TYPE}
}

proc update_MODELPARAM_VALUE.PORT_3_WIDTH { MODELPARAM_VALUE.PORT_3_WIDTH PARAM_VALUE.PORT_3_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_3_WIDTH}] ${MODELPARAM_VALUE.PORT_3_WIDTH}
}

proc update_MODELPARAM_VALUE.PORT_3_OFFSET { MODELPARAM_VALUE.PORT_3_OFFSET PARAM_VALUE.PORT_3_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_3_OFFSET}] ${MODELPARAM_VALUE.PORT_3_OFFSET}
}

proc update_MODELPARAM_VALUE.PORT_3_TYPE { MODELPARAM_VALUE.PORT_3_TYPE PARAM_VALUE.PORT_3_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_3_TYPE}] ${MODELPARAM_VALUE.PORT_3_TYPE}
}

proc update_MODELPARAM_VALUE.PORT_4_WIDTH { MODELPARAM_VALUE.PORT_4_WIDTH PARAM_VALUE.PORT_4_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_4_WIDTH}] ${MODELPARAM_VALUE.PORT_4_WIDTH}
}

proc update_MODELPARAM_VALUE.PORT_4_OFFSET { MODELPARAM_VALUE.PORT_4_OFFSET PARAM_VALUE.PORT_4_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_4_OFFSET}] ${MODELPARAM_VALUE.PORT_4_OFFSET}
}

proc update_MODELPARAM_VALUE.PORT_4_TYPE { MODELPARAM_VALUE.PORT_4_TYPE PARAM_VALUE.PORT_4_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_4_TYPE}] ${MODELPARAM_VALUE.PORT_4_TYPE}
}

proc update_MODELPARAM_VALUE.PORT_5_WIDTH { MODELPARAM_VALUE.PORT_5_WIDTH PARAM_VALUE.PORT_5_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_5_WIDTH}] ${MODELPARAM_VALUE.PORT_5_WIDTH}
}

proc update_MODELPARAM_VALUE.PORT_5_OFFSET { MODELPARAM_VALUE.PORT_5_OFFSET PARAM_VALUE.PORT_5_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_5_OFFSET}] ${MODELPARAM_VALUE.PORT_5_OFFSET}
}

proc update_MODELPARAM_VALUE.PORT_5_TYPE { MODELPARAM_VALUE.PORT_5_TYPE PARAM_VALUE.PORT_5_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_5_TYPE}] ${MODELPARAM_VALUE.PORT_5_TYPE}
}

proc update_MODELPARAM_VALUE.PORT_6_WIDTH { MODELPARAM_VALUE.PORT_6_WIDTH PARAM_VALUE.PORT_6_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_6_WIDTH}] ${MODELPARAM_VALUE.PORT_6_WIDTH}
}

proc update_MODELPARAM_VALUE.PORT_6_OFFSET { MODELPARAM_VALUE.PORT_6_OFFSET PARAM_VALUE.PORT_6_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_6_OFFSET}] ${MODELPARAM_VALUE.PORT_6_OFFSET}
}

proc update_MODELPARAM_VALUE.PORT_6_TYPE { MODELPARAM_VALUE.PORT_6_TYPE PARAM_VALUE.PORT_6_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_6_TYPE}] ${MODELPARAM_VALUE.PORT_6_TYPE}
}

proc update_MODELPARAM_VALUE.PORT_7_WIDTH { MODELPARAM_VALUE.PORT_7_WIDTH PARAM_VALUE.PORT_7_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_7_WIDTH}] ${MODELPARAM_VALUE.PORT_7_WIDTH}
}

proc update_MODELPARAM_VALUE.PORT_7_OFFSET { MODELPARAM_VALUE.PORT_7_OFFSET PARAM_VALUE.PORT_7_OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_7_OFFSET}] ${MODELPARAM_VALUE.PORT_7_OFFSET}
}

proc update_MODELPARAM_VALUE.PORT_7_TYPE { MODELPARAM_VALUE.PORT_7_TYPE PARAM_VALUE.PORT_7_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_7_TYPE}] ${MODELPARAM_VALUE.PORT_7_TYPE}
}

