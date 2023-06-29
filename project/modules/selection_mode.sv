module selection_mode
    (
        input   logic     i_clk,
        input   logic     i_reset_n,
        input   logic     i_select_mode,
        input   logic     i_threshold,

        output  logic     o_select_mode,
        output  logic     o_threshold
    );

    logic r_select_mode;
    logic r_threshold;

    assign o_select_mode = r_select_mode;
    assign o_threshold   = r_threshold;

    always_ff @(posedge i_clk, negedge i_reset_n)
        if (!i_reset_n)
            begin
                r_select_mode <= 0;
                r_threshold   <= 0;
            end

        else
            begin
                if (i_select_mode)
                    r_select_mode <= ~r_select_mode;
                else
                    r_select_mode <= r_select_mode;

                if (i_threshold)
                    r_threshold <= ~r_threshold;
                else
                    r_threshold <= r_threshold;
            end

endmodule : selection_mode