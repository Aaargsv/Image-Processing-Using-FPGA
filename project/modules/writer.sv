module writer
    #(
        parameter MAX_ADDRESS,
        parameter COLOR_CHANNEL,
        parameter WIDTH_IMAGE  = 640,
        parameter HEIGHT_IMAGE = 480
    )
    (
        input   logic i_clk,
        input   logic i_data_ready,
        input   logic i_reset_n,

        input   logic [2 : 0][COLOR_CHANNEL - 1 : 0] i_data,

        output  logic                                o_wr_enable,
        output  logic [2 : 0][COLOR_CHANNEL - 1 : 0] o_data,
        output	logic  [18 : 0] 				     o_wr_address
    );


        localparam NUM_PIXELS = WIDTH_IMAGE * HEIGHT_IMAGE;

        logic [2 : 0][COLOR_CHANNEL - 1 : 0] r_data;
        logic                                s_wr_enable;
		  
		  assign o_data         = r_data;
		  assign o_wr_enable    = s_wr_enable & (o_wr_address <= MAX_ADDRESS);

        always_ff @(posedge i_clk, negedge i_reset_n)
            begin
                if (!i_reset_n)
                    begin
                        s_wr_enable  <=  0;
                        o_wr_address <= '1;
                    end
                else
                    begin
                        if (i_data_ready)
                            begin
                                s_wr_enable     <= 1;
                                r_data          <= i_data;
                                o_wr_address    <= (o_wr_address == NUM_PIXELS - 1) ? '0 : o_wr_address + 1;
                            end
                        else
                            begin
                                s_wr_enable     <= 0;
                                o_wr_address    <= o_wr_address;
                            end
                    end
            end
endmodule 