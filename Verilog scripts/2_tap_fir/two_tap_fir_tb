// Test script for the two_tap_fir filter
module two_tap_fir_tb;

// Set the parameters for the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

reg clock;
reg reset;
reg startTransistion;
wire [31:0] outputData;

// Connect the two_tap_fir script
two_tap_fir dut(
	.clock 	(clock),
	.startTransistion (startTransistion),
	.dataOut (outputData)
);



initial begin
	reset = 1;
	startTransistion = 0;
	repeat(RST_CYCLES) @ (posedge clock);
	reset = 0;
	startTransistion = 1;
end

initial begin
	clock = 0;
end

real HALF_CLOCK_PERIOD = (1000000000.0/$itor(CLOCK_FREQ))/2.0;

integer half_cycles = 0;

always begin
	#(HALF_CLOCK_PERIOD);
	clock = ~clock;
	half_cycles = half_cycles + 1;

	if(half_cycles == (2*NUM_CYCLES)) begin
		$stop;
	end
end

endmodule
