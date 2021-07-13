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
reg [2:0] state;
localparam IDLE = 0;
localparam ENABLE_COEFF = 1;
localparam FIR_MAIN = 2;
localparam CHECK_RESULTS = 3;
localparam STOP = 4;
localparam EMPTY_STATE = 5;
localparam EMPTY_STATE = 6;
localparam EMPTY_STATE = 7;





// Connecting the coeff for the FIR module.
setup_FIR_coeff #(
	.LENGTH 				(LENGTH),
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
	.loadDataFlag			(loadDataFlag),
	.coeffSetFlag			(coeffSetFlag),
	.stopDataLoadFlag 	(stopDataLoadFlag),
	.coeffIn					(coeffOut),
	.dataIn					(dataIn),
	
	
	.dataOut 				(dataOut)
);




// Set the init values of the local parameters.
initial begin
	startTest = 1'd0;
	stopDataLoadFlag = 1'd0;
	dataIn = 0;
	loadDataFlag = 1'd0;
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
	dataInBuff[44] <= 18'd999
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
	case(state) begin
		IDLE: begin
			if(startTest) begin
				state <= ENABLE_COEFF;
			end
		end
		
		ENABLE_COEFF: begin
			enableFIRCoeff <= 1'd1;
			state <= FIR_MAIN;
		end
		
		FIR_MAIN: begin
		
		end
		
		STOP: begin
		
		end
		
		default: begin
		
		end	
	endcase
end


endmodule
