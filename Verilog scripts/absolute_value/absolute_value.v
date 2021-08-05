/*

 absolute_value.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
 This module obtaines the absolute value of dataIn. It checks the provided inputs
 dataInRe and dataInIm, makes them posative, and then uses the alpha max plus beta
 min approximation to obtain the abs value of the provided complex input. The 
 coefficients alpha is equal to 1, whilst beta is equal to 1/4. 
 
 This module is not used in the main module (pulse_compression_filter). This module 
 was created to compare the results and its resources when compared to calculating
 the abs value through the module square_root_cal.
 
*/


module absolute_value #(
	parameter DATA_WIDTH = 82
) (
	input clock,
	input enable,
	input signed [DATA_WIDTH - 1:0] dataInRe,
	input signed [DATA_WIDTH - 1:0] dataInIm,
	
	output reg signed [DATA_WIDTH:0] dataOut
);

reg [DATA_WIDTH - 1:0] absDataInRe;
reg [DATA_WIDTH - 1:0] absDataInIm;



// Setting the initial value to 0. 
initial begin
	absDataInRe <= {(DATA_WIDTH){1'd0}};
	absDataInIm <= {(DATA_WIDTH){1'd0}};
	
	dataOut <= {(DATA_WIDTH + 1){1'd0}};
end




always @ (posedge clock) begin

	// If enable is set, do the following. Else set the output to 0.
	if(enable) begin
	
		// Check the MSB bit of dataIn. If 1, the value is negative, hence dataOut should be 
		// set to -dataIn, else dataOut should be equal to dataIn
		if(dataInRe[DATA_WIDTH - 1] == 1'd1) begin
			absDataInRe = -dataInRe;
		end
		else begin
			absDataInRe = dataInRe;
		end
		
		if(dataInIm[DATA_WIDTH - 1] == 1'd1) begin
			absDataInIm = -dataInIm;
		end
		else begin
			absDataInIm = dataInIm;
		end
		
		
		// Alpha (1/1) max plus beta (1/4) min. This if statment checks which value 
		// absDataInRe or absDataInIm is larger than the other. The smaller value 
		// if bit shifted twice to the right (same as * 1/4 rounded down) and then 
		// added to the larger value to get an approximation of the abs value.
		if(absDataInRe >= absDataInIm) begin
			dataOut = absDataInRe + (absDataInIm  >> 2);
		end
		else begin
			dataOut = absDataInIm + (absDataInRe >> 2);
		end
		
		
	end
	else begin
		dataOut = {(DATA_WIDTH + 1){1'd0}};
	end

end



endmodule
