// -------------------------------------------------------------
// 
// File Name: hdl_prj/hdlsrc/util_mw_bypass_user_logic/util_mw_bypass_user_logic_dut.v
// Created: 2018-08-08 16:25:38
// 
// Generated by MATLAB 9.5 and HDL Coder 3.13
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: util_mw_bypass_user_logic_dut
// Source Path: util_mw_bypass_user_logic/util_mw_bypass_user_logic_dut
// Hierarchy Level: 1
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module util_mw_bypass_user_logic_dut
          #(
           parameter DATA_WIDTH = 16,
           parameter NUM_CHAN=4) 
          (clk,
           reset,
           dut_enable,
           sel,
           bypass_data_in_0,
           bypass_data_in_1,
           bypass_valid_in_0,
           bypass_data_in_2,
           bypass_data_in_3,
           bypass_valid_in_1,
           bypass_data_in_4,
           bypass_data_in_5,
           bypass_valid_in_2,
           bypass_data_in_6,
           bypass_data_in_7,
           bypass_valid_in_3,
           dut_data_in_0,
           dut_data_in_1,
           dut_data_in_2,
           dut_data_in_3,
           dut_data_in_4,
           dut_data_in_5,
           dut_data_in_6,
           dut_data_in_7,
           dut_valid_in,
           ce_out,
           mux_data_out_0,
           mux_data_out_1,
           mux_valid_out_0,
           mux_data_out_2,
           mux_data_out_3,
           mux_valid_out_1,
           mux_data_out_4,
           mux_data_out_5,
           mux_valid_out_2,
           mux_data_out_6,
           mux_data_out_7,
           mux_valid_out_3);


  input   clk;
  input   reset;
  input   dut_enable;  // ufix1
  input   sel;  // ufix1
  input   signed [(DATA_WIDTH-1):0] bypass_data_in_0;  // sfix16
  input   signed [(DATA_WIDTH-1):0] bypass_data_in_1;  // sfix16
  input   bypass_valid_in_0;  // ufix1
  input   signed [(DATA_WIDTH-1):0] bypass_data_in_2;  // sfix16
  input   signed [(DATA_WIDTH-1):0] bypass_data_in_3;  // sfix16
  input   bypass_valid_in_1;  // ufix1
  input   signed [(DATA_WIDTH-1):0] bypass_data_in_4;  // sfix16
  input   signed [(DATA_WIDTH-1):0] bypass_data_in_5;  // sfix16
  input   bypass_valid_in_2;  // ufix1
  input   signed [(DATA_WIDTH-1):0] bypass_data_in_6;  // sfix16
  input   signed [(DATA_WIDTH-1):0] bypass_data_in_7;  // sfix16
  input   bypass_valid_in_3;  // ufix1
  input   signed [(DATA_WIDTH-1):0] dut_data_in_0;  // sfix16
  input   signed [(DATA_WIDTH-1):0] dut_data_in_1;  // sfix16
  input   signed [(DATA_WIDTH-1):0] dut_data_in_2;  // sfix16
  input   signed [(DATA_WIDTH-1):0] dut_data_in_3;  // sfix16
  input   signed [(DATA_WIDTH-1):0] dut_data_in_4;  // sfix16
  input   signed [(DATA_WIDTH-1):0] dut_data_in_5;  // sfix16
  input   signed [(DATA_WIDTH-1):0] dut_data_in_6;  // sfix16
  input   signed [(DATA_WIDTH-1):0] dut_data_in_7;  // sfix16
  input   dut_valid_in;  // ufix1
  output  ce_out;  // ufix1
  output  signed [(DATA_WIDTH-1):0] mux_data_out_0;  // sfix16
  output  signed [(DATA_WIDTH-1):0] mux_data_out_1;  // sfix16
  output  mux_valid_out_0;  // ufix1
  output  signed [(DATA_WIDTH-1):0] mux_data_out_2;  // sfix16
  output  signed [(DATA_WIDTH-1):0] mux_data_out_3;  // sfix16
  output  mux_valid_out_1;  // ufix1
  output  signed [(DATA_WIDTH-1):0] mux_data_out_4;  // sfix16
  output  signed [(DATA_WIDTH-1):0] mux_data_out_5;  // sfix16
  output  mux_valid_out_2;  // ufix1
  output  signed [(DATA_WIDTH-1):0] mux_data_out_6;  // sfix16
  output  signed [(DATA_WIDTH-1):0] mux_data_out_7;  // sfix16
  output  mux_valid_out_3;  // ufix1


  wire enb;
  wire ce_out_sig;  // ufix1
  wire signed [(DATA_WIDTH-1):0] mux_data_out_0_sig;  // sfix16
  wire signed [(DATA_WIDTH-1):0] mux_data_out_1_sig;  // sfix16
  wire mux_valid_out_0_sig;  // ufix1
  wire signed [(DATA_WIDTH-1):0] mux_data_out_2_sig;  // sfix16
  wire signed [(DATA_WIDTH-1):0] mux_data_out_3_sig;  // sfix16
  wire mux_valid_out_1_sig;  // ufix1
  wire signed [(DATA_WIDTH-1):0] mux_data_out_4_sig;  // sfix16
  wire signed [(DATA_WIDTH-1):0] mux_data_out_5_sig;  // sfix16
  wire mux_valid_out_2_sig;  // ufix1
  wire signed [(DATA_WIDTH-1):0] mux_data_out_6_sig;  // sfix16
  wire signed [(DATA_WIDTH-1):0] mux_data_out_7_sig;  // sfix16
  wire mux_valid_out_3_sig;  // ufix1


  assign enb = dut_enable;

  util_mw_bypass_user_logic_src_util_mw_bypass_user_logic #(.DATA_WIDTH(DATA_WIDTH),.NUM_CHAN(NUM_CHAN)) u_util_mw_bypass_user_logic_src_util_mw_bypass_user_logic (.clk(clk),
                                                                                                                     .clk_enable(enb),
                                                                                                                     .reset(reset),
                                                                                                                     .sel(sel),  // ufix1
                                                                                                                     .bypass_data_in_0(bypass_data_in_0),  // sfix16
                                                                                                                     .bypass_data_in_1(bypass_data_in_1),  // sfix16
                                                                                                                     .bypass_valid_in_0(bypass_valid_in_0),  // ufix1
                                                                                                                     .bypass_data_in_2(bypass_data_in_2),  // sfix16
                                                                                                                     .bypass_data_in_3(bypass_data_in_3),  // sfix16
                                                                                                                     .bypass_valid_in_1(bypass_valid_in_1),  // ufix1
                                                                                                                     .bypass_data_in_4(bypass_data_in_4),  // sfix16
                                                                                                                     .bypass_data_in_5(bypass_data_in_5),  // sfix16
                                                                                                                     .bypass_valid_in_2(bypass_valid_in_2),  // ufix1
                                                                                                                     .bypass_data_in_6(bypass_data_in_6),  // sfix16
                                                                                                                     .bypass_data_in_7(bypass_data_in_7),  // sfix16
                                                                                                                     .bypass_valid_in_3(bypass_valid_in_3),  // ufix1
                                                                                                                     .dut_data_in_0(dut_data_in_0),  // sfix16
                                                                                                                     .dut_data_in_1(dut_data_in_1),  // sfix16
                                                                                                                     .dut_data_in_2(dut_data_in_2),  // sfix16
                                                                                                                     .dut_data_in_3(dut_data_in_3),  // sfix16
                                                                                                                     .dut_data_in_4(dut_data_in_4),  // sfix16
                                                                                                                     .dut_data_in_5(dut_data_in_5),  // sfix16
                                                                                                                     .dut_data_in_6(dut_data_in_6),  // sfix16
                                                                                                                     .dut_data_in_7(dut_data_in_7),  // sfix16
                                                                                                                     .dut_valid_in(dut_valid_in),  // ufix1
                                                                                                                     .ce_out(ce_out_sig),  // ufix1
                                                                                                                     .mux_data_out_0(mux_data_out_0_sig),  // sfix16
                                                                                                                     .mux_data_out_1(mux_data_out_1_sig),  // sfix16
                                                                                                                     .mux_valid_out_0(mux_valid_out_0_sig),  // ufix1
                                                                                                                     .mux_data_out_2(mux_data_out_2_sig),  // sfix16
                                                                                                                     .mux_data_out_3(mux_data_out_3_sig),  // sfix16
                                                                                                                     .mux_valid_out_1(mux_valid_out_1_sig),  // ufix1
                                                                                                                     .mux_data_out_4(mux_data_out_4_sig),  // sfix16
                                                                                                                     .mux_data_out_5(mux_data_out_5_sig),  // sfix16
                                                                                                                     .mux_valid_out_2(mux_valid_out_2_sig),  // ufix1
                                                                                                                     .mux_data_out_6(mux_data_out_6_sig),  // sfix16
                                                                                                                     .mux_data_out_7(mux_data_out_7_sig),  // sfix16
                                                                                                                     .mux_valid_out_3(mux_valid_out_3_sig)  // ufix1
                                                                                                                     );

  assign ce_out = ce_out_sig;

  assign mux_data_out_0 = mux_data_out_0_sig;

  assign mux_data_out_1 = mux_data_out_1_sig;

  assign mux_valid_out_0 = mux_valid_out_0_sig;

  assign mux_data_out_2 = mux_data_out_2_sig;

  assign mux_data_out_3 = mux_data_out_3_sig;

  assign mux_valid_out_1 = mux_valid_out_1_sig;

  assign mux_data_out_4 = mux_data_out_4_sig;

  assign mux_data_out_5 = mux_data_out_5_sig;

  assign mux_valid_out_2 = mux_valid_out_2_sig;

  assign mux_data_out_6 = mux_data_out_6_sig;

  assign mux_data_out_7 = mux_data_out_7_sig;

  assign mux_valid_out_3 = mux_valid_out_3_sig;

endmodule  // util_mw_bypass_user_logic_dut

