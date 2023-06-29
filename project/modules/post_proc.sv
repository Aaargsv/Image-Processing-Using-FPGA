module post_proc
    #(
        parameter COLOR_CHANNEL
    )
    (
        input   logic                                   i_clk,
        input   logic                                   i_reset_n,

        input   logic                                   i_data_ready,
        input   logic [2 : 0][COLOR_CHANNEL - 1 : 0]    i_data,
        input   logic [2 : 0]                           i_kernel_address,
        input   logic                                   i_select_mode,
        input   logic                                   i_threshold,

        output  logic                                   o_data_ready,
        output  logic [2 : 0][COLOR_CHANNEL - 1 : 0]    o_data

    );

    logic [2 : 0][COLOR_CHANNEL - 1 : 0]    r_data;
    logic                                   r_data_ready;

    assign o_data       = r_data;
    assign o_data_ready = r_data_ready;

    always_ff @(posedge i_clk, negedge i_reset_n)
        if (!i_reset_n)
            begin
                r_data_ready <= 0;
                r_data       <= 0;
            end
        else
            begin
                if (i_data_ready)
                    begin
                        r_data_ready <= 1;

                        if ((i_select_mode || i_kernel_address == 3'b001) && i_threshold)
                            begin
                                r_data[2] <= (i_data[2] < 64) ? 0 : 8'h FF;
                                r_data[1] <= (i_data[1] < 64) ? 0 : 8'h FF;
                                r_data[0] <= (i_data[0] < 64) ? 0 : 8'h FF;
                            end
                        else if (i_kernel_address == 3'b101)
                            begin
                                r_data[2] <= i_data[2] >> 4;
                                r_data[1] <= i_data[1] >> 4;
                                r_data[0] <= i_data[0] >> 4;
                            end
                        else if (i_kernel_address == 3'b110)
                            begin
                                r_data[2] <= i_data[2] + 128;
                                r_data[1] <= i_data[1] + 128;
                                r_data[0] <= i_data[0] + 128;
                            end
                        else
                            r_data <= i_data;
                    end
                else
                    r_data_ready <= 0;
            end

endmodule : post_proc