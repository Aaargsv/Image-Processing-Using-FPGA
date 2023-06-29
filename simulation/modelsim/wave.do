onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_filter_test/clk
add wave -noupdate /testbench_filter_test/pclk
add wave -noupdate /testbench_filter_test/reset
add wave -noupdate /testbench_filter_test/counter
add wave -noupdate /testbench_filter_test/w_config_done
add wave -noupdate /testbench_filter_test/w_hsync
add wave -noupdate /testbench_filter_test/w_vsync
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/i_clk
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/i_reset_n
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/i_pclk
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/i_data
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/i_hsync
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/i_vsync
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/i_red_screen
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/i_select_mode
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/i_kernel_address
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_device_working
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_xclk
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_siod
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_sioc
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_vga_hsync
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_vga_vsync
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_vga_r
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_vga_g
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_vga_b
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_dac_nblank
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_dac_clk
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_dac_nsync
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_camera_reset
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/o_camera_pwdn
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_kernel
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_kernel_from_mem
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_pixel_data_16
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/wr_address
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_clk_50mhz
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_clk_25mhz
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_config_done
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_config_start
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_device_work_start
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_pixel_ready
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_pixel_data_valid
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/wr_ram_data
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/rd_address_ram_to_vga
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_we_memory
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_sioc
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_siod
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/dac_nsync
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_data_from_wb
add wave -noupdate -expand /testbench_filter_test/image_proc_top_design_inst/w_pixel_area_data
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_pixel_data_valid_wb
add wave -noupdate -expand /testbench_filter_test/image_proc_top_design_inst/w_data_from_mux
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_data_ready_from_mux
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_data_to_ram
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_wr_enable
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_convolution_value
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_magnitude_value
add wave -noupdate /testbench_filter_test/image_proc_top_design_inst/w_magnitude_ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10462748 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 444
configure wave -valuecolwidth 354
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {9446940 ps} {10462748 ps}
