module convolution_set
    #(
        parameter KERNEL,
        parameter KERNEL_NUM_ELEMENTS,
        parameter COLOR_CHANNEL,
        parameter DATA_KERNEL_WIDTH
    )

    (
        input  logic signed     [DATA_KERNEL_WIDTH   - 1 : 0]   								i_kernel   		  		   [KERNEL_NUM_ELEMENTS  - 1 : 0],
        input  logic 		    [KERNEL - 1 : 0][2 : 0][COLOR_CHANNEL - 1 : 0] 				    i_pixel_area_data 		   [KERNEL - 1 : 0],

        output logic 		    [COLOR_CHANNEL - 1 : 0]		   								    o_convolution_value		   [2 : 0]

    );

    logic 		   [COLOR_CHANNEL - 1 : 0]                          w_pixel_area_color_channel [2 : 0][KERNEL_NUM_ELEMENTS - 1 : 0];
    logic 		   [KERNEL - 1 : 0][2 : 0][COLOR_CHANNEL - 1 : 0] 	w_pixel_area_data 		   [KERNEL - 1 : 0];

    assign w_pixel_area_data = i_pixel_area_data;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1)
            begin : pixel_area_color_channel_distribution
                genvar j, k;

                for (j = 0; j < KERNEL; j = j + 1)
                    begin : gen_1
                        for (k = 0; k < KERNEL; k = k + 1)
                            begin : gen_2
                                assign w_pixel_area_color_channel[i][KERNEL * j + k] = w_pixel_area_data[j][k][i];
                            end
                    end
            end

        for (i = 0; i < 3; i = i + 1)
            begin : generation_convolution

                convolution
                #(
                    .KERNEL_NUM_ELEMENTS	(KERNEL_NUM_ELEMENTS),
                    .COLOR_CHANNEL			(COLOR_CHANNEL),
                    .DATA_KERNEL_WIDTH 	    (DATA_KERNEL_WIDTH),
                    .ADDER_WIDTH 			()
                )

                    convolution_inst
                    (
                        .i_kernel 				(i_kernel),
                        .i_pixel_area			(w_pixel_area_color_channel[i]),
                        .o_convolution_value	(o_convolution_value[i])
                    );
            end
    endgenerate

endmodule : convolution_set