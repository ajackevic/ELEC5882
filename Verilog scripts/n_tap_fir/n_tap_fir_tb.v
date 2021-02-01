module n_tap_fir_tb;

// Parameters for creating the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

reg clock;
reg startTransistion;
reg [7:0] sr_coeff_in;
wire [7:0] dataOut1;
wire [7:0] dataOut2;
wire [7:0] dataOut3;

// Connec the device under test
n_tap_fir dut(
	.clock					(clock),
	.load_coefficients_flag (startTransistion),
	.coefficient_in	  		(sr_coeff_in),
	.data_out1 				(dataOut1),
	.data_out2 				(dataOut2),
	.data_out3 				(dataOut3)
);



initial begin
	// Set the init values and then set the coefficient values every clock cycle
	sr_coeff_in = 0;
	startTransistion = 0;
	repeat(RST_CYCLES) @ (posedge clock);
	startTransistion = 1;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd1;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd2;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd3;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd4;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd5;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd6;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd7;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd8;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd9;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd10;
	repeat(1) @ (posedge clock);
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
