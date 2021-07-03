module testMIFRead #(
	parameter LENGTH = 20000,
	parameter DATA_WIDTH = 16

)(
	input clock,
	input enable,
	
	output reg coeffSetFlag,	
	output signed [DATA_WIDTH - 1:0] coeffOutRe,
	output signed [DATA_WIDTH - 1:0] coeffOutIm
);


reg signed [DATA_WIDTH-1:0] myMemory [0:LENGTH - 1];


initial begin
	$readmemb("MFImpulseCoeff.mif", myMemory);
end



endmodule
