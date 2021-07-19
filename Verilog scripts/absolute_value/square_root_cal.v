/*

 square_root_cal.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
 This module calculates the square root value of the provided inputData value. This 
 is achieved through the usage of the Non-Restoring Square Root algorithm. The data 
 width of the output must be exactly half the input bit width. Input bit width must 
 be equal to an even number.
 
 To fully understand how the Non-Restoring Square Root method works pleas read 
 the following:
 - http://www.ijcte.org/papers/281-G850.pdf
 - https://digitalsystemdesign.in/non-restoring-algorithm-for-square-root/
 - http://www.ijceronline.com/papers/(NCASSGC)/W107-116.pdf
 

*/





module square_root_cal(
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

	// If enable do the square root operation.
	if(enable) begin
	
		// With each new enable/value, reset the main parameters
		dataIn = inputData;
		currentBits = 142'd0;
		subtractBits = 142'd0;
		remainderBits = 142'd0;
		tempOut = 71'd0;
		
		

		// A for loop which goes through all the values in. The for loop iterations
		// must equal half of inputData bit width.
		for(i = 70; i >= -0; i = i - 1) begin
			
			// Adding the MSB 2 bits of dataIn to the start of currentBits. Hence shift 
			// currentBits to the left by 2 positions and setting bits 0 and 1 to the 2
			// MSB's of dataIn.
			currentBits = {currentBits[139:0], dataIn[141:140]};
			// Shifting dataIn two positions so that in the next for loop iteration, the 
			// corresponding 2 bits of dataIn are processed.
			dataIn = dataIn << 2;
			
			
			// Setting subtractBits to remainderBits bit shifted by 2 values, with bits
			// 1 and 0 being set to 2'b01.
			subtractBits = {remainderBits[139:0], 2'd1};
			
			// Check if the remainder of currentBits - subtractBits is negative. If
			// subtractBits is larger than currentBits, then the remainder would be 
			// negative, else it would be posative (0 is considered posative). 
			if(subtractBits > currentBits) begin
				// If subtractBits > currentBits, set the current tempOut bit to 0.
				tempOut[i] = 1'd0;
			end
			else begin		
				// If currentBits > subtractBits (remainder is posative), set the
				// current tempOut bit to 1. Then recalculate currentBits. This is equal
				// to the remainder value of currentBits - subtractBits.
				tempOut[i] = 1'd1;
				currentBits = currentBits - subtractBits;
				
			end
			
			// Reset remainderBits, then set its value to the shifted value of 
			// tempOut. 
			remainderBits = 141'd0;
			remainderBits = remainderBits + (tempOut >> (i));
		end
		
		// Set the final value of tempOut to outputData.
		outputData = tempOut;
	end	
	
	
	// If enable is low, set outputData to 0.
	else begin
		outputData = 71'd0;
	end


end

endmodule
