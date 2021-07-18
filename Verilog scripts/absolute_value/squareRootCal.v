module squareRootCal(
	input clock,
	input enable,
	input [141:0] inputData,
	
	output reg [70:0] outputData
);





// Creating the local parameters.
reg [141:0] currentBits;
reg [141:0] subtractBits;
reg [141:0] remainderBits;
reg [141:0] dataIn;
reg [70:0] tempOut;



// Setting the localparam 
initial begin
	currentBits <= 142'd0;
	subtractBits <= 142'd0;
	remainderBits <= 142'd0;
	dataIn <= 142'd0;
	
	tempOut <= 71'd0;
	outputData <= 71'd0;
	
end





// Creating the integers which are used for the for loops in the always block.
integer i;
integer n;
always @ (posedge clock or enable) begin

	if(enable) begin
	
		// With each new enable/value, reset the main parameters
		dataIn = inputData;
		currentBits = 142'd0;
		subtractBits = 142'd0;
		remainderBits = 142'd0;
		tempOut = 71'd0;

		for(i = 70; i >= -0; i = i - 1) begin
			
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

				remainderBits = currentBits - subtractBits;
				tempOut[i] = 1'd1;
				currentBits = remainderBits;
				
			end
			
			// Reset remainderBits, then set its value to 0's bit shifted by (71-i) with 
			// the values of tempOut.
			remainderBits = 141'd0;
		
			remainderBits = remainderBits + (tempOut >> (i));
		end
		
		outputData = tempOut;
	end	
	
	else begin
		outputData = tempOut;
	end




end

endmodule
