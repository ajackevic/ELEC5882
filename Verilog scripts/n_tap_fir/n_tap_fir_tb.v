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
localparam DATA_WIDTH = 8;




//
// Creating the local parameters.
//
reg clock;
reg startTest;

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
	
	repeat(RST_CYCLES) @ (posedge clock);
	startTest = 1'd1;
end



// Set the initial value of the clock.
initial begin
	clock <= 0;
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
		
		default: begin
		
		end	
	endcase
end


endmodule
