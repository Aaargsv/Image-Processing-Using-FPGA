module shift_register
#(
	parameter N = 3,
	parameter PXL_CHANNEL = 8
)
(
	input  logic 							  			 	i_clk,
	input  logic 							  			 	i_reset_n,
	input  logic 							  			 	i_enable_rx,
	input  logic [2 : 0][PXL_CHANNEL - 1 : 0] 			 	i_data,
	
	output logic [2 : 0][PXL_CHANNEL - 1 : 0] 			 	o_data,
	output logic [N - 1 : 0][2 : 0][PXL_CHANNEL - 1 : 0] 	o_whole_data_reg,
	output logic 											o_enable_tx
	
);

	logic [N - 1 : 0][2 : 0][PXL_CHANNEL - 1 : 0] r_shift_reg;
	logic [$clog2(N) - 1 : 0] 					  r_counter;
	
	always_ff @(posedge i_clk, negedge i_reset_n)
		begin
			if (!i_reset_n)
				begin
					r_counter   <= 0;
					r_shift_reg <= 0;
				end
			else if (i_enable_rx)
				begin
					if ( r_counter == N)
						r_counter <=  r_counter;
					else
						r_counter  <=  r_counter + 1;

					r_shift_reg <= {r_shift_reg [N - 2 : 0], i_data};

				end
			else
				r_shift_reg <= r_shift_reg;
		end

	assign o_enable_tx 			  = (r_counter == N) & i_enable_rx;
	assign o_whole_data_reg       = r_shift_reg;
	assign o_data      			  = r_shift_reg[N - 1];

endmodule
