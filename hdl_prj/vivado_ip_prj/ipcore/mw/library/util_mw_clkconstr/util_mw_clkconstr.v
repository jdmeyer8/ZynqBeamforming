// ***************************************************************************
// ***************************************************************************
// Copyright 2015-2016(c) The Mathworks, Inc
//
// All rights reserved.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module util_mw_clkconstr (
	clk,
	clk_out
 );

	input   	clk;
	output  	clk_out;

	// parameters
	parameter   CLKOUT0_REQUESTED_OUT_FREQ  = "100.0";

	assign clk_out = clk;

endmodule  // util_mw_clkconstr