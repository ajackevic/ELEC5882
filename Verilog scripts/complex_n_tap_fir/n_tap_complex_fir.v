module n_tap_complex_fir #(
	parameter length = 10
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
	output reg signed [20:0] data_out_Q,
	output reg signed [7:0] data_out1,
	output reg signed [7:0] data_out2,
	output reg signed [20:0] data_out3
);

reg signed [7:0] coeff_buffer_I [0:length - 1];
reg signed [7:0] coeff_buffer_Q [0:length - 1];
reg signed [7:0] input_data_buffer_I [0:length -1];
reg signed [7:0] input_data_buffer_Q [0:length -1];
reg [9:0] coeff_counter;						// This can not be a constant. Will need to be dependant on n. Either that or make ir realy large
// input data width + coefficient width + log(N) = output width
reg signed [18:0] fir_output_II;
reg signed [18:0] fir_output_IQ;
reg signed [18:0] fir_output_QI;
reg signed [18:0] fir_output_QQ;



reg [2:0] state;
reg [2:0] IDLE  			= 3'd0;
reg [2:0] LOAD_COEFFICIENTS = 3'd1;
reg [2:0] FIR_MAIN 		    = 3'd2;
reg [2:0] STOP  			= 3'd3;

initial begin : init_values
	// Set all the values inside the coeff_buffer to 0;
	integer k;
	for (k = 0; k <= length - 1 ; k = k + 1) begin
		coeff_buffer_I[k] = 0;
		coeff_buffer_Q[k] = 0;
		input_data_buffer_I[k] = 0;
		input_data_buffer_Q[k] = 0;
	end

	state = 0;
	coeff_counter = 0;

	data_out1 = 0;
	data_out2 = 0;
	data_out3 = 0;
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
			// starts the FIR operation when the value becomes 1.
			if(load_coefficients_flag == 1) begin
				state = LOAD_COEFFICIENTS;
			end
		end

		LOAD_COEFFICIENTS: begin
			for (n = length - 1; n > 0; n = n - 1) begin
				coeff_buffer_I[n] <= coeff_buffer_I[n-1];
			end
			coeff_buffer_I[0] <= coefficient_in_I;


			for (n = length - 1; n > 0; n = n - 1) begin
				coeff_buffer_Q[n] <= coeff_buffer_Q[n-1];
			end
			coeff_buffer_Q[0] <= coefficient_in_Q;

			coeff_counter = coeff_counter + 10'd1;
			if(coeff_counter == length) begin
				state = FIR_MAIN;
			end
		end

		FIR_MAIN: begin
			if(load_data_flag == 1) begin

				for (n = length - 1; n > 0; n = n - 1) begin
					input_data_buffer_I[n] <= input_data_buffer_I[n - 1];
				end
				input_data_buffer_I[0] <= data_in_I;

				for (n = length - 1; n > 0; n = n - 1) begin
					input_data_buffer_Q[n] <= input_data_buffer_Q[n - 1];
				end
				input_data_buffer_Q[0] <= data_in_Q;


				fir_output_II = 0;
				fir_output_IQ = 0;
				fir_output_QI = 0;
				fir_output_QQ = 0;


				for (n = 0; n <= length - 1; n = n + 1) begin
					fir_output_II = fir_output_II + (input_data_buffer_I[n] * coeff_buffer_I[length - 1 - n]);
					fir_output_IQ = fir_output_IQ + (input_data_buffer_I[n] * coeff_buffer_Q[length - 1 - n]);
					fir_output_QI = fir_output_QI + (input_data_buffer_Q[n] * coeff_buffer_I[length - 1 - n]);
					fir_output_QQ = fir_output_QQ + (input_data_buffer_Q[n] * coeff_buffer_Q[length - 1 - n]);
				end


				data_out_I = fir_output_II - fir_output_QQ;
				data_out_Q = fir_output_IQ + fir_output_QI;

			end

			// Transition to stop state when stop_data_load_flag is 1.
			if(stop_data_load_flag == 1) begin
				state = STOP;
			end

			// Load data to the corresponding data_out so that they can be monitored in simulation.
			data_out1 = coeff_buffer_I[3];
			data_out2 = coeff_buffer_Q[3];
			data_out3 = fir_output_II;
		end

		STOP: begin

		end

	endcase

end

endmodule
