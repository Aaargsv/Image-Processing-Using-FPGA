module top
(
		input  logic 			i_clk,
		input  logic 			i_reset_n,
		input  logic 			i_pclk,
		input  logic [7 : 0]	i_data,
		input  logic 			i_hsync,
		input  logic			i_vsync,
		input  logic 			i_red_screen,
		input  logic 			i_select_mode,
		input  logic [2 : 0]	i_kernel_address,

		output logic 			o_device_working,
		output logic 			o_xclk,
		output logic			o_siod,
		output logic			o_sioc,

		
		output logic 			o_dac_nblank,
		output logic  			o_dac_clk,
		output logic 			o_dac_nsync,
		output logic 			o_camera_reset,
		output logic			o_camera_pwdn

);
	image_proc_top_design image_proc_top_design_inst(.*);

endmodule
