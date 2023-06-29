module main_control
	(
		input 	logic i_clk,
		input 	logic i_reset_n,
		input 	logic i_config_done,

		output	logic o_config_start,
		output  logic o_device_work_start
		
	);

	parameter FSM_CONFIG_CAM = 1'b 0;
	parameter FSM_WORK		 = 1'b 1;

	logic [2 : 0] r_state;

	always_ff @(posedge i_clk, negedge i_reset_n)
		begin
			if (!i_reset_n)
				begin
					o_config_start 		<= 0;
					o_device_work_start	<= 0;
					r_state				<= FSM_CONFIG_CAM;
				end
			else
				begin
					case (r_state)

						FSM_CONFIG_CAM :
							begin

								if (i_config_done)
									begin
										o_config_start <= 0;
										r_state		   <= FSM_WORK;
									end
								else
									begin
										o_config_start <= 1;
										r_state		   <= FSM_CONFIG_CAM;
									end
							end

						FSM_WORK :
							begin
								o_device_work_start	<= 1;
								r_state				<= FSM_WORK;
							end

						default :
							r_state	<=	FSM_CONFIG_CAM;

					endcase
				end
		end
	
endmodule : main_control
