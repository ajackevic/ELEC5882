/*

 setup_complex_FIR_coeff_tb.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module is a test bench for the script setupComplexCoefficients.v. It tests wheather the set
 coefficients of the DUT are outputted in the correct manner and if they are of the correct values.


*/

module setup_complex_FIR_coeff_tb;


// Parameters for creating the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;



// Parameters for the dut module.
localparam LENGTH = 20;
localparam DATA_WIDTH = 18;



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
	expectedOutputsRe[0] <= 18'd34124;
	expectedOutputsIm[0] <= -18'd7392;
	expectedOutputsRe[1] <= 18'd34124;
	expectedOutputsIm[1] <= 18'd15;
	expectedOutputsRe[2] <= 18'd0;
	expectedOutputsIm[2] <= 18'd89998;
	expectedOutputsRe[3] <= 18'd4991;
	expectedOutputsIm[3] <= -18'd43211;
	expectedOutputsRe[4] <= 18'd12522;
	expectedOutputsIm[4] <= -18'd131072;
	expectedOutputsRe[5] <= -18'd7711;
	expectedOutputsIm[5] <= 18'd131071;
	expectedOutputsRe[6] <= -18'd5151;
	expectedOutputsIm[6] <= 18'd5151;
	expectedOutputsRe[7] <= 18'd81122;
	expectedOutputsIm[7] <= 18'd81122;
	expectedOutputsRe[8] <= 18'd9890;
	expectedOutputsIm[8] <= 18'd0;
	expectedOutputsRe[9] <= 18'd1091;
	expectedOutputsIm[9] <= 18'd882;
	expectedOutputsRe[10] <= -18'd9111;
	expectedOutputsIm[10] <= -18'd9;
	expectedOutputsRe[11] <= -18'd10369;
	expectedOutputsIm[11] <= 18'd8982;
	expectedOutputsRe[12] <= 18'd911;
	expectedOutputsIm[12] <= -18'd119;
	expectedOutputsRe[13] <= 18'd1121;
	expectedOutputsIm[13] <= 18'd6969;
	expectedOutputsRe[14] <= 18'd591;
	expectedOutputsIm[14] <= -18'd666;
	expectedOutputsRe[15] <= 18'd7590;
	expectedOutputsIm[15] <= 18'd8422;
	expectedOutputsRe[16] <= 18'd19;
	expectedOutputsIm[16] <= -18'd19223;
	expectedOutputsRe[17] <= 18'd5811;
	expectedOutputsIm[17] <= -18'd131072;
	expectedOutputsRe[18] <= -18'd970;
	expectedOutputsIm[18] <= -18'd9790;
	expectedOutputsRe[19] <= 18'd10000;
	expectedOutputsIm[19] <= 18'd1;
	// Set enableModule to 1 after RST_CYCLES clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end




// Instantiating the module.
setup_complex_FIR_coeff # (
	.LENGTH				(LENGTH),
	.DATA_WIDTH			(DATA_WIDTH)
) dut (
	.clock				(clock),
	.enable				(enableModule),

	.coeffSetFlag		(filterSetFlag),
	.coeffOutRe			(coefficientOutRe),
	.coeffOutIm			(coefficientOutIm)
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
