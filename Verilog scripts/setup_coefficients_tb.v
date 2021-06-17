/*

 setup_coefficients_tb.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module is a test bench for the script setupCoefficients.v. It tests wheather the set 
 coefficients of the DUT are outputted in the correct manner and if they are of the correct values.
 
 
*/


module setup_coefficients_tb;


// Parameters for creating the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;



// Parameters for the dut module.
localparam LENGTH = 20;
localparam DATA_WIDTH = 8;



// Local parameters for the dut module.
reg clock;
reg enableModule; 
wire filterSetFlag;
wire signed [DATA_WIDTH-1:0] coefficientOut;



// Local parameters for interacting with the dut output.
// Counter length should be log2(LENGTH).
reg [4:0] coefficientCounter;
reg signed [DATA_WIDTH - 1:0] expectedOutputs [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] obtainedValues [0:LENGTH - 1];
reg testFailedFlag;




// FSM states.
reg [1:0] state;
localparam [1:0] IDLE = 2'd0;
localparam [1:0] CHECK_COEFFICIENTS = 2'd1;
localparam [1:0] DISPLAY_RESULTS = 2'd2;
localparam [1:0] STOP = 2'd3;



// Set the initial value of the clock.
initial begin : init_values
	// Set all the values inside the buffer obtainedValues to 0.
	integer k;
	for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
		obtainedValues[k] = 0;
	end
	
	// Setting the local variables in the module to 0.
	clock = 0;
	enableModule = 0;
	testFailedFlag = 0;
	state = IDLE;
	coefficientCounter = 5'd0;
	
	// Set the expected outputs. Make sure all values (from 0 to LENGTH -1) of the array are covered.
	expectedOutputs[0] = 8'd34;
	expectedOutputs[1] = 8'd34;
	expectedOutputs[2] = 8'd0;
	expectedOutputs[3] = 8'd49;
	expectedOutputs[4] = 8'd125;
	expectedOutputs[5] = -8'd77;
	expectedOutputs[6] = -8'd51;
	expectedOutputs[7] = 8'd8;
	expectedOutputs[8] = 8'd98;
	expectedOutputs[9] = 8'd109;
	expectedOutputs[10] = -8'd91;
	expectedOutputs[11] = -8'd3;
	expectedOutputs[12] = 8'd9;
	expectedOutputs[13] = 8'd1;
	expectedOutputs[14] = 8'd59;
	expectedOutputs[15] = 8'd75;
	expectedOutputs[16] = 8'd19;
	expectedOutputs[17] = 8'd58;
	expectedOutputs[18] = -8'd97;
	expectedOutputs[19] = 8'd10;
	
	// Set enableModule to 1 after RST_CYCLES clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end




// Instantiating the module setupCoefficients.
setupCoefficients # (
	.LENGTH				(LENGTH),
	.DATA_WIDTH			(DATA_WIDTH)
) dut (
	.clock				(clock),
	.enable				(enableModule),
	
	.filterSetFlag		(filterSetFlag),
	.coefficientOut	(coefficientOut)
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




// Checking and outputted coefficients and then displaying the test script transcript results.
integer n;
always @ (posedge clock) begin
	case(state)
	
		// State IDLE. This state waits until enableModule is set before transistioning to CHECK_COEFFICIENTS.
		IDLE: begin
			if(enableModule) begin
				state <= CHECK_COEFFICIENTS;
			end
		end
		
		
		// State CHECK_COEFFICIENTS. This state stores the obtained coefficients, checks if the obtained
		// coefficient is equal to the expect values and finally transistioning to state DISPLAY_RESULTS
		// once all the coefficients are checked.
		CHECK_COEFFICIENTS: begin
		
			// Store the obtained coefficient outputs to the variable obtainedValues.
			obtainedValues[coefficientCounter] = coefficientOut;
			
			// Check if the current coefficient is equal to the expected coefficient values. If they are 
			// not identical set testFailedFlag high.
			if(coefficientOut != expectedOutputs[coefficientCounter]) begin
				testFailedFlag = 1'd1;
			end
			
			// Increment coefficientCounter.
			coefficientCounter = coefficientCounter + 5'd1;
			
			// Once all the coefficient are checked, transistion to DISPLAY_RESULTS.
			if(coefficientCounter == LENGTH) begin
				state = DISPLAY_RESULTS;
			end
		end
		
		
		// State DISPLAY_RESULTS. This state is reponsiable for displaying the transcript results of the 
		// test bench. Once displayed, it will transistion to state STOP.
		DISPLAY_RESULTS: begin
			$display("This is a test script for the module setupCoefficients. \n",
						"It tests wheather the set coefficients of the DUT are outputted in the \n",
						"correct manner and if they are of the correct values. \n \n",
			);
		
			if(testFailedFlag) begin
				$display("Test results: FAILED \n \n");
			end
			else begin
				$display("Test results: PASSED \n \n");
			end
			
			// Display all expected and the obtained coefficient values.
			for (n = 0; n <= LENGTH - 1; n = n + 1) begin
				$display("Coefficient:%d   Expected Value:%d   Obtained Value:%d \n", n+1, expectedOutputs[n], obtainedValues[n]);
			end
			
			// Transistion to state STOP.
			state = STOP;
		end
		
		
		// State STOP. This state is responsiable stoping the simulation.
		STOP: begin
			$stop;
		end
		
		
		// Reseting all the values of the local variables. This default state is added just incase the FSM
		// is in an unkown state.
		default: begin
		
			for (n = 0; n <= LENGTH - 1 ; n = n + 1) begin
				obtainedValues[n] = 0;
			end
		
			enableModule = 0;
			testFailedFlag = 0;
			state = IDLE;
			coefficientCounter = 5'd0;
			state = IDLE;
		end
	endcase
end



endmodule
