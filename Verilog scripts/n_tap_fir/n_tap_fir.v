/*

 n_tap_fir.v
 --------------
 By: Augustas Jackevic
 Date: February 2021

 Module Description:
 -------------------
 This module is a design of an n-type FIR (Finite Impulse Response)
 filter. This filter is the convolution operation between the
 input data (data_in) and the coefficient data (coefficient_in). The
 default LENGTH is 10. It should be noted, to help understand the workings
 of the FIR_MAIN state, the PDF in:
 The workings of an FIR filter\The workings of a FIR filter.pdf should be read.

*/

module n_tap_fir #(
	parameter LENGTH = 10
	parameter DATA_WIDTH = 8;
)(
	input clock,
	input load_coefficients_flag,
	input load_data_flag,
	input stop_data_load_flag,
	input signed [DATA_WIDTH - 1:0] coefficient_in,
	input signed [DATA_WIDTH - 1:0] data_in,
	output reg signed [18:0] data_out
);

reg signed [DATA_WIDTH - 1:0] coeff_buffer [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] input_data_buffer [0:LENGTH -1];
reg [9:0] coeff_counter;						// This can not be a constant. Will need to be dependant on n. Either that or make ir realy large
// input data width + coefficient width + log(N) = output width
reg signed [18:0] fir_output;


// FSM states
reg [2:0] state;
reg [2:0] IDLE = 3'd0;
reg [2:0] LOAD_COEFFICIENTS = 3'd1;
reg [2:0] FIR_MAIN = 3'd2;
reg [2:0] STOP = 3'd3;

initial begin : init_values
	// Set all the values inside the coeff_buffer to 0;
	integer k;
	for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
		coeff_buffer[k] = 0;
		input_data_buffer[k] = 0;
	end

	state = 0;
	coeff_counter = 0;

	data_out = 0;
	fir_output = 0;
end

integer n;
always @(posedge clock) begin
	case(state)
		IDLE: begin
			// The IDLE state checks the LOAD_COEFFICIENTS value and only
			// starts the FIR operation when the value becomes 1.
			if(load_coefficients_flag == 1) begin
				state = LOAD_COEFFICIENTS;
			end
		end

		LOAD_COEFFICIENTS: begin
			// Shift the values inside coeff_buffer by 1
			for (n = LENGTH - 1; n > 0; n = n - 1) begin
				coeff_buffer[n] <= coeff_buffer[n-1];
			end

			// Load the coefficient values to coeff_buffer
			coeff_buffer[0] <= coefficient_in;

			// Increment coeff_counter, when it is equal to LENGTH + 1, the
			// coeff_buffer is full, thus change to state STOP.
			coeff_counter = coeff_counter + 10'd1;
			if(coeff_counter == LENGTH) begin
				state = FIR_MAIN;
			end
		end

		FIR_MAIN: begin
			// If the data input stream is ready, do the following.
			if(load_data_flag == 1) begin
				//Shift the values inside input_data_buffer by 1.
				for (n = LENGTH - 1; n > 0; n = n - 1) begin
					input_data_buffer[n] <= input_data_buffer[n - 1];
				end

				// Load the data_in values to input_data_buffer.
				input_data_buffer[0] <= data_in;

				// A multiplication between the input data and the corresponding coefficients
				// in the delayed buffer line. This for loop also sums all the components together.
				fir_output = 0;
				for (n = 0; n <= LENGTH - 1; n = n + 1) begin
					fir_output = fir_output + (input_data_buffer[n] * coeff_buffer[LENGTH - 1 - n]);
				end
			end

			// Transition to stop state when stop_data_load_flag is 1.
			if(stop_data_load_flag == 1) begin
				state = STOP;
			end

			// Load data to the corresponding data_out so that they can be monitored in simulation.
			data_out3 = fir_output;
		end

		STOP: begin

		end

	endcase

end

endmodule
