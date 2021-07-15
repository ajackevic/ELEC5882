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

// Parameters for the dut module.
localparam TAPS = 20;
localparam DATA_WIDTH = 18;

// Parameter for the number of data inputs.
localparam NUMB_DATAIN = 60;



//
// Creating the local regs and wires.
// Note: The range of reg signed [N:0] is [-2^(N-1) to (2^(N-1))-1)].
//
reg clock;
reg startTest;
reg testFailedFlag;
reg [7:0] dataInCounter;
reg [7:0] dataOutCounter;
reg signed [(DATA_WIDTH * 3) - 1:0] dataInBuffRe [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 3) - 1:0] dataInBuffIm [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 4) - 1:0] expectedDataOutBuffRe [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 4) - 1:0] expectedDataOutBuffIm [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 4) - 1:0] obtainedValuesRe [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 4) - 1:0] obtainedValuesIm [0:NUMB_DATAIN - 1];


// Local parameters for the n_tap_complex_fir module.
reg loadCoeff;
reg loadDataFlag;
reg stopDataLoadFlag;
reg signed [(DATA_WIDTH * 3) - 1:0] dataInRe;
reg signed [(DATA_WIDTH * 3) - 1:0] dataInIm;
wire signed [(DATA_WIDTH * 4) - 1:0] dataOutRe;
wire signed [(DATA_WIDTH * 4) - 1:0] dataOutIm;



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
	.enable				(enableFIRCoeff),

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
	
	loadCoeff = 1'd0;
	enableFIRCoeff = 1'd0;
	startTest = 1'd0;
	testFailedFlag = 1'd0;
	stopDataLoadFlag = 1'd0;
	loadDataFlag = 1'd0;
	
	dataInRe = 54'd0;
	dataInIm = 54'd0;
	dataInCounter = 8'd0;
	dataOutCounter = 8'd0;
	
	repeat(RST_CYCLES) @ (posedge clock);
	startTest = 1'd1;
end

	
	
// Set the initial value of the clock, dataInBuff, and expectedDataOutBuff.
initial begin
	clock <= 0;
	
	// 20 131071 are sent (max 18 bit value) to check the upper bounds of the FIR filter.
	dataInBuffRe[0]  <= 54'd131071;
	dataInBuffIm[0]  <= 54'd131071;
	dataInBuffRe[1]  <= 54'd131071;
	dataInBuffIm[1]  <= 54'd131071;
	dataInBuffRe[2]  <= 54'd131071;
	dataInBuffIm[2]  <= 54'd131071;
	dataInBuffRe[3]  <= 54'd131071;
	dataInBuffIm[3]  <= 54'd131071;
	dataInBuffRe[4]  <= 54'd131071;
	dataInBuffIm[4]  <= 54'd131071;
	dataInBuffRe[5]  <= 54'd131071;
	dataInBuffIm[5]  <= 54'd131071;
	dataInBuffRe[6]  <= 54'd131071;
	dataInBuffIm[6]  <= 54'd131071;
	dataInBuffRe[7]  <= 54'd131071;
	dataInBuffIm[7]  <= 54'd131071;
	dataInBuffRe[8]  <= 54'd131071;
	dataInBuffIm[8]  <= 54'd131071;
	dataInBuffRe[9]  <= 54'd131071;
	dataInBuffIm[9]  <= 54'd131071;
	dataInBuffRe[10] <= 54'd131071;
	dataInBuffIm[10] <= 54'd131071;
	dataInBuffRe[11] <= 54'd131071;
	dataInBuffIm[11] <= 54'd131071;
	dataInBuffRe[12] <= 54'd131071;
	dataInBuffIm[12] <= 54'd131071;
	dataInBuffRe[13] <= 54'd131071;
	dataInBuffIm[13] <= 54'd131071;
	dataInBuffRe[14] <= 54'd131071;
	dataInBuffIm[14] <= 54'd131071;
	dataInBuffRe[15] <= 54'd131071;
	dataInBuffIm[15] <= 54'd131071;
	dataInBuffRe[16] <= 54'd131071;
	dataInBuffIm[16] <= 54'd131071;
	dataInBuffRe[17] <= 54'd131071;
	dataInBuffIm[17] <= 54'd131071;
	dataInBuffRe[18] <= 54'd131071;
	dataInBuffIm[18] <= 54'd131071;
	dataInBuffRe[19] <= 54'd131071;
	dataInBuffIm[19] <= 54'd131071;
	
	// 20 -131072 are sent (smallest 18 bit value) to check the lower bounds of the FIR filter.
	dataInBuffRe[20] <= -54'd131072;
	dataInBuffIm[20] <= -54'd131072;
	dataInBuffRe[21] <= -54'd131072;
	dataInBuffIm[21] <= -54'd131072;
	dataInBuffRe[22] <= -54'd131072;
	dataInBuffIm[22] <= -54'd131072;
	dataInBuffRe[23] <= -54'd131072;
	dataInBuffIm[23] <= -54'd131072;
	dataInBuffRe[24] <= -54'd131072;
	dataInBuffIm[24] <= -54'd131072;
	dataInBuffRe[25] <= -54'd131072;
	dataInBuffIm[25] <= -54'd131072;
	dataInBuffRe[26] <= -54'd131072;
	dataInBuffIm[26] <= -54'd131072;
	dataInBuffRe[27] <= -54'd131072;
	dataInBuffIm[27] <= -54'd131072;
	dataInBuffRe[28] <= -54'd131072;
	dataInBuffIm[28] <= -54'd131072;
	dataInBuffRe[29] <= -54'd131072;
	dataInBuffIm[29] <= -54'd131072;
	dataInBuffRe[30] <= -54'd131072;
	dataInBuffIm[30] <= -54'd131072;
	dataInBuffRe[31] <= -54'd131072;
	dataInBuffIm[31] <= -54'd131072;
	dataInBuffRe[32] <= -54'd131072;
	dataInBuffIm[32] <= -54'd131072;
	dataInBuffRe[33] <= -54'd131072;
	dataInBuffIm[33] <= -54'd131072;
	dataInBuffRe[34] <= -54'd131072;
	dataInBuffIm[34] <= -54'd131072;
	dataInBuffRe[35] <= -54'd131072;
	dataInBuffIm[35] <= -54'd131072;
	dataInBuffRe[36] <= -54'd131072;
	dataInBuffIm[36] <= -54'd131072;
	dataInBuffRe[37] <= -54'd131072;
	dataInBuffIm[37] <= -54'd131072;
	dataInBuffRe[38] <= -54'd131072;
	dataInBuffIm[38] <= -54'd131072;
	dataInBuffRe[39] <= -54'd131072;
	dataInBuffIm[39] <= -54'd131072;
	
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






