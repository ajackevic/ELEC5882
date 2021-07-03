/*

 setup_MF_coeff_tb.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module is a test bench for the module setup_MF_coeff. It connects to the instantiated 
 module. The test bench as of now does not do any self-testing, only observing the signals 
 in ModelSim. It is vital that the MIF file is placed in <project directory>\simulation\modelsim, 
 otherwise ModelSim will no read the MIF data. To compile successfully in Quartus have a copy
 of the MIF file in <project directory>\ELEC5882\Verilog scripts\matched_filter too.


*/



// Setting the time unit for this module.
`timescale 1 ns/100 ps


module setup_MF_coeff_tb;




// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 50000;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

// Parameters for the dut module.
localparam LENGTH = 10000;
localparam DATA_WIDTH = 16;




// Local parameters for the dut module.
reg clock;
reg enableModule;
wire signed [DATA_WIDTH-1:0] outputValueRe;
wire signed [DATA_WIDTH-1:0] outputValueIm;
wire coeffSetFlag;




// Setting the init values.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	// Set enableModule to 1 after RST_CYCLES clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end




// Connecting the instantiated dut module.
setup_MF_coeff #(
	.LENGTH 			(LENGTH),
	.DATA_WIDTH 	(DATA_WIDTH),
	.DATA_MIF		(1)

) dut (
	.clock			(clock),
	.enable			(enableModule),
	
	.coeffSetFlag	(coeffSetFlag),
	.coeffOutRe		(outputValueRe),
	.coeffOutIm		(outputValueIm)
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
