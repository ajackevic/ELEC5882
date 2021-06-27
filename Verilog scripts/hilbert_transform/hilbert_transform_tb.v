module hilbert_transform_tb;


// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 20;
localparam LENGTH = 27;
localparam DATA_WIDTH = 18;


// Creating the lcoal parameters.
reg clock;
reg enable;
reg stopDataInFlag;
reg signed [DATA_WIDTH - 1:0] dataIn;
wire signed [(DATA_WIDTH * 2) - 1:0] dataOutRe;
wire signed [(DATA_WIDTH * 2) - 1:0] dataOutIm;


// Connect the device under test.
hilbert_transform #(
	.LENGTH 					(LENGTH),
	.DATA_WIDTH 			(DATA_WIDTH)
) dut (
	.clock					(clock),
	.enable					(enable),
	.stopDataInFlag		(stopDataInFlag),
	.dataIn					(dataIn),
	
	.dataOutRe				(dataOutRe),
	.dataOutIm				(dataOutIm)
);

initial begin
	enable = 1'd0;
	stopDataInFlag = 1'd0;
	dataIn = 18'd0;
	repeat(RST_CYCLES) @ (posedge clock);
	enable = 1'd1;
	
	repeat(50) @ (posedge clock);
	
	repeat(1) @ (posedge clock);
	dataIn = 18'd60;
	repeat(1) @ (posedge clock);
	dataIn = 18'd70;
	repeat(1) @ (posedge clock);
	dataIn = 18'd80;
	repeat(1) @ (posedge clock);
	dataIn = 18'd90;
	repeat(1) @ (posedge clock);
	dataIn = 18'd100;
	repeat(1) @ (posedge clock);
	dataIn = 18'd110;
	repeat(1) @ (posedge clock);
	dataIn = 18'd120;
	repeat(1) @ (posedge clock);
	dataIn = -18'd126;
	repeat(1) @ (posedge clock);
	dataIn = -18'd116;
	repeat(1) @ (posedge clock);
	dataIn = -18'd106;
	repeat(1) @ (posedge clock);
	dataIn = -18'd96;
	repeat(1) @ (posedge clock);
	dataIn = -18'd86;
	repeat(1) @ (posedge clock);
	dataIn = -18'd76;
	repeat(1) @ (posedge clock);
	dataIn = -18'd66;
	repeat(1) @ (posedge clock);
	dataIn = -18'd56;
	repeat(1) @ (posedge clock);
	dataIn = -18'd116;
	repeat(1) @ (posedge clock);
	dataIn = -18'd106;
	repeat(1) @ (posedge clock);
	dataIn = -18'd96;
	repeat(1) @ (posedge clock);
	dataIn = -18'd116;
	repeat(1) @ (posedge clock);
	dataIn = 18'd120;
	repeat(1) @ (posedge clock);
	dataIn = 18'd0;
	repeat(1) @ (posedge clock);
	dataIn = -18'd60;
	repeat(1) @ (posedge clock);
	dataIn = -18'd111;
	repeat(1) @ (posedge clock);
	dataIn = -18'd114;
	repeat(1) @ (posedge clock);
	dataIn = 18'd13;
	repeat(1) @ (posedge clock);
	dataIn = -18'd93;
	repeat(1) @ (posedge clock);
	dataIn = 18'd111;
	repeat(1) @ (posedge clock);
	dataIn = -18'd87;
	
	repeat(1) @ (posedge clock);
	stopDataInFlag = 1'd1;
end


// Set the initial value of the clock.
initial begin
	clock = 0;
end


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
