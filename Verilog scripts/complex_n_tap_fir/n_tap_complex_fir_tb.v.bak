/*

 n_tap_complex_fir_tb.v
 --------------
 By: Augustas Jackevic
 Date: 11th Feb 2021

 Module Description:
 -------------------
 This module is a test bench for the module n_tap_complex_fir.v. The script
 sends the coefficients (coefficient_in_I and coefficient_in_Q) and the
 input data (sr_data_in_I and sr_data_in_Q) to the test script, the output
 data (data_out_I and data_out_Q) is then observed in ModelSim. The results
 are then confirmed through the convolution operation in MATLAB, with the same
 inputs.

*/

module n_tap_complex_fir_tb;

// Parameters for creating the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

reg clock;
reg load_coefficients_flag;
reg load_data_flag;
reg stop_data_load_flag;

reg signed [7:0] coefficient_in_I;
reg signed [7:0] coefficient_in_Q;
reg signed [7:0] sr_data_in_I;
reg signed [7:0] sr_data_in_Q;

// Note the range of reg signed [7:0] is [-128 to 127].

wire [20:0] data_out_I;
wire [20:0] data_out_Q;

// Connect the device under test
n_tap_complex_fir #(
	.length			(4)
	) dut(
	.clock					(clock),
	.load_coefficients_flag (load_coefficients_flag),
	.load_data_flag			(load_data_flag),
	.stop_data_load_flag	(stop_data_load_flag),
	.coefficient_in_I	  	(coefficient_in_I),
	.coefficient_in_Q	  	(coefficient_in_Q),
	.data_in_I				(sr_data_in_I),
	.data_in_Q				(sr_data_in_Q),
	.data_out_I				(data_out_I),
	.data_out_Q				(data_out_Q)
);


initial begin

	// Set the init values. Then send the coefficients and then the data in
	// a serial manner, one clock cycle at a time.
	coefficient_in_I = 0;
	coefficient_in_Q = 0;
	sr_data_in_I = 0;
	sr_data_in_Q = 0;

	load_coefficients_flag = 0;
	load_data_flag = 0;
	stop_data_load_flag = 0;
	repeat(RST_CYCLES) @ (posedge clock);

	// Set the coiefficient values. Make sure the number of coefficients is
	// equal to the set length of the n_tap_fir module. In this case there are
	// 4 set values,
	load_coefficients_flag = 1;
	repeat(1) @ (posedge clock);
	coefficient_in_I = 8'd3;
	coefficient_in_Q = 8'd7;
	repeat(1) @ (posedge clock);
	coefficient_in_I = 8'd2;
	coefficient_in_Q = 8'd0;
	repeat(1) @ (posedge clock);
	coefficient_in_I = 8'd17;
	coefficient_in_Q = 8'd5;
	repeat(1) @ (posedge clock);
	coefficient_in_I = 8'd0;
	coefficient_in_Q = -8'd3;
	repeat(20) @ (posedge clock);

	load_data_flag = 1;

	// Set the input data values, in this case there are 4 values.
	repeat(5) @ (posedge clock);
	sr_data_in_I = 8'd2;
	sr_data_in_Q = 8'd3;
	repeat(1) @ (posedge clock);
	sr_data_in_I = 8'd5;
	sr_data_in_Q = 8'd10;
	repeat(1) @ (posedge clock);
	sr_data_in_I = -8'd2;
	sr_data_in_Q = -8'd3;
	repeat(1) @ (posedge clock);
	sr_data_in_I = 8'd0;
	sr_data_in_Q = -8'd6;
	repeat(1) @ (posedge clock);

	// Need to add [length number entered to the n_tap_complex_fir module - 1], in thus case
	// that is 3 padded 0s. This is required by convolution opperation that the FIR
	// filters achives.
	sr_data_in_I = 8'd0;
	sr_data_in_Q = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in_I = 8'd0;
	sr_data_in_Q = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in_I = 8'd0;
	sr_data_in_Q = 8'd0;
	repeat(1) @ (posedge clock);

	stop_data_load_flag =1 ;
end

initial begin
	clock = 0;
end

real HALF_CLOCK_PERIOD = (1000000000.0/$itor(CLOCK_FREQ))/2.0;
integer half_cycles = 0;

always begin
	#(HALF_CLOCK_PERIOD);
	clock = ~clock;
	half_cycles = half_cycles + 1;

	if(half_cycles == (2*NUM_CYCLES)) begin
		$stop;
	end
end

endmodule
