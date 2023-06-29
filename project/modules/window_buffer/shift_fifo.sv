module shift_fifo
#(
    parameter PXL_CHANNEL = 8,
    parameter SHIFT_FIFO_DEPTH
)

(
    input   logic                              i_clk,
    input   logic                              i_reset_n,
    input   logic                              i_enable_rx,
    input   logic [2 : 0][PXL_CHANNEL - 1 : 0] i_data,

    output  logic                              o_enable_tx,
    output  logic [2 : 0][PXL_CHANNEL - 1 : 0] o_data
);

    logic [$clog2(SHIFT_FIFO_DEPTH) - 1 : 0]   r_counter;
    logic                                      r_write;
    logic                                      r_read;

    assign r_read      = (r_counter == SHIFT_FIFO_DEPTH /*- 1*/) & i_enable_rx; //<fix> was without & i_enable_rx
    assign r_write     = i_enable_rx;
    assign o_enable_tx = r_read;

    fifo #(.FIFO_DEPTH(SHIFT_FIFO_DEPTH + 1 /* + 0*/))  fifo_inst
                                            (
                                                .i_clk        (i_clk),
                                                .i_reset_n    (i_reset_n),
                                                .i_read       (r_read),
                                                .i_write      (r_write),
                                                .i_write_value(i_data),
                                                .o_empty      (),
                                                .o_full       (),
                                                .o_read_value (o_data)
                                            );

    always_ff @(posedge i_clk, negedge i_reset_n)
        begin
            if (!i_reset_n)
                r_counter <= 0;
            else
                begin
                    if (r_write)
                        begin
                            if (r_counter < SHIFT_FIFO_DEPTH)  /*if (r_counter < SHIFT_FIFO_DEPTH - 1)*/
                                r_counter <= r_counter + 1;
                            else
                                r_counter <= r_counter;
                        end
                end
        end

endmodule : shift_fifo
