// Setting the time unit for this module.
`timescale 1 ns/100 ps


module squareRootCal_tb;



// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 1000000;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;



// Local parameters for the dut module.
reg clock;
reg enableModule;
reg [141:0] dataIn;
wire [71:0] dataOut;



// Setting the init values.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	dataIn = 141'd1234;
	
	
	// Set enableModule high after RST_CYCLES number of clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end













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



endmodule;
