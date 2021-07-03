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


initial begin
	integer k;

	$readmemb("MFImpulseCoeff.mif", MIFBuffer);
	
	
	for (k = 0; k <= LENGTH - 1 ; k = k + 1) begin
		realCoeffBuffer[k] = {(DATA_WIDTH){1'd0}};
		imagCoeffBuffer[k] = {(DATA_WIDTH){1'd0}};
	end
end



endmodule
