/*

 n_tap_complex_fir.v
 --------------
 By: Augustas Jackevic
 Date: February 2021

 Module Description:
 -------------------
 This module is a design of an n-type complex FIR (Finite Impulse Response)
 filter. This filter is the convolution operation between the complex
 input data (dataIn) and the complex coefficient data (coefficientIn). The
 default LENGTH is 12. The FIR filter can be used to do the convolution operation.
 For this script, the convolution operation is of two inputs, data_in and coefficient_in.
 It should be noted, to help understand the workings of the FIR_MAIN state, the PDF in:
 The workings of an FIR filter\The workings of a complex FIR filter.pdf should be read.

*/

module n_tap_complex_fir #(
	parameter LENGTH = 12,
	parameter DATA_WIDTH = 8
)(
	input clock,
	input loadCoeff,
	input coeffSetFlag,
	input loadDataFlag,
	input stopDataLoadFlag,
	input signed [(DATA_WIDTH * 3) - 1:0] dataInRe,
	input signed [(DATA_WIDTH * 3) - 1:0] dataInIm,
	input signed [DATA_WIDTH - 1:0] coeffInRe,
	input signed [DATA_WIDTH - 1:0] coeffInIm,
	
	output reg signed [(DATA_WIDTH * 4) - 1:0] dataOutRe,
	output reg signed [(DATA_WIDTH * 4) - 1:0] dataOutIm
);



// Creating the buffers to store the input data and coefficients.
reg signed [DATA_WIDTH - 1:0] coeffBufferRe [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] coeffBufferIm [0:LENGTH - 1];
reg signed [(DATA_WIDTH * 3) - 1:0] inputDataBufferRe [0:LENGTH -1];
reg signed [(DATA_WIDTH * 3) - 1:0] inputDataBufferIm [0:LENGTH -1];
// Note the range of reg signed [7:0] is [-128 to 127].


reg signed [DATA_WIDTH - 1:0] coeffPreBufferRe [0:2];
reg signed [DATA_WIDTH - 1:0] coeffPreBufferIm [0:2];



// FIR = output width = input data width + coefficient width + log(N) 
reg signed [(DATA_WIDTH * 4) - 1:0] firOutputReRe;
reg signed [(DATA_WIDTH * 4) - 1:0] firOutputReIm;
reg signed [(DATA_WIDTH * 4) - 1:0] firOutputImRe;
reg signed [(DATA_WIDTH * 4) - 1:0] firOutputImIm;



reg [19:0] coeffBufferCounter; 


// FSM states.
reg [2:0] state;
reg [2:0] IDLE = 3'd0;
reg [2:0] WAIT_1_CYCLE = 3'd1;
reg [2:0] FIR_MAIN = 3'd2;
reg [2:0] STOP = 3'd3;
reg [2:0] EMPTY_STATE1 = 3'd4;
reg [2:0] EMPTY_STATE2 = 3'd5;
reg [2:0] EMPTY_STATE3 = 3'd6;
reg [2:0] EMPTY_STATE4 = 3'd7;



// Setting the initial values.
initial begin : init_values

	// Set all the values inside the buffers to 0.
	integer k;
	for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
		coeffBufferRe[k] <= 0;
		coeffBufferIm[k] <= 0;
		inputDataBufferRe[k] <= 0;
		inputDataBufferIm[k] <= 0;
	end

	coeffBufferCounter <= 20'd0;
	state <= IDLE;
	
	
	coeffPreBufferRe[0] <= {(DATA_WIDTH){1'd0}};
	coeffPreBufferIm[0] <= {(DATA_WIDTH){1'd0}};
	coeffPreBufferRe[1] <= {(DATA_WIDTH){1'd0}};
	coeffPreBufferIm[1] <= {(DATA_WIDTH){1'd0}};
	coeffPreBufferRe[2] <= {(DATA_WIDTH){1'd0}};
	coeffPreBufferIm[2] <= {(DATA_WIDTH){1'd0}};
	

	firOutputReRe <= 0;
	firOutputReIm <= 0;
	firOutputImRe <= 0;
	firOutputImIm <= 0;

	dataOutRe <= 0;
	dataOutIm <= 0;
end





integer n;
always @(posedge clock) begin
	case(state)
	
		// State IDLE. This state transitions to WAIT_1_CYCLE.
		IDLE: begin
			if(loadCoeff) begin
				state <= WAIT_1_CYCLE;
			end
		end

		// State WAIT_1_CYCLE. This state is waits for 1 clock cyle.
		WAIT_1_CYCLE: begin
				state <= FIR_MAIN;
		end

		
		// State FIR_MAIN. This state is responsiable for the main FIR opperation. It follows
		// the logic outlined in the pdf "The workings of a complex FIR filter". It also load 
		// the coefficients in parallel to the FIR opperation.
		FIR_MAIN: begin
		
			// Continoue loading the coefficients.
			if(coeffBufferCounter <= LENGTH + 2) begin
				coeffPreBufferRe[0] <= coeffInRe;
				coeffPreBufferIm[0] <= coeffInIm;
			
				for (n = 0; n < 2; n = n + 1) begin
					
					coeffPreBufferRe[n+1] <= coeffPreBufferRe[n];
					coeffPreBufferIm[n+1] <= coeffPreBufferIm[n];
				end
			
				coeffBufferRe[LENGTH - coeffBufferCounter - 1 + 3] <= coeffPreBufferRe[2];
				coeffBufferIm[LENGTH - coeffBufferCounter - 1 + 3] <= coeffPreBufferIm[2];
				
				coeffBufferCounter <= coeffBufferCounter + 20'd1;
			end
		
		
			// If the data input stream is ready, do the following.
			if(loadDataFlag == 1) begin
				// Shift the values inside inputDataBufferRe and inputDataBufferIm by 1.
				for (n = LENGTH - 1; n > 0; n = n - 1) begin
					inputDataBufferRe[n] <= inputDataBufferRe[n - 1];
					inputDataBufferIm[n] <= inputDataBufferIm[n - 1];
				end
				// Load the inputDataBufferRe and inputDataBufferIm values to the start of the buffer.
				inputDataBufferRe[0] <= dataInRe;
				inputDataBufferIm[0] <= dataInIm;


				// firOutput is set to 0, as everytime FIR_MAIN loops, previous firOutput value is used, hence the first
				// firOutput value that is used in the for loop would not be of the correct value.
				firOutputReRe = 0;
				firOutputReIm = 0;
				firOutputImRe = 0;
				firOutputImIm = 0;
				

				// This operation does the multiplication and summation between corresponding input data with
				/// the corresponding coefficients.
				for (n = 0; n <= LENGTH - 1; n = n + 1) begin
					firOutputReRe = firOutputReRe + (inputDataBufferRe[n] * coeffBufferRe[LENGTH - 1 - n]);
					firOutputReIm = firOutputReIm + (inputDataBufferRe[n] * coeffBufferIm[LENGTH - 1 - n]);
					firOutputImRe = firOutputImRe + (inputDataBufferIm[n] * coeffBufferRe[LENGTH - 1 - n]);
					firOutputImIm = firOutputImIm + (inputDataBufferIm[n] * coeffBufferIm[LENGTH - 1 - n]);
				end

				// Addition / subtraction opperation required for the complex numbers.
				dataOutRe = firOutputReRe - firOutputImIm;
				dataOutIm = firOutputReIm + firOutputImRe;

			end

			// Transition to stop state when stopDataLoadFlag is 1.
			if(stopDataLoadFlag == 1) begin
				state = STOP;
			end
		end

		
		// State Stop. This state is responsiable for the resetting of the used parameters and then 
		// transistioning to the state IDLE.
		STOP: begin: resetValues
			// Set all the values inside the coeffBuffer to 0.
			integer k;
			for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
				coeffBufferRe[k] <= 0;
				coeffBufferIm[k] <= 0;
				inputDataBufferRe[k] <= 0;
				inputDataBufferIm[k] <= 0;
			end

			// Set the internal variables and outputs to 0.
			state <= IDLE;
			dataOutRe <= 0;
			dataOutIm <= 0;
			firOutputReRe <= 0;
			firOutputReIm <= 0;
			firOutputImRe <= 0;
			firOutputImIm <= 0;
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
				coeffBufferRe[k] <= 0;
				coeffBufferIm[k] <= 0;
				inputDataBufferRe[k] <= 0;
				inputDataBufferIm[k] <= 0;
			end

			// Set the internal variables and outputs to 0.
			state <= IDLE;
			dataOutRe <= 0;
			dataOutIm <= 0;
			firOutputReRe <= 0;
			firOutputReIm <= 0;
			firOutputImRe <= 0;
			firOutputImIm <= 0;
		end

	endcase

end

endmodule
