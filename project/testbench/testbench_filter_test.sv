`timescale 1ns/1ns
module testbench_filter_test;


    logic clk;
	logic pclk;
    logic reset;

    logic [7 : 0]            counter;
    logic                    w_config_done;
    logic                    w_hsync;
    logic                    w_vsync;
    logic [2 : 0][7 : 0]	 w_data;
	
	
	
	logic 			i_red_screen;

    logic 			o_device_working;
    logic 			o_xclk;
    logic			o_siod;
    logic			o_sioc;
    logic 		 	vga_hsync;
    logic 		 	vga_vsync;
    logic [7 : 0]	vga_r;
    logic [7 : 0]	vga_g;
    logic [7 : 0]	vga_b;
    logic 			dac_nblank;
    logic  			dac_clk;
    logic 			dac_nsync;
    logic [9 : 0]	o_hsync_counter;
    logic 			o_camera_reset;
    logic			o_camera_pwdn;

    localparam FSM_CONFIG        = 0;
    localparam FSM_VSYNC_DELAY   = 1;
    localparam FSM_HSYNC_DELAY   = 2;
    localparam FSM_TRANS         = 3;
    localparam FSM_DELAY         = 4;

    logic [7 : 0]            r_delay_counter;
    logic [7 : 0]            r_state;



    image_proc_top_design image_proc_top_design_inst
        (
            .i_clk              (clk),
            .i_reset_n          (reset),
            .i_pclk             (pclk),
            .i_data             (counter),
            .i_hsync            (w_hsync),
            .i_vsync            (w_vsync),
            .i_red_screen       (1),
            .i_select_mode      (1),
            .i_kernel_address   (3'b 000),

            .o_device_working   (o_device_working),
            .o_xclk             (),
            .o_siod             (),
            .o_sioc             (),

            .o_vga_hsync        (),
            .o_vga_vsync        (),
            .o_vga_r            (),
            .o_vga_g            (),
            .o_vga_b            (),
            .o_dac_nblank       (),
            .o_dac_clk          (),
            .o_dac_nsync        (),
            .o_camera_reset     (),
            .o_camera_pwdn      ()

        );
	

    initial
        begin

            clk                 = 0;
			pclk				= 0;
            w_config_done       = 0;
            w_vsync             = 0;
            w_hsync             = 0;
            counter             = 8'b 1010_1010;
            r_delay_counter     = 0;
            reset               = 1;
            r_state             = FSM_CONFIG;

            fork

                forever #5  clk  = ~clk;
				forever #20 pclk = ~pclk;

                #60     reset         = 0;
                #90     reset         = 1;
			
                forever
                    begin
                        @(posedge pclk)
                            begin
                                case (r_state)

                                    FSM_CONFIG :
                                        begin
                                            /*if (r_delay_counter < 8)
                                                begin
                                                    r_delay_counter <= r_delay_counter + 1;
                                                    r_state         <= FSM_CONFIG;
                                                end
                                            else
                                                begin
                                                    r_state         <= FSM_VSYNC_DELAY;
                                                    r_delay_counter <= 0;
                                                    w_config_done   <= 1;
                                                end*/
												
											if (o_device_working)
												begin
													r_state         <= FSM_VSYNC_DELAY;
												end
											else
												begin
													r_state         <= FSM_CONFIG;
												end
                                        end

                                    FSM_VSYNC_DELAY :
                                        begin
                                            if (r_delay_counter < 32)
                                                begin
													w_vsync 		<= 1;
                                                    r_delay_counter <= r_delay_counter + 1;
                                                    r_state         <= FSM_VSYNC_DELAY;
                                                end
                                            else
                                                begin
                                                    r_state         <= FSM_HSYNC_DELAY;
                                                    w_vsync         <= 0;
                                                    r_delay_counter <= 0;
                                                end
                                        end

                                    FSM_HSYNC_DELAY :
                                        begin
                                            if (r_delay_counter < 8)
                                                begin
                                                    r_delay_counter <= r_delay_counter + 1;
                                                    r_state         <= FSM_HSYNC_DELAY;
                                                end
                                            else
                                                begin
                                                    r_state         <= FSM_TRANS;
                                                    w_hsync         <= 1;
                                                    r_delay_counter <= 0;
                                                end
                                        end

                                    FSM_TRANS :
                                        begin
                                            if (w_hsync)
                                                begin
                                                    if (counter < 255)
                                                        begin
                                                            r_delay_counter <= 0;
                                                            r_state         <= FSM_TRANS;
                                                            counter         <= counter + 1;
                                                        end
                                                    else
                                                        begin
                                                            counter         <= 8'b 10101010;
                                                            r_state         <= FSM_DELAY;
                                                            w_hsync         <= 0;
                                                        end
                                                end
                                        end

                                    FSM_DELAY:
                                        begin
                                            if (r_delay_counter < 8)
                                                begin
                                                    r_delay_counter <= r_delay_counter + 1;
                                                    r_state         <= FSM_DELAY;
                                                end
                                            else
                                                begin
                                                    r_state         <= FSM_TRANS;
                                                    r_delay_counter <= 0;
                                                    w_hsync         <= 1;
                                                end
                                        end
                                endcase
                            end
                    end
            join
        end

endmodule : testbench_filter_test
