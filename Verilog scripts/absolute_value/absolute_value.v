/*

 absolute_value.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
 This module obtaines the absolute value of dataIn. Once enable is set, if MSB of dataIn is 
 to 1 dataOut is set to - dataIn, else dataOut is equal to dataIn.

*/


module absolute_value #(
	parameter DATA_WIDTH = 18
) (
	input clock,
	input enable,
	input signed [DATA_WIDTH - 1:0] dataInRe,
	input signed [DATA_WIDTH - 1:0] dataInIm,
	
	output reg signed [DATA_WIDTH - 1:0] dataOut
);

reg [DATA_WIDTH - 1:0] absDataInRe;
reg [DATA_WIDTH - 1:0] absDataInIm;



// Setting the initial value to 0. 
initial begin
	absDataInRe <= {(DATA_WIDTH){1'd0}};
	absDataInIm <= {(DATA_WIDTH){1'd0}};
	
	dataOut <= {(DATA_WIDTH){1'd0}};
end




always @ (posedge clock) begin

	// If enable is set, do the following. Else set the output to 0.
	if(enable) begin
	
		// Check the MSB bit of dataIn. If 1, the value is negative, hence dataOut should be 
		// set to -dataIn, else dataOut should be equal to dataIn
		if(dataInRe[DATA_WIDTH - 1] == 1'd1) begin
			dataOut <= -dataInRe;
		end
		else begin
			dataOut <= dataInRe;
		end
		
		if(dataInIm[DATA_WIDTH - 1] == 1'd1) begin
			dataOut <= -dataInIm;
		end
		else begin
			dataOut <= dataInIm;
		end
		
	end
	else begin
		dataOut <= {(DATA_WIDTH){1'd0}};
	end

end



endmodule
