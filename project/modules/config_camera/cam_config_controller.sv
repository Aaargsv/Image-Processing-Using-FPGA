module cam_config_controller
	#(
		parameter CLK_FREQUENCY = 25000000
	)

	(
		input  logic		    i_clk,
		input  logic		    i_reset_n,
		input  logic		    i_SCCB_ready,
		input  logic [15 : 0]   i_rom_data,
		input  logic		    i_config_start,

		output logic [7:0]    	o_SCCB_address,
		output logic [7:0]    	o_SCCB_data,
		output logic	    	o_SCCB_start,
		output logic		    o_config_done,
		output logic [7:0]		o_rom_address

	);

	localparam FSM_IDLE 		    		= 3'b 000;
	localparam FSM_READ_FROM_ROM 		= 3'b 001;
	localparam FSM_SEND_TO_SCCB  		= 3'b 010;
	localparam FSM_RESET_START_SCCB 	= 3'b 011;
	localparam FSM_WAIT					= 3'b 100;
	localparam FSM_CONFIG_DONE   		= 3'b 101;
	localparam FSM_CLEANUP  			= 3'b 110;

	logic [15 : 0] 								r_rom_data;
	logic [$clog2(CLK_FREQUENCY / 100) - 1 : 0] r_clk_counter;
	logic [2 : 0] 								r_state;

	always_ff @(posedge i_clk, negedge i_reset_n)
		begin
			if (!i_reset_n)
				begin
					o_rom_address <= 0;
					r_state		  <= FSM_IDLE;
					r_clk_counter <= 0;
					r_rom_data	  <= 0;
					o_config_done <= 0;
					o_SCCB_start  <= 0;
				end
			else
				begin
					case (r_state)

						FSM_IDLE :
							begin

								o_rom_address <= 0;
								o_SCCB_start  <= 0;

								if (i_config_start)
									begin
										r_state	   	  <= FSM_READ_FROM_ROM;
										o_config_done <= 0;
									end

								else
									r_state	   <= FSM_IDLE;
							end


						FSM_READ_FROM_ROM :
							begin
								r_rom_data    <= i_rom_data;
								r_state	      <= FSM_SEND_TO_SCCB;
							end

						FSM_SEND_TO_SCCB :
							begin
								case (r_rom_data)
									16'h FF_FF :
										begin
											r_state	   <= FSM_CONFIG_DONE;
										end

									16'h FF_F0:
										begin
											if (r_clk_counter < CLK_FREQUENCY / 100 - 1)
												begin
													r_clk_counter <= r_clk_counter + 1'b1;
													r_state		  <= FSM_SEND_TO_SCCB;
												end
											else
												begin
													r_clk_counter <= 0;
													o_rom_address <= o_rom_address + 1'b1;
													r_state		  <= FSM_WAIT;
												end
										end


									default :
										begin
											if (i_SCCB_ready)
												begin
													o_SCCB_start   <= 1;
													o_SCCB_address <= r_rom_data[15 : 8];
													o_SCCB_data    <= r_rom_data[ 7 : 0];
													o_rom_address  <= o_rom_address + 1'b1;
													r_state		   <= FSM_RESET_START_SCCB ;
												end
											else
												r_state		<= FSM_SEND_TO_SCCB;

										end
								endcase
							end

						FSM_RESET_START_SCCB :
							begin
								o_SCCB_start  <= 0;
								r_state 	  <= FSM_WAIT;
							end

						FSM_WAIT :
							begin
								if (i_SCCB_ready)
									r_state <= FSM_READ_FROM_ROM;
								else
									r_state <= FSM_WAIT;
							end

						FSM_CONFIG_DONE :
							begin
								o_config_done <= 1;
								r_state		  <= FSM_CLEANUP;
							end

						FSM_CLEANUP :
							r_state		  <= FSM_IDLE;

					endcase
				end
		end

endmodule : cam_config_controller

