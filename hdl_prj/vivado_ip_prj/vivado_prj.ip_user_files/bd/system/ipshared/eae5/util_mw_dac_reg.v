/*
	Copright 2016-2017 MathWorks, Inc.
	
	DAC Register IP
	
	Register DAC outputs based on valid signal
		

*/

module util_mw_dac_reg (

	clk,
	rst,
	
	dac_valid,
	
	dac_data_in_0,
	dac_data_in_1,
	dac_data_in_2,
	dac_data_in_3,
	dac_data_in_4,
	dac_data_in_5,
	dac_data_in_6,
	dac_data_in_7,
	
	dac_data_out_0,
	dac_data_out_1,
	dac_data_out_2,
	dac_data_out_3,
	dac_data_out_4,
	dac_data_out_5,
	dac_data_out_6,
	dac_data_out_7
	); 
	
	parameter DATA_WIDTH = 16;
	parameter NUM_CHAN = 4;
	
	input							clk;
	input							rst;
	
	input							dac_valid;
	
	input [(DATA_WIDTH-1):0] dac_data_in_0;
	input [(DATA_WIDTH-1):0] dac_data_in_1;
	input [(DATA_WIDTH-1):0] dac_data_in_2;
	input [(DATA_WIDTH-1):0] dac_data_in_3;
	input [(DATA_WIDTH-1):0] dac_data_in_4;
	input [(DATA_WIDTH-1):0] dac_data_in_5;
	input [(DATA_WIDTH-1):0] dac_data_in_6;
	input [(DATA_WIDTH-1):0] dac_data_in_7;
	
	output reg [(DATA_WIDTH-1):0] dac_data_out_0;
	output reg [(DATA_WIDTH-1):0] dac_data_out_1;
	output reg [(DATA_WIDTH-1):0] dac_data_out_2;
	output reg [(DATA_WIDTH-1):0] dac_data_out_3;
	output reg [(DATA_WIDTH-1):0] dac_data_out_4;
	output reg [(DATA_WIDTH-1):0] dac_data_out_5;
	output reg [(DATA_WIDTH-1):0] dac_data_out_6;
	output reg [(DATA_WIDTH-1):0] dac_data_out_7;
	
	always @(posedge clk) begin
		if (rst == 1'b1) begin
			dac_data_out_0 <= 'd0;
			dac_data_out_1 <= 'd0;
			dac_data_out_2 <= 'd0;
			dac_data_out_3 <= 'd0;
			dac_data_out_4 <= 'd0;
			dac_data_out_5 <= 'd0;
			dac_data_out_6 <= 'd0;
			dac_data_out_7 <= 'd0;
		end else begin
			if (dac_valid) begin
				dac_data_out_0 <= dac_data_in_0;
				dac_data_out_1 <= dac_data_in_1;
				dac_data_out_2 <= dac_data_in_2;
				dac_data_out_3 <= dac_data_in_3;
				dac_data_out_4 <= dac_data_in_4;
				dac_data_out_5 <= dac_data_in_5;
				dac_data_out_6 <= dac_data_in_6;
				dac_data_out_7 <= dac_data_in_7;
			end
		end
	end
		
endmodule
  