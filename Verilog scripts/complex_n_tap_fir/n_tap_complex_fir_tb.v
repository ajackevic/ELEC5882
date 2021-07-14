/*

 n_tap_complex_fir_tb.v
 --------------
 By: Augustas Jackevic
 Date: 11th Feb 2021

 Module Description:
 -------------------
 This module is a test bench for the module n_tap_complex_fir.v. The script
 sends the input data (dataInRe and dataInIm) to the test script, the output
 data (dataOutRe and dataOutIm) is then observed in ModelSim. The results
 are then confirmed through the convolution operation in MATLAB, with the same
 inputs.

*/

module n_tap_complex_fir_tb;


// Parameters for creating the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;


localparam TAPS = 20;
localparam DATA_WIDTH = 18;





//
// Creating the local regs and wires.
// Note: The range of reg signed [N:0] is [-2^(N-1) to (2^(N-1))-1)].
//
reg clock;
reg startTest;
reg testFailedFlag;
reg [7:0] dataInCounter;
reg [7:0] dataOutCounter;
reg signed [DATA_WIDTH - 1:0] dataInBuffRe [0:NUMB_DATAIN - 1];
reg signed [DATA_WIDTH - 1:0] dataInBuffIm [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 2) - 1:0] expectedDataOutBuffRe [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 2) - 1:0] expectedDataOutBuffIm [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 2) - 1:0] obtainedValuesRe [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 2) - 1:0] obtainedValuesIm [0:NUMB_DATAIN - 1];


// Local parameters for the n_tap_complex_fir module.
reg loadDataFlag;
reg stopDataLoadFlag;
reg signed [(DATA_WIDTH * 2) - 1:0] dataInRe;
reg signed [(DATA_WIDTH * 2) - 1:0] dataInIm;
wire signed [(DATA_WIDTH * 3) - 1:0] dataOutRe;
wire signed [(DATA_WIDTH * 3) - 1:0] dataOutIm;



// Local parameters for the setup_complex_FIR_coeff module.
reg loadCoeff;
wire coeffSetFlag;
wire signed [DATA_WIDTH - 1:0] coeffOutRe;
wire signed [DATA_WIDTH - 1:0] coeffOutIm;






// Connecting module setup_complex_FIR_coeff and hence supplying the coefficients 
// to the dut module.
setup_complex_FIR_coeff # (
	.LENGTH				(TAPS),
	.DATA_WIDTH			(DATA_WIDTH)
) dut_coeff (
	.clock				(clock),
	.enable				(loadCoeff),

	.coeffSetFlag		(coeffSetFlag),
	.coeffOutRe			(coeffOutRe),
	.coeffOutIm			(coeffOutIm)
);




// Connect the dut module.
n_tap_complex_fir #(
	.LENGTH					(TAPS),
	.DATA_WIDTH				(DATA_WIDTH)
	) dut (
	.clock					(clock),
	.loadCoeff				(loadCoeff),
	.coeffSetFlag			(filterSetFlag),
	
	.loadDataFlag			(loadDataFlag),
	.stopDataLoadFlag		(stopDataLoadFlag),
	.dataInRe				(dataInRe),
	.dataInIm				(dataInIm),
	.coeffInRe				(coeffOutRe),
	.coeffInIm				(coeffOutIm),
	
	.dataOutRe				(dataOutRe),
	.dataOutIm				(dataOutIm)
);




initial begin

	// Set the init values. Then send the c the data in a serial manner, one clock 
	// cycle at a time.
	dataInRe = 0;
	dataInIm = 0;

	loadDataFlag = 0;
	stopDataLoadFlag = 0;
	
	loadCoeff = 0;
	repeat(RST_CYCLES) @ (posedge clock);
	repeat(20) @ (posedge clock);
	loadCoeff = 1;
	loadDataFlag = 1;
	

	// Set the input data values, in this case there are 4 values.
	repeat(2) @ (posedge clock);
	dataInRe = 8'd2;
	dataInIm = 8'd3;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd5;
	dataInIm = 8'd10;
	repeat(1) @ (posedge clock);
	dataInRe = -8'd2;
	dataInIm = -8'd3;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = -8'd6;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd56;
	dataInIm = -8'd39;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd55;
	dataInIm = 8'd110;
	repeat(1) @ (posedge clock);
	dataInRe = -8'd21;
	dataInIm = -8'd93;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd46;
	dataInIm = -8'd54;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd76;
	dataInIm = 8'd8;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd5;
	dataInIm = 8'd10;
	repeat(1) @ (posedge clock);
	dataInRe = -8'd15;
	dataInIm = -8'd96;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = -8'd75;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd12;
	dataInIm = 8'd98;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd78;
	dataInIm = 8'd100;
	repeat(1) @ (posedge clock);
	dataInRe = -8'd20;
	dataInIm = -8'd30;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd99;
	dataInIm = -8'd69;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd21;
	dataInIm = 8'd32;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd53;
	dataInIm = 8'd107;
	repeat(1) @ (posedge clock);
	dataInRe = -8'd28;
	dataInIm = -8'd33;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = -8'd66;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd26;
	dataInIm = 8'd38;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd57;
	dataInIm = 8'd107;
	repeat(1) @ (posedge clock);
	dataInRe = -8'd25;
	dataInIm = -8'd35;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd80;
	dataInIm = -8'd96;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd42;
	dataInIm = 8'd3;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd1;
	dataInIm = 8'd1;
	repeat(1) @ (posedge clock);
	dataInRe = -8'd32;
	dataInIm = -8'd23;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd90;
	dataInIm = -8'd96;
	repeat(1) @ (posedge clock);

	// Need to add [length number entered to the n_tap_complex_fir module - 1], in this case
	// that is 11 padded 0s. This is required by convolution opperation that the FIR
	// filters achives.
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);
	dataInRe = 8'd0;
	dataInIm = 8'd0;
	repeat(1) @ (posedge clock);


	//stopDataLoadFlag = 1;
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
