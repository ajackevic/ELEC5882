module squareRootCal(
	input clock,
	input enable,
	input [141:0] inputData,
	
	output [71:0] outputData
);



reg [141:0] currentBits;
reg [141:0] subtractBits;
reg [141:0] remainderBits;
reg [141:0] dataIn;

initial begin
	currentBits <= 142'd0;
	subtractBits <= 142'd0;
	remainderBits <= 142'd0;
	dataIn <= 142'd0;
end



integer i;
always @ (posedge clock or enable) begin
	if(enable) begin
		dataIn = inputData;
		currentBits = 142'd0;
		subtractBits = 142'd0;
		remainderBits = 142'd0;
		
		
		for(i = 71; i => 0; i = i - 1) begin
		currentBits = dataIn[(i*2)-1:(i*2)-3];
		
		end	
		
	
	end
	
	else begin
		outputData <= 72'd0;
	end









end

endmodule
