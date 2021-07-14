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
reg enableFIRCoeff;
wire coeffSetFlag;
wire signed [DATA_WIDTH - 1:0] coeffOutRe;
wire signed [DATA_WIDTH - 1:0] coeffOutIm;





// FSM states for loading the coefficients and dataIn.
reg [1:0] stateDut;
localparam IDLE = 0;
localparam ENABLE_COEFF = 1;
localparam FIR_MAIN = 2;
localparam STOP = 3;

// FSM states for checking dataOut.
reg [1:0] stateResults;
localparam CHECK_RESULTS = 1;
localparam PRINT_RESULTS = 2;






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
	.loadCoeff				(enableFIRCoeff),
	.coeffSetFlag			(coeffSetFlag),
	
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
	stateDut = IDLE;
	stateResults = IDLE;
	
	enableFIRCoeff = 1'd0;
	startTest = 1'd0;
	testFailedFlag = 1'd0;
	stopDataLoadFlag = 1'd0;
	loadDataFlag = 1'd0;
	
	dataInRe = 18'd0;
	dataInIm = 18'd0;
	dataInCounter = 8'd0;
	dataOutCounter = 8'd0;
	
	repeat(RST_CYCLES) @ (posedge clock);
	startTest = 1'd1;
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
