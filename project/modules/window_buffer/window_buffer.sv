module window_buffer
	#(
		parameter COLOR_CHANNEL = 8,
		parameter KERNEL = 3,

		parameter WIDTH_IMAGE  = 6,
		parameter HEIGHT_IMAGE
	)

	(
		input  logic 							  				  		i_clk,
		input  logic 							  				  		i_reset_n,
		input  logic [2 : 0][COLOR_CHANNEL - 1 : 0] 				 	i_pixel_data,
		input  logic 											  		i_pixel_ready,
		output logic [KERNEL - 1 : 0][2 : 0][COLOR_CHANNEL - 1 : 0] 	o_pixel_area_data [KERNEL - 1 : 0],
		output logic 											  		o_pixel_data_valid


	);

	localparam BUFFER_SIZE  	= WIDTH_IMAGE * 2 + 3;
	localparam NUMBER_OF_RAM 	= KERNEL - 1;
	localparam INIT_FILL_NUMBER = KERNEL + (KERNEL / 2) * WIDTH_IMAGE - KERNEL / 2;
	localparam NUM_PIXELS		= WIDTH_IMAGE * HEIGHT_IMAGE;

	logic  [NUMBER_OF_RAM : 0] 			w_shift_fifo_enable_rx;
	logic  [KERNEL - 1 : 0]  			w_shift_reg_enable_rx;

	logic  [2 : 0][COLOR_CHANNEL - 1 : 0] wi_data_shift_reg  		[KERNEL - 1 : 0];
	logic  [2 : 0][COLOR_CHANNEL - 1 : 0] wo_data_shift_reg  		[KERNEL - 1 : 0];

	logic  [2 : 0][COLOR_CHANNEL - 1 : 0] wi_data_shift_fifo 		[NUMBER_OF_RAM - 1 : 0];
	logic  [2 : 0][COLOR_CHANNEL - 1 : 0] wo_data_shift_fifo 		[NUMBER_OF_RAM - 1 : 0];


	logic  [$clog2(NUM_PIXELS) - 1 : 0] 	r_counter_pixel;
	logic 								  	s_data_valid;
	logic 									r_flag_vsync;

	genvar i;
	generate
		for (i = 0; i < NUMBER_OF_RAM; i++)
			begin : generation_ram_buffers

				shift_fifo #(.SHIFT_FIFO_DEPTH(WIDTH_IMAGE - KERNEL)) shift_fifo_inst
				(
					.i_clk			(i_clk),
					.i_reset_n		(i_reset_n),
					.i_enable_rx	(w_shift_fifo_enable_rx[i] &  i_pixel_ready),
					.i_data			(wi_data_shift_fifo[i]),
					.o_enable_tx	(w_shift_reg_enable_rx[i + 1]),
					.o_data			(wo_data_shift_fifo[i])
				);

				assign wi_data_shift_fifo[i]    = wo_data_shift_reg[i];
				assign wi_data_shift_reg[i + 1] = wo_data_shift_fifo[i];

			end
			
		for (i = 0; i < KERNEL; i++)
			begin : generation_shift_register
			
				shift_register shift_register_inst
			    (
					.i_clk				(i_clk),
					.i_reset_n			(i_reset_n),
					.i_enable_rx		(w_shift_reg_enable_rx[i] &  i_pixel_ready),
					.i_data				(wi_data_shift_reg[i]),
					.o_data				(wo_data_shift_reg[i]),
					.o_whole_data_reg	(o_pixel_area_data[i]),
					.o_enable_tx		(w_shift_fifo_enable_rx[i])
			    );
				
			end
	endgenerate

	assign w_shift_reg_enable_rx[0]     =  i_pixel_ready;
	assign wi_data_shift_reg[0]         =  i_pixel_data;
	assign o_pixel_data_valid 			=  s_data_valid;

	always_ff@(posedge i_clk, negedge i_reset_n)
		begin
			if (!i_reset_n)
				begin
					r_counter_pixel    		<=  0;
					s_data_valid			<=  0;
				end
			else
				begin
				
					if(i_pixel_ready)
						begin
							if (r_counter_pixel == INIT_FILL_NUMBER)
								begin
									s_data_valid	<= 1;
									r_counter_pixel <= r_counter_pixel;
								end
								
							else
								begin
									r_counter_pixel	<= r_counter_pixel + 1;
									s_data_valid	<= 0;
								end
						end
					else
						s_data_valid	<= 0;
				end
		end

endmodule : window_buffer
