module squareRootCal(
	input clock,
	input enable,
	input [141:0] inputData,
	
	output reg [70:0] outputData
);



reg [141:0] currentBits;
reg [141:0] subtractBits;
reg [141:0] remainderBits;
reg [141:0] dataIn;
reg [70:0] tempOut;
reg intFlag;
reg signed [7:0] i;

reg [141:0] oldCurrentBits;
reg [141:0] oldRemainderBits;





initial begin
	currentBits <= 142'd0;
	subtractBits <= 142'd0;
	remainderBits <= 142'd0;
	dataIn <= 142'd0;
	oldCurrentBits <= 142'd0;
	oldRemainderBits <= 142'd0;
	
	tempOut <= 71'd0;
	
	intFlag <= 1'd0;
	i <= 8'd70;
end



//integer i;
integer n;
always @ (posedge clock or enable) begin

	if(enable && (intFlag == 1'd0)) begin
	
		// With each new enable/value, reset the main parameters
		dataIn = inputData;
		currentBits = 142'd0;
		subtractBits = 142'd0;
		remainderBits = 142'd0;
		tempOut = 71'd0;
		intFlag = 1'd1;
	end
	
	else if(enable && i != -8'd1) begin
		
		// A for loop for calculating the square root.
		currentBits = {currentBits[139:0], dataIn[141:140]};
		dataIn = dataIn << 2;
		
		// subtractBits is equal to {b'remainderBits,01}.
		subtractBits = {remainderBits[139:0], 2'd1};
		
		// Calculatting the remainderBits.	
		if(subtractBits > currentBits) begin
			tempOut[i] = 1'd0;
			
		end
		else begin										// remainderBits is pos (0 is pos)

			oldCurrentBits = currentBits;
			remainderBits = currentBits - subtractBits;
			oldRemainderBits = remainderBits;
			tempOut[i] = 1'd1;
			currentBits = remainderBits;
			
		end
		
		// Reset remainderBits, then set its value to 0's bit shifted by (71-i) with 
		// the values of tempOut.
		remainderBits = 141'd0;
	
		remainderBits = remainderBits + (tempOut >> (i));
		
		
		i = i - 8'd1;
		
	end	
	
	else begin
		outputData = tempOut;
	end




end

endmodule
