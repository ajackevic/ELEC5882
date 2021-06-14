/*

 n_tap_complex_fir.v
 --------------
 By: Augustas Jackevic
 Date: February 2021

 Module Description:
 -------------------
 This module is a design of an n-type complex FIR (Finite Impulse Response)
 filter. This filter is the convolution operation between the complex
 input data (data_in) and the complex coefficient data (coefficient_in). The
 default LENGTH is 10. The FIR filter can be used to do the convolution operation.
 For this script, the convolution operation is of two inputs, data_in and coefficient_in.
 It should be noted, to help understand the workings of the FIR_MAIN state, the PDF in:
 The workings of an FIR filter\The workings of a FIR filter.pdf should be read.

*/

module n_tap_complex_fir #(
	parameter LENGTH = 10
)(
	input clock,
	input load_coefficients_flag,
	input load_data_flag,
	input stop_data_load_flag,
	input signed [7:0] coefficient_in_I,
	input signed [7:0] coefficient_in_Q,
	input signed [7:0] data_in_I,
	input signed [7:0] data_in_Q,
	output reg signed [20:0] data_out_I,
	output reg signed [20:0] data_out_Q
);

// Creating the buffers to store the input data and coefficients.

reg signed [7:0] coeff_buffer_I [0:LENGTH - 1];
reg signed [7:0] coeff_buffer_Q [0:LENGTH - 1];
reg signed [7:0] input_data_buffer_I [0:LENGTH -1];
reg signed [7:0] input_data_buffer_Q [0:LENGTH -1];
// Note the range of reg signed [7:0] is [-128 to 127].
reg [9:0] coeff_counter;		// This can not be a constant. Will need to be dependant on n. Either that or make ir realy large.

// input data width + coefficient width + log(N) = output width.
reg signed [18:0] fir_output_II;
reg signed [18:0] fir_output_IQ;
reg signed [18:0] fir_output_QI;
reg signed [18:0] fir_output_QQ;


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
		coeff_buffer_I[k] = 0;
		coeff_buffer_Q[k] = 0;
		input_data_buffer_I[k] = 0;
		input_data_buffer_Q[k] = 0;
	end

	state = 0;
	coeff_counter = 0;

	fir_output_II = 0;
	fir_output_IQ = 0;
	fir_output_QI = 0;
	fir_output_QQ = 0;

	data_out_I = 0;
	data_out_Q = 0;
end

integer n;
always @(posedge clock) begin
	case(state)
		IDLE: begin
			// The IDLE state checks the LOAD_COEFFICIENTS value and only
			// starts the FIR operation when the value becomes 1 and all the
			// coefficients have been loaded.
			if(load_coefficients_flag == 1) begin
				state = LOAD_COEFFICIENTS;
			end
		end

		LOAD_COEFFICIENTS: begin
			// Shift the values inside coeff_buffer_I by 1.
			for (n = LENGTH - 1; n > 0; n = n - 1) begin
				coeff_buffer_I[n] <= coeff_buffer_I[n-1];
			end
			// Load the coefficient_in_I value to the start of the buffer.
			coeff_buffer_I[0] <= coefficient_in_I;

			// Shift the values inside coeff_buffer_Q by 1.
			for (n = LENGTH - 1; n > 0; n = n - 1) begin
				coeff_buffer_Q[n] <= coeff_buffer_Q[n-1];
			end
			// Load the coefficient_in_Q value to the start of the buffer.
			coeff_buffer_Q[0] <= coefficient_in_Q;

			// When the coeff_counter is eaual to the LENGTH parameter,
			// all the coefficients have been loaded and the the FSM should
			// transition to the next state, FIR_MAIN.
			coeff_counter = coeff_counter + 10'd1;
			if(coeff_counter == LENGTH) begin
				state = FIR_MAIN;
			end
		end

		FIR_MAIN: begin
			// If the data input stream is ready, do the following.
			if(load_data_flag == 1) begin
				// Shift the values inside input_data_buffer_I by 1.
				for (n = LENGTH - 1; n > 0; n = n - 1) begin
					input_data_buffer_I[n] <= input_data_buffer_I[n - 1];
				end
				// Load the input_data_buffer_I value to the start of the buffer.
				input_data_buffer_I[0] <= data_in_I;

				// Shift the values inside input_data_buffer_Q by 1.
				for (n = LENGTH - 1; n > 0; n = n - 1) begin
					input_data_buffer_Q[n] <= input_data_buffer_Q[n - 1];
				end
				// Load the input_data_buffer_Q value to the start of the buffer.
				input_data_buffer_Q[0] <= data_in_Q;


				fir_output_II = 0;
				fir_output_IQ = 0;
				fir_output_QI = 0;
				fir_output_QQ = 0;

				// This operation does the multiplication and summation between corresponding input data with
				/// the corresponding coefficients.
				for (n = 0; n <= LENGTH - 1; n = n + 1) begin
					fir_output_II = fir_output_II + (input_data_buffer_I[n] * coeff_buffer_I[LENGTH - 1 - n]);
					fir_output_IQ = fir_output_IQ + (input_data_buffer_I[n] * coeff_buffer_Q[LENGTH - 1 - n]);
					fir_output_QI = fir_output_QI + (input_data_buffer_Q[n] * coeff_buffer_I[LENGTH - 1 - n]);
					fir_output_QQ = fir_output_QQ + (input_data_buffer_Q[n] * coeff_buffer_Q[LENGTH - 1 - n]);
				end

				// Addition / subtraction opperation required for the complex numbers.
				data_out_I = fir_output_II - fir_output_QQ;
				data_out_Q = fir_output_IQ + fir_output_QI;

			end

			// Transition to stop state when stop_data_load_flag is 1.
			if(stop_data_load_flag == 1) begin
				state = STOP;
			end
		end

		STOP: begin

		end

	endcase

end

endmodule
