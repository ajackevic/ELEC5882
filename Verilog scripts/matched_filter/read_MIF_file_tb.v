/*

 read_MIF_file_tb.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module is a test bench for the module setup_MF_coeff. It connects to the instantiated 
 module. The test bench as of now does not do any self-testing, only observing the signals 
 in ModelSim. It is vital that the MIF file is placed in <project directory>\simulation\modelsim, 
 otherwise ModelSim will no read the MIF data. To compile successfully in Quartus have a copy
 of the MIF file in <project directory>\ELEC5882\Verilog scripts\matched_filter too.
 
 Set DATA_TYPE to 1 to load the coeff and 2 to load the input data.


*/



// Setting the time unit for this module.
`timescale 1 ns/100 ps


module read_MIF_file_tb;




// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 1000000;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

// Parameters for the dut module.
localparam LENGTH = 800;
localparam DATA_WIDTH = 12;




// Local parameters for the dut module.
reg clock;
reg enableModule;
wire signed [DATA_WIDTH-1:0] outputValueRe;
wire signed [DATA_WIDTH-1:0] outputValueIm;
wire dataFinishedFlag;



// Local parameters for the test bench.
reg signed [DATA_WIDTH - 1: 0] obtainedOutBuffRe [0:9];
reg signed [DATA_WIDTH - 1: 0] obtainedOutBuffIm [0:9];
reg signed [DATA_WIDTH - 1: 0] expectedOutBuffRe [0:9];
reg signed [DATA_WIDTH - 1: 0] expectedOutBuffIm [0:9];
reg [9:0] MIFCounter;
reg [4:0] counter;
reg testFailedFlag;




// FSM
reg [1:0] state;
localparam IDLE = 0;
localparam READ_DATA = 1;
localparam PRINT_RESULTS = 2;
localparam STOP = 3;



// Setting the init values.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	counter = 5'd0;
	MIFCounter = 10'd0;
	testFailedFlag = 1'd0;
	state = IDLE;
	
	
	
	expectedOutBuffRe[0] = 12'd1026;
	expectedOutBuffIm[0] = 12'd1769;
	expectedOutBuffRe[1] = 12'd3;
	expectedOutBuffIm[1] = 12'd2046;
	expectedOutBuffRe[2] = -12'd1022;
	expectedOutBuffIm[2] = 12'd1516;
	expectedOutBuffRe[3] = -12'd1451;
	expectedOutBuffIm[3] = 12'd424;
	expectedOutBuffRe[4] = -12'd1037;
	expectedOutBuffIm[4] = -12'd659;
	expectedOutBuffRe[5] = 12'd1377;
	expectedOutBuffIm[5] = -12'd58;
	expectedOutBuffRe[6] = 12'd1410;
	expectedOutBuffIm[6] = 12'd130;
	expectedOutBuffRe[7] = 12'd1433;
	expectedOutBuffIm[7] = 12'd358;
	expectedOutBuffRe[8] = 12'd1446;
	expectedOutBuffIm[8] = 12'd624;
	expectedOutBuffRe[9] = 12'd1451;
	expectedOutBuffIm[9] = 12'd1082;
	
	
	
	// Set enableModule to 1 after RST_CYCLES clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end




// Connecting the instantiated dut module.
read_MIF_file #(
	.LENGTH 				(LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH),
	.DATA_TYPE			(1)

) dut (
	.clock				(clock),
	.enable				(enableModule),
	
	.dataFinishedFlag	(dataFinishedFlag),
	.outputRe			(outputValueRe),
	.outputIm			(outputValueIm)
);




// Clock parameters.
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




integer n;
always @ (posedge clock) begin
	case(state)
		
		
		IDLE: begin
			if(enableModule) begin
				state = READ_DATA;
			end
		end
		
		READ_DATA: begin
			
			if(MIFCounter >= 10'd1) begin
				if((MIFCounter <= 10'd5) || (MIFCounter >= 10'd796)) begin
				
				
					obtainedOutBuffRe[counter] = outputValueRe;
					obtainedOutBuffIm[counter] = outputValueIm;
				
				
					if((obtainedOutBuffRe[counter] != expectedOutBuffRe[counter]) || (obtainedOutBuffIm[counter] != expectedOutBuffIm[counter])) begin
						testFailedFlag = 1'd1;
					end
				
					counter = counter + 5'd1;
				end
			end
			
			
			if(MIFCounter == 10'd800) begin
				state = PRINT_RESULTS;
				counter = 5'd0;
			end
			
			
			MIFCounter = MIFCounter + 10'd1;
		end
		
		PRINT_RESULTS: begin
			$display("This is a test bench for the module read_MIF_file. \n \n",
						"It tests whether the first and last 5 values of the MIF file are read correctly by comparing \n",
						"them to the expected values taken from MATLAB. \n \n"
			);
			
			// Check if testFailedFlag is high, is so print the test failed, else it passed.
			if(testFailedFlag) begin
				$display("Test results: FAILED \n \n");
			end
			else begin
				$display("Test results: PASSED \n \n");
			end
			
			
			// Display all the expected and aquired results.
			for (n = 0; n <= 4; n = n + 1) begin
				$display("MIF data value (real):     %d   Expected Value:%d   Obtained Value:%d", n+1, expectedOutBuffRe[n], obtainedOutBuffRe[n]);
				$display("MIF data value (imag):     %d   Expected Value:%d   Obtained Value:%d", n+1, expectedOutBuffIm[n], obtainedOutBuffIm[n]);
			end
			
			for (n = 0; n <= 4; n = n + 1) begin
				$display("MIF data value (real):     %d   Expected Value:%d   Obtained Value:%d", n+796, expectedOutBuffRe[n], obtainedOutBuffRe[n]);
				$display("MIF data value (imag):     %d   Expected Value:%d   Obtained Value:%d", n+796, expectedOutBuffIm[n], obtainedOutBuffIm[n]);
			end
			
			state = STOP;
		end
		
		STOP: begin
			$stop;
		end
		
		default: begin
			clock = 1'd0;
			enableModule = 1'd0;
			counter = 5'd0;
			MIFCounter = 10'd0;
			testFailedFlag = 1'd0;
		end
		
	endcase
end

endmodule
