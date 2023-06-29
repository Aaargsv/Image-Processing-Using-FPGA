module pixel_capture
    #(
        parameter MAX_ADDRESS
    )
    (
        input 	logic 				i_clk,
        input 	logic 				i_pclk,
        input 	logic 				i_reset_n,
        input 	logic [7 : 0] 		i_data,
        input 	logic 				i_hsync,
        input  	logic				i_vsync,
        input   logic				i_device_work_start,

        output 	logic [15 : 0]  	o_pixel_data,
        output 	logic [15 : 0]  	o_fake_output,
        output  logic				o_pixel_ready,
        output  logic				o_we_memory,
        output  logic               o_vsync,

        output	logic [18 : 0] 		o_wr_address
    );

    localparam MAX_PIXEL = 307199;

    logic [15 : 0] 	r_data;
    logic			r_latch_vsync;
    logic [18 : 0]  r_pixel_counter;
    logic [9 : 0]   r_hor_counter;
    logic [9 : 0]   r_ver_counter;
    logic [15 : 0]  r_vsync;
    logic           r_latch_pclk;
    logic           r_second_byte;
    logic           r_flag_hsync;

    assign o_vsync      = &r_vsync;
    assign o_pixel_data = r_data;

    always_comb
        begin
    	if (r_hor_counter < 320)
            begin
                if (r_ver_counter < 160)
                    begin
                        o_fake_output = {5'hff, 6'h00, 5'hff};
                    end
                else if ( r_ver_counter < 320)
                    begin
                        o_fake_output = {5'hff, 6'h00, 5'h00};
                    end
                else
                    begin
                        o_fake_output = {5'h00, 6'hff, 5'hff};
                    end
    	    end
    	else
            begin
                if (r_ver_counter < 160)
                    begin
                        o_fake_output = {5'h00, 6'hff, 5'h00};
                    end
                else if ( r_ver_counter < 320)
                    begin
                        o_fake_output = {5'h00, 6'h00, 5'hff};
                    end
                else
                    begin
                        o_fake_output = {5'hff, 6'hff, 5'h00};
                    end
    	    end
    end

    /*always_comb begin
    	if (r_ver_counter < 50) begin
    		o_fake_output = {5'hff, 6'h00, 5'hff};
    	end
    	else if (r_ver_counter < 100) begin
    		o_fake_output = {5'hff, 6'h00, 5'h00};
    	end
    	else if (r_ver_counter < 150) begin
    		o_fake_output = {5'h00, 6'hff, 5'h00};
    	end
    	else if (r_ver_counter < 200) begin
    		o_fake_output = {5'h00, 6'h00, 5'hff};
    	end
    	else begin
    		o_fake_output = {5'hff, 6'hff, 5'h00};
    	end
    end*/


    assign o_wr_address = r_pixel_counter;
    assign o_we_memory = o_pixel_ready & (r_pixel_counter <= MAX_ADDRESS);

    always_ff @(posedge i_clk, negedge i_reset_n)
        begin
            if (~i_reset_n)
                begin
                    r_vsync         <= '1;
                    r_latch_pclk    <= '0;
                    r_second_byte   <= '0;
                    o_pixel_ready   <= '0;
                    r_data		    <= '0;
                    r_pixel_counter <= '0;
                    r_hor_counter   <= '0;
                    r_ver_counter   <= '0;
                    r_flag_hsync    <= '1;
                end
            else
                begin
                    if (i_device_work_start == 1)
                        begin
                            r_vsync <= {r_vsync[14 : 0], i_vsync};
                            if(&r_vsync)
                                begin
                                    o_pixel_ready   <= '0;
                                    r_pixel_counter <= '0;
                                    r_hor_counter   <= '0;
                                    r_ver_counter   <= '0;
                                end
                        else
                            begin
                                r_latch_pclk <= i_pclk;
                                if (i_hsync == 1)
                                    begin
                                        r_flag_hsync <= 1'b1;
                                        if (~r_latch_pclk & i_pclk)
                                            begin
                                                if (r_second_byte)
                                                    begin
                                                        r_data[7 : 0] <= i_data;
                                                        o_pixel_ready <= '1;
                                                        r_pixel_counter <= r_pixel_counter + 1'b1;
                                                        r_hor_counter <= r_hor_counter + 1'b1;
                                                    end
                                                else
                                                    begin
                                                        r_data[15 : 8] <= i_data;
                                                        o_pixel_ready <= '0;
                                                    end
                                                r_second_byte <= ~r_second_byte;
                                            end
                                        else
                                            begin
                                                o_pixel_ready <= '0;
                                            end
                                    end
                                else
                                    begin
                                        o_pixel_ready <= '0;
                                        r_flag_hsync <= 1'b0;
                                        if (r_flag_hsync)
                                            begin
                                                r_ver_counter <= r_ver_counter + 1'b1;
                                                r_hor_counter <= '0;
                                            end
                                        else
                                            begin
                                                r_ver_counter <= r_ver_counter;
                                            end
                                    end
                            end
                        end
                end
        end
endmodule : pixel_capture
