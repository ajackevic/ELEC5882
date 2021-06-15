/*

 n_tap_fir_tb.v
 --------------
 By: Augustas Jackevic
 Date: 10th Feb 2021

 Module Description:
 -------------------
 This module is a test bench for the module n_tap_fir.v. The script
 sends the coefficients (sr_coeff_in) and the input data (sr_data_in)
 to the test script, the output data (dataOut) is then observed in
 ModelSim. The results are then confirmed through the convolution
 operation in MATLAB, with the same inputs.

*/

module n_tap_fir_tb;

// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

reg clock;
reg load_data_flag;
reg stop_data_load_flag;
reg signed [7:0] sr_data_in;
wire [18:0] dataOut;
// Note the range of reg signed [7:0] is [-128 to 127].

// Connect the device under test.
n_tap_fir #(
	.LENGTH						(20),
	.DATA_WIDTH					(8)
	) dut(
	.clock						(clock),
	.loadDataFlag				(load_data_flag),
	.stopDataLoadFlag 		(stop_data_load_flag),
	.dataIn						(sr_data_in),
	.dataOut 					(dataOut)
);


initial begin

	// Set the init values. Then send the coefficients and then the data in
	// a serial manner, one clock cycle at a time.
	stop_data_load_flag = 0;
	sr_data_in = 0;
	load_data_flag = 0;
	repeat(RST_CYCLES) @ (posedge clock);

	repeat(13) @ (posedge clock);
	load_data_flag = 1;

	// Set the input data values, in this case there are 51 values.
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd10;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd20;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd30;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd40;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd50;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd60;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd70;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd80;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd90;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd100;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd110;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd120;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd126;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd116;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd106;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd96;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd86;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd76;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd66;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd56;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd116;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd106;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd96;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd116;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd120;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd60;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd111;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd114;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd13;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd93;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd111;
	repeat(1) @ (posedge clock);
	sr_data_in = -8'd87;

	// Need to add [length number entered to the n_tap_fir module - 1], in thus case
	// that is 19 padded 0s. This is required by convolution opperation that the FIR
	// filters achives.
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
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
