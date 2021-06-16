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
	input loadCoefficientsFlag,
	input loadDataFlag,
	input stopDataLoadFlag,
	input signed [7:0] coefficientInI,
	input signed [7:0] coefficientInQ,
	input signed [7:0] dataInI,
	input signed [7:0] dataInQ,
	output reg signed [20:0] dataOutI,
	output reg signed [20:0] dataOutQ
);

// Creating the buffers to store the input data and coefficients.

reg signed [7:0] coeffBufferI [0:LENGTH - 1];
reg signed [7:0] coeffBufferQ [0:LENGTH - 1];
reg signed [7:0] inputDataBufferI [0:LENGTH -1];
reg signed [7:0] inputDataBufferQ [0:LENGTH -1];
// Note the range of reg signed [7:0] is [-128 to 127].
reg [9:0] coeffCounter;		// This can not be a constant. Will need to be dependant on n. Either that or make ir realy large.

// input data width + coefficient width + log(N) = output width.
reg signed [18:0] firOutputII;
reg signed [18:0] firOutputIQ;
reg signed [18:0] firOutputQI;
reg signed [18:0] firOutputQQ;


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
		coeffBufferI[k] = 0;
		coeffBufferQ[k] = 0;
		inputDataBufferI[k] = 0;
		inputDataBufferQ[k] = 0;
	end

	state = 0;
	coeffCounter = 0;

	firOutputII = 0;
	firOutputIQ = 0;
	firOutputQI = 0;
	firOutputQQ = 0;

	dataOutI = 0;
	dataOutQ = 0;
end

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
			// Shift the values inside coeffBufferI by 1.
			for (n = LENGTH - 1; n > 0; n = n - 1) begin
				coeffBufferI[n] <= coeffBufferI[n-1];
			end
			// Load the coefficientInI value to the start of the buffer.
			coeffBufferI[0] <= coefficientInI;

			// Shift the values inside coeffBufferQ by 1.
			for (n = LENGTH - 1; n > 0; n = n - 1) begin
				coeffBufferQ[n] <= coeffBufferQ[n-1];
			end
			// Load the coefficientInQ value to the start of the buffer.
			coeffBufferQ[0] <= coefficientInQ;

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
				// Shift the values inside inputDataBufferI by 1.
				for (n = LENGTH - 1; n > 0; n = n - 1) begin
					inputDataBufferI[n] <= inputDataBufferI[n - 1];
				end
				// Load the inputDataBufferI value to the start of the buffer.
				inputDataBufferI[0] <= dataInI;

				// Shift the values inside inputDataBufferQ by 1.
				for (n = LENGTH - 1; n > 0; n = n - 1) begin
					inputDataBufferQ[n] <= inputDataBufferQ[n - 1];
				end
				// Load the inputDataBufferQ value to the start of the buffer.
				inputDataBufferQ[0] <= dataInQ;


				firOutputII = 0;
				firOutputIQ = 0;
				firOutputQI = 0;
				firOutputQQ = 0;

				// This operation does the multiplication and summation between corresponding input data with
				/// the corresponding coefficients.
				for (n = 0; n <= LENGTH - 1; n = n + 1) begin
					firOutputII = firOutputII + (inputDataBufferI[n] * coeffBufferI[LENGTH - 1 - n]);
					firOutputIQ = firOutputIQ + (inputDataBufferI[n] * coeffBufferQ[LENGTH - 1 - n]);
					firOutputQI = firOutputQI + (inputDataBufferQ[n] * coeffBufferI[LENGTH - 1 - n]);
					firOutputQQ = firOutputQQ + (inputDataBufferQ[n] * coeffBufferQ[LENGTH - 1 - n]);
				end

				// Addition / subtraction opperation required for the complex numbers.
				dataOutI = firOutputII - firOutputQQ;
				dataOutQ = firOutputIQ + firOutputQI;

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
