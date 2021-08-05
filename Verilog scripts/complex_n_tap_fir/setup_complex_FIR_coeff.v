/*

 setup_complex_FIR_coeff.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module sets up the coefficients for the complex FIR filter. When setting the coefficients
 make sure all the coefficients up to the value of LENGTH are set and are at a bit width
 of DATA_WIDTH. If more than 1023 coefficients are used, increase the bit width of
 coeffCounter. The coefficients will be passed on as soon as enable is set, and once all
 the values are passed through coeffOutRe and coeffOutIm the coeffSetFlag is then set.

 This modules is not used my the main module (pulse_compression_filter). It is only used
 by n_tap_complex_fir_tb to test the functionality of its DUT module.
 
*/



module setup_complex_FIR_coeff#(
	parameter LENGTH = 20,
	parameter DATA_WIDTH = 18
)(
	input clock,
	input enable,
	output reg coeffSetFlag,
	output reg signed [DATA_WIDTH - 1:0] coeffOutRe,
	output reg signed [DATA_WIDTH - 1:0] coeffOutIm
);



// Coefficient counter. Filter will only for 1023 ((2^10)-1) taps.
reg [9:0] coeffCounter;
// Designing the correct length of the coefficient arrays based on parameters LENGTH and DATA_WIDTH.
reg signed [DATA_WIDTH - 1:0] coeffRe [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] coeffIm [0:LENGTH - 1];



// Setting the coefficients. When setting the coefficients, make sure all values are covered.
// This should include from 0 to LENGTH - 1.
initial begin
	coeffRe[0] <= 18'd34124;
	coeffIm[0] <= -18'd7392;
	coeffRe[1] <= 18'd34124;
	coeffIm[1] <= 18'd15;
	coeffRe[2] <= 18'd0;
	coeffIm[2] <= 18'd89998;
	coeffRe[3] <= 18'd4991;
	coeffIm[3] <= -18'd43211;
	coeffRe[4] <= 18'd12522;
	coeffIm[4] <= -18'd131072;
	coeffRe[5] <= -18'd7711;
	coeffIm[5] <= 18'd131071;
	coeffRe[6] <= -18'd5151;
	coeffIm[6] <= 18'd5151;
	coeffRe[7] <= 18'd81122;
	coeffIm[7] <= 18'd81122;
	coeffRe[8] <= 18'd9890;
	coeffIm[8] <= 18'd0;
	coeffRe[9] <= 18'd1091;
	coeffIm[9] <= 18'd882;
	coeffRe[10] <= -18'd9111;
	coeffIm[10] <= -18'd9;
	coeffRe[11] <= -18'd10369;
	coeffIm[11] <= 18'd8982;
	coeffRe[12] <= 18'd911;
	coeffIm[12] <= -18'd119;
	coeffRe[13] <= 18'd1121;
	coeffIm[13] <= 18'd6969;
	coeffRe[14] <= 18'd591;
	coeffIm[14] <= -18'd666;
	coeffRe[15] <= 18'd7590;
	coeffIm[15] <= 18'd8422;
	coeffRe[16] <= 18'd19;
	coeffIm[16] <= -18'd19223;
	coeffRe[17] <= 18'd5811;
	coeffIm[17] <= -18'd131072;
	coeffRe[18] <= -18'd970;
	coeffIm[18] <= -18'd9790;
	coeffRe[19] <= 18'd10000;
	coeffIm[19] <= 18'd1;
end



// Set the initial outputs to 0.
initial begin
	coeffOutRe <= {(DATA_WIDTH){1'd0}};
	coeffOutIm <= {(DATA_WIDTH){1'd0}};
	coeffSetFlag <= 1'd0;
	coeffCounter <= 10'd0;
end




always @(posedge clock) begin

	// If enable is set, set coeffOut Re and Im based on the coeffCounter and the array coefficients values.
	// When all the coefficients were passed across, set the coeffSetFlag high. If not enabled, set
	// coeffSetFlag low and reset the coeffCounter.
	if(enable) begin: setCoefficients

		// Set coeffOut Re and Im to the corresponding coefficients array value.
		coeffOutRe <= coeffRe[coeffCounter];
		coeffOutIm <= coeffIm[coeffCounter];

		// Increment coeffCounter each loop.
		coeffCounter <= coeffCounter + 10'd1;

		// Set flag high when coeffCounter is equal to the filter length - 1.
		if(coeffCounter == LENGTH) begin
			coeffSetFlag <= 1'd1;
		end

	end

	// Reset the values if enable is not set.
	else begin
		coeffSetFlag <= 1'd0;
		coeffCounter <= 10'd0;
		coeffOutRe <= {(DATA_WIDTH){1'd0}};
		coeffOutIm <= {(DATA_WIDTH){1'd0}};
	end

end


endmodule
