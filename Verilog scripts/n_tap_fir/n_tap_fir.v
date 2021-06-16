/*

 n_tap_fir.v
 --------------
 By: Augustas Jackevic
 Date: February 2021

 Module Description:
 -------------------
 This module is a design of an n-type FIR (Finite Impulse Response)
 filter. This filter is the convolution operation between the
 input data (dataIn) and the coefficient data (coefficientIn). The
 default LENGTH is 10. It should be noted, to help understand the workings
 of the FIR_MAIN state, the PDF in:
 The workings of an FIR filter\The workings of a FIR filter.pdf should be read.

*/

module n_tap_fir #(
	parameter LENGTH = 20,
	parameter DATA_WIDTH = 8
)(
	input clock,
	input loadDataFlag,
	input stopDataLoadFlag,
	input signed [DATA_WIDTH - 1:0] dataIn,
	
	output reg signed [18:0] dataOut
);


// Creating the internal buffers for the coefficients and data in,
reg signed [DATA_WIDTH - 1:0] coeffBuffer [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] inputDataBuffer [0:LENGTH -1];

// Coefficient counter. Filter will only for 1023 ((2^10)-1) taps.
reg [9:0] coeffCounter;

// Local parameter to store the FIR filters output.
// FIR output width = input data width + coefficient width + log2(LENGTH)
reg signed [18:0] firOutput;

reg loadCoefficients;
wire coefficientsSetFlag;
wire signed [DATA_WIDTH - 1:0] coefficientIn;



// FSM states
reg [2:0] state;
reg [2:0] IDLE = 3'd0;
reg [2:0] LOAD_COEFFICIENTS = 3'd1;
reg [2:0] FIR_MAIN = 3'd2;
reg [2:0] STOP = 3'd3;
reg [2:0] EMPTY_STATE1 = 3'd4;
reg [2:0] EMPTY_STATE2 = 3'd5;
reg [2:0] EMPTY_STATE3 = 3'd6;
reg [2:0] EMPTY_STATE4 = 3'd7;



// Setting the initial values.
initial begin : initalValues

	// Set all the values inside the coeffBuffer to 0.
	integer k;
	for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
		coeffBuffer[k] <= 0;
		inputDataBuffer[k] <= 0;
	end

	// Set the internal variables and outputs to 0.
	state <= IDLE;
	coeffCounter <= 0;
	loadCoefficients <= 0;
	dataOut <= 0;
	firOutput <= 0;
	
end


// Instantiating the setup of the coefficient module. This module passes the LENGTH 
// amount of coefficients through coefficientOut.
setupCoefficients #(
	.LENGTH 			 (LENGTH),
	.DATA_WIDTH 	 (DATA_WIDTH)
)Coefficients(
	.clock			 (clock),
	.enable			 (loadCoefficients),
	
	.filterSetFlag	 (coefficientsSetFlag),
	.coefficientOut (coefficientIn)
);




integer n;
always @(posedge clock) begin
	case(state)
	
	
		// State IDLE. This checks the loadCoefficientsFlag value and only
		// transition to state LOAD_COEFFICIENTS when the flag is high.
		IDLE: begin
			
			state <= LOAD_COEFFICIENTS;

		end
		
		
		
		// State LOAD_COEFFICIENTS. This state is responsiable for loading the
		// coefficients to coeffBuffer. Once all the coefficients are loaded the
		// state transitions to FIR_MAIN.
		LOAD_COEFFICIENTS: begin
			
			loadCoefficients <= 1'd1;
		
			// A for loop that shifts the values inside coeffBuffer by 1 position.
			for (n = LENGTH - 1; n > 0; n = n - 1) begin
				coeffBuffer[n] <= coeffBuffer[n-1];
			end

			// Load the new coefficient value to the start of coeffBuffer.
			coeffBuffer[0] <= coefficientIn;
			coeffCounter <= coeffCounter + 10'd1;

			
			if(coefficientsSetFlag) begin
				state <= FIR_MAIN;
				loadCoefficients <= 1'd0;
			end
		end
		
		
		// State FIR_MAIN. This state is responsiable for the main FIR opperation. It follows
		// the logic outlined in the pdf "The workings of a FIR filter".
		FIR_MAIN: begin
		
			// If the data input stream is ready, do the following.
			if(loadDataFlag == 1) begin
				//Shift the values inside inputDataBuffer by 1.
				for (n = LENGTH - 1; n > 0; n = n - 1) begin
					inputDataBuffer[n] <= inputDataBuffer[n - 1];
				end

				// Load the new dataIn value to the start of inputDataBuffer.
				inputDataBuffer[0] <= dataIn;
			
				// firOutput is set to 0, as everytime FIR_MAIN loops, previous firOutput value is used, hence the first
				// firOutput value that is used in the for loop would not be of the correct value.
				firOutput = 0;
				// A multiplication between the input data and the corresponding coefficients
				// in the delayed buffer line. This for loop also sums all the components together.
				for (n = 0; n <= LENGTH - 1; n = n + 1) begin
					firOutput = firOutput + (inputDataBuffer[n] * coeffBuffer[LENGTH - 1 - n]);
				end
			end

			// Load the output of the FIR to the output reg of the module, dataOut.
			dataOut = firOutput;
			
			// Transition to stop state when stopDataLoadFlag is 1.
			if(stopDataLoadFlag == 1) begin
				state <= STOP;
			end
		end
		

		
		STOP: begin
			state <= IDLE;
		end
		
		
		// Empty states that transition to IDLE. These are added to remove any infered latched by Quartus 
		// for the FSM.
		EMPTY_STATE1: begin
			state <= IDLE;
		end
		EMPTY_STATE2: begin
			state <= IDLE;
		end
		EMPTY_STATE3: begin
			state <= IDLE;
		end
		EMPTY_STATE4: begin
			state <= IDLE;
		end
		
		
		// State default. This state is added just incase the FSM is in an unknown state, it resets all
		// all the local parameter and sets state to IDLE.
		default: begin: defaultValues
			// Set all the values inside the coeffBuffer to 0.
			integer k;
			for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
				coeffBuffer[k] <= 0;
				inputDataBuffer[k] <= 0;
			end

			// Set the internal variables and outputs to 0.
			state <= IDLE;
			coeffCounter <= 0;
			dataOut <= 0;
			firOutput <= 0;
		end

	endcase

end



endmodule
