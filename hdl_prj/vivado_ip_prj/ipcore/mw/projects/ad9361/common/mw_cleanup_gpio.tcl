#Add the GPIO MUX Core

if { ![info exists MW_GPIO_WIDTH] } {
    set MW_GPIO_WIDTH 64
}
if { ![info exists MW_GPIO_OFFSET_ENABLE] } {
    set MW_GPIO_OFFSET_ENABLE 47
}
if { ![info exists MW_GPIO_OFFSET_TXNRX] } {
    set MW_GPIO_OFFSET_TXNRX 48
}
if { ![info exists MW_GPIO_OFFSET_EN_AGC] } {
    set MW_GPIO_OFFSET_EN_AGC 44
}
if { ![info exists MW_GPIO_OFFSET_STATUS] } {
    set MW_GPIO_OFFSET_STATUS 32
}
if { ![info exists MW_GPIO_OFFSET_CTL] } {
    set MW_GPIO_OFFSET_CTL 40
}

set MW_GPIO_STATIC_OUTPUT 1
set MW_GPIO_STATIC_INPUT 2

set cpu_name [get_property Name [mw_get_cpu]]
set gpio_mux [create_bd_cell -type ip -vlnv mathworks.com:user:util_mw_gpio_mux:* gpio_mux_0]
set_property CONFIG.GPIO_IO_WIDTH $MW_GPIO_WIDTH $gpio_mux
set_property CONFIG.NUM_PORTS {5} $gpio_mux

 switch [mw_project_get cpu_type] {
        zynq7_arm {
            set cpu_gpio_i ${cpu_name}/GPIO_I
            set cpu_gpio_o ${cpu_name}/GPIO_O
            set cpu_gpio_t ${cpu_name}/GPIO_T
        }
		zynqmp_arm {
            set cpu_gpio_i ${cpu_name}/emio_gpio_i
            set cpu_gpio_o ${cpu_name}/emio_gpio_o
            set cpu_gpio_t ${cpu_name}/emio_gpio_t
		}
    }

mw_disconnect_pin ${cpu_gpio_i}
mw_disconnect_pin ${cpu_gpio_o}
mw_disconnect_pin ${cpu_gpio_t}

mw_connect_pin gpio_i gpio_mux_0/GPIO_OUT_i
mw_connect_pin gpio_o gpio_mux_0/GPIO_OUT_o
mw_connect_pin gpio_t gpio_mux_0/GPIO_OUT_t

mw_connect_pin ${cpu_gpio_i} gpio_mux_0/GPIO_IN_i
mw_connect_pin ${cpu_gpio_o} gpio_mux_0/GPIO_IN_o
mw_connect_pin ${cpu_gpio_t} gpio_mux_0/GPIO_IN_t

#ENABLE
set_property CONFIG.PORT_0_WIDTH {1} $gpio_mux
set_property CONFIG.PORT_0_OFFSET $MW_GPIO_OFFSET_ENABLE $gpio_mux
set_property CONFIG.PORT_0_TYPE $MW_GPIO_STATIC_OUTPUT $gpio_mux

#TXNRX
set_property CONFIG.PORT_1_WIDTH {1} $gpio_mux
set_property CONFIG.PORT_1_OFFSET $MW_GPIO_OFFSET_TXNRX $gpio_mux
set_property CONFIG.PORT_1_TYPE $MW_GPIO_STATIC_OUTPUT $gpio_mux

#EN_AGC
set_property CONFIG.PORT_2_WIDTH {1} $gpio_mux
set_property CONFIG.PORT_2_OFFSET $MW_GPIO_OFFSET_EN_AGC $gpio_mux
set_property CONFIG.PORT_2_TYPE $MW_GPIO_STATIC_OUTPUT $gpio_mux

#STATUS
set_property CONFIG.PORT_3_WIDTH {8} $gpio_mux
set_property CONFIG.PORT_3_OFFSET $MW_GPIO_OFFSET_STATUS $gpio_mux
set_property CONFIG.PORT_3_TYPE $MW_GPIO_STATIC_INPUT $gpio_mux

#CTL
set_property CONFIG.PORT_4_WIDTH {4} $gpio_mux
set_property CONFIG.PORT_4_OFFSET $MW_GPIO_OFFSET_CTL $gpio_mux
set_property CONFIG.PORT_4_TYPE $MW_GPIO_STATIC_OUTPUT $gpio_mux

# Update the timing for the GPIO paths
add_files -norecurse -fileset sources_1 $mw_ad9361/common/mw_gpio_timing.xdc