module sqrt
    #(
        parameter DATA_SIZE      = 17,
        parameter COLOR_CHANNEL  = 8
    )
    (
        input   logic                         				i_clk,
        input   logic [DATA_SIZE : 0]        			 	i_data,
        input   logic                        			 	i_data_ready,
        input   logic                                       i_reset_n,

        output  logic [(DATA_SIZE + 1) / 2 - 1 : 0] 		o_data,
        output  logic                         				o_data_ready
    );


    logic [DATA_SIZE : 0]   w_data          [(DATA_SIZE + 1) / 2 + 2];
    logic                   w_root_ready    [(DATA_SIZE + 1) / 2 + 2];
	 
	 assign w_data[1] 	             = i_data;
	 assign w_root_ready[1]	         = i_data_ready;
	 assign o_data			         = gen_wire[(DATA_SIZE + 1) / 2 + 1].w_root[(DATA_SIZE + 1) / 2 - 1 : 0];
	 assign o_data_ready             = w_root_ready[(DATA_SIZE + 1) / 2 + 1];
	 assign gen_wire[1].w_root       = 0;
    assign gen_wire[1].w_remainder   = i_data[DATA_SIZE : DATA_SIZE - 1];


    genvar i;
    generate
        for (i = 1; i <= (DATA_SIZE + 1) / 2 + 1; i++)
            begin : gen_wire
                logic [i - 1 : 0]        w_root;
                logic [2 * i - 1 : 0]    w_remainder;
            end

        for (i = 1; i <= (DATA_SIZE + 1) / 2; i++)
            begin : gen_sqrt_stage
                sqrt_stage #(.N(i), .SIZE_DATA(DATA_SIZE)) sqrt_stage_inst
                (
                    .i_clk          (i_clk),
                    .i_reset_n      (i_reset_n),
                    .i_data         (w_data[i]),
                    .i_root         (gen_wire[i].w_root),
                    .i_root_ready   (w_root_ready[i]),
                    .i_remainder    (gen_wire[i].w_remainder),
                    .o_data         (w_data[i + 1]),
                    .o_root         (gen_wire[i + 1].w_root),
                    .o_root_ready   (w_root_ready[i + 1]),
                    .o_remainder    (gen_wire[i + 1].w_remainder)
                );
            end
    endgenerate
endmodule
