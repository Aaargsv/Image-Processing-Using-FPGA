module address_kernel_counter
    (
        input   logic           i_clk,
        input   logic           i_reset_n,
        input   logic           i_button,

        output  logic [2 : 0]   o_address

    );

    logic [2 : 0] r_address;
    logic         r_latch_button;

    always_ff @(posedge i_clk, negedge i_reset_n)
        begin
            if (!i_reset_n)
                begin
                    o_address       <= 0;
                    r_latch_button  <= 0;
                end

            else
                begin
                    if (i_button)
                        r_latch_button  <= 1;
                    else
                        begin
                            r_latch_button  <= 0;
                            if (r_latch_button == 1)
                                o_address <= o_address + 1;
                        end
                end
        end
endmodule : address_kernel_counter

