/*
    Copright 2016-2017 MathWorks, Inc.
    
    ADC Bridge IP
    
    adc_in --> bridge_out --> [User IP] --> bridge_in --> dmac_out

*/

module util_mw_adc_bridge_ctl (
        
    adc_data_0,
    adc_data_1,
    adc_data_2,
    adc_data_3,
    adc_data_4,
    adc_data_5,
    adc_data_6,
    adc_data_7,
    
    adc_valid_0,
    adc_valid_1,
    adc_valid_2,
    adc_valid_3,
    adc_valid_4,
    adc_valid_5,
    adc_valid_6,
    adc_valid_7,
    
    adc_enable_0,
    adc_enable_1,
    adc_enable_2,
    adc_enable_3,
    adc_enable_4,
    adc_enable_5,
    adc_enable_6,
    adc_enable_7,
    
    bridge_out_0,
    bridge_out_1,
    bridge_out_2,
    bridge_out_3,
    bridge_out_4,
    bridge_out_5,
    bridge_out_6,
    bridge_out_7,
    bridge_out_valid,
    bridge_out_enable,
    
    bridge_in_0,
    bridge_in_1,
    bridge_in_2,
    bridge_in_3,
    bridge_in_4,
    bridge_in_5,
    bridge_in_6,
    bridge_in_7,
    
    dmac_out
    ); 
    
    parameter DATA_WIDTH = 16;
    parameter NUM_CHAN = 4;
    
    input [(DATA_WIDTH-1):0]         adc_data_0;
    input [(DATA_WIDTH-1):0]         adc_data_1;
    input [(DATA_WIDTH-1):0]         adc_data_2;
    input [(DATA_WIDTH-1):0]         adc_data_3;
    input [(DATA_WIDTH-1):0]         adc_data_4;
    input [(DATA_WIDTH-1):0]         adc_data_5;
    input [(DATA_WIDTH-1):0]         adc_data_6;
    input [(DATA_WIDTH-1):0]         adc_data_7;
    
    input                            adc_valid_0;
    input                            adc_valid_1;
    input                            adc_valid_2;
    input                            adc_valid_3;
    input                            adc_valid_4;
    input                            adc_valid_5;
    input                            adc_valid_6;
    input                            adc_valid_7;
    
    input                            adc_enable_0;
    input                            adc_enable_1;
    input                            adc_enable_2;
    input                            adc_enable_3;
    input                            adc_enable_4;
    input                            adc_enable_5;
    input                            adc_enable_6;
    input                            adc_enable_7;
   
    output wire [(DATA_WIDTH*NUM_CHAN-1):0]     dmac_out;
    
    output wire [(DATA_WIDTH-1):0] bridge_out_0;
    output wire [(DATA_WIDTH-1):0] bridge_out_1;
    output wire [(DATA_WIDTH-1):0] bridge_out_2;
    output wire [(DATA_WIDTH-1):0] bridge_out_3;
    output wire [(DATA_WIDTH-1):0] bridge_out_4;
    output wire [(DATA_WIDTH-1):0] bridge_out_5;
    output wire [(DATA_WIDTH-1):0] bridge_out_6;
    output wire [(DATA_WIDTH-1):0] bridge_out_7;
    
    output wire                 bridge_out_valid;
    output wire                 bridge_out_enable;
    
    input [(DATA_WIDTH-1):0] bridge_in_0;
    input [(DATA_WIDTH-1):0] bridge_in_1;
    input [(DATA_WIDTH-1):0] bridge_in_2;
    input [(DATA_WIDTH-1):0] bridge_in_3;
    input [(DATA_WIDTH-1):0] bridge_in_4;
    input [(DATA_WIDTH-1):0] bridge_in_5;
    input [(DATA_WIDTH-1):0] bridge_in_6;
    input [(DATA_WIDTH-1):0] bridge_in_7;
    
    
    wire [(DATA_WIDTH-1):0] bridge_in_tmp[0:7];

    // Static assignment
    assign bridge_out_0 = adc_data_0;
    assign bridge_out_1 = adc_data_1;
    assign bridge_out_2 = adc_data_2;
    assign bridge_out_3 = adc_data_3;
    assign bridge_out_4 = adc_data_4;
    assign bridge_out_5 = adc_data_5;
    assign bridge_out_6 = adc_data_6;
    assign bridge_out_7 = adc_data_7;
    
    assign bridge_in_tmp[0] = bridge_in_0;
    assign bridge_in_tmp[1] = bridge_in_1;
    assign bridge_in_tmp[2] = bridge_in_2;
    assign bridge_in_tmp[3] = bridge_in_3;
    assign bridge_in_tmp[4] = bridge_in_4;
    assign bridge_in_tmp[5] = bridge_in_5;
    assign bridge_in_tmp[6] = bridge_in_6;
    assign bridge_in_tmp[7] = bridge_in_7;
    
    genvar n;
    // Concatenate / slice the data in use
    generate
        for (n = 0; n < NUM_CHAN; n = n + 1) begin: in_loop
            assign dmac_out[((n+1)*DATA_WIDTH-1):(n*DATA_WIDTH)] = bridge_in_tmp[n];
        end
    endgenerate         
    
    assign bridge_out_enable = adc_enable_0 | adc_enable_1 | adc_enable_2 | 
        adc_enable_3 | adc_enable_4 | adc_enable_5 | adc_enable_6 | adc_enable_7;

    assign bridge_out_valid = adc_valid_0 | adc_valid_1 | adc_valid_2 | 
        adc_valid_3 | adc_valid_4 | adc_valid_5 | adc_valid_6 | adc_valid_7;
        
endmodule
  