module setupFIRFilter #(
	parameter LENGTH = 10,
	parameter DATA_WIDTH = 8
)

(
	input clock,
	input enable,
	output reg filterSetFlag,
	output reg signed [DATA_WIDTH - 1:0] coefficient_in;
);


endmodule
