// (c) Copyright 1995-2019 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: analog.com:user:util_upack:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_util_ad9361_dac_upack_0 (
  dac_clk,
  dac_enable_0,
  dac_valid_0,
  dac_valid_out_0,
  dac_data_0,
  dac_enable_1,
  dac_valid_1,
  dac_valid_out_1,
  dac_data_1,
  dac_enable_2,
  dac_valid_2,
  dac_valid_out_2,
  dac_data_2,
  dac_enable_3,
  dac_valid_3,
  dac_valid_out_3,
  dac_data_3,
  dac_valid,
  dac_sync,
  dac_data
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dac_clk, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN system_util_mw_clkconstr_0_clk_out" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 dac_clk CLK" *)
input wire dac_clk;
input wire dac_enable_0;
input wire dac_valid_0;
output wire dac_valid_out_0;
output wire [15 : 0] dac_data_0;
input wire dac_enable_1;
input wire dac_valid_1;
output wire dac_valid_out_1;
output wire [15 : 0] dac_data_1;
input wire dac_enable_2;
input wire dac_valid_2;
output wire dac_valid_out_2;
output wire [15 : 0] dac_data_2;
input wire dac_enable_3;
input wire dac_valid_3;
output wire dac_valid_out_3;
output wire [15 : 0] dac_data_3;
output wire dac_valid;
output wire dac_sync;
input wire [63 : 0] dac_data;

  util_upack #(
    .CHANNEL_DATA_WIDTH(16),
    .NUM_OF_CHANNELS(4)
  ) inst (
    .dac_clk(dac_clk),
    .dac_enable_0(dac_enable_0),
    .dac_valid_0(dac_valid_0),
    .dac_valid_out_0(dac_valid_out_0),
    .dac_data_0(dac_data_0),
    .dac_enable_1(dac_enable_1),
    .dac_valid_1(dac_valid_1),
    .dac_valid_out_1(dac_valid_out_1),
    .dac_data_1(dac_data_1),
    .dac_enable_2(dac_enable_2),
    .dac_valid_2(dac_valid_2),
    .dac_valid_out_2(dac_valid_out_2),
    .dac_data_2(dac_data_2),
    .dac_enable_3(dac_enable_3),
    .dac_valid_3(dac_valid_3),
    .dac_valid_out_3(dac_valid_out_3),
    .dac_data_3(dac_data_3),
    .dac_enable_4(1'B0),
    .dac_valid_4(1'B0),
    .dac_valid_out_4(),
    .dac_data_4(),
    .dac_enable_5(1'B0),
    .dac_valid_5(1'B0),
    .dac_valid_out_5(),
    .dac_data_5(),
    .dac_enable_6(1'B0),
    .dac_valid_6(1'B0),
    .dac_valid_out_6(),
    .dac_data_6(),
    .dac_enable_7(1'B0),
    .dac_valid_7(1'B0),
    .dac_valid_out_7(),
    .dac_data_7(),
    .dac_valid(dac_valid),
    .dac_sync(dac_sync),
    .dac_data(dac_data)
  );
endmodule
