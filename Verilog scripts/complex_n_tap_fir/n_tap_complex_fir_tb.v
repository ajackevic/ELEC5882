/*

 n_tap_complex_fir_tb.v
 --------------
 By: Augustas Jackevic
 Date: Feb 2021

 Module Description:
 -------------------
 This module is a test bench for the module n_tap_complex_fir.v. The test bench 
 sets the coefficients of the dut module by calling and passing through
 the outputs of setup_complex_FIR_coeff to the dut module. Serial data is then 
 passed through dataInRe and dataInIm and the corresponding output is then observed in 
 dataOutRe and dataOutIm. This test bench checks whether the coefficients of the DUT are 
 correctly loaded and stored in the module, if the FIR filter performs the 
 convolution correctly and lastly if the maximum and minimum bounds of the 
 filter are exceeded. The convolution opperation is checked with MATLABS
 corresponding outputs.

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



// Set the init values of the regs.
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
	
	
	// 20 random values are sent to check the other opperations.
	dataInBuffRe[40] <= -54'd123;
	dataInBuffIm[40] <= 54'd12111;
	dataInBuffRe[41] <= 54'd891;
	dataInBuffIm[41] <= 54'd9;
	dataInBuffRe[42] <= 54'd0;
	dataInBuffIm[42] <= 54'd511;
	dataInBuffRe[43] <= 54'd1241;
	dataInBuffIm[43] <= -54'd7819;
	dataInBuffRe[44] <= -54'd76;
	dataInBuffIm[44] <= 54'd1111;
	dataInBuffRe[45] <= 54'd9861;
	dataInBuffIm[45] <= -54'd90;
	dataInBuffRe[46] <= -54'd8191;
	dataInBuffIm[46] <= -54'd88910;
	dataInBuffRe[47] <= 54'd888;
	dataInBuffIm[47] <= -54'd9901;
	dataInBuffRe[48] <= 54'd12;
	dataInBuffIm[48] <= 54'd11111;
	dataInBuffRe[49] <= -54'd1231;
	dataInBuffIm[49] <= -54'd131072;
	dataInBuffRe[50] <= -54'd131072;
	dataInBuffIm[50] <= -54'd131072;
	dataInBuffRe[51] <= 54'd89700;
	dataInBuffIm[51] <= -54'd12;
	dataInBuffRe[52] <= 54'd35111;
	dataInBuffIm[52] <= -54'd78819;
	dataInBuffRe[53] <= 54'd1;
	dataInBuffIm[53] <= 54'd99719;
	dataInBuffRe[54] <= 54'd999;
	dataInBuffIm[54] <= -54'd666;
	dataInBuffRe[55] <= -54'd1251;
	dataInBuffIm[55] <= -54'd678;
	dataInBuffRe[56] <= 54'd69696;
	dataInBuffIm[56] <= 54'd420;
	dataInBuffRe[57] <= -54'd69420;
	dataInBuffIm[57] <= -54'd552;
	dataInBuffRe[58] <= 54'd891;
	dataInBuffIm[58] <= -54'd111;
	dataInBuffRe[59] <= 54'd131071;
	dataInBuffIm[59] <= -54'd987;
	
	
	
	
	// The expectedDataOutBuff values are aquired from MATLAB through the
	// convolution opperation between the coefficients and dataInBuff.
	expectedDataOutBuffRe[0]  <= 72'd5441543636;
	expectedDataOutBuffIm[0]  <= 72'd3503789972;
	expectedDataOutBuffRe[1]  <= 72'd9912244375;
	expectedDataOutBuffIm[1]  <= 72'd7978422841;
	expectedDataOutBuffRe[2]  <= -72'd1883883483;
	expectedDataOutBuffIm[2]  <= 72'd19774550699;
	expectedDataOutBuffRe[3]  <= 72'd4434000859;
	expectedDataOutBuffIm[3]  <= 72'd14765017079;
	expectedDataOutBuffRe[4]  <= 72'd23255010033;
	expectedDataOutBuffIm[4]  <= -72'd773449971;
	expectedDataOutBuffRe[5]  <= 72'd5064714511;
	expectedDataOutBuffIm[5]  <= 72'd15395468589;
	expectedDataOutBuffRe[6]  <= 72'd3714421069;
	expectedDataOutBuffIm[6]  <= 72'd15395468589;
	expectedDataOutBuffRe[7]  <= 72'd3714421069;
	expectedDataOutBuffIm[7]  <= 72'd36660951913;
	expectedDataOutBuffRe[8]  <= 72'd5010713259;
	expectedDataOutBuffIm[8]  <= 72'd37957244103;
	expectedDataOutBuffRe[9]  <= 72'd5038107098;
	expectedDataOutBuffIm[9]  <= 72'd38215847186;
	expectedDataOutBuffRe[10] <= 72'd3845098856;
	expectedDataOutBuffIm[10] <= 72'd37020479666;
	expectedDataOutBuffRe[11] <= 72'd1308743935;
	expectedDataOutBuffIm[11] <= 72'd36838684189;
	expectedDataOutBuffRe[12] <= 72'd1443747065;
	expectedDataOutBuffIm[12] <= 72'd36942492421;
	expectedDataOutBuffRe[13] <= 72'd677243857;
	expectedDataOutBuffIm[13] <= 72'd38002856811;
	expectedDataOutBuffRe[14] <= 72'd842000104;
	expectedDataOutBuffIm[14] <= 72'd37993026486;
	expectedDataOutBuffRe[15] <= 72'd732949032;
	expectedDataOutBuffIm[15] <= 72'd40091735338;
	expectedDataOutBuffRe[16] <= 72'd3255017214;
	expectedDataOutBuffIm[16] <= 72'd37574647854;
	expectedDataOutBuffRe[17] <= 72'd21196408907;
	expectedDataOutBuffIm[17] <= 72'd21156563323;
	expectedDataOutBuffRe[18] <= 72'd22352455127;
	expectedDataOutBuffIm[18] <= 72'd19746239363;
	expectedDataOutBuffRe[19] <= 72'd23663034056;
	expectedDataOutBuffIm[19] <= 72'd21057080434;
	expectedDataOutBuffRe[20] <= 72'd12779905268;
	expectedDataOutBuffIm[20] <= 72'd14049473758;
	expectedDataOutBuffRe[21] <= 72'd3838469681;
	expectedDataOutBuffIm[21] <= 72'd5100173881;
	expectedDataOutBuffRe[22] <= 72'd27430815395;
	expectedDataOutBuffIm[22] <= -72'd18492171833;
	expectedDataOutBuffRe[23] <= 72'd14794998509;
	expectedDataOutBuffIm[23] <= -72'd8473066373;
	expectedDataOutBuffRe[24] <= -72'd22847163433;
	expectedDataOutBuffIm[24] <= 72'd22603986277;
	expectedDataOutBuffRe[25] <= 72'd13533566393;
	expectedDataOutBuffIm[25] <= -72'd9733974203;
	expectedDataOutBuffRe[26] <= 72'd16234163579;
	expectedDataOutBuffIm[26] <= -72'd9733974203;
	expectedDataOutBuffRe[27] <= 72'd16234163579;
	expectedDataOutBuffIm[27] <= -72'd52265103095;
	expectedDataOutBuffRe[28] <= 72'd13641569309;
	expectedDataOutBuffIm[28] <= -72'd54857697365;
	expectedDataOutBuffRe[29] <= 72'd13586781422;
	expectedDataOutBuffIm[29] <= -72'd55374905504;
	expectedDataOutBuffRe[30] <= 72'd15972807008;
	expectedDataOutBuffIm[30] <= -72'd52984161344;
	expectedDataOutBuffRe[31] <= 72'd21045536201;
	expectedDataOutBuffIm[31] <= -72'd52620569003;
	expectedDataOutBuffRe[32] <= 72'd20775528911;
	expectedDataOutBuffIm[32] <= -72'd52828186259;
	expectedDataOutBuffRe[33] <= 72'd22308541175;
	expectedDataOutBuffIm[33] <= -72'd54948923129;
	expectedDataOutBuffRe[34] <= 72'd21979027424;
	expectedDataOutBuffIm[34] <= -72'd54929262404;
	expectedDataOutBuffRe[35] <= 72'd22197130400;
	expectedDataOutBuffIm[35] <= -72'd59126696120;
	expectedDataOutBuffRe[36] <= 72'd17152974794;
	expectedDataOutBuffIm[36] <= -72'd54092501948;
	expectedDataOutBuffRe[37] <= -72'd18729945475;
	expectedDataOutBuffIm[37] <= -72'd21256207625;
	expectedDataOutBuffRe[38] <= -72'd21042046735;
	expectedDataOutBuffIm[38] <= -72'd18435548945;
	expectedDataOutBuffRe[39] <= -72'd23663214592;
	expectedDataOutBuffIm[39] <= -72'd21057241088;
	expectedDataOutBuffRe[40] <= -72'd18136302180;
	expectedDataOutBuffIm[40] <= -72'd17139239404;
	expectedDataOutBuffRe[41] <= -72'd13724802497;
	expectedDataOutBuffIm[41] <= -72'd12671762613;
	expectedDataOutBuffRe[42] <= -72'd26602896565;
	expectedDataOutBuffIm[42] <= -72'd1275851429;
	expectedDataOutBuffRe[43] <= -72'd18722733187;
	expectedDataOutBuffIm[43] <= -72'd6404713852;
	expectedDataOutBuffRe[44] <= 72'd1184776809;
	expectedDataOutBuffIm[44] <= -72'd21929700629;
	expectedDataOutBuffRe[45] <= -72'd19113580540;
	expectedDataOutBuffIm[45] <= -72'd5811652277;
	expectedDataOutBuffRe[46] <= -72'd20983482766;
	expectedDataOutBuffIm[46] <= -72'd8677388311;
	expectedDataOutBuffRe[47] <= -72'd22287471268;
	expectedDataOutBuffIm[47] <= 72'd13834299845;
	expectedDataOutBuffRe[48] <= -72'd9264775945;
	expectedDataOutBuffIm[48] <= 72'd16214761048;
	expectedDataOutBuffRe[49] <= -72'd22670343246;
	expectedDataOutBuffIm[49] <= 72'd11853716685;
	expectedDataOutBuffRe[50] <= -72'd37811673170;
	expectedDataOutBuffIm[50] <= 72'd8509515001;
	expectedDataOutBuffRe[51] <= -72'd1308330062;
	expectedDataOutBuffIm[51] <= 72'd9891017085;
	expectedDataOutBuffRe[52] <= -72'd8362411154;
	expectedDataOutBuffIm[52] <= 72'd2096680530;
	expectedDataOutBuffRe[53] <= -72'd39426775735;
	expectedDataOutBuffIm[53] <= 72'd21435323337;
	expectedDataOutBuffRe[54] <= -72'd16069884484;
	expectedDataOutBuffIm[54] <= 72'd34417522341;
	expectedDataOutBuffRe[55] <= -72'd16182307543;
	expectedDataOutBuffIm[55] <= -72'd9397513762;
	expectedDataOutBuffRe[56] <= -72'd12120694483;
	expectedDataOutBuffIm[56] <= 72'd13027556829;
	expectedDataOutBuffRe[57] <= 72'd22677092767;
	expectedDataOutBuffIm[57] <= -72'd14173454053;
	expectedDataOutBuffRe[58] <= -72'd10263383877;
	expectedDataOutBuffIm[58] <= 72'd10318675348;
	expectedDataOutBuffRe[59] <= 72'd14905513835;
	expectedDataOutBuffIm[59] <= -72'd13284280934;
end




// Parameters for the clock signal.
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
	
	
		// State IDLE. This state waits until startTest is high before transitioning to enabling 
		// the loading of the coefficients to the module n_tap_complex_fir and then 
		// transitioning to ENABLE_COEFF.
		IDLE: begin
			if(startTest) begin
				stateDut <= ENABLE_COEFF;
				loadCoeff <= 1'd1;
			end
		end
		
		
		// State ENABLE_COEFF. This state enables the coefficients module and transitions to FIR_MAIN.
		// The module n_tap_complex_fir requires 6 clock cycles before loadDataFlag can be set high, 
		// thus the added wait of 5 clock cycles. This state also enables the reading/loading of the 
		// coefficients from the module setup_complex_FIR_coeff.
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







// This always block checks the obtained results from the dut module.
integer n;
always @ (posedge clock) begin
	case(stateResults)
	
		// State IDLE. This state waits until loadDataFlag is set high, before waiting one clock
		// cycles then transitioning to CHECK_RESULTS. The reson for the wait is due to the internal 
		// workings of the module n_tap_complex_fir.
		IDLE: begin
			if(loadDataFlag) begin
				repeat(1) @ (posedge clock);
				stateResults <= CHECK_RESULTS;
			end
		end
		
		
		// State CHECK_RESULTS. This state stores the dataOut values to obtainedValues and then
		// checks if the aquired dataOut value is equal to the corresponding expectedDataOutBuff
		// value. If it is not, testFailedFlag is set high. Once dataOutCounter is equal to 
		// NUMB_DATAIN - 2, the state transitions to PRINT_RESULTS.
		CHECK_RESULTS: begin
			obtainedValuesRe[dataOutCounter] <= dataOutRe;
			obtainedValuesIm[dataOutCounter] <= dataOutIm;
			
		
			if((dataOutRe != expectedDataOutBuffRe[dataOutCounter]) || (dataOutIm != expectedDataOutBuffIm[dataOutCounter])) begin
				testFailedFlag <= 1'd1;
			end
			
			if(dataOutCounter == NUMB_DATAIN - 2) begin
				stateResults <= PRINT_RESULTS;
			end
			else begin
				dataOutCounter <= dataOutCounter + 8'd1;
			end
			
		end
		
		
		// State PRINT_RESULTS. This state prints the transcript of the test bench.
		PRINT_RESULTS: begin
			$display("This is a test bench for the module n_tap_complex_fir. \n \n",
						"It tests whether the coefficients of the DUT are correctly loaded \n",
						"and stored in the module, if the FIR filter performs the convolution correctly \n",
						"and lastly if the maximum and minimum bounds of the filter are exceeded. \n",
						"The convolution opperation is checked with MATLABS corresponding outputs. \n \n"

			);
			
			if(testFailedFlag) begin
				$display("Test results: FAILED \n \n");
			end
			else begin
				$display("Test results: PASSED \n \n");
			end
			
			// Display all the expected and aquired results.
			for (n = 0; n <= NUMB_DATAIN - 2; n = n + 1) begin
				$display("Real Data Out:     %d   Expected Value:%d   Obtained Value:%d", n+1, expectedDataOutBuffRe[n], obtainedValuesRe[n]);
				$display("Imaginary Data Out:%d   Expected Value:%d   Obtained Value:%d", n+1, expectedDataOutBuffIm[n], obtainedValuesIm[n]);
			end
			
			stateResults = STOP;
		end
		
		
		// State STOP. This state resets all the used parameters in this FSM.
		STOP: begin
			testFailedFlag = 1'd0;
			dataOutCounter = 8'd0;
			
			for (n = 0; n <= NUMB_DATAIN - 2; n = n + 1) begin
				obtainedValuesRe[n] = 54'd0;
				obtainedValuesIm[n] = 54'd0;
			end
			
			$stop;
		end
		
		
		// State default. This is a default state just incase the FSM is in an unkown state.
		default: begin
			stateResults <= IDLE;
			testFailedFlag <= 1'd0;
			dataOutCounter <= 8'd0;
			
			for (n = 0; n <= NUMB_DATAIN - 2; n = n + 1) begin
				obtainedValuesRe[n] <= 54'd0;
				obtainedValuesIm[n] <= 54'd0;
			end
		end	
		
	endcase
end



endmodule
