/*

 matched_filter_tb.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
 This module is a test bench for the module matched_filter_tb.v. The script
 as of now only enables the matched filter and observes the modules output in
 ModelSim.

*/


// Setting the time unit used in this module.
`timescale 1 ns/100 ps



module matched_filter_tb;


// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 500000;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 20;


// Creating the local parameters for the DUT module
localparam COEFF_LENGTH = 800;
localparam DATA_LENGTH = 7700;
localparam HT_COEFF_LENGTH = 27;
localparam DATA_WIDTH = 12;




// Creating the local parameters the DUT.
reg clock;
reg enableModule;
wire [31:0] MFOutput;

// Creating the local parameters for storing the MIF data.
reg [17:0] MIFBuffer [0:31];

// Creating the local parameters for the testing purposes.
reg [17:0] MIFCounter;
reg [17:0] outputBuffer [0:31];
reg testFailedFlag;




// FSM
reg [1:0] state;
localparam IDLE = 0;
localparam SEND_AND_COMAPRE = 1;
localparam PRINT_RESULTS = 2;
localparam STOP = 3;




// Set the initial value of the clock.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	testFailedFlag = 1'd0;
	state = IDLE;
	MIFCounter = 18'd0;
	
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end



// Transfer the data in the file MFOutputData.mif to MIFBuffer.
// This MIF file contains the expected output of the matched filter
// from the MATLAB simulation.
initial begin
	$readmemb("MFOutputData.mif", MIFBuffer);
end






// Instantiated DUT module.
 matched_filter #(
	.COEFF_LENGTH 		(COEFF_LENGTH),
	.DATA_LENGTH 		(DATA_LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH)
) dut (
	.clock				(clock),
	.enable				(enableModule),
	
	.MFOutput  		  (MFOutput)
);



// Calculating the parameters for the 50MHz clock.
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



always @ (posedge clock) begin
	case(state)
	
		IDLE: begin
		
		end
		
		SEND_AND_COMAPRE: begin
		
		end
		
		PRINT_RESULTS: begin
		
		end
		
		STOP: begin
		
		end
		
		default: begin
		
		end	
	
	endmodule
end

endmodule
