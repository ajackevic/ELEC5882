/*

 absolute_value_tb.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
 This module is a test bench for the module absolute_value. Values for dataInRe are sent 
 from the set buffer in the inital begin block, with the obtained values then stored, and 
 compared with the expected values. The scripts results are then printed in the scripts 
 transcript.

*/



// Setting the time unit for this module.
`timescale 1 ns/100 ps

module absolute_value_tb;



// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 1000000;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

// Parameter for the dut module.
localparam DATA_WIDTH = 18;




// Local parameters for the dut module.
reg clock;
reg enableModule;
reg signed [DATA_WIDTH - 1:0] dataInRe;
reg signed [DATA_WIDTH - 1:0] dataInIm;
wire signed [DATA_WIDTH:0] dataOut;



// Local parameters used for test purposes.
reg testFailedFlag;
reg [4:0] counter;
reg signed [DATA_WIDTH - 1:0] dataInBuffRe[0:19];
reg signed [DATA_WIDTH - 1:0] dataInBuffIm[0:19];
reg signed [DATA_WIDTH:0] obtainedDataOutBuff [0:19];
reg signed [DATA_WIDTH:0] expectedDataOutBuff [0:19];


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
	dataInRe = 18'd0;
	dataInIm = 18'd0;
	state = IDLE;
	counter = 5'd0;
	testFailedFlag = 1'd0;
	
	
	// Set the dataIn values to the buffer.
	dataInBuffRe[0] = 18'd59;
	dataInBuffIm[0] = 18'd15683;
	dataInBuffRe[1] = 18'd15683;
	dataInBuffIm[1] = -18'd15696;
	dataInBuffRe[2] = -18'd15696;
	dataInBuffIm[2] = -18'd111111;
	dataInBuffRe[3] = -18'd111111;
	dataInBuffIm[3] = -18'd131000;
	dataInBuffRe[4] = -18'd131000;
	dataInBuffIm[4] = 18'd69420;
	dataInBuffRe[5] = 18'd69420;
	dataInBuffIm[5] = -18'd12363;
	dataInBuffRe[6] = -18'd12363;
	dataInBuffIm[6] = -18'd123456;
	dataInBuffRe[7] = -18'd123456;
	dataInBuffIm[7] = -18'd123456;
	dataInBuffRe[8] = 18'd65432;
	dataInBuffIm[8] = 18'd10101;
	dataInBuffRe[9] = 18'd10101;
	dataInBuffIm[9] = 18'd5786;
	dataInBuffRe[10] = 18'd5786;
	dataInBuffIm[10] = -18'd9989;
	dataInBuffRe[11] = -18'd9989;
	dataInBuffIm[11] = -18'd45876;
	dataInBuffRe[12] = -18'd45876;
	dataInBuffIm[12] = 18'd0;
	dataInBuffRe[13] = 18'd0;
	dataInBuffIm[13] = -18'd123;
	dataInBuffRe[14] = -18'd123;
	dataInBuffIm[14] = -18'd9989;
	dataInBuffRe[15] = 18'd513;
	dataInBuffIm[15] = -18'd3516;
	dataInBuffRe[16] = -18'd230;
	dataInBuffIm[16] = -18'd334;
	dataInBuffRe[17] = -18'd9879;
	dataInBuffIm[17] = 18'd1793;
	dataInBuffRe[18] = 18'd12;
	dataInBuffIm[18] = -18'd78;
	dataInBuffRe[19] = 18'd0;
	dataInBuffIm[19] = -18'd1357;
	
	
	
	// Setting the expected values to the buffer.
	expectedDataOutBuff[0] = 18'd15697;
	expectedDataOutBuff[1] = 18'd19616;
	expectedDataOutBuff[2] = 18'd115035;
	expectedDataOutBuff[3] = 18'd158777;
	expectedDataOutBuff[4] = 18'd148355;
	expectedDataOutBuff[5] = 18'd72510;
	expectedDataOutBuff[6] = 18'd126546;
	expectedDataOutBuff[7] = 18'd154320;
	expectedDataOutBuff[8] = 18'd67957;
	expectedDataOutBuff[9] = 18'd11547;
	expectedDataOutBuff[10] = 18'd11435;
	expectedDataOutBuff[11] = 18'd48373;
	expectedDataOutBuff[12] = 18'd45876;
	expectedDataOutBuff[13] = 18'd123;
	expectedDataOutBuff[14] = 18'd10019;
	expectedDataOutBuff[15] = 18'd3644;
	expectedDataOutBuff[16] = 18'd391;
	expectedDataOutBuff[17] = 18'd10327;
	expectedDataOutBuff[18] = 18'd81;
	expectedDataOutBuff[19] = 18'd1357;
	
	


	//Set enableModule high after RST_CYCLES clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end






// Instantiating the dut module.
absolute_value #(
	.DATA_WIDTH 	(DATA_WIDTH)
) dut (
	.clock			(clock),
	.enable			(enableModule),
	.dataInRe		(dataInRe),
	.dataInIm		(dataInIm),
	
	.dataOut			(dataOut)
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




// Always block for sending data, checking output, and printing the test results of the test bench.
integer n;
always @(posedge clock) begin
	case(state)
	
		// State IDLE. This state waits till the variable enableModule is high before transistioning to the state SEND_DATA.
		IDLE: begin
			if(enableModule) begin
				state = SEND_DATA;
			end
		end
		
			
		// State SEND_DATA. This state sends dataIn from the buffer using the counter variable, stores the corresponding output
		// values in a buffer, and finally checks if the obtained value is equal to the expected value. If the obtained value is 
		// not equal to the expected value set the flag testFailedFlag high. 
		SEND_DATA: begin
			// When counter is equal to 22, reset the variable and then transistion to the state PRINT_RESULTS.
			if(counter == 5'd22) begin
				state = PRINT_RESULTS;
				counter = 5'd0;
			end
			
			// If counter is less than or equal to 19, send the corresponding buffer values to dataIn, else set dataIn to 0.
			if(counter <= 5'd19) begin
				dataInRe = dataInBuffRe[counter];
				dataInIm = dataInBuffIm[counter];
			end
			else begin
				dataInRe = 18'd0;
				dataInIm = 18'd0;
			end
			
			
			// The dut module takes 2 clock cycle to output values, hence only store the dataOut to the obtained buffer values
			// after 2 clock cycles. One stored then check if the obtained values if equal to the expected value, if not set the 
			// flag testFailedFlag high.
			if(counter > 5'd1) begin
				obtainedDataOutBuff[counter - 5'd2] = dataOut;
				
				if(obtainedDataOutBuff[counter] != expectedDataOutBuff[counter]) begin
					testFailedFlag = 1'd1;
				end
				
			end
			
			// Increment counter by 1.
			counter = counter + 5'd1;
		end

		
		// State PRINT_RESULTS. This state is responsiabe for printing the transcript of the test bench.
		PRINT_RESULTS: begin
			$display("This is a test bench for the module absolute_value. \n \n",
						"It tests whether the abs module alpha max plus beta min performs its main opperation correctly. \n",
						"Data is supplied to the module, with the corresponding output then being checked with the expected \n",
						"outputs obtained from MATLAB. \n \n"
			);
			
			// Check if testFailedFlag is high, is so print the test failed, else it passed.
			if(testFailedFlag) begin
				$display("Test results: FAILED \n \n");
			end
			else begin
				$display("Test results: PASSED \n \n");
			end
			
			
			// Display all the expected and aquired results.
			for (n = 0; n <= 19; n = n + 1) begin
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
			enableModule = 1'd0;
			dataInRe = 18'd0;
			dataInIm = 18'd0;
			counter = 5'd0;
			testFailedFlag = 1'd0;
		end
	endcase
end

endmodule
