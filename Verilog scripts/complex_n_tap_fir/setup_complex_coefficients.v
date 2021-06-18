/*

 setup_complex_coefficients.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module sets up the coefficients for the complex FIR filter. When setting the coefficients 
 make sure all the coefficients up to the value of LENGTH are set and are at a bit width 
 of DATA_WIDTH. If more than 1023 coefficients are used, increase the bit width of 
 coeffCounter. The coefficients will be passed on as soon as enable is set, and once all
 the values are passed through coefficientOutRe and coefficientOutIm the filterSetFlag is then set.
 
 
*/



module setup_complex_coefficients#(
	parameter LENGTH = 12,
	parameter DATA_WIDTH = 8
)(
	input clock,
	input enable,
	output reg filterSetFlag,
	output reg signed [DATA_WIDTH - 1:0] coefficientOutRe,
	output reg signed [DATA_WIDTH - 1:0] coefficientOutIm
);



// Coefficient counter. Filter will only for 1023 ((2^10)-1) taps.
reg [9:0] coeffCounter;
// Designing the correct length of the coefficient arrays based on parameters LENGTH and DATA_WIDTH.
reg signed [DATA_WIDTH - 1:0] coefficientsRe [0:LENGTH - 1];
reg signed [DATA_WIDTH - 1:0] coefficientsIm [0:LENGTH - 1];



// Setting the coefficients. When setting the coefficients, make sure all values are covered.
// This should include from 0 to LENGTH - 1.
initial begin
	coefficientsRe[0] <= 8'd3;
	coefficientsIm[0] <= 8'd7;
	coefficientsRe[1] <= 8'd2;
	coefficientsIm[1] <= 8'd0;
	coefficientsRe[2] <= 8'd17;
	coefficientsIm[2] <= 8'd5;
	coefficientsRe[3] <= 8'd0;
	coefficientsIm[3] <= -8'd3;
	coefficientsRe[4] <= 8'd55;
	coefficientsIm[4] <= -8'd103;
	coefficientsRe[5] <= 8'd120;
	coefficientsIm[5] <= -8'd111;
	coefficientsRe[6] <= 8'd123;
	coefficientsIm[6] <= -8'd24;
	coefficientsRe[7] <= 8'd56;
	coefficientsIm[7] <= 8'd96;
	coefficientsRe[8] <= -8'd99;
	coefficientsIm[8] <= -8'd32;
	coefficientsRe[9] <= -8'd109;
	coefficientsIm[9] <= -8'd76;
	coefficientsRe[10] <= 8'd23;
	coefficientsIm[10] <= -8'd14;
	coefficientsRe[11] <= -8'd60;
	coefficientsIm[11] <= 8'd10;
end



// Set the initial outputs to 0.
initial begin
	coefficientOutRe <= {(DATA_WIDTH){1'd0}};
	coefficientOutIm <= {(DATA_WIDTH){1'd0}};
	filterSetFlag <= 1'd0;
	coeffCounter <= 10'd0;
end




always @(posedge clock) begin

	// If enable is set, set coefficientOut based on the coeffCounter and the array coefficients values.
	// When all the coefficients were passed across, set the filterSetFlag high. If not enabled, set 
	// filterSetFlag low and reset the coeffCounter.
	if(enable) begin: setCoefficients

		// Set coefficientOut to the corresponding coefficients array value.
		coefficientOutRe <= coefficientsRe[coeffCounter];
		coefficientOutIm <= coefficientsIm[coeffCounter];
		
		// Increment coeffCounter each loop.
		coeffCounter <= coeffCounter + 10'd1;
		
		// Set flag high when coeffCounter is equal to the filter length - 1.
		if(coeffCounter == LENGTH - 1) begin
			filterSetFlag <= 1'd1;
		end
		
	end
	
	// Reset the values if enable is not set.
	else begin
		filterSetFlag <= 1'd0;
		coeffCounter <= 10'd0;
		coefficientOutRe <= {(DATA_WIDTH){1'd0}};
		coefficientOutIm <= {(DATA_WIDTH){1'd0}};
	end
	
end


endmodule

