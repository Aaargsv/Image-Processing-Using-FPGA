module sqrt_stage
    #(
        parameter N,
        parameter SIZE_DATA,
        parameter SIZE_ROOT_IN   = N,
        parameter SIZE_ROOT_OUT  = N + 1,
        parameter SIZE_REM_IN    = 2 * N,
        parameter SIZE_REM_OUT   = 2 * (N + 1)

    )
    (
        input   logic                                           i_clk,
        input   logic                                           i_reset_n,
        input   logic               [SIZE_DATA      : 0]        i_data,
        input   logic               [SIZE_ROOT_IN - 1  : 0]     i_root,
        input   logic                                           i_root_ready,
        input   logic     signed    [SIZE_REM_IN - 1  : 0]      i_remainder,

        output  logic               [SIZE_DATA         : 0]     o_data,
        output  logic               [SIZE_ROOT_OUT - 1 : 0]     o_root,
        output  logic                                           o_root_ready,
        output  logic     signed    [SIZE_REM_OUT - 1  : 0]     o_remainder
    );


    logic           [SIZE_DATA        : 0] r_data;
    logic           [SIZE_ROOT_IN - 1 : 0] r_root;
    logic   signed  [SIZE_REM_IN  - 1 : 0] r_remainder;
    logic   signed  [SIZE_REM_IN  - 1 : 0] r_remainder_temp;

    assign r_remainder_temp = (r_remainder >= 0) ? r_remainder - {r_root, 2'b 01} :
                                                  r_remainder + {r_root, 2'b 11} ;

    assign o_root       = (r_remainder_temp >= 0) ? {r_root, 1'b1} : {r_root, 1'b0};
    assign o_remainder  = {r_remainder_temp, r_data[SIZE_DATA : SIZE_DATA - 1]};
    assign o_data       = r_data;

    always_ff @(posedge i_clk)
        begin
            if (!i_reset_n)
                begin
                    o_root_ready <= 0;
                end
            else
                begin
                    if (i_root_ready)
                        begin
                            o_root_ready <= 1;
                            r_data       <= {i_data[SIZE_DATA - 2 : 0], 2'b 00};
                            r_root       <= i_root;
                            r_remainder  <= i_remainder;
                        end
                    else
                        o_root_ready <= 0;
                end

        end
endmodule


