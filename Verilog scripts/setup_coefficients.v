/*

 setup_coefficients.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module sets up the coefficients for the FIR filter. When setting the coefficients 
 make sure all the coefficient up to the value of LENGTH are set and are at a bit width 
 of DATA_WIDTH. If more than 1023 coefficients are used, increase the bit width of 
 coeffCounter. The coefficients will be passed on as soon as enable is set, and once all
 the values are passed through coefficientOut the filterSetFlag is then set.
 
 
*/

module setup_coefficients #(
	parameter LENGTH = 20,
	parameter DATA_WIDTH = 8
)(
	input clock,
	input enable,
	output reg filterSetFlag,
	output reg signed [DATA_WIDTH - 1:0] coefficientOut
);

// Coefficient counter. Filter will only for 1023 ((2^10)-1) taps.
reg [9:0] coeffCounter;
// Designing the correct length of the coefficient array based on parameters LENGTH and DATA_WIDTH.
reg signed [DATA_WIDTH - 1:0] coefficients [0:LENGTH - 1];



// Setting the coefficients. When setting the coefficients, make sure all values are covered.
// This should be from 0 to LENGTH - 1.
initial begin
	coefficients[0] <= 8'd34;
	coefficients[1] <= 8'd34;
	coefficients[2] <= 8'd0;
	coefficients[3] <= 8'd49;
	coefficients[4] <= 8'd125;
	coefficients[5] <= -8'd77;
	coefficients[6] <= -8'd51;
	coefficients[7] <= 8'd8;
	coefficients[8] <= 8'd98;
	coefficients[9] <= 8'd109;
	coefficients[10] <= -8'd91;
	coefficients[11] <= -8'd3;
	coefficients[12] <= 8'd9;
	coefficients[13] <= 8'd1;
	coefficients[14] <= 8'd59;
	coefficients[15] <= 8'd75;
	coefficients[16] <= 8'd19;
	coefficients[17] <= 8'd58;
	coefficients[18] <= -8'd97;
	coefficients[19] <= 8'd10;
end


// Set the initial outputs to 0.
initial begin
	coefficientOut <= {(DATA_WIDTH){1'd0}};
	filterSetFlag <= 1'd0;
	coeffCounter <= 10'd0;
end



always @(posedge clock) begin

	// If enable is set, set coefficientOut based on the coeffCounter and the array coefficients values.
	// When all the coefficients were passed across, set the filterSetFlag high. If not enabled, set 
	// filterSetFlag low and reset the coeffCounter.
	if(enable) begin: setCoefficients

		// Set coefficientOut to the corresponding coefficients array value.
		coefficientOut <= coefficients[coeffCounter];
		
		// Increment coeffCounter each loop.
		coeffCounter <= coeffCounter + 10'd1;
		
		// Set flag high when coeffCounter is equal to the filter length - 1.
		if(coeffCounter == LENGTH - 1) begin
			filterSetFlag <= 1'd1;
		end
		
	end
	else begin
		filterSetFlag <= 1'd0;
		coeffCounter <= 10'd0;
		coefficientOut <= {(DATA_WIDTH){1'd0}};
	end
	
end


endmodule
