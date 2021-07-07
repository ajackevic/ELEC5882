// Setting the time unit for this module.
`timescale 1 ns/100 ps


module absolute_value_tb;



// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 1000000;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

localparam DATA_WIDTH = 18;


// Local parameters for the dut module.
reg clock;
reg enableModule;
reg signed [DATA_WIDTH - 1:0] dataIn;
wire signed [DATA_WIDTH - 1:0] dataOut;



// Setting the init values.
initial begin
	clock = 1'd0;
end




absolute_value #(
	.DATA_WIDTH 	(DATA_WIDTH)
) dut (
	.clock			(clock),
	.enable			(enableModule),
	.dataIn			(dataIn),
	
	.dataOut			(dataOut)
);





// Clock parameters.
real HALF_CLOCK_PERIOD = (1000000000.0/$itor(CLOCK_FREQ))/2.0;
integer half_cycles = 0;



// Create the clock toggeling and stop it simulation when half_cycles == (2*NUM_CYCLES).
always begin
	#(HALF_CLOCK_PERIOD);
	clock = ~clock;
	half_cycles = half_cycles + 1;

	if(half_cycles == (2*NUM_CYCLES)) begin
		$stop;
	end
end




endmodule
