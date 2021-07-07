module  absolute_value #(
	parameter DATA_WIDTH = 18
) (
	input clock,
	input enable,
	input signed [DATA_WIDTH - 1:0] dataIn,
	
	output reg signed [DATA_WIDTH - 1:0] dataOut
);



// Setting the output to an initial value of 0. 
initial begin
	dataOut <= {(DATA_WIDTH){1'd0}};
end



always @ (posedge clock) begin

	// If enable is set, do the following. Else set the output to 0.
	if(enable) begin
	
		// Check the MSB bit of dataIn. If 1, the value is negative, hence dataOut should be 
		// set to -dataIn, else dataOut should be equal to dataIn
		if(dataIn[DATA_WIDTH - 1] == 1'd1) begin
			dataOut <= -dataIn;
		end
		else begin
			dataOut <= dataIn;
		end
	end
	else begin
		dataOut <= {(DATA_WIDTH){1'd0}};
	end

end


endmodule
