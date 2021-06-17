/*

 setup_complex_coefficients_tb.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module is a test bench for the script setupComplexCoefficients.v. It tests wheather the set 
 coefficients of the DUT are outputted in the correct manner and if they are of the correct values.
 
 
*/

module setup_complex_coefficients_tb;


// Parameters for creating the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;



// Parameters for the dut module.
localparam LENGTH = 12;
localparam DATA_WIDTH = 8;



// Local parameters for the dut module.
reg clock;
reg enableModule; 
wire filterSetFlag;
wire signed [DATA_WIDTH-1:0] coefficientOutRe;
wire signed [DATA_WIDTH-1:0] coefficientOutIm;



// Local parameters for interacting with the dut output.
// Counter length should be log2(LENGTH).
reg [4:0] coefficientCounter;
reg signed [DATA_WIDTH - 1:0] expectedOutputsRe [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] expectedOutputsIm [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] obtainedValuesRe [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] obtainedValuesIm [0:LENGTH - 1];
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
		obtainedValuesRe[k] = 0;
		obtainedValuesIm[k] = 0;
	end
	
	// Setting the local variables in the module to 0.
	clock = 0;
	enableModule = 0;
	testFailedFlag = 0;
	state = IDLE;
	coefficientCounter = 5'd0;
	
	// Set the expected outputs. Make sure all values (from 0 to LENGTH -1) of the array are covered.
	expectedOutputsRe[0] <= 8'd3;
	expectedOutputsIm[0] <= 8'd7;
	expectedOutputsRe[1] <= 8'd2;
	expectedOutputsIm[1] <= 8'd0;
	expectedOutputsRe[2] <= 8'd17;
	expectedOutputsIm[2] <= 8'd5;
	expectedOutputsRe[3] <= 8'd0;
	expectedOutputsIm[3] <= -8'd3;
	expectedOutputsRe[4] <= 8'd55;
	expectedOutputsIm[4] <= -8'd103;
	expectedOutputsRe[5] <= 8'd120;
	expectedOutputsIm[5] <= -8'd111;
	expectedOutputsRe[6] <= 8'd123;
	expectedOutputsIm[6] <= -8'd24;
	expectedOutputsRe[7] <= 8'd56;
	expectedOutputsIm[7] <= 8'd96;
	expectedOutputsRe[8] <= -8'd99;
	expectedOutputsIm[8] <= -8'd32;
	expectedOutputsRe[9] <= -8'd109;
	expectedOutputsIm[9] <= -8'd76;
	expectedOutputsRe[10] <= 8'd23;
	expectedOutputsIm[10] <= -8'd14;
	expectedOutputsRe[11] <= -8'd60;
	expectedOutputsIm[11] <= 8'd10;
	
	// Set enableModule to 1 after RST_CYCLES clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end




// Instantiating the module.
setupComplexCoefficients # (
	.LENGTH				(LENGTH),
	.DATA_WIDTH			(DATA_WIDTH)
) dut (
	.clock				(clock),
	.enable				(enableModule),
	
	.filterSetFlag		(filterSetFlag),
	.coefficientOutRe	(coefficientOutRe),
	.coefficientOutIm	(coefficientOutIm)
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
		
			// Store the obtained coefficient outputs to the variable obtainedValues Re and Im.
			obtainedValuesRe[coefficientCounter] = coefficientOutRe;
			obtainedValuesIm[coefficientCounter] = coefficientOutIm;
			
			// Check if the current coefficient is equal to the expected coefficient values. If they are 
			// not identical set testFailedFlag high.
			if((coefficientOutRe != expectedOutputsRe[coefficientCounter]) | (coefficientOutIm != expectedOutputsIm[coefficientCounter])) begin
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
			$display("This is a test script for the module setupComplexCoefficients. \n",
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
				$display("Coefficient:%d   Expected Value:%d+j%d   Obtained Value:%d+j%d \n", n+1, expectedOutputsRe[n], expectedOutputsIm[n], obtainedValuesRe[n], obtainedValuesIm[n]);
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
				obtainedValuesRe[n] = 0;
				obtainedValuesIm[n] = 0;
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
