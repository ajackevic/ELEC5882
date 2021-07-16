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
	
	
	
	expectedDataOutBuffRe[0]  <= 54'd5441543636;
	expectedDataOutBuffIm[0]  <= 54'd3503789972;
	expectedDataOutBuffRe[1]  <= 54'd9912244375;
	expectedDataOutBuffIm[1]  <= 54'd7978422841;
	expectedDataOutBuffRe[2]  <= -54'd1883883483;
	expectedDataOutBuffIm[2]  <= 54'd19774550699;
	expectedDataOutBuffRe[3]  <= 54'd4434000859;
	expectedDataOutBuffIm[3]  <= 54'd14765017079;
	expectedDataOutBuffRe[4]  <= 54'd23255010033;
	expectedDataOutBuffIm[4]  <= -54'd773449971;
	expectedDataOutBuffRe[5]  <= 54'd5064714511;
	expectedDataOutBuffIm[5]  <= 54'd15395468589;
	expectedDataOutBuffRe[6]  <= 54'd3714421069;
	expectedDataOutBuffIm[6]  <= 54'd15395468589;
	expectedDataOutBuffRe[7]  <= 54'd3714421069;
	expectedDataOutBuffIm[7]  <= 54'd36660951913;
	expectedDataOutBuffRe[8]  <= 54'd5010713259;
	expectedDataOutBuffIm[8]  <= 54'd37957244103;
	expectedDataOutBuffRe[9]  <= 54'd5038107098;
	expectedDataOutBuffIm[9]  <= 54'd38215847186;
	expectedDataOutBuffRe[10] <= 54'd3845098856;
	expectedDataOutBuffIm[10] <= 54'd37020479666;
	expectedDataOutBuffRe[11] <= 54'd1308743935;
	expectedDataOutBuffIm[11] <= 54'd36838684189;
	expectedDataOutBuffRe[12] <= 54'd1443747065;
	expectedDataOutBuffIm[12] <= 54'd36942492421;
	expectedDataOutBuffRe[13] <= 54'd677243857;
	expectedDataOutBuffIm[13] <= 54'd38002856811;
	expectedDataOutBuffRe[14] <= 54'd842000104;
	expectedDataOutBuffIm[14] <= 54'd37993026486;
	expectedDataOutBuffRe[15] <= 54'd732949032;
	expectedDataOutBuffIm[15] <= 54'd40091735338;
	expectedDataOutBuffRe[16] <= 54'd3255017214;
	expectedDataOutBuffIm[16] <= 54'd37574647854;
	expectedDataOutBuffRe[17] <= 54'd21196408907;
	expectedDataOutBuffIm[17] <= 54'd21156563323;
	expectedDataOutBuffRe[18] <= 54'd22352455127;
	expectedDataOutBuffIm[18] <= 54'd19746239363;
	expectedDataOutBuffRe[19] <= 54'd23663034056;
	expectedDataOutBuffIm[19] <= 54'd21057080434;
	expectedDataOutBuffRe[20] <= 54'd12779905268;
	expectedDataOutBuffIm[20] <= 54'd14049473758;
	expectedDataOutBuffRe[21] <= 54'd3838469681;
	expectedDataOutBuffIm[21] <= 54'd5100173881;
	expectedDataOutBuffRe[22] <= 54'd27430815395;
	expectedDataOutBuffIm[22] <= -54'd18492171833;
	expectedDataOutBuffRe[23] <= 54'd14794998509;
	expectedDataOutBuffIm[23] <= -54'd8473066373;
	expectedDataOutBuffRe[24] <= -54'd22847163433;
	expectedDataOutBuffIm[24] <= 54'd22603986277;
	expectedDataOutBuffRe[25] <= 54'd13533566393;
	expectedDataOutBuffIm[25] <= -54'd9733974203;
	expectedDataOutBuffRe[26] <= 54'd16234163579;
	expectedDataOutBuffIm[26] <= -54'd9733974203;
	expectedDataOutBuffRe[27] <= 54'd16234163579;
	expectedDataOutBuffIm[27] <= -54'd52265103095;
	expectedDataOutBuffRe[28] <= 54'd13641569309;
	expectedDataOutBuffIm[28] <= -54'd54857697365;
	expectedDataOutBuffRe[29] <= 54'd13586781422;
	expectedDataOutBuffIm[29] <= -54'd55374905504;
	expectedDataOutBuffRe[30] <= 54'd15972807008;
	expectedDataOutBuffIm[30] <= -54'd52984161344;
	expectedDataOutBuffRe[31] <= 54'd21045536201;
	expectedDataOutBuffIm[31] <= -54'd52620569003;
	expectedDataOutBuffRe[32] <= 54'd20775528911;
	expectedDataOutBuffIm[32] <= -54'd52828186259;
	expectedDataOutBuffRe[33] <= 54'd22308541175;
	expectedDataOutBuffIm[33] <= -54'd54948923129;
	expectedDataOutBuffRe[34] <= 54'd21979027424;
	expectedDataOutBuffIm[34] <= -54'd54929262404;
	expectedDataOutBuffRe[35] <= 54'd22197130400;
	expectedDataOutBuffIm[35] <= -54'd59126696120;
	expectedDataOutBuffRe[36] <= 54'd17152974794;
	expectedDataOutBuffIm[36] <= -54'd54092501948;
	expectedDataOutBuffRe[37] <= -54'd18729945475;
	expectedDataOutBuffIm[37] <= -54'd21256207625;
	expectedDataOutBuffRe[38] <= -54'd21042046735;
	expectedDataOutBuffIm[38] <= -54'd18435548945;
	expectedDataOutBuffRe[39] <= -54'd23663214592;
	expectedDataOutBuffIm[39] <= -54'd21057241088;
	expectedDataOutBuffRe[40] <= -54'd18136302180;
	expectedDataOutBuffIm[40] <= -54'd17139239404;
	expectedDataOutBuffRe[41] <= -54'd13724802497;
	expectedDataOutBuffIm[41] <= -54'd12671762613;
	expectedDataOutBuffRe[42] <= -54'd26602896565;
	expectedDataOutBuffIm[42] <= -54'd1275851429;
	expectedDataOutBuffRe[43] <= -54'd18722733187;
	expectedDataOutBuffIm[43] <= -54'd6404713852;
	expectedDataOutBuffRe[44] <= 54'd1184776809;
	expectedDataOutBuffIm[44] <= -54'd21929700629;
	expectedDataOutBuffRe[45] <= -54'd19113580540;
	expectedDataOutBuffIm[45] <= -54'd5811652277;
	expectedDataOutBuffRe[46] <= -54'd20983482766;
	expectedDataOutBuffIm[46] <= -54'd8677388311;
	expectedDataOutBuffRe[47] <= -54'd22287471268;
	expectedDataOutBuffIm[47] <= 54'd13834299845;
	expectedDataOutBuffRe[48] <= -54'd9264775945;
	expectedDataOutBuffIm[48] <= 54'd16214761048;
	expectedDataOutBuffRe[49] <= -54'd22670343246;
	expectedDataOutBuffIm[49] <= 54'd11853716685;
	expectedDataOutBuffRe[50] <= -54'd37811673170;
	expectedDataOutBuffIm[50] <= 54'd8509515001;
	expectedDataOutBuffRe[51] <= -54'd1308330062;
	expectedDataOutBuffIm[51] <= 54'd9891017085;
	expectedDataOutBuffRe[52] <= -54'd8362411154;
	expectedDataOutBuffIm[52] <= 54'd2096680530;
	expectedDataOutBuffRe[53] <= -54'd39426775735;
	expectedDataOutBuffIm[53] <= 54'd21435323337;
	expectedDataOutBuffRe[54] <= -54'd16069884484;
	expectedDataOutBuffIm[54] <= 54'd34417522341;
	expectedDataOutBuffRe[55] <= -54'd16182307543;
	expectedDataOutBuffIm[55] <= -54'd9397513762;
	expectedDataOutBuffRe[56] <= -54'd12120694483;
	expectedDataOutBuffIm[56] <= 54'd13027556829;
	expectedDataOutBuffRe[57] <= 54'd22677092767;
	expectedDataOutBuffIm[57] <= -54'd14173454053;
	expectedDataOutBuffRe[58] <= -54'd10263383877;
	expectedDataOutBuffIm[58] <= 54'd10318675348;
	expectedDataOutBuffRe[59] <= 54'd14905513835;
	expectedDataOutBuffIm[59] <= -54'd13284280934;
	
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





integer n;
always @ (posedge clock) begin
	case(stateResults)
		IDLE: begin
			if(loadDataFlag) begin
				repeat(1) @ (posedge clock);
				stateResults <= CHECK_RESULTS;
			end
		end
		
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
		
		STOP: begin
			testFailedFlag = 1'd0;
			dataOutCounter = 8'd0;
			
			for (n = 0; n <= NUMB_DATAIN - 2; n = n + 1) begin
				obtainedValuesRe[n] = 54'd0;
				obtainedValuesIm[n] = 54'd0;
			end
			
			$stop;
		end
		
		default: begin
			stateResults <= IDLE;
			dataOutCounter <= 8'd0;
			
			for (n = 0; n <= NUMB_DATAIN - 2; n = n + 1) begin
				obtainedValuesRe[n] <= 54'd0;
				obtainedValuesIm[n] <= 54'd0;
			end
		end	
	endcase
end


endmodule