// This always block loads the coefficients and the dataIn.
always @(posedge clock) begin
	case(stateDut)
	
	
		// State IDLE. This state waits until startTest is high before transitioning to ENABLE_COEFF.
		IDLE: begin
			if(startTest) begin
				stateDut <= ENABLE_COEFF;
				loadCoeff <= 1'd1;
			end
		end
		
		
		// State ENABLE_COEFF. This state enables the coefficients module and transitions to FIR_MAIN.
		ENABLE_COEFF: begin
			enableFIRCoeff = 1'd1;
			repeat(5) @ (posedge clock);
			stateDut = FIR_MAIN;
		end
		
		
		// State FIR_MAIN. This state enables the loading of data to the dut module and then
		// loads dataInBuff to dataIn. When the counter is equal to NUMB_DATAIN the state 
		// transitions to STOP.
		FIR_MAIN: begin
			loadDataFlag <= 1'd1;
		
			if(dataInCounter == NUMB_DATAIN) begin
				stateDut <= STOP;
			end
			else begin
			
				if(coeffSetFlag) begin
					enableFIRCoeff <= 1'd0;
				end
				
				dataInRe <= dataInBuffRe[dataInCounter];
				dataInIm <= dataInBuffIm[dataInCounter];
				
				dataInCounter <= dataInCounter + 8'd1;
			end
			
		end
		
		
		// State STOP. This state resets all the used parameters in this FSM.
		STOP: begin
			enableFIRCoeff <= 1'd0;
			startTest <= 1'd0;
			stopDataLoadFlag <= 1'd0;
			loadDataFlag <= 1'd0;
	
			dataInRe <= 54'd0;
			dataInIm <= 54'd0;
			dataInCounter <= 8'd0;
		end
		
		
		// State default. This is a default state just incase the FSM is in an unkown state.
		default: begin
			stateDut <= IDLE;
			enableFIRCoeff <= 1'd0;
			startTest <= 1'd0;
			stopDataLoadFlag <= 1'd0;
			loadDataFlag <= 1'd0;
	
			dataInRe <= 54'd0;
			dataInIm <= 54'd0;
			dataInCounter <= 8'd0;
		end	
	endcase
end


endmodule
