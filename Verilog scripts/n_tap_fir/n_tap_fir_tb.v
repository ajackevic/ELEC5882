/*

 n_tap_fir_tb.v
 --------------
 By: Augustas Jackevic
 Date: 10th Feb 2021

 Module Description:
 -------------------
 This module is a test bench for the module n_tap_fir.v. The script
 sends the the input data (dataIn) to the test script, the output 
 data (dataOut) is then observed in ModelSim. The results are then
 confirmed through the convolution operation in MATLAB, with the same inputs.

*/

module n_tap_fir_tb;


// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

localparam LENGTH = 20;
localparam DATA_WIDTH = 8;


// Creating the lcoal parameters.
// Note the range of reg signed [N:0] is [-2^(N-1) to (2^(N-1))-1)].
reg clock;
reg loadDataFlag;
reg coeffSetFlag;
reg stopDataLoadFlag;
reg signed [7:0] dataIn;
reg signed [7:0] coeffIn;
wire [18:0] dataOut;


// Connect the device under test.
n_tap_fir #(
	.LENGTH					(LENGTH),
	.DATA_WIDTH				(DATA_WIDTH)
	)dut(
	
	.clock					(clock),
	.loadDataFlag			(loadDataFlag),
	.coeffSetFlag			(coeffSetFlag),
	.stopDataLoadFlag 	(stopDataLoadFlag),
	.coeffIn					(coeffIn),
	.dataIn					(dataIn),
	
	
	.dataOut 				(dataOut)
);




// Set the init values. Then send the data in a serial manner, one 
// clock cycle at a time.
initial begin

	stopDataLoadFlag = 0;
	coeffSetFlag = 0;
	coeffIn = 0;
	dataIn = 0;
	loadDataFlag = 0;
	repeat(RST_CYCLES) @ (posedge clock);

	repeat(13) @ (posedge clock);
	loadDataFlag = 1;

	// Set the input data values, in this case there are 51 values.
	repeat(1) @ (posedge clock);
	dataIn = 8'd10;
	repeat(1) @ (posedge clock);
	dataIn = 8'd20;
	repeat(1) @ (posedge clock);
	dataIn = 8'd30;
	repeat(1) @ (posedge clock);
	dataIn = 8'd40;
	repeat(1) @ (posedge clock);
	dataIn = 8'd50;
	repeat(1) @ (posedge clock);
	dataIn = 8'd60;
	repeat(1) @ (posedge clock);
	dataIn = 8'd70;
	repeat(1) @ (posedge clock);
	dataIn = 8'd80;
	repeat(1) @ (posedge clock);
	dataIn = 8'd90;
	repeat(1) @ (posedge clock);
	dataIn = 8'd100;
	repeat(1) @ (posedge clock);
	dataIn = 8'd110;
	repeat(1) @ (posedge clock);
	dataIn = 8'd120;
	repeat(1) @ (posedge clock);
	dataIn = -8'd126;
	repeat(1) @ (posedge clock);
	dataIn = -8'd116;
	repeat(1) @ (posedge clock);
	dataIn = -8'd106;
	repeat(1) @ (posedge clock);
	dataIn = -8'd96;
	repeat(1) @ (posedge clock);
	dataIn = -8'd86;
	repeat(1) @ (posedge clock);
	dataIn = -8'd76;
	repeat(1) @ (posedge clock);
	dataIn = -8'd66;
	repeat(1) @ (posedge clock);
	dataIn = -8'd56;
	repeat(1) @ (posedge clock);
	dataIn = -8'd116;
	repeat(1) @ (posedge clock);
	dataIn = -8'd106;
	repeat(1) @ (posedge clock);
	dataIn = -8'd96;
	repeat(1) @ (posedge clock);
	dataIn = -8'd116;
	repeat(1) @ (posedge clock);
	dataIn = 8'd120;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = -8'd60;
	repeat(1) @ (posedge clock);
	dataIn = -8'd111;
	repeat(1) @ (posedge clock);
	dataIn = -8'd114;
	repeat(1) @ (posedge clock);
	dataIn = 8'd13;
	repeat(1) @ (posedge clock);
	dataIn = -8'd93;
	repeat(1) @ (posedge clock);
	dataIn = 8'd111;
	repeat(1) @ (posedge clock);
	dataIn = -8'd87;

	// Need to add [length number entered to the n_tap_fir module - 1], in this case
	// that is 19 padded 0s. This is required by convolution opperation that the FIR
	// filters achives.
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	dataIn = 8'd0;
	repeat(1) @ (posedge clock);
	//stopDataLoadFlag = 1 ;
end


// Set the initial value of the clock.
initial begin
	clock = 0;
end


real HALF_CLOCK_PERIOD = (1000000000.0/$itor(CLOCK_FREQ))/2.0;
integer half_cycles = 0;

// Create the clock toggeling and stop it simulation when half_cycles == (2*NUM_CYCLES).
always begin
	#(HALF_CLOCK_PERIOD);
	clock = ~clock;
	half_cycles = half_cycles + 1;

	if(half_cycles == (2*NUM_CYCLES)) begin
		$stop;
	end
end

endmodule
