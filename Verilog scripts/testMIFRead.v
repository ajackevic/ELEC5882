module testMIFRead #(
	parameter LENGTH = 20000,
	parameter DATA_WIDTH = 16

)(
	input clock,
	input enable,
	
	output signed [DATA_WIDTH - 1:0] outputValue
);


reg signed [DATA_WIDTH-1:0] myMemory [0:LENGTH - 1];


initial begin
	$readmemb("MFImpulseCoeff.mif", myMemory);
end



endmodule
