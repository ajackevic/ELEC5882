/*

 square_root_cal_tb.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
 This module is a test bench for the module square_root_cal. Values for dataInRe are sent 
 from the set buffer in the inital begin block, with the obtained values then stored, and 
 compared with the expected values. The scripts results are then printed in the scripts 
 transcript.

*/



// Setting the time unit for this module.
`timescale 1 ns/100 ps


module square_root_cal_tb;



// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 1000000;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;



// Parameters for the dur module. 
// INPUT_DATA_WIDTH = (log2(2 * MaxValue^2))) rounded up. Has to be an even number.
// OUTPUT_DATA_WIDTH = INPUT_DATA_WIDTH / 2.
localparam INPUT_DATA_WIDTH = 32;  
localparam OUTPUT_DATA_WIDTH = 16;



// Local parameters for the dut module.
reg clock;
reg enableModule;
reg [INPUT_DATA_WIDTH - 1:0] dataIn;
wire [OUTPUT_DATA_WIDTH - 1:0] dataOut;


// Local parameters used for the test bench.
reg signed [INPUT_DATA_WIDTH - 1:0] dataInBuff[0:9];
reg signed [INPUT_DATA_WIDTH:0] obtainedDataOutBuff [0:9];
reg signed [INPUT_DATA_WIDTH:0] expectedDataOutBuff [0:9];
reg [3:0] counter;
reg testFailedFlag;


// FSM
reg [1:0] state;
localparam IDLE = 0;
localparam SEND_DATA = 1;
localparam PRINT_RESULTS = 2;
localparam STOP = 3;





// Setting the init values.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	testFailedFlag = 1'd0;
	dataIn = 32'd0;
	counter = 4'd0;
	state = IDLE;
	
	
	
	// Setting the values of dataIn buffer.
	dataInBuff[0] = 32'd45646;
	dataInBuff[1] = 32'd454536;
	dataInBuff[2] = 32'd258211;
	dataInBuff[3] = 32'd4294967295;
	dataInBuff[4] = 32'd25810;
	dataInBuff[5] = 32'd4;
	dataInBuff[6] = 32'd5688;
	dataInBuff[7] = 32'd86542;
	dataInBuff[8] = 32'd0;
	dataInBuff[9] = 32'd123;

	
	
	// Setting the expected values in the buffer.
	expectedDataOutBuff[0] = 16'd213;
	expectedDataOutBuff[1] = 16'd674;
	expectedDataOutBuff[2] = 16'd508;
	expectedDataOutBuff[3] = 16'd65535;
	expectedDataOutBuff[4] = 16'd160;
	expectedDataOutBuff[5] = 16'd2;
	expectedDataOutBuff[6] = 16'd75;
	expectedDataOutBuff[7] = 16'd294;
	expectedDataOutBuff[8] = 16'd0;
	expectedDataOutBuff[9] = 16'd11;

	
	
	// Set enableModule high after RST_CYCLES number of clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end





// Instantiating the dut module.
square_root_cal #(
	.INPUT_DATA_WIDTH		(INPUT_DATA_WIDTH),
	.OUTPUT_DATA_WIDTH	(OUTPUT_DATA_WIDTH)
) dut (
	.clock					(clock),
	.enable					(enableModule),
	.inputData				(dataIn),
	
	.outputData				(dataOut)
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
	
	
		// State IDLE. This state waits until enableModule is set high before transistioning to SEND_DATA.
		IDLE: begin
			if(enableModule) begin
				state = SEND_DATA;
			end
		end

		
		// State SEND_DATA. This state sends dataIn from the buffer using the counter variable, stores the corresponding output
		// values in a buffer, and finally checks if the obtained value is equal to the expected value. If the obtained value is 
		// not equal to the expected value set the flag testFailedFlag high. 
		SEND_DATA: begin
		
			// When counter is equal to 12, transistion to the state PRINT_RESULTS and set counter to 0.
			if(counter == 4'd12) begin
				state = PRINT_RESULTS;
				counter = 4'd0;
			end
			
			
			// If counter is less than or equal to 9, send the corresponding buffer values to dataIn, else set dataIn to 0.
			if(counter <= 4'd9) begin
				dataIn = dataInBuff[counter];
			end
			else begin
				dataIn = 72'd0;
			end
			
			// The dut module takes 2 clock cycle to output values, hence only store the dataOut to the obtained buffer values
			// after 2 clock cycles. One stored then check if the obtained values if equal to the expected value, if not set the 
			// flag testFailedFlag high.
			if(counter > 1) begin
				obtainedDataOutBuff[counter - 5'd2] = dataOut;
				
				if(obtainedDataOutBuff[counter] != expectedDataOutBuff[counter]) begin
					testFailedFlag = 1'd1;
				end
			end
			
			// Increment counter by 1.
			counter = counter + 4'd1;
		
		end
		
		
		// State PRINT_RESULTS. This state is responsiabe for printing the transcript of the test bench.
		PRINT_RESULTS: begin
			$display("This is a test bench for the module sqaure_root_cal. \n \n",
						"It tests whether the non-restoring square root algorithm performs its main opperation correctly. \n",
						"Data is supplied to the module, with the corresponding output then being checked with the expected \n",
						"outputs obtained from MATLAB. Additionally the expected outputs were also worked out by hand to confirm \n", 
						"the MATLAB results. \n \n"
			);
			
			// Check if testFailedFlag is high, is so print the test failed, else it passed.
			if(testFailedFlag) begin
				$display("Test results: FAILED \n \n");
			end
			else begin
				$display("Test results: PASSED \n \n");
			end
			
			
			// Display all the expected and aquired results.
			for (n = 0; n <= 9; n = n + 1) begin
				$display("Data Out:     %d   Expected Value:%d   Obtained Value:%d", n+1, expectedDataOutBuff[n], obtainedDataOutBuff[n]);
			end
			
			state = STOP;
		end
		
		
		// State STOP. This state stops the simulation.
		STOP: begin
			$stop;
		end
		
		
		// State default. This state is added just incase ther FSM is in an unkown state.
		default: begin
			clock = 1'd0;
			enableModule = 1'd0;
			testFailedFlag = 1'd0;
			dataIn = 72'd0;
			counter = 4'd0;
			state = IDLE;
		end
		
	endcase
end



endmodule
