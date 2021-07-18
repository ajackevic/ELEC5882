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
reg [71:0] tempOut;





initial begin
	currentBits <= 142'd0;
	subtractBits <= 142'd0;
	remainderBits <= 142'd0;
	dataIn <= 142'd0;
	tempOut <= 71'd0;
end



integer i;
always @ (posedge clock or enable) begin
	if(enable) begin
		dataIn = inputData;
		currentBits = 142'd0;
		subtractBits = 142'd0;
		remainderBits = 142'd0;
		
		
		for(i = 71; i => 0; i = i - 1) begin
			currentBits = {currentBits[141:2], dataIn[(i*2)-1:(i*2)-3]};
			subtractBits = {remainderBits[139:0], 2'd1};
			
			remainderBits = currentBits - subtractBits;
			
			if(remainderBits[141] == 1'd1) begin	// If remainderBits is neg
				tempOut[i] = 1'd0;
			end
			else begin										// If remainderBits is pos (0 is pos)
				tempOut[i] = 1'd1;
				currentBits = remainderBits;
			end
			
			remainderBits = 141'd0;
			remainderBits = {remainderBits[141:(71-i)+1], tempOut[71:i]}
			
		end	
		
	
	end
	
	else begin
		outputData <= 72'd0;
	end









end

endmodule
