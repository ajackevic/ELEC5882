module testMIFRead #(
	parameter LENGTH = 10000,
	parameter DATA_WIDTH = 16

)(
	input clock,
	input enable,
	
	output reg coeffSetFlag,	
	output signed [DATA_WIDTH - 1:0] coeffOutRe,
	output signed [DATA_WIDTH - 1:0] coeffOutIm
);


reg signed [DATA_WIDTH-1:0] MIFBuffer [0:(LENGTH * 2) - 1];

reg signed [DATA_WIDTH-1:0] realCoeffBuffer [0:LENGTH - 1];
reg signed [DATA_WIDTH-1:0] imagCoeffBuffer [0:LENGTH - 1];
// Width is log2(LENGTH) rounded up
reg [13:0] coeffBufferCounter; 

initial begin: initValues
	integer k;
	
	$readmemb("MFImpulseCoeff.mif", MIFBuffer);
	
	coeffBufferCounter = 14'd0;
	for (k = 0; k <= (LENGTH * 2) - 1 ; k = k + 2) begin
		realCoeffBuffer[coeffBufferCounter] = MIFBuffer[k];
		imagCoeffBuffer[coeffBufferCounter] = MIFBuffer[k+1];
		
		coeffBufferCounter = coeffBufferCounter + 14'd1;
	end
end



always @ (posedge clock) begin


end


endmodule
