module kernel_mem
    #(
        parameter KERNEL_NUM_ELEMENTS,
        parameter DATA_KERNEL_WIDTH
    )
    (
        input  logic                                          i_clk,
        input  logic          [2 : 0]                         i_kernel_address,
        output logic signed   [DATA_KERNEL_WIDTH   - 1 : 0]   o_kernel          [KERNEL_NUM_ELEMENTS  - 1 : 0]
    );

    always_ff @(posedge i_clk)
        begin
            case(i_kernel_address)
                3'b000 : o_kernel <=
                    '{ 0,  0, 0,
                       0,  1, 0,
                       0,  0, 0  }; //identity


                3'b001 : o_kernel <=
                    '{  -1, -1, -1,
                        -1,  8, -1,
                        -1, -1, -1 }; //edge detector

                3'b010 : o_kernel <=
                    '{   0, -1,  0,
                        -1,  5, -1,
                         0, -1,  0 }; //sharpening


                3'b011 : o_kernel <=
                    '{  -1, -1, -1,
                        -1,  9, -1,
                        -1, -1, -1 }; //sharpening 2

                3'b100 : o_kernel <=
                    '{  1,  1,  1,
                        1, -7,  1,
                        1,  1,  1 }; //hard sharpening

                3'b101 : o_kernel <=
                    '{  1, 2, 1,
                        2, 4, 2,
                        1, 2, 1 }; //gaussian blur


                3'b110 : o_kernel <=
                    '{  -1,  -1,  0,
                        -1,   0,  1,
                         0,   1,  1 }; //emboss gray


                3'b111 : o_kernel <=
                    '{  -2,  -1,  0,
                        -1,   1,  1,
                         0,   1,  2 }; //emboss color


                default : o_kernel <=
                    '{ 0,  0, 0,
                       0,  1, 0,
                       0,  0, 0  }; //identity
				endcase
			end

endmodule : kernel_mem