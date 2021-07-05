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


*/



module setup_complex_FIR_coeff#(
	parameter LENGTH = 12,
	parameter DATA_WIDTH = 8
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
	coeffRe[0] <= 8'd3;
	coeffIm[0] <= 8'd7;
	coeffRe[1] <= 8'd2;
	coeffIm[1] <= 8'd0;
	coeffRe[2] <= 8'd17;
	coeffIm[2] <= 8'd5;
	coeffRe[3] <= 8'd0;
	coeffIm[3] <= -8'd3;
	coeffRe[4] <= 8'd55;
	coeffIm[4] <= -8'd103;
	coeffRe[5] <= 8'd120;
	coeffIm[5] <= -8'd111;
	coeffRe[6] <= 8'd123;
	coeffIm[6] <= -8'd24;
	coeffRe[7] <= 8'd56;
	coeffIm[7] <= 8'd96;
	coeffRe[8] <= -8'd99;
	coeffIm[8] <= -8'd32;
	coeffRe[9] <= -8'd109;
	coeffIm[9] <= -8'd76;
	coeffRe[10] <= 8'd23;
	coeffIm[10] <= -8'd14;
	coeffRe[11] <= -8'd60;
	coeffIm[11] <= 8'd10;
end



// Set the initial outputs to 0.
initial begin
	coeffOutRe <= {(DATA_WIDTH){1'd0}};
	coeffOutIm <= {(DATA_WIDTH){1'd0}};
	coeffSetFlag <= 1'd0;
	coeffCounter <= 10'd0;
end




always @(posedge clock) begin

	// If enable is set, set coefficientOut based on the coeffCounter and the array coefficients values.
	// When all the coefficients were passed across, set the coeffSetFlag high. If not enabled, set
	// coeffSetFlag low and reset the coeffCounter.
	if(enable) begin: setCoefficients

		// Set coefficientOut to the corresponding coefficients array value.
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
