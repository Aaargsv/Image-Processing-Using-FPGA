module range_control
    #(
        parameter COLOR_CHANNEL,
        parameter DATA_SIZE
    )
    (
        input   logic                                 i_clk,
        input   logic                                 i_reset_n,
        input   logic                                 i_data_ready,
        input   logic [(DATA_SIZE + 1) / 2 - 1 : 0]   i_data,

        output  logic                                 o_data_ready,
        output  logic [COLOR_CHANNEL - 1 : 0]         o_data
    );

    logic [(DATA_SIZE + 1) / 2 - 1 : 0]  r_data;

    assign o_data = (r_data > 255) ? 255 : r_data;

    always_ff @(posedge i_clk)
        begin
            if (!i_reset_n)
                begin
                    o_data_ready    <= 0;
                end
            else
                begin
                    if (i_data_ready)
                        begin
                            r_data          <= i_data;
                            o_data_ready    <= 1;
                        end
                    else
                        o_data_ready    <= 0;
                end

        end

endmodule : range_control
