/*
	Copright 2016-2017 MathWorks, Inc.
	
	DAC Bridge IP
	
	dmac_in --> bridge_out --> [User IP] --> (cont)
	(cont) --> bridge_in --> dac_out
		

*/

module util_mw_dac_bridge_ctl (

	clk,
	rst,
	
	dac_valid_0,
	dac_valid_1,
	dac_valid_2,
	dac_valid_3,
	dac_valid_4,
	dac_valid_5,
	dac_valid_6,
	dac_valid_7,
	
	dac_valid,
	
	dac_enable_0,
	dac_enable_1,
	dac_enable_2,
	dac_enable_3,
	dac_enable_4,
	dac_enable_5,
	dac_enable_6,
	dac_enable_7,
	
	dmac_in,
	
	bridge_enable_out,
	
	bridge_out_0,
	bridge_out_1,
	bridge_out_2,
	bridge_out_3,
	bridge_out_4,
	bridge_out_5,
	bridge_out_6,
	bridge_out_7,
	
	bridge_valid_in,
	
	bridge_in_0,
	bridge_in_1,
	bridge_in_2,
	bridge_in_3,
	bridge_in_4,
	bridge_in_5,
	bridge_in_6,
	bridge_in_7,
	
	dac_data_0,
	dac_data_1,
	dac_data_2,
	dac_data_3,
	dac_data_4,
	dac_data_5,
	dac_data_6,
	dac_data_7
	); 
	
	parameter DATA_WIDTH = 16;
	parameter NUM_CHAN = 4;
	
	input							clk;
	input							rst;
	
	input							dac_valid_0;
	input							dac_valid_1;
	input							dac_valid_2;
	input							dac_valid_3;
	input							dac_valid_4;
	input							dac_valid_5;
	input							dac_valid_6;
	input							dac_valid_7;
	
	output wire						dac_valid;
	
	input							dac_enable_0;
	input							dac_enable_1;
	input							dac_enable_2;
	input							dac_enable_3;
	input							dac_enable_4;
	input							dac_enable_5;
	input							dac_enable_6;
	input							dac_enable_7;

	input [(DATA_WIDTH*NUM_CHAN-1):0] 	dmac_in;
	
	output wire 					bridge_enable_out;
	
	output wire [(DATA_WIDTH-1):0] bridge_out_0;
	output wire [(DATA_WIDTH-1):0] bridge_out_1;
	output wire [(DATA_WIDTH-1):0] bridge_out_2;
	output wire [(DATA_WIDTH-1):0] bridge_out_3;
	output wire [(DATA_WIDTH-1):0] bridge_out_4;
	output wire [(DATA_WIDTH-1):0] bridge_out_5;
	output wire [(DATA_WIDTH-1):0] bridge_out_6;
	output wire [(DATA_WIDTH-1):0] bridge_out_7;
	
	input wire				bridge_valid_in;
	
	input [(DATA_WIDTH-1):0] bridge_in_0;
	input [(DATA_WIDTH-1):0] bridge_in_1;
	input [(DATA_WIDTH-1):0] bridge_in_2;
	input [(DATA_WIDTH-1):0] bridge_in_3;
	input [(DATA_WIDTH-1):0] bridge_in_4;
	input [(DATA_WIDTH-1):0] bridge_in_5;
	input [(DATA_WIDTH-1):0] bridge_in_6;
	input [(DATA_WIDTH-1):0] bridge_in_7;
	
	output reg [(DATA_WIDTH-1):0] dac_data_0;
	output reg [(DATA_WIDTH-1):0] dac_data_1;
	output reg [(DATA_WIDTH-1):0] dac_data_2;
	output reg [(DATA_WIDTH-1):0] dac_data_3;
	output reg [(DATA_WIDTH-1):0] dac_data_4;
	output reg [(DATA_WIDTH-1):0] dac_data_5;
	output reg [(DATA_WIDTH-1):0] dac_data_6;
	output reg [(DATA_WIDTH-1):0] dac_data_7;
	
	wire [(DATA_WIDTH-1):0] bridge_out_tmp[0:7];
	

	// Static assignment
	assign bridge_out_0 = bridge_out_tmp[0];
	assign bridge_out_1 = bridge_out_tmp[1];
	assign bridge_out_2 = bridge_out_tmp[2];
	assign bridge_out_3 = bridge_out_tmp[3];
	assign bridge_out_4 = bridge_out_tmp[4];
	assign bridge_out_5 = bridge_out_tmp[5];
	assign bridge_out_6 = bridge_out_tmp[6];
	assign bridge_out_7 = bridge_out_tmp[7];
	
	always @(posedge clk) begin
		if (rst == 1'b1) begin
			dac_data_0 <= 'd0;
			dac_data_1 <= 'd0;
			dac_data_2 <= 'd0;
			dac_data_3 <= 'd0;
			dac_data_4 <= 'd0;
			dac_data_5 <= 'd0;
			dac_data_6 <= 'd0;
			dac_data_7 <= 'd0;
		end else begin
			if (bridge_valid_in) begin
				dac_data_0 <= bridge_in_0;
				dac_data_1 <= bridge_in_1;
				dac_data_2 <= bridge_in_2;
				dac_data_3 <= bridge_in_3;
				dac_data_4 <= bridge_in_4;
				dac_data_5 <= bridge_in_5;
				dac_data_6 <= bridge_in_6;
				dac_data_7 <= bridge_in_7;
			end
		end
	end
	
	genvar n;
	// Concatenate / slice the data in use
	generate
		for (n = 0; n < NUM_CHAN; n = n + 1) begin: in_loop
			assign bridge_out_tmp[n] = dmac_in[((n+1)*DATA_WIDTH-1):(n*DATA_WIDTH)];
		end
		for (n = NUM_CHAN; n < 8; n = n + 1) begin: null_loop
			assign bridge_out_tmp[n] = 'd0;
		end
	endgenerate	
	
	assign bridge_enable_out = dac_enable_0 | dac_enable_1 | dac_enable_2 | 
		dac_enable_3 | dac_enable_4 | dac_enable_5 | dac_enable_6 | dac_enable_7;

	assign dac_valid = dac_valid_0 | dac_valid_1 | dac_valid_2 | 
		dac_valid_3 | dac_valid_4 | dac_valid_5 | dac_valid_6 | dac_valid_7;		
		
endmodule
  