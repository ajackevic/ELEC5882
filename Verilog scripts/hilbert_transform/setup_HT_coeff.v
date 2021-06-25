/*

 setup_HT_coeff.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module sets up the coefficients for the hilbert transform filter. When setting 
 the coefficients make sure all the coefficient up to the value of LENGTH are set 
 and are at a bit width of DATA_WIDTH. If more than 1023 coefficients are used, 
 increase the bit width of coeffCounter. The coefficients will be passed on as 
 soon as enable is set, and once all the values are passed through coefficientOut 
 the filterSetFlag is then set.
 
 The hilbert transform coefficients are obtained from MATLAB through the function
 firpm (Parks-McClellan optimal FIR filter design). These values are then muiltiplied
 by 100000 to change the values from decimal to integers.

*/


module setup_HT_coeff#(
	parameter LENGTH = 27,
	parameter DATA_WIDTH = 18
)(
	input clock,
	input enable,
	output reg coeffSetFlag,
	output reg signed [DATA_WIDTH - 1:0] coefficientOut
);



// Coefficient counter. Filter will only for 1023 ((2^10)-1) taps.
reg [9:0] coeffCounter;
// Designing the correct length of the coefficient array based on parameters LENGTH and DATA_WIDTH.
reg signed [DATA_WIDTH - 1:0] coefficients [0:LENGTH - 1];



// Setting the coefficients. When setting the coefficients, make sure all values are covered.
// This should be from 0 to LENGTH - 1.
initial begin
	coefficients[0] <= -17'd775;
	coefficients[1] <= 17'd0;
	coefficients[2] <= -17'd1582;
	coefficients[3] <= 17'd0;
	coefficients[4] <= -17'd3114;
	coefficients[5] <= 17'd0;
	coefficients[6] <= -17'd5642;
	coefficients[7] <= 17'd0;
	coefficients[8] <= -17'd10043;
	coefficients[9] <= 17'd0;
	coefficients[10] <= -17'd19511;
	coefficients[11] <= 17'd0;
	coefficients[12] <= -17'd63075;
	coefficients[13] <= 17'd0;
	coefficients[14] <= 17'd63075;
	coefficients[15] <= 17'd0;
	coefficients[16] <= 17'd19511;
	coefficients[17] <= 17'd0;
	coefficients[18] <= 17'd10043;
	coefficients[19] <= 17'd0;
	coefficients[20] <= 17'd5642;
	coefficients[21] <= 17'd0;
	coefficients[22] <= 17'd3114;
	coefficients[23] <= 17'd0;
	coefficients[24] <= 17'd1582;
	coefficients[25] <= 17'd0;
	coefficients[26] <= 17'd775;
end


// Set the initial outputs to 0.
initial begin
	coefficientOut <= {(DATA_WIDTH){1'd0}};
	coeffSetFlag <= 1'd0;
	coeffCounter <= 10'd0;
end



always @(posedge clock) begin

	// If enable is set, set coefficientOut based on the coeffCounter and the array coefficients values.
	// When all the coefficients were passed across, set the coeffSetFlag high. If not enabled, set
	// coeffSetFlag low and reset the coeffCounter.
	if(enable) begin: setCoefficients

		// Set coefficientOut to the corresponding coefficients array value.
		coefficientOut <= coefficients[coeffCounter];

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
		coefficientOut <= {(DATA_WIDTH){1'd0}};
	end

end

endmodule
