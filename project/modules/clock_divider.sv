
module clock_divider
	#(
	parameter FREQ_1 = 50_000_000,
	parameter FREQ_2 = 25_000_000
	)

	(
		input  logic i_clk,
		input  logic i_reset_n,

		output logic o_clk
	);

	always_ff @(posedge i_clk, negedge i_reset_n) begin
		if (~i_reset_n) begin
			o_clk <= '0;
		end
		else begin
			o_clk <= ~o_clk;
		end
	end

endmodule : clock_divider



