module sccb_transmitter
#(
	parameter SCCB_FREQUENCY = 100000,
	parameter CLK_FREQUENCY = 25000000
)
(
	input logic 			i_clk,
	input logic 			i_reset_n,
	input logic 			i_start,

	input logic [7 : 0] 	i_address,
	input logic [7 : 0] 	i_data,

	output logic 			o_sioc,
	output logic 			o_siod,
	output logic 			o_ready

);

	localparam CLK_PER_BIT = CLK_FREQUENCY / SCCB_FREQUENCY;
	localparam CAMERA_ADDRESS = 8'h42;

	logic [$clog2(2 * CLK_PER_BIT) - 1 : 0] r_clk_counter;
	logic [2 : 0] r_byte_counter;
	logic [3 : 0] r_bit_counter;

	logic [7 : 0] r_address;
	logic [7 : 0] r_data;
	logic [7 : 0] r_tx_byte;
	logic [3 : 0] r_state;
	logic [3 : 0] r_return_state;

	enum {

		FSM_IDLE,			//0000
		FSM_START_SIGNAL,	//0001
		FSM_SELECT_BYTE,	//0010

		FSM_TX_BIT_1,		//0011
		FSM_TX_BIT_2,		//0100
		FSM_TX_BIT_3,		//0101
		FSM_TX_BIT_4,		//0110

		FSM_END_SIGNAL_1,	//0111
		FSM_END_SIGNAL_2,	//1000
		FSM_END_SIGNAL_3,	//1001
		FSM_END_SIGNAL_4,	//1010

		FSM_DONE,			//1011
		FSM_TIMER			//1100

	} FSM;

	always_ff @(posedge i_clk, negedge i_reset_n)
		begin
			if (!i_reset_n)
				begin
					r_clk_counter  	<= 0;
					r_byte_counter 	<= 0;
					r_bit_counter  	<= 0;
					r_tx_byte		<= 0;
					o_ready	 	 	<= 1;
					o_sioc 		 	<= 1;
					o_siod		 	<= 1;
					o_ready		 	<= 1;
					r_state		 	<= FSM_IDLE;
					r_return_state 	<= FSM_IDLE;
				end
			else
				begin
					case(r_state)
						FSM_IDLE :
							begin
								o_siod <= 1;
								o_sioc <= 1;

								if (i_start)
									begin
										r_state      <= FSM_START_SIGNAL;
										r_address    <= i_address;
										r_data       <= i_data;
										o_ready	     <= 0;
									end
								else
									begin
										r_state     <= FSM_IDLE;
										o_ready	  	<= 1;
									end

							end

						FSM_START_SIGNAL:
							begin
								o_siod 		 	<= 0;
								r_return_state 	<= FSM_SELECT_BYTE;
								r_clk_counter  	<= CLK_PER_BIT / 4;
								r_state  		<= FSM_TIMER;

							end

						FSM_SELECT_BYTE:
							begin
								if (r_byte_counter == 3)
									begin
										r_state <= FSM_END_SIGNAL_1;
									end
								else
									begin
										r_state 		 <= FSM_TX_BIT_1;
										r_byte_counter   <= r_byte_counter + 1;
										r_bit_counter    <= 0;

										case(r_byte_counter)
											0: r_tx_byte <= CAMERA_ADDRESS;
											1: r_tx_byte <= r_address;
											2: r_tx_byte <= r_data;

											default:
												r_tx_byte <= r_data;
										endcase
									end
							end

						FSM_TX_BIT_1:
							begin
								o_sioc         <= 0;
								r_return_state <= FSM_TX_BIT_2;
								r_clk_counter  <= CLK_PER_BIT / 4;
								r_state  	   <= FSM_TIMER;
							end

						FSM_TX_BIT_2:
							begin
								if (r_bit_counter == 8)
									o_siod <= 1;
								else
									o_siod <= r_tx_byte[7];

								r_return_state <= FSM_TX_BIT_3;
								r_clk_counter  <= CLK_PER_BIT / 4;
								r_state  	   <= FSM_TIMER;
							end

						FSM_TX_BIT_3:
							begin

								o_sioc         <= 1;
								r_return_state <= FSM_TX_BIT_4;
								r_clk_counter  <= CLK_PER_BIT / 2;
								r_state  	   <= FSM_TIMER;

							end

						FSM_TX_BIT_4:
							begin

								if (r_bit_counter == 8)
									r_state <= FSM_SELECT_BYTE;
								else
									r_state <= FSM_TX_BIT_1;

								r_tx_byte     <= r_tx_byte << 1;
								r_bit_counter <= r_bit_counter + 1;
							end

						FSM_END_SIGNAL_1:
							begin
								o_sioc         <= 0;
								r_return_state <= FSM_END_SIGNAL_2;
								r_clk_counter  <= CLK_PER_BIT / 4;
								r_state  	   <= FSM_TIMER;
							end

						FSM_END_SIGNAL_2:
							begin
								o_siod 	       <= 0;
								r_return_state <= FSM_END_SIGNAL_3;
								r_clk_counter  <= CLK_PER_BIT / 4;
								r_state  	   <= FSM_TIMER;
							end

						FSM_END_SIGNAL_3:
							begin
								o_sioc 	       <= 1;
								r_return_state <= FSM_END_SIGNAL_4;
								r_clk_counter  <= CLK_PER_BIT / 4;
								r_state  	   <= FSM_TIMER;
							end

						FSM_END_SIGNAL_4:
							begin
								o_siod         <= 1;
								r_return_state <= FSM_DONE;
								r_clk_counter  <= CLK_PER_BIT / 4;
								r_state  	   <= FSM_TIMER;
							end


						FSM_DONE:
							begin
								r_byte_counter <= 0;
								r_return_state <= FSM_IDLE;
								r_clk_counter  <= 2 * CLK_PER_BIT;
								r_state  	   <= FSM_TIMER;
							end

						FSM_TIMER:
							begin
								if (r_clk_counter > 0)
									begin
										r_clk_counter <=  r_clk_counter - 1;
										r_state       <= FSM_TIMER;
									end
								else
									r_state <= r_return_state;
							end

						default :
							r_state <= FSM_IDLE;
					endcase
				end
		end

endmodule : sccb_transmitter
