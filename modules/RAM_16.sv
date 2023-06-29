module RAM_16
#(
	parameter DEPTH
)
(
	input  logic 							  i_clk,
	input  logic 							  i_write_enable,

	input  logic [$clog2(DEPTH) - 1 : 0] 	  i_write_address,
	input  logic [$clog2(DEPTH) - 1 : 0] 	  i_read_address,
	
	input  logic [15 : 0]  i_write_value,
	output logic [15 : 0]  o_read_value
	
	
);

	logic [15 : 0]	ram [DEPTH - 1 : 0];

	always_ff @(posedge i_clk) begin
		if (i_write_enable)
			ram[i_write_address] <= i_write_value;
		o_read_value <= ram[i_read_address];
		end

endmodule : RAM_16