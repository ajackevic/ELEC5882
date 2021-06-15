module setupCoefficients #(
	parameter LENGTH = 20,
	parameter DATA_WIDTH = 8
)(
	input clock,
	input enable,
	output reg filterSetFlag,
	output reg signed [DATA_WIDTH - 1:0] coefficientOut
);

reg signed [DATA_WIDTH - 1:0] coefficients [0:LENGTH - 1];

// Setting the coefficients. When setting the coefficients, make sure all values are covered.
// This should be from 0 to LENGTH - 1.
initial begin
	coefficients[0] = 8'd34;
	coefficients[1] = 8'd34;
	coefficients[2] = 8'd0;
	coefficients[3] = 8'd49;
	coefficients[4] = 8'd125;
	coefficients[5] = -8'd77;
	coefficients[6] = -8'd51;
	coefficients[7] = 8'd8;
	coefficients[8] = 8'd97;
	coefficients[9] = 8'd109;
	coefficients[10] = -8'd91;
	coefficients[11] = -8'd3;
	coefficients[12] = 8'd9;
	coefficients[13] = 8'd1;
	coefficients[14] = 8'd59;
	coefficients[15] = 8'd75;
	coefficients[16] = 8'd19;
	coefficients[17] = 8'd58;
	coefficients[18] = -8'd97;
	coefficients[19] = 8'd10;
end

// Set the initial outputs to 0.
initial begin
	coefficientOut <= {(DATA_WIDTH){1'd0}};
	filterSetFlag <= 1'd0;
end


always @(posedge clock) begin

	if(enable) begin: setCoefficients
		integer k;
		for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
			coefficientOut <= coefficients[k];
		end
		
		filterSetFlag <= 1'd1;
	end
	else begin
		filterSetFlag <= 1'd0;
	end
	
end


endmodule
