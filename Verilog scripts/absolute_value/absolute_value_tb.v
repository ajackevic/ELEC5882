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
	enableModule = 1'd0;
	dataIn = 18'd0;
	
	//Set enableModule.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
	
	// Send the data.
	repeat(1) @ (posedge clock);
	dataIn = 18'd59;
	repeat(1) @ (posedge clock);
	dataIn = 18'd15683;
	repeat(1) @ (posedge clock);
	dataIn = -18'd15696;
	repeat(1) @ (posedge clock);
	dataIn = -18'd111111;
	repeat(1) @ (posedge clock);
	dataIn = -18'd131000;
	repeat(1) @ (posedge clock);
	dataIn = 18'd69420;
	repeat(1) @ (posedge clock);
	dataIn = -18'd12363;
	repeat(1) @ (posedge clock);
	dataIn = -18'd123456;
	repeat(1) @ (posedge clock);
	dataIn = 18'd65432;
	repeat(1) @ (posedge clock);
	dataIn = 18'd10101;
	repeat(1) @ (posedge clock);
	dataIn = 18'd5786;
	repeat(1) @ (posedge clock);
	dataIn = -18'd9989;
	repeat(1) @ (posedge clock);
	dataIn = -18'd45876;
	repeat(1) @ (posedge clock);
	dataIn = 18'd0;
	repeat(1) @ (posedge clock);
	dataIn = -18'd123;
	repeat(1) @ (posedge clock);
	enableModule = 1'd0;
end






// Instantiating the dut module.
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
