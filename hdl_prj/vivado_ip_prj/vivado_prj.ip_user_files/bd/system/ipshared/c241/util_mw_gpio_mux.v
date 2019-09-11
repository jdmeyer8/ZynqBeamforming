/*
    Copright 2016-2017 MathWorks, Inc.
    
    Cascade of GPIO Muxes
    
    GPIO_IN --\___ /--------\____ ... /--------\____ GPIO_OUT
    port_0  --/    port_1 --/         port_7 --/
*/

module util_mw_gpio_mux (
        
    GPIO_IN_o,
    GPIO_IN_t,
    GPIO_IN_i,
    
    port_0_o,
    port_0_t,
    port_0_i,
    port_0_mux_sel,

    port_1_o,
    port_1_t,
    port_1_i,
    port_1_mux_sel,

    port_2_o,
    port_2_t,
    port_2_i,
    port_2_mux_sel,

    port_3_o,
    port_3_t,
    port_3_i,
    port_3_mux_sel,

    port_4_o,
    port_4_t,
    port_4_i,
    port_4_mux_sel,

    port_5_o,
    port_5_t,
    port_5_i,
    port_5_mux_sel,

    port_6_o,
    port_6_t,
    port_6_i,
    port_6_mux_sel,

    port_7_o,
    port_7_t,
    port_7_i,
    port_7_mux_sel,    
    
    GPIO_OUT_o,
    GPIO_OUT_t,
    GPIO_OUT_i
    ); 
    
    parameter GPIO_IO_WIDTH = 32;
    parameter NUM_PORTS = 8;
    
    parameter PORT_0_WIDTH = 32;
    parameter PORT_0_OFFSET = 0;
    parameter PORT_0_TYPE = 0;

    parameter PORT_1_WIDTH = 32;
    parameter PORT_1_OFFSET = 0;
    parameter PORT_1_TYPE = 0;
    
    parameter PORT_2_WIDTH = 32;
    parameter PORT_2_OFFSET = 0;
    parameter PORT_2_TYPE = 0;
    
    parameter PORT_3_WIDTH = 32;
    parameter PORT_3_OFFSET = 0;
    parameter PORT_3_TYPE = 0;
    
    parameter PORT_4_WIDTH = 32;
    parameter PORT_4_OFFSET = 0;
    parameter PORT_4_TYPE = 0;
    
    parameter PORT_5_WIDTH = 32;
    parameter PORT_5_OFFSET = 0;
    parameter PORT_5_TYPE = 0;
    
    parameter PORT_6_WIDTH = 32;
    parameter PORT_6_OFFSET = 0;
    parameter PORT_6_TYPE = 0;
    
    parameter PORT_7_WIDTH = 32;
    parameter PORT_7_OFFSET = 0;
    parameter PORT_7_TYPE = 0;
    
    input [(GPIO_IO_WIDTH-1):0]            GPIO_IN_o;
    input [(GPIO_IO_WIDTH-1):0]            GPIO_IN_t;
    output wire [(GPIO_IO_WIDTH-1):0]      GPIO_IN_i;
    
    input [(PORT_0_WIDTH-1):0]             port_0_o;
    input [(PORT_0_WIDTH-1):0]             port_0_t;
    output wire [(PORT_0_WIDTH-1):0]       port_0_i;
    input [(PORT_0_WIDTH-1):0]             port_0_mux_sel;
    
    input [(PORT_1_WIDTH-1):0]             port_1_o;
    input [(PORT_1_WIDTH-1):0]             port_1_t;
    output wire [(PORT_1_WIDTH-1):0]       port_1_i;
    input [(PORT_1_WIDTH-1):0]             port_1_mux_sel;
    
    input [(PORT_2_WIDTH-1):0]             port_2_o;
    input [(PORT_2_WIDTH-1):0]             port_2_t;
    output wire [(PORT_2_WIDTH-1):0]       port_2_i;
    input [(PORT_2_WIDTH-1):0]             port_2_mux_sel;
    
    input [(PORT_3_WIDTH-1):0]             port_3_o;
    input [(PORT_3_WIDTH-1):0]             port_3_t;
    output wire [(PORT_3_WIDTH-1):0]       port_3_i;
    input [(PORT_3_WIDTH-1):0]             port_3_mux_sel;
    
    input [(PORT_4_WIDTH-1):0]             port_4_o;
    input [(PORT_4_WIDTH-1):0]             port_4_t;
    output wire [(PORT_4_WIDTH-1):0]       port_4_i;
    input [(PORT_4_WIDTH-1):0]             port_4_mux_sel;
    
    input [(PORT_5_WIDTH-1):0]             port_5_o;
    input [(PORT_5_WIDTH-1):0]             port_5_t;
    output wire [(PORT_5_WIDTH-1):0]       port_5_i;
    input [(PORT_5_WIDTH-1):0]             port_5_mux_sel;
    
    input [(PORT_6_WIDTH-1):0]             port_6_o;
    input [(PORT_6_WIDTH-1):0]             port_6_t;
    output wire [(PORT_6_WIDTH-1):0]       port_6_i;
    input [(PORT_6_WIDTH-1):0]             port_6_mux_sel;

    input [(PORT_7_WIDTH-1):0]             port_7_o;
    input [(PORT_7_WIDTH-1):0]             port_7_t;
    output wire [(PORT_7_WIDTH-1):0]       port_7_i;
    input [(PORT_7_WIDTH-1):0]             port_7_mux_sel;
    
    output wire [(GPIO_IO_WIDTH-1):0]      GPIO_OUT_o;
    output wire [(GPIO_IO_WIDTH-1):0]      GPIO_OUT_t;
    input [(GPIO_IO_WIDTH-1):0]            GPIO_OUT_i;
    
    
    wire [(GPIO_IO_WIDTH-1):0]    GPIO_o[0:8];
    wire [(GPIO_IO_WIDTH-1):0]    GPIO_t[0:8];
    wire [(GPIO_IO_WIDTH-1):0]    GPIO_i[0:8];
        
    wire [(GPIO_IO_WIDTH-1):0]  port_o[0:7];
    wire [(GPIO_IO_WIDTH-1):0]  port_t[0:7];
    wire [(GPIO_IO_WIDTH-1):0]  port_i[0:7];
    
    wire [(GPIO_IO_WIDTH-1):0]  port_mux_sel_in[0:7];
    wire [(GPIO_IO_WIDTH-1):0]  port_mux_sel[0:7];
    wire [(GPIO_IO_WIDTH-1):0]  port_t_sel[0:7];

    localparam integer PORT_WIDTH [0:7] = { 
        PORT_0_WIDTH,
        PORT_1_WIDTH,
        PORT_2_WIDTH,
        PORT_3_WIDTH,
        PORT_4_WIDTH,
        PORT_5_WIDTH,
        PORT_6_WIDTH,
        PORT_7_WIDTH
    };
    localparam integer PORT_OFFSET [0:7] = { 
        PORT_0_OFFSET,
        PORT_1_OFFSET,
        PORT_2_OFFSET,
        PORT_3_OFFSET,
        PORT_4_OFFSET,
        PORT_5_OFFSET,
        PORT_6_OFFSET,
        PORT_7_OFFSET
    };
    localparam integer PORT_TYPE [0:7] = { 
        PORT_0_TYPE,
        PORT_1_TYPE,
        PORT_2_TYPE,
        PORT_3_TYPE,
        PORT_4_TYPE,
        PORT_5_TYPE,
        PORT_6_TYPE,
        PORT_7_TYPE
    };    

    /* Map the input/output to the array */
    assign GPIO_OUT_o = GPIO_o[NUM_PORTS];
    assign GPIO_OUT_t = GPIO_t[NUM_PORTS];
    assign GPIO_i[NUM_PORTS] = GPIO_OUT_i;
    
    assign GPIO_o[0] = GPIO_IN_o;
    assign GPIO_t[0] = GPIO_IN_t;
    assign GPIO_IN_i = GPIO_i[0];
    
    /* Map the ports to the array */
    
    assign port_o[0] = port_0_o;
    assign port_t[0] = port_0_t;
    assign port_0_i = port_i[0];
    assign port_mux_sel_in[0] = port_0_mux_sel;
    
    assign port_o[1] = port_1_o;
    assign port_t[1] = port_1_t;
    assign port_1_i = port_i[1];
    assign port_mux_sel_in[1] = port_1_mux_sel;
    
    assign port_o[2] = port_2_o;
    assign port_t[2] = port_2_t;
    assign port_2_i = port_i[2];
    assign port_mux_sel_in[2] = port_2_mux_sel;
    
    assign port_o[3] = port_3_o;
    assign port_t[3] = port_3_t;
    assign port_3_i = port_i[3];
    assign port_mux_sel_in[3] = port_3_mux_sel;
    
    assign port_o[4] = port_4_o;
    assign port_t[4] = port_4_t;
    assign port_4_i = port_i[4];
    assign port_mux_sel_in[4] = port_4_mux_sel;
    
    assign port_o[5] = port_5_o;
    assign port_t[5] = port_5_t;
    assign port_5_i = port_i[5];
    assign port_mux_sel_in[5] = port_5_mux_sel;
    
    assign port_o[6] = port_6_o;
    assign port_t[6] = port_6_t;
    assign port_6_i = port_i[6];
    assign port_mux_sel_in[6] = port_6_mux_sel;
    
    assign port_o[7] = port_7_o;
    assign port_t[7] = port_7_t;
    assign port_7_i = port_i[7];
    assign port_mux_sel_in[7] = port_7_mux_sel;
    
    genvar n;
    
    // Cascade of muxes
    generate
        for (n = 0; n < NUM_PORTS; n = n + 1) begin: module_loop
            
            /* PORT_TYPE:
               0 = Dynamic Mux
               1 = Static Output (always use port B in output mode)
               2 = Static Input (always use port B in input mode)
               3 = Static I/O (always use port B in I/O mode)
               4 = Bypass (always use port A)
           */
            assign port_mux_sel[n] = (PORT_TYPE[n] == 0) ? port_mux_sel_in[n] :
                (PORT_TYPE[n] == 4) ? {PORT_WIDTH[n]{1'b0}} :
                {PORT_WIDTH[n]{1'b1}};
            
            assign port_t_sel[n] = (PORT_TYPE[n] == 1) ? {PORT_WIDTH[n]{1'b0}} :
                (PORT_TYPE[n] == 2) ? {PORT_WIDTH[n]{1'b1}} : port_t[n] ;
            
            util_mw_gpio_mux_core #(
                .GPIO_A_WIDTH (GPIO_IO_WIDTH),
                .GPIO_B_WIDTH (PORT_WIDTH[n]),
                .GPIO_B_OFFSET (PORT_OFFSET[n])
            ) i_mux_core (
                .gpio_o_A(GPIO_o[n]),
                .gpio_i_A(GPIO_i[n]),
                .gpio_t_A(GPIO_t[n]),
                
                .gpio_o_B(port_o[n]),
                .gpio_i_B(port_i[n]),
                .gpio_t_B(port_t_sel[n]),
                
                .mux_sel(port_mux_sel[n]),
                
                .gpio_i(GPIO_i[n+1]),
                .gpio_o(GPIO_o[n+1]),
                .gpio_t(GPIO_t[n+1])
            );
        end
    endgenerate
endmodule
  