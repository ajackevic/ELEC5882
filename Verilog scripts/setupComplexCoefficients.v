module setupComplexCoefficients#(
	parameter LENGTH = 20,
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
	else begin
		filterSetFlag <= 1'd0;
		coeffCounter <= 10'd0;
		coefficientOutRe <= {(DATA_WIDTH){1'd0}};
		coefficientOutIm <= {(DATA_WIDTH){1'd0}};
	end
	
end


endmodule

