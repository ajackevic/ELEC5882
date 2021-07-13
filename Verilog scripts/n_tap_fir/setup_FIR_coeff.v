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


*/

module setup_FIR_coeff #(
	parameter LENGTH = 20,
	parameter DATA_WIDTH = 8
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
	coeff[0] <= 8'd34;
	coeff[1] <= 8'd34;
	coeff[2] <= 8'd0;
	coeff[3] <= 8'd49;
	coeff[4] <= 8'd125;
	coeff[5] <= -8'd77;
	coeff[6] <= -8'd51;
	coeff[7] <= 8'd8;
	coeff[8] <= 8'd98;
	coeff[9] <= 8'd109;
	coeff[10] <= -8'd91;
	coeff[11] <= -8'd3;
	coeff[12] <= 8'd9;
	coeff[13] <= 8'd1;
	coeff[14] <= 8'd59;
	coeff[15] <= 8'd75;
	coeff[16] <= 8'd19;
	coeff[17] <= 8'd58;
	coeff[18] <= -8'd97;
	coeff[19] <= 8'd10;
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
