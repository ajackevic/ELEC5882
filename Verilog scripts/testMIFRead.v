module testMIFRead #(
	parameter LENGTH = 20000,
	parameter DATA_WIDTH = 13

)(
	input clock,
	input enable,
	
	output reg signed [DATA_WIDTH - 1:0] outputValue
);

reg [14:0] MIFAdress;

initial begin
	MIFAdress <= 15'd0;
	outputValue <= {(DATA_WIDTH){1'd0}};
end



MFImpulseResponseCoeff(
	.clock		(clock),
	.address		(MIFAdress),
	.q				(outputValue)
);



endmodule
