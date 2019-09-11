/*
    Copright 2016-2017 MathWorks, Inc.
    
    GPIO Mux Core Module
    
    gpio_o_A --\___ gpio_o
    gpio_o_B --/

    gpio_t_A --\___ gpio_t
    gpio_t_B --/
    
    gpio_i __/--gpio_i_A
             \--gpio_i_B
*/

module util_mw_gpio_mux_core (
        
    gpio_o_A,
    gpio_i_A,
    gpio_t_A,
    
    gpio_o_B,
    gpio_i_B,
    gpio_t_B,
    
    mux_sel,
    
    gpio_i,
    gpio_o,
    gpio_t
    ); 
    
    parameter GPIO_A_WIDTH = 32;
    parameter GPIO_B_WIDTH = 32;
    parameter GPIO_B_OFFSET = 0;
    
    input [(GPIO_A_WIDTH-1):0]             gpio_o_A;
    input [(GPIO_A_WIDTH-1):0]             gpio_t_A;
    output wire [(GPIO_A_WIDTH-1):0]       gpio_i_A;
    
    input [(GPIO_B_WIDTH-1):0]             gpio_o_B;
    input [(GPIO_B_WIDTH-1):0]             gpio_t_B;
    output wire [(GPIO_B_WIDTH-1):0]       gpio_i_B;
    
   
    input [(GPIO_B_WIDTH-1):0]             mux_sel;
    
    output wire [(GPIO_A_WIDTH-1):0]       gpio_o;
    output wire [(GPIO_A_WIDTH-1):0]       gpio_t;
    input [(GPIO_A_WIDTH-1):0]             gpio_i;
    
    
    genvar n;
    
    // Concatenate / slice the data in use
    generate
        for (n = 0; n < GPIO_B_OFFSET; n = n + 1) begin: bypass_loop_low
            assign gpio_o[n] = gpio_o_A[n];
            assign gpio_t[n] = gpio_t_A[n];
        end
        for (n = GPIO_B_OFFSET; n < GPIO_B_OFFSET+GPIO_B_WIDTH; n = n + 1) begin: mux_loop
            assign gpio_o[n] = mux_sel[n-GPIO_B_OFFSET] ? gpio_o_B[n-GPIO_B_OFFSET] : gpio_o_A[n];
            assign gpio_t[n] = mux_sel[n-GPIO_B_OFFSET] ? gpio_t_B[n-GPIO_B_OFFSET] : gpio_t_A[n];
            assign gpio_i_B[n-GPIO_B_OFFSET] = gpio_i[n];
        end
        for (n = GPIO_B_OFFSET+GPIO_B_WIDTH; n < GPIO_A_WIDTH; n = n + 1) begin: bypass_loop_high
            assign gpio_o[n] = gpio_o_A[n];
            assign gpio_t[n] = gpio_t_A[n];
        end
    endgenerate
    
    assign gpio_i_A = gpio_i;
 
endmodule
  