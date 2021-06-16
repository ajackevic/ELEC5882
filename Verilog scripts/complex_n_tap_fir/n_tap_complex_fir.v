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
 default LENGTH is 10. The FIR filter can be used to do the convolution operation.
 For this script, the convolution operation is of two inputs, data_in and coefficient_in.
 It should be noted, to help understand the workings of the FIR_MAIN state, the PDF in:
 The workings of an FIR filter\The workings of a complex FIR filter.pdf should be read.

*/

module n_tap_complex_fir #(
	parameter LENGTH = 12,
	parameter DATA_WIDTH = 8
)(
	input clock,
	input loadDataFlag,
	input stopDataLoadFlag,
	input signed [7:0] dataInRe,
	input signed [7:0] dataInIm,
	
	output reg signed [20:0] dataOutRe,
	output reg signed [20:0] dataOutIm
);



// Creating the buffers to store the input data and coefficients.
reg signed [DATA_WIDTH - 1:0] coeffBufferRe [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] coeffBufferIm [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] inputDataBufferRe [0:LENGTH -1];
reg signed [DATA_WIDTH - 1:0] inputDataBufferIm [0:LENGTH -1];
// Note the range of reg signed [7:0] is [-128 to 127].


// FIR = output width = input data width + coefficient width + log(N) 
reg signed [18:0] firOutputReRe;
reg signed [18:0] firOutputReIm;
reg signed [18:0] firOutputImRe;
reg signed [18:0] firOutputImIm;



// Creating the parameters for the instantiated setupComplexCoefficients module.
reg loadCoefficients;
wire coefficientsSetFlag;
wire signed [DATA_WIDTH - 1:0] coefficientInRe;
wire signed [DATA_WIDTH - 1:0] coefficientInIm;


// FSM states.
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
initial begin : init_values

	// Set all the values inside the buffers to 0.
	integer k;
	for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
		coeffBufferRe[k] <= 0;
		coeffBufferIm[k] <= 0;
		inputDataBufferRe[k] <= 0;
		inputDataBufferIm[k] <= 0;
	end

	state <= IDLE;
	loadCoefficients <= 0;

	firOutputReRe <= 0;
	firOutputReIm <= 0;
	firOutputImRe <= 0;
	firOutputImIm <= 0;

	dataOutRe <= 0;
	dataOutIm <= 0;
end




// Instantiating the setup of the coefficient module. This module passes the LENGTH 
// amount of coefficients through coefficientInRe and coefficientInIm.
setupComplexCoefficients #(
	.LENGTH 			 	(LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH)
)Coefficients(
	.clock				(clock),
	.enable				(loadCoefficients),
	
	.filterSetFlag	 	(coefficientsSetFlag),
	.coefficientOutRe (coefficientInRe),
	.coefficientOutIm	(coefficientInIm)
);





integer n;
always @(posedge clock) begin
	case(state)
	
		// State IDLE. This state transitions to LOAD_COEFFICIENTS.
		IDLE: begin
			state = LOAD_COEFFICIENTS;
		end

		// State LOAD_COEFFICIENTS. This state is responsiable for loading the
		// coefficients to coeffBufferRe and coeffBufferIn. Once all the coefficients 
		// are loaded the state transitions to FIR_MAIN.
		LOAD_COEFFICIENTS: begin
		
			// Enable the loading of the coefficients.
			loadCoefficients <= 1'd1;
			
			// Shift the values inside coeffBufferRe and coeffBufferIm by 1.
			for (n = LENGTH - 1; n > 0; n = n - 1) begin
				coeffBufferRe[n] <= coeffBufferRe[n-1];
				coeffBufferIm[n] <= coeffBufferIm[n-1];
			end
			
			
			// Load the coefficientInRe and coefficientInIm value to the start of the buffer.
			coeffBufferRe[0] <= coefficientInRe;
			coeffBufferIm[0] <= coefficientInIm;
			
			// If coefficientsSetFlag flag is set, transition to FIR_MAIN and disable the 
			// loading of the coefficients.
			if(coefficientsSetFlag) begin
				state <= FIR_MAIN;
				loadCoefficients <= 1'd0;
			end
		end

		
		// State FIR_MAIN. This state is responsiable for the main FIR opperation. It follows
		// the logic outlined in the pdf "The workings of a complex FIR filter".
		FIR_MAIN: begin
		
			// If the data input stream is ready, do the following.
			if(loadDataFlag == 1) begin
				// Shift the values inside inputDataBufferRe by 1.
				for (n = LENGTH - 1; n > 0; n = n - 1) begin
					inputDataBufferRe[n] <= inputDataBufferRe[n - 1];
				end
				// Load the inputDataBufferRe value to the start of the buffer.
				inputDataBufferRe[0] <= dataInRe;

				// Shift the values inside inputDataBufferIm by 1.
				for (n = LENGTH - 1; n > 0; n = n - 1) begin
					inputDataBufferIm[n] <= inputDataBufferIm[n - 1];
				end
				// Load the inputDataBufferIm value to the start of the buffer.
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
