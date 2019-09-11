// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Wed Apr  3 13:42:58 2019
// Host        : jason-OptiPlex-9020 running 64-bit Ubuntu 16.04.3 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ rx_ram_core_stub.v
// Design      : rx_ram_core
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z045ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clka, wea, addra, dina, douta, clkb, enb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[13:0],dina[15:0],douta[511:0],clkb,enb,web[0:0],addrb[13:0],dinb[15:0],doutb[511:0]" */;
  input clka;
  input [0:0]wea;
  input [13:0]addra;
  input [15:0]dina;
  output [511:0]douta;
  input clkb;
  input enb;
  input [0:0]web;
  input [13:0]addrb;
  input [15:0]dinb;
  output [511:0]doutb;
endmodule
