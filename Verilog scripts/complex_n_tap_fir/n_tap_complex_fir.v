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
 The workings of an FIR filter\The workings of a FIR filter.pdf should be read.

*/

module n_tap_complex_fir #(
	parameter LENGTH = 10
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

reg signed [7:0] coeffBufferRe [0:LENGTH - 1];
reg signed [7:0] coeffBufferIm [0:LENGTH - 1];
reg signed [7:0] inputDataBufferRe [0:LENGTH -1];
reg signed [7:0] inputDataBufferIm [0:LENGTH -1];
// Note the range of reg signed [7:0] is [-128 to 127].
reg [9:0] coeffCounter;		// This can not be a constant. Will need to be dependant on n. Either that or make ir realy large.

// input data width + coefficient width + log(N) = output width.
reg signed [18:0] firOutputReRe;
reg signed [18:0] firOutputReIm;
reg signed [18:0] firOutputImRe;
reg signed [18:0] firOutputImIm;


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

initial begin : init_values
	// Set all the values inside the coeff_buffer to 0.
	integer k;
	for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
		coeffBufferRe[k] = 0;
		coeffBufferIm[k] = 0;
		inputDataBufferRe[k] = 0;
		inputDataBufferIm[k] = 0;
	end

	state = 0;
	coeffCounter = 0;

	firOutputReRe = 0;
	firOutputReIm = 0;
	firOutputImRe = 0;
	firOutputImIm = 0;

	dataOutRe = 0;
	dataOutIm = 0;
end


// Instantiating the setup of the coefficient module. This module passes the LENGTH 
// amount of coefficients through coefficientInRe and coefficientInIm.
setupComplexCoefficients #(
	.LENGTH 			 	(LENGTH),
	.DATA_WIDTH 		 (DATA_WIDTH)
)Coefficients(
	.clock				 (clock),
	.enable				 (loadCoefficients),
	
	.filterSetFlag	 	(coefficientsSetFlag),
	.coefficientOutRe (coefficientInRe),
	.coefficientOutIm	(coefficientInIm)
);





integer n;
always @(posedge clock) begin
	case(state)
		IDLE: begin
			// The IDLE state checks the LOAD_COEFFICIENTS value and only
			// starts the FIR operation when the value becomes 1 and all the
			// coefficients have been loaded.
			if(loadCoefficientsFlag == 1) begin
				state = LOAD_COEFFICIENTS;
			end
		end

		LOAD_COEFFICIENTS: begin
			// Shift the values inside coeffBufferRe by 1.
			for (n = LENGTH - 1; n > 0; n = n - 1) begin
				coeffBufferRe[n] <= coeffBufferRe[n-1];
			end
			// Load the coefficientInRe value to the start of the buffer.
			coeffBufferRe[0] <= coefficientInRe;

			// Shift the values inside coeffBufferIm by 1.
			for (n = LENGTH - 1; n > 0; n = n - 1) begin
				coeffBufferIm[n] <= coeffBufferIm[n-1];
			end
			// Load the coefficientInIm value to the start of the buffer.
			coeffBufferIm[0] <= coefficientInIm;

			// When the coeffCounter is eaual to the LENGTH parameter,
			// all the coefficients have been loaded and the the FSM should
			// transition to the next state, FIR_MAIN.
			coeffCounter = coeffCounter + 10'd1;
			if(coeffCounter == LENGTH) begin
				state = FIR_MAIN;
			end
		end

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

		end

	endcase

end

endmodule
