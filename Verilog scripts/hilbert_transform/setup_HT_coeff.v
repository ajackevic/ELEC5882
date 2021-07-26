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
 soon as enable is set, and once all the values are passed through coeffOut 
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
	output reg signed [DATA_WIDTH - 1:0] coeffOut
);



// Coefficient counter. Filter will only for 1023 ((2^10)-1) taps.
reg [9:0] coeffCounter;
// Designing the correct length of the coefficient array based on parameters LENGTH and DATA_WIDTH.
reg signed [DATA_WIDTH - 1:0] coefficients [0:LENGTH - 1];



// Setting the coefficients. When setting the coefficients, make sure all values are covered.
// This should be from 0 to LENGTH - 1.
initial begin
	coefficients[0] <= -12'd25;
	coefficients[1] <= 12'd0;
	coefficients[2] <= -12'd51;
	coefficients[3] <= 12'd0;
	coefficients[4] <= -12'd100;
	coefficients[5] <= 12'd0;
	coefficients[6] <= -12'd181;
	coefficients[7] <= 12'd0;
	coefficients[8] <= -12'd321;
	coefficients[9] <= 12'd0;
	coefficients[10] <= -12'd624;
	coefficients[11] <= 12'd0;
	coefficients[12] <= -12'd2018;
	coefficients[13] <= 12'd0;
	coefficients[14] <= 12'd2018;
	coefficients[15] <= 12'd0;
	coefficients[16] <= 12'd624;
	coefficients[17] <= 12'd0;
	coefficients[18] <= 12'd321;
	coefficients[19] <= 12'd0;
	coefficients[20] <= 12'd181;
	coefficients[21] <= 12'd0;
	coefficients[22] <= 12'd100;
	coefficients[23] <= 12'd0;
	coefficients[24] <= 12'd51;
	coefficients[25] <= 12'd0;
	coefficients[26] <= 12'd25;
end


// Set the initial outputs to 0.
initial begin
	coeffOut <= {(DATA_WIDTH){1'd0}};
	coeffSetFlag <= 1'd0;
	coeffCounter <= 10'd0;
end



always @(posedge clock) begin

	// If enable is set, set coeffOut based on the coeffCounter and the array coefficients values.
	// When all the coefficients were passed across, set the coeffSetFlag high. If not enabled, set
	// coeffSetFlag low and reset the coeffCounter.
	if(enable) begin: setCoefficients

		// Set flag high when coeffCounter is equal to the filter length - 1.
		if(coeffCounter == LENGTH - 1) begin
			coeffSetFlag <= 1'd1;
			coeffOut <= coefficients[coeffCounter];
		end
		else begin
			// Set coeffOut to the corresponding coefficients array value.
			coeffOut <= coefficients[coeffCounter];

			// Increment coeffCounter each loop.
			coeffCounter <= coeffCounter + 10'd1;
		
			coeffSetFlag <= 1'd0;
		end

	end
	else begin
		coeffSetFlag <= 1'd0;
		coeffCounter <= 10'd0;
		coeffOut <= {(DATA_WIDTH){1'd0}};
	end

end

endmodule
