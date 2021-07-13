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

// Parameters for the dut module.
localparam TAPS = 20;
localparam DATA_WIDTH = 18;

// Parameter for the number of data inputs.
localparam NUMB_DATAIN = 60;


//
// Creating the local parameters.
//
reg clock;
reg startTest;
reg [7:0] dataInCounter;
reg signed [DATA_WIDTH - 1:0] dataInBuff [0:NUMB_DATAIN - 1];
reg signed [(DATA_WIDTH * 2) - 1:0] expectedDataOutBuff [0:NUMB_DATAIN - 1];

// Local parameters for the n_tap_fir module.
reg loadDataFlag;
reg stopDataLoadFlag;
// Note the range of reg signed [N:0] is [-2^(N-1) to (2^(N-1))-1)].
reg signed [DATA_WIDTH - 1:0] dataIn;
wire signed [(DATA_WIDTH * 2) - 1:0] dataOut;

// Local parameters for the setup_FIR_coeff module.
reg enableFIRCoeff;
wire coeffSetFlag;
wire signed [DATA_WIDTH - 1:0] coeffOut;




// FSM states.
reg [1:0] stateDut;
localparam IDLE = 0;
localparam ENABLE_COEFF = 1;
localparam FIR_MAIN = 2;
localparam STOP = 3;


reg [1:0] stateResults;
localparam RESULTS = 1;
localparam EMPTY_STATE1 = 2;
localparam EMPTY_STATE2 = 3;





// Connecting the coeff for the FIR module.
setup_FIR_coeff #(
	.LENGTH 				(TAPS),
	.DATA_WIDTH 		(DATA_WIDTH)
) setupCoeff (
	.clock				(clock),
	.enable				(enableFIRCoeff),
	
	.coeffSetFlag		(coeffSetFlag),
	.coeffOut			(coeffOut)
);





// Connect the device under test.
n_tap_fir #(
	.LENGTH					(TAPS),
	.DATA_WIDTH				(DATA_WIDTH)
	)dut(
	
	.clock					(clock),
	.loadCoeff				(enableFIRCoeff),
	.loadDataFlag			(loadDataFlag),
	.coeffSetFlag			(coeffSetFlag),
	.stopDataLoadFlag 	(stopDataLoadFlag),
	.coeffIn					(coeffOut),
	.dataIn					(dataIn),
	
	
	.dataOut 				(dataOut)
);




// Set the init values of the local parameters.
initial begin
	stateDut = IDLE;
	stateResults = IDLE;
	
	enableFIRCoeff = 1'd0;
	startTest = 1'd0;
	stopDataLoadFlag = 1'd0;
	loadDataFlag = 1'd0;
	
	dataIn = 18'd0;
	dataInCounter = 8'd0;
	
	repeat(RST_CYCLES) @ (posedge clock);
	startTest = 1'd1;
end



