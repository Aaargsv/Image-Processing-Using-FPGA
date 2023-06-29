module fifo
    #(
        parameter COLOR_CHANNEL = 8,
        parameter FIFO_DEPTH
    )
    (
        input  logic                                i_clk,
        input  logic                                i_reset_n,
        input  logic                                i_read,
        input  logic                                i_write,
        input  logic [2 : 0][COLOR_CHANNEL - 1 : 0] i_write_value,

        output logic                                o_empty,
        output logic                                o_full,
        output logic [2 : 0][COLOR_CHANNEL - 1 : 0] o_read_value

    );

        logic [$clog2(FIFO_DEPTH + 1) - 1 : 0] r_write_address;
        logic [$clog2(FIFO_DEPTH + 1) - 1 : 0] r_read_address;

        logic [$clog2(FIFO_DEPTH + 1) - 1 : 0] r_next_write_address;
        logic                                  r_write_enable;

        RAM #(.DEPTH(FIFO_DEPTH + 1)) ram
                                      (
                                        .i_clk          (i_clk),
                                        .i_write_enable (r_write_enable),
                                        .i_write_address(r_write_address),
                                        .i_read_address (r_read_address),
                                        .i_write_value  (i_write_value),
                                        .o_read_value   (o_read_value)
                                      );


        assign o_empty              = (r_write_address      == r_read_address);
        assign o_full               = (r_next_write_address == r_read_address);
        assign r_write_enable       = i_write & (~o_full);
        assign r_next_write_address = ( r_write_address == FIFO_DEPTH) ? 0
                                        : r_write_address + 1;

        always_ff @(posedge i_clk, negedge i_reset_n)
        begin
            if (!i_reset_n)
                begin
                    r_write_address <= 0;
                    r_read_address  <= 0;
                end
            else
                begin
                    if (i_write && !o_full)
                        r_write_address <= (r_write_address == FIFO_DEPTH) ? 0 :
                                            r_write_address + 1;
                    else
                        r_write_address <=  r_write_address;

                    if (i_read && !o_empty)
                        r_read_address <= (r_read_address == FIFO_DEPTH ) ? 0 :
                            r_read_address + 1;
                    else
                        r_read_address <= r_read_address;
                end
        end
endmodule : fifo
