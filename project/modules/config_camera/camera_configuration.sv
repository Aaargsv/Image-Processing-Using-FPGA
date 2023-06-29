module camera_configuration
	#(
		parameter CLK_FREQUENCY  = 25000000,
		parameter SCCB_FREQUENCY = 100000
	)
	(
		input 	logic i_clk,
		input 	logic i_reset_n,
		input 	logic i_config_start,

		output 	logic o_config_done,
		output  logic o_sioc,
		output	logic o_siod
	);


	logic [7:0]     i_address;
	logic [15:0]    o_data;
	logic		    i_SCCB_ready;
	logic [15 : 0]  i_rom_data;
	logic [7:0]    	o_SCCB_address;
	logic [7:0]    	o_SCCB_data;
	logic	    	o_SCCB_start;



	configuration_rom configuration_rom_inst
					  (
						  .i_clk    	(i_clk),
						  .i_address	(i_address),
						  .o_data 		(o_data)
					  );

	cam_config_controller
							#(.CLK_FREQUENCY(CLK_FREQUENCY))
	cam_config_controller_inst
						  (
							  .i_clk			(i_clk),
							  .i_reset_n		(i_reset_n),
							  .i_SCCB_ready		(i_SCCB_ready),
							  .i_rom_data		(o_data),
							  .i_config_start	(i_config_start),
							  .o_SCCB_address	(o_SCCB_address),
							  .o_SCCB_data		(o_SCCB_data),
							  .o_SCCB_start		(o_SCCB_start),
							  .o_config_done	(o_config_done),
							  .o_rom_address	(i_address)
						  );

	sccb_transmitter
					#(
					.SCCB_FREQUENCY(SCCB_FREQUENCY),
					.CLK_FREQUENCY (CLK_FREQUENCY)
					)
	sccb_transmitter_inst
					 (
						 .i_clk			(i_clk),
						 .i_reset_n		(i_reset_n),
						 .i_start		(o_SCCB_start),
						 .i_address		(o_SCCB_address),
						 .i_data		(o_SCCB_data),
						 .o_sioc		(o_sioc),
						 .o_siod		(o_siod),
						 .o_ready		(i_SCCB_ready)

					 );

	endmodule : camera_configuration
