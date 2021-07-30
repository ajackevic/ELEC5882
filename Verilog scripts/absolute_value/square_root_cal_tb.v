// Setting the time unit for this module.
`timescale 1 ns/100 ps


module square_root_cal_tb;



// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 1000000;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;



// Parameters for the dur module. 
// INPUT_DATA_WIDTH = (log2(2 * MaxValue^2))) rounded up. Has to be an even number.
// OUTPUT_DATA_WIDTH = INPUT_DATA_WIDTH / 2.
localparam INPUT_DATA_WIDTH = 72;  
localparam OUTPUT_DATA_WIDTH = 36;


// Local parameters for the dut module.
reg clock;
reg enableModule;
reg [141:0] dataIn;
wire [70:0] dataOut;



// Setting the init values.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	dataIn = 141'd1234;
	
	
	// Set enableModule high after RST_CYCLES number of clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end


square_root_cal #(
	.INPUT_DATA_WIDTH		(INPUT_DATA_WIDTH),
	.OUTPUT_DATA_WIDTH	(OUTPUT_DATA_WIDTH)
) dut (
	.clock					(clock),
	.enable					(enableModule),
	.inputData				(dataIn),
	
	.outputData				(dataOut)
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
