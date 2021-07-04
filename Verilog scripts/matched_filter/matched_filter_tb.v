module matched_filter_tb;


// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 20;


// Creating the lcoal parameters.
reg clock;



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
