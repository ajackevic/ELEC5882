/*

 n_tap_complex_fir_tb.v
 --------------
 By: Augustas Jackevic
 Date: 11th Feb 2021

 Module Description:
 -------------------
 This module is a test bench for the module n_tap_complex_fir.v. The script
 sends the coefficients (coefficientInRe and coefficientInIm) and the
 input data (srDataInRe and srDataInIm) to the test script, the output
 data (dataOutRe and dataOutIm) is then observed in ModelSim. The results
 are then confirmed through the convolution operation in MATLAB, with the same
 inputs.

*/

module n_tap_complex_fir_tb;

// Parameters for creating the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

reg clock;
reg loadCoefficientsFlag;
reg loadDataFlag;
reg stopDataLoadFlag;

reg signed [7:0] coefficientInRe;
reg signed [7:0] coefficientInIm;
reg signed [7:0] srDataInRe;
reg signed [7:0] srDataInIm;

// Note the range of reg signed [7:0] is [-128 to 127].

wire [20:0] dataOutRe;
wire [20:0] dataOutIm;

// Connect the device under test
n_tap_complex_fir #(
	.LENGTH					(12),
	.DATA_WIDTH				(8)
	) dut(
	.clock					(clock),
	
	.loadDataFlag			(loadDataFlag),
	.stopDataLoadFlag		(stopDataLoadFlag),
	.dataInRe				(srDataInRe),
	.dataInIm				(srDataInIm),
	
	.dataOutRe				(dataOutRe),
	.dataOutIm				(dataOutIm)
);


initial begin

	// Set the init values. Then send the coefficients and then the data in
	// a serial manner, one clock cycle at a time.
	srDataInRe = 0;
	srDataInIm = 0;

	loadDataFlag = 0;
	stopDataLoadFlag = 0;
	repeat(RST_CYCLES) @ (posedge clock);
	repeat(20) @ (posedge clock);


	loadDataFlag = 1;

	// Set the input data values, in this case there are 4 values.
	repeat(5) @ (posedge clock);
	srDataInRe = 8'd2;
	srDataInIm = 8'd3;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd5;
	srDataInIm = 8'd10;
	repeat(1) @ (posedge clock);
	srDataInRe = -8'd2;
	srDataInIm = -8'd3;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = -8'd6;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd56;
	srDataInIm = -8'd39;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd55;
	srDataInIm = 8'd110;
	repeat(1) @ (posedge clock);
	srDataInRe = -8'd21;
	srDataInIm = -8'd93;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd46;
	srDataInIm = -8'd54;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd76;
	srDataInIm = 8'd8;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd5;
	srDataInIm = 8'd10;
	repeat(1) @ (posedge clock);
	srDataInRe = -8'd15;
	srDataInIm = -8'd96;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = -8'd75;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd12;
	srDataInIm = 8'd98;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd78;
	srDataInIm = 8'd100;
	repeat(1) @ (posedge clock);
	srDataInRe = -8'd20;
	srDataInIm = -8'd30;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd99;
	srDataInIm = -8'd69;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd21;
	srDataInIm = 8'd32;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd53;
	srDataInIm = 8'd107;
	repeat(1) @ (posedge clock);
	srDataInRe = -8'd28;
	srDataInIm = -8'd33;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = -8'd66;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd26;
	srDataInIm = 8'd38;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd57;
	srDataInIm = 8'd107;
	repeat(1) @ (posedge clock);
	srDataInRe = -8'd25;
	srDataInIm = -8'd35;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd80;
	srDataInIm = -8'd96;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd42;
	srDataInIm = 8'd3;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd1;
	srDataInIm = 8'd1;
	repeat(1) @ (posedge clock);
	srDataInRe = -8'd32;
	srDataInIm = -8'd23;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd90;
	srDataInIm = -8'd96;
	repeat(1) @ (posedge clock);

	// Need to add [length number entered to the n_tap_complex_fir module - 1], in thus case
	// that is 3 padded 0s. This is required by convolution opperation that the FIR
	// filters achives.
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	srDataInRe = 8'd0;
	srDataInIm = 8'd0;
	repeat(1) @ (posedge clock);


	//stopDataLoadFlag = 1;
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
