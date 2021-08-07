/*

 setup_FIR_coeff.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module sets up the coeff for the FIR filter. When setting the coeff
 make sure all the coefficient up to the value of LENGTH are set and are at a bit width
 of DATA_WIDTH. If more than 1023 coeff are used, increase the bit width of
 coeffCounter. The coeff will be passed on as soon as enable is set, and once all
 the values are passed through coeffOut the coeffSetFlag is then set.

 This modules is not used my the main module (pulse_compression_filter). It is only used
 by n_tap_fir_tb to test the functionality of its DUT module.

*/

module setup_FIR_coeff #(
	parameter LENGTH = 20,
	parameter DATA_WIDTH = 18
)(
	input clock,
	input enable,
	output reg coeffSetFlag,
	output reg signed [DATA_WIDTH - 1:0] coeffOut
);

// Coefficient counter. Filter will only for 1023 ((2^10)-1) taps.
reg [9:0] coeffCounter;
// Designing the correct length of the coefficient array based on parameters LENGTH and DATA_WIDTH.
reg signed [DATA_WIDTH - 1:0] coeff [0:LENGTH - 1];



// Setting the coeff. When setting the coeff, make sure all values are covered.
// This should be from 0 to LENGTH - 1.
initial begin
	coeff[0] <= 18'd34124;
	coeff[1] <= 18'd3114;
	coeff[2] <= 18'd0;
	coeff[3] <= 18'd4991;
	coeff[4] <= 18'd12522;
	coeff[5] <= -18'd7711;
	coeff[6] <= -18'd5151;
	coeff[7] <= 18'd81122;
	coeff[8] <= 18'd9890;
	coeff[9] <= 18'd1091;
	coeff[10] <= -18'd9111;
	coeff[11] <= -18'd10369;
	coeff[12] <= 18'd911;
	coeff[13] <= 18'd1121;
	coeff[14] <= 18'd591;
	coeff[15] <= 18'd7590;
	coeff[16] <= 18'd19;
	coeff[17] <= 18'd5811;
	coeff[18] <= -18'd970;
	coeff[19] <= 18'd10000;
end


// Set the initial outputs to 0.
initial begin
	coeffOut <= {(DATA_WIDTH){1'd0}};
	coeffSetFlag <= 1'd0;
	coeffCounter <= 10'd0;
end



always @(posedge clock) begin

	// If enable is set, set coeffOut based on the coeffCounter and the array coeff values.
	// When all the coeff were passed across, set the coeffSetFlag high. If not enabled, set
	// coeffSetFlag low and reset the coeffCounter.
	if(enable) begin: setcoeff

		// Set coeffOut to the corresponding coeff array value.
		coeffOut <= coeff[coeffCounter];

		// Increment coeffCounter each loop.
		coeffCounter <= coeffCounter + 10'd1;

		// Set flag high when coeffCounter is equal to the filter length - 1.
		if(coeffCounter == LENGTH - 1) begin
			coeffSetFlag <= 1'd1;
		end

	end
	else begin
		coeffSetFlag <= 1'd0;
		coeffCounter <= 10'd0;
		coeffOut <= {(DATA_WIDTH){1'd0}};
	end

end


endmodule
