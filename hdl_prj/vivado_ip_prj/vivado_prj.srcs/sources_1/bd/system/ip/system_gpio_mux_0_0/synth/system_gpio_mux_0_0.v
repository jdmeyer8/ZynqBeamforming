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


// IP VLNV: mathworks.com:user:util_mw_gpio_mux:1.0
// IP Revision: 1

(* X_CORE_INFO = "util_mw_gpio_mux,Vivado 2017.4" *)
(* CHECK_LICENSE_TYPE = "system_gpio_mux_0_0,util_mw_gpio_mux,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_gpio_mux_0_0 (
  GPIO_IN_o,
  GPIO_IN_t,
  GPIO_IN_i,
  GPIO_OUT_o,
  GPIO_OUT_t,
  GPIO_OUT_i
);

(* X_INTERFACE_INFO = "mathworks.com:interface:gpio:1.0 GPIO_IN TRI_O" *)
input wire [63 : 0] GPIO_IN_o;
(* X_INTERFACE_INFO = "mathworks.com:interface:gpio:1.0 GPIO_IN TRI_T" *)
input wire [63 : 0] GPIO_IN_t;
(* X_INTERFACE_INFO = "mathworks.com:interface:gpio:1.0 GPIO_IN TRI_I" *)
output wire [63 : 0] GPIO_IN_i;
(* X_INTERFACE_INFO = "mathworks.com:interface:gpio:1.0 GPIO_OUT TRI_O" *)
output wire [63 : 0] GPIO_OUT_o;
(* X_INTERFACE_INFO = "mathworks.com:interface:gpio:1.0 GPIO_OUT TRI_T" *)
output wire [63 : 0] GPIO_OUT_t;
(* X_INTERFACE_INFO = "mathworks.com:interface:gpio:1.0 GPIO_OUT TRI_I" *)
input wire [63 : 0] GPIO_OUT_i;

  util_mw_gpio_mux #(
    .GPIO_IO_WIDTH(64),
    .NUM_PORTS(5),
    .PORT_0_WIDTH(1),
    .PORT_0_OFFSET(47),
    .PORT_0_TYPE(4),
    .PORT_1_WIDTH(1),
    .PORT_1_OFFSET(48),
    .PORT_1_TYPE(4),
    .PORT_2_WIDTH(1),
    .PORT_2_OFFSET(44),
    .PORT_2_TYPE(4),
    .PORT_3_WIDTH(8),
    .PORT_3_OFFSET(32),
    .PORT_3_TYPE(4),
    .PORT_4_WIDTH(4),
    .PORT_4_OFFSET(40),
    .PORT_4_TYPE(4),
    .PORT_5_WIDTH(32),
    .PORT_5_OFFSET(0),
    .PORT_5_TYPE(0),
    .PORT_6_WIDTH(32),
    .PORT_6_OFFSET(0),
    .PORT_6_TYPE(0),
    .PORT_7_WIDTH(32),
    .PORT_7_OFFSET(0),
    .PORT_7_TYPE(0)
  ) inst (
    .GPIO_IN_o(GPIO_IN_o),
    .GPIO_IN_t(GPIO_IN_t),
    .GPIO_IN_i(GPIO_IN_i),
    .port_0_o(1'B0),
    .port_0_t(1'B0),
    .port_0_i(),
    .port_0_mux_sel(1'B0),
    .port_1_o(1'B0),
    .port_1_t(1'B0),
    .port_1_i(),
    .port_1_mux_sel(1'B0),
    .port_2_o(1'B0),
    .port_2_t(1'B0),
    .port_2_i(),
    .port_2_mux_sel(1'B0),
    .port_3_o(8'B0),
    .port_3_t(8'B0),
    .port_3_i(),
    .port_3_mux_sel(8'B0),
    .port_4_o(4'B0),
    .port_4_t(4'B0),
    .port_4_i(),
    .port_4_mux_sel(4'B0),
    .port_5_o(32'B0),
    .port_5_t(32'B0),
    .port_5_i(),
    .port_5_mux_sel(32'B0),
    .port_6_o(32'B0),
    .port_6_t(32'B0),
    .port_6_i(),
    .port_6_mux_sel(32'B0),
    .port_7_o(32'B0),
    .port_7_t(32'B0),
    .port_7_i(),
    .port_7_mux_sel(32'B0),
    .GPIO_OUT_o(GPIO_OUT_o),
    .GPIO_OUT_t(GPIO_OUT_t),
    .GPIO_OUT_i(GPIO_OUT_i)
  );
endmodule
