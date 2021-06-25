module setup_HT_coeff
	parameter LENGTH = 27,
	parameter DATA_WIDTH = 17
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
	filterSetFlag <= 1'd0;
	coeffCounter <= 10'd0;
end


/* This shoud be done in a normal way. As in have the setting of the
   coefficients in this script. The loading of the matched filter coefficients
	should be done on a MIF file. This script should follow very simillar logic
	as the other setup_coeff scripts.
*/

endmodule
