module convolution
	#(
		parameter KERNEL_NUM_ELEMENTS 	= 9,
		parameter COLOR_CHANNEL 		= 8,
		parameter DATA_KERNEL_WIDTH 	= 9,
		parameter ADDER_WIDTH 			= 2 * DATA_KERNEL_WIDTH + $clog2(KERNEL_NUM_ELEMENTS)

	)

	(
		input  logic signed   [DATA_KERNEL_WIDTH   - 1 : 0]   	i_kernel   	 [KERNEL_NUM_ELEMENTS - 1 : 0],
		input  logic unsigned [COLOR_CHANNEL - 1 : 0] 			i_pixel_area [KERNEL_NUM_ELEMENTS - 1 : 0],
		//output logic signed   [ADDER_WIDTH - 1: 0] 		   	    o_convolution_value
		output logic signed   [COLOR_CHANNEL - 1 : 0] 			o_convolution_value
	);


	localparam NUMBER_WIRES = 2 * (KERNEL_NUM_ELEMENTS - 1);
	localparam MAX_VALUE 	= 255;
	localparam MIN_VALUE 	= 0;
	
	logic signed [DATA_KERNEL_WIDTH - 1 : 0]     	w_signed_pixel_area 	[KERNEL_NUM_ELEMENTS - 1  : 0];
	logic signed [2 * DATA_KERNEL_WIDTH - 1 : 0] 	w_multiplication 	 	[KERNEL_NUM_ELEMENTS - 1  : 0];
	logic signed [ADDER_WIDTH - 1: 0] 				w_adder_connect 		[NUMBER_WIRES - 1 : 0];
	logic signed [ADDER_WIDTH - 1: 0] 				w_unnorm_conv;
	
	
	genvar i;
	generate
		for (i = 0; i < KERNEL_NUM_ELEMENTS; i++)
			begin : assignment_signed_pixel_area
				assign w_signed_pixel_area[i]   = i_pixel_area[i];
				assign w_multiplication [i]     = i_kernel[i] * w_signed_pixel_area[i];
				
			end

		for (i = 0; i < KERNEL_NUM_ELEMENTS - 1; i++)
			begin : multipliers_to_addres
				assign  w_adder_connect[i + KERNEL_NUM_ELEMENTS - 1] = w_multiplication [i];
			end

	
		logic [$clog2(KERNEL_NUM_ELEMENTS - 1) : 0] j;
		for (i = 1; i < KERNEL_NUM_ELEMENTS - 1; i++)
			begin : adders_generation
				assign w_adder_connect[i] = w_adder_connect[{i, 1'b0}] + w_adder_connect[{i, 1'b1}];
			end
	endgenerate
	
	assign w_unnorm_conv 		= w_adder_connect[1] + w_multiplication[KERNEL_NUM_ELEMENTS - 1];
	assign o_convolution_value 	= ( w_unnorm_conv  > MAX_VALUE ) ? MAX_VALUE :
									 ( ( w_unnorm_conv  < MIN_VALUE ) ? MIN_VALUE : w_unnorm_conv );
endmodule : convolution