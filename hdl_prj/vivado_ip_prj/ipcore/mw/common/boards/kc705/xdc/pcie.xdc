set_property IOSTANDARD DIFF_HSTL_II_18 [get_ports refclk_p]
set_property PACKAGE_PIN U8 [get_ports refclk_p]
set_property PACKAGE_PIN U7 [get_ports refclk_n]
create_clock -period 10.000 -name refclk_p -waveform {0.000 5.000} [get_ports {refclk_p}]

set_property IOSTANDARD LVCMOS25 [get_ports pcie_perst_n]
set_property PULLUP true [get_ports pcie_perst_n]
set_property LOC G25 [get_ports pcie_perst_n]