// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Wed Apr  3 12:08:09 2019
// Host        : jason-OptiPlex-9020 running 64-bit Ubuntu 16.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/jason/matlab/Projects/ZynqBF_2tx/hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/prj_ip/prj_ip.srcs/sources_1/ip/gsram1/gsram1_stub.v
// Design      : gsram1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z045ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module gsram1(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[5:0],dina[1023:0],douta[1023:0]" */;
  input clka;
  input [0:0]wea;
  input [5:0]addra;
  input [1023:0]dina;
  output [1023:0]douta;
endmodule
