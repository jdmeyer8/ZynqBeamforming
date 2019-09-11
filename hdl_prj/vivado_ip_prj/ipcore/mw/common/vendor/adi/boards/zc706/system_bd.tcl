proc mw_adi_bd_board_cleanup {} {
    delete_bd_objs [get_bd_cells sys_audio_clkgen]
}