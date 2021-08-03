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
reg [31:0] MIFBuffer [0:14399];

// Creating the local parameters for the testing purposes.
reg [13:0] MIFCounter;
reg [31:0] outputBuffer [0:14399];
reg testFailedFlag;




// FSM
reg [1:0] state;
localparam IDLE = 0;
localparam COMAPRE_DATA = 1;
localparam PRINT_RESULTS = 2;
localparam STOP = 3;




// Set the initial value of the clock.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	testFailedFlag = 1'd0;
	state = IDLE;
	MIFCounter = 14'd0;
	
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
			if(enableModule) begin
				repeat(13) @ (posedge clock);
				state = COMAPRE_DATA;
			end
		end
		
		COMAPRE_DATA: begin
			outputBuffer[MIFCounter] = MFOutput;
			if(outputBuffer[MIFCounter] != MIFBuffer[MIFCounter]) begin
				testFailedFlag = 1'd1;
			end
			
			MIFCounter = MIFCounter + 14'd1;
			
			if(MIFCounter == 14'd14400) begin
				state = PRINT_RESULTS;
			end
		end
		
		PRINT_RESULTS: begin
			$display("This is a test bench for the module matched_filter. \n",
						"It tests whether the output of the pulse compression filter \n",
						"is the same as the obtained output from the MATLAB implmentation. \n \n"
			);
			
			// Check if testFailedFlag is high, is so print the test failed, else it passed.
			if(testFailedFlag) begin
				$display("Test results: FAILED \n \n");
			end
			else begin
				$display("Test results: PASSED \n \n");
			end

			
			state = STOP;
		end
		
		STOP: begin
			$stop;
		end
		
		default: begin
			clock = 1'd0;
			enableModule = 1'd0;
			testFailedFlag = 1'd0;
			state = IDLE;
			MIFCounter = 14'd0;
		end	
	
	endcase
end

endmodule
