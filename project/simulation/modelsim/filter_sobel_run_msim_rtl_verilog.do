transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/post_proc.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/address_kernel_counter.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/config_camera {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/config_camera/sccb_transmitter.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/config_camera {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/config_camera/configuration_rom.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/config_camera {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/config_camera/camera_configuration.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/config_camera {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/config_camera/cam_config_controller.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/convolution {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/convolution/convolution_set.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/convolution {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/convolution/convolution.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/magnitude/sqrt {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/magnitude/sqrt/sqrt_stage.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/magnitude/sqrt {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/magnitude/sqrt/sqrt.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/magnitude/sqrt {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/magnitude/sqrt/range_control.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/magnitude {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/magnitude/magnitude.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer/window_buffer.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer/shift_register.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer/shift_fifo.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer/RAM.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/window_buffer/fifo.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/pixel_capture.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/mux.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/main_control.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/kernel_mem.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/image_proc_top_design.sv}
vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/modules/clock_divider.sv}

vlog -sv -work work +incdir+D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/testbench {D:/Files/Projects/LearnProjects/Dev/Diploma/filter_sobel/testbench/testbench_filter_test.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench_filter_test

add wave *
view structure
view signals
run -all
