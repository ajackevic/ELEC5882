module n_tap_fir_tb;

// Parameters for creating the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

reg clock;
reg load_coefficients_flag;
reg load_data_flag;
reg stop_data_load_flag;
reg [7:0] sr_coeff_in;
reg [7:0] sr_data_in;
wire [7:0] dataOut1;
wire [7:0] dataOut2;
wire [18:0] dataOut3;

// Connect the device under test
n_tap_fir #(
	.length			(20)
	) dut(
	.clock					(clock),
	.load_coefficients_flag (load_coefficients_flag),
	.load_data_flag			(load_data_flag),
	.stop_data_load_flag	(stop_data_load_flag),
	.coefficient_in	  		(sr_coeff_in),
	.data_in				(sr_data_in),
	.data_out1 				(dataOut1),
	.data_out2 				(dataOut2),
	.data_out3 				(dataOut3)
);


initial begin

	// Set the init values. Then send the coefficients and then the data in
	// a serial manner, one clock cycle at a time.
	sr_coeff_in = 0;
	stop_data_load_flag = 0;
	sr_data_in = 0;
	load_coefficients_flag = 0;
	load_data_flag = 0;
	repeat(RST_CYCLES) @ (posedge clock);

	// Set the coiefficient values. Make sure the number of coefficients is
	// equal to the set length of the n_tap_fir module. In this case there are
	// 20 set values,
	load_coefficients_flag = 1;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd34;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd34;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd49;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd125;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd179;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd205;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd8;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd97;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd109;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd165;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd253;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd9;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd1;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd59;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd75;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd19;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd58;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd159;
	repeat(1) @ (posedge clock);
	sr_coeff_in = 8'd10;
	repeat(20) @ (posedge clock);
	load_data_flag = 1;

	// Set the input data values, in this case there are 51 values.
	repeat(5) @ (posedge clock);
	sr_data_in = 8'd10;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd20;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd30;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd40;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd50;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd60;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd70;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd80;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd90;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd100;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd110;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd120;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd130;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd140;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd150;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd160;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd170;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd180;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd190;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd200;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd140;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd150;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd160;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd140;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd120;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd190;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd145;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd142;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd13;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd163;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd111;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd169;

	// Need to add [length number entered to the n_tap_fir module - 1], in thus case
	// that is 19 padded 0s. This is required by convolution opperation that the FIR
	// filters achives.
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);`
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	sr_data_in = 8'd0;
	repeat(1) @ (posedge clock);
	stop_data_load_flag =1 ;
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