// Set the initial value of the clock and dataInBuff and expectedDataOutBuff.
initial begin
	clock <= 0;
	
	dataInBuff[0]  <= 18'd131071;
	dataInBuff[1]  <= 18'd131071;
	dataInBuff[2]  <= 18'd131071;
	dataInBuff[3]  <= 18'd131071;
	dataInBuff[4]  <= 18'd131071;
	dataInBuff[5]  <= 18'd131071;
	dataInBuff[6]  <= 18'd131071;
	dataInBuff[7]  <= 18'd131071;
	dataInBuff[8]  <= 18'd131071;
	dataInBuff[9]  <= 18'd131071;
	dataInBuff[10] <= 18'd131071;
	dataInBuff[11] <= 18'd131071;
	dataInBuff[12] <= 18'd131071;
	dataInBuff[13] <= 18'd131071;
	dataInBuff[14] <= 18'd131071;
	dataInBuff[15] <= 18'd131071;
	dataInBuff[16] <= 18'd131071;
	dataInBuff[17] <= 18'd131071;
	dataInBuff[18] <= 18'd131071;
	dataInBuff[19] <= 18'd131071;
	
	dataInBuff[20] <= -18'd131072;
	dataInBuff[21] <= -18'd131072;
	dataInBuff[22] <= -18'd131072;
	dataInBuff[23] <= -18'd131072;
	dataInBuff[24] <= -18'd131072;
	dataInBuff[25] <= -18'd131072;
	dataInBuff[26] <= -18'd131072;
	dataInBuff[27] <= -18'd131072;
	dataInBuff[28] <= -18'd131072;
	dataInBuff[29] <= -18'd131072;
	dataInBuff[30] <= -18'd131072;
	dataInBuff[31] <= -18'd131072;
	dataInBuff[32] <= -18'd131072;
	dataInBuff[33] <= -18'd131072;
	dataInBuff[34] <= -18'd131072;
	dataInBuff[35] <= -18'd131072;
	dataInBuff[36] <= -18'd131072;
	dataInBuff[37] <= -18'd131072;
	dataInBuff[38] <= -18'd131072;
	dataInBuff[39] <= -18'd131072;
	
	dataInBuff[40] <= 18'd131071;
	dataInBuff[41] <= 18'd0;
	dataInBuff[42] <= -18'd17923;
	dataInBuff[43] <= -18'd666;
	dataInBuff[44] <= 18'd999;
	dataInBuff[45] <= -18'd12361;
	dataInBuff[46] <= -18'd1;
	dataInBuff[47] <= 18'd1251;
	dataInBuff[48] <= 18'd48302;
	dataInBuff[49] <= 18'd8592;
	dataInBuff[50] <= 18'd22341;
	dataInBuff[51] <= -18'd55555;
	dataInBuff[52] <= -18'd32123;
	dataInBuff[53] <= -18'd9898;
	dataInBuff[54] <= 18'd23411;
	dataInBuff[55] <= -18'd23211;
	dataInBuff[56] <= 18'd992;
	dataInBuff[57] <= 18'd73;
	dataInBuff[58] <= -18'd124;
	dataInBuff[59] <= -18'd1231;
	
	
	
	expectedDataOutBuff[0]  <= 36'd4472666804;
	expectedDataOutBuff[1]  <= 36'd4880821898;
	expectedDataOutBuff[2]  <= 36'd4880821898;
	expectedDataOutBuff[3]  <= 36'd5534997259;
	expectedDataOutBuff[4]  <= 36'd7176268321;
	expectedDataOutBuff[5]  <= 36'd6165579840;
	expectedDataOutBuff[6]  <= 36'd5490433119;
	expectedDataOutBuff[7]  <= 36'd16123174781;
	expectedDataOutBuff[8]  <= 36'd17419466971;
	expectedDataOutBuff[9]  <= 36'd17562465432;
	expectedDataOutBuff[10] <= 36'd16368277551;
	expectedDataOutBuff[11] <= 36'd15009202352;
	expectedDataOutBuff[12] <= 36'd15128608033;
	expectedDataOutBuff[13] <= 36'd15275538624;
	expectedDataOutBuff[14] <= 36'd15353001585;
	expectedDataOutBuff[15] <= 36'd16347830475;
	expectedDataOutBuff[16] <= 36'd16350320824;
	expectedDataOutBuff[17] <= 36'd17111974405;
	expectedDataOutBuff[18] <= 36'd16984835535;
	expectedDataOutBuff[19] <= 36'd9350177803;
	expectedDataOutBuff[20] <= 36'd8533864501;
	expectedDataOutBuff[21] <= 36'd8533864501;
	expectedDataOutBuff[22] <= 36'd7225508788;
	expectedDataOutBuff[23] <= 36'd3942954142;
	expectedDataOutBuff[24] <= 36'd5964338815;
	expectedDataOutBuff[25] <= 36'd7314637408;
	expectedDataOutBuff[26] <= -36'd13950927038;
	expectedDataOutBuff[27] <= -36'd16543521308;
	expectedDataOutBuff[28] <= -36'd16829519321;
	expectedDataOutBuff[29] <= -36'd14441134448;
	expectedDataOutBuff[30] <= -36'd11722973681;
	expectedDataOutBuff[31] <= -36'd11961785954;
	expectedDataOutBuff[32] <= -36'd12255648257;
	expectedDataOutBuff[33] <= -36'd12410574770;
	expectedDataOutBuff[34] <= -36'd14400240140;
	expectedDataOutBuff[35] <= -36'd14405220857;
	expectedDataOutBuff[36] <= -36'd15928533830;
	expectedDataOutBuff[37] <= -36'd15674255120;
	expectedDataOutBuff[38] <= -36'd18295685120;
	expectedDataOutBuff[39] <= -36'd9350317388;
	expectedDataOutBuff[40] <= -36'd13006670890;
	expectedDataOutBuff[41] <= -36'd14026430436;
	expectedDataOutBuff[42] <= -36'd12185009077;
	expectedDataOutBuff[43] <= -36'd9446075034;
	expectedDataOutBuff[44] <= -36'd13648896292;
	expectedDataOutBuff[45] <= -36'd13746638923;
	expectedDataOutBuff[46] <= -36'd8637890954;
	expectedDataOutBuff[47] <= -36'd2120632630;
	expectedDataOutBuff[48] <= -36'd1759493161;
	expectedDataOutBuff[49] <= -36'd2467235478;
	expectedDataOutBuff[50] <= -36'd6096312730;
	expectedDataOutBuff[51] <= -36'd4508939584;
	expectedDataOutBuff[52] <= -36'd3400027393;
	expectedDataOutBuff[53] <= -36'd2340162471;
	expectedDataOutBuff[54] <= 36'd1267724388;
	expectedDataOutBuff[55] <= -36'd825693084;
	expectedDataOutBuff[56] <= 36'd1902480668;
   expectedDataOutBuff[57] <= -36'd5770887581;
	expectedDataOutBuff[58] <= -36'd2959737156;
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






always @(posedge clock) begin
	case(stateDut)
		IDLE: begin
			if(startTest) begin
				stateDut <= ENABLE_COEFF;
			end
		end
		
		ENABLE_COEFF: begin
			enableFIRCoeff <= 1'd1;
			stateDut <= FIR_MAIN;
		end
		
		FIR_MAIN: begin
			loadDataFlag <= 1'd1;
		
			if(dataInCounter == NUMB_DATAIN) begin
				stateDut <= STOP;
			end
			else begin
			
				if(coeffSetFlag) begin
					enableFIRCoeff <= 1'd0;
				end
				
				dataIn <= dataInBuff[dataInCounter];
				dataInCounter <= dataInCounter + 8'd1;
			end
		end
		
		STOP: begin
			enableFIRCoeff <= 1'd0;
			startTest <= 1'd0;
			stopDataLoadFlag <= 1'd0;
			loadDataFlag <= 1'd0;
	
			dataIn <= 18'd0;
			dataInCounter <= 8'd0;
		end
		
		default: begin
			stateDut <= IDLE;
			enableFIRCoeff <= 1'd0;
			startTest <= 1'd0;
			stopDataLoadFlag <= 1'd0;
			loadDataFlag <= 1'd0;
	
			dataIn <= 18'd0;
			dataInCounter <= 8'd0;
		end	
	endcase
end


endmodule
