module squareRootCal(
	input clock,
	input enable,
	input [141:0] inputData,
	
	output [71:0] outputData
);



reg [141:0] currentBits;
reg [141:0] subtractBits;
reg [141:0] remainderBits;

initial begin
	currentBits <= 142'd0;
	subtractBits <= 142'd0;
	remainderBits <= 142'd0;
end



always @ (posedge clock or enable) begin












end

endmodule
