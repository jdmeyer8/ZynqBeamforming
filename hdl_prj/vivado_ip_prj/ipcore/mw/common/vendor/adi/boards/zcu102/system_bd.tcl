set adi_board_has_hdmi false
set sys_zynq 2

proc mw_adi_bd_board_cleanup {} {
    global sys_zynq
    
    mw_project_set mw_ip_baseaddr 0x80000000
}