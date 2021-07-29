/*

 absolute_value_tb.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
 This module is a test bench for the module absolute_value. values for dataInRe are set and
 the values of dataOut are then the values of dataOut are observed in ModelSim.

*/



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
reg signed [DATA_WIDTH - 1:0] dataInRe;
reg signed [DATA_WIDTH - 1:0] dataInIm;
wire signed [DATA_WIDTH:0] dataOut;



reg signed [DATA_WIDTH - 1:0] dataInBuffRe[0:19];
reg signed [DATA_WIDTH - 1:0] dataInBuffIm[0:19];
reg signed [DATA_WIDTH:0] obtainedDataOutBuff [0:19];
reg signed [DATA_WIDTH:0] expectedDataOutBuff [0:19];



// Setting the init values.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	dataInRe = 18'd0;
	dataInIm = 18'd0;
	
	
	
	
	dataInBuffRe[0] = 18'd59;
	dataInBuffIm[0] = 18'd15683;
	dataInBuffRe[1] = 18'd15683;
	dataInBuffIm[1] = -18'd15696;
	dataInBuffRe[2] = -18'd15696;
	dataInBuffIm[2] = -18'd111111;
	dataInBuffRe[3] = -18'd111111;
	dataInBuffIm[3] = -18'd131000;
	dataInBuffRe[4] = -18'd131000;
	dataInBuffIm[4] = 18'd69420;
	dataInBuffRe[5] = 18'd69420;
	dataInBuffIm[5] = -18'd12363;
	dataInBuffRe[6] = -18'd12363;
	dataInBuffIm[6] = -18'd123456;
	dataInBuffRe[7] = -18'd123456;
	dataInBuffIm[7] = -18'd123456;
	dataInBuffRe[8] = 18'd65432;
	dataInBuffIm[8] = 18'd10101;
	dataInBuffRe[9] = 18'd10101;
	dataInBuffIm[9] = 18'd5786;
	dataInBuffRe[10] = 18'd5786;
	dataInBuffIm[10] = -18'd9989;
	dataInBuffRe[11] = -18'd9989;
	dataInBuffIm[11] = -18'd45876;
	dataInBuffRe[12] = -18'd45876;
	dataInBuffIm[12] = 18'd0;
	dataInBuffRe[13] = 18'd0;
	dataInBuffIm[13] = -18'd123;
	dataInBuffRe[14] = -18'd123;
	dataInBuffIm[14] = -18'd9989
	dataInBuffRe[15] = 18'd513;
	dataInBuffIm[15] = -18'd3516;
	dataInBuffRe[16] = -18'd230;
	dataInBuffIm[16] = -18'd334;
	dataInBuffRe[17] = -18'9879;
	dataInBuffIm[17] = 18'd1793
	dataInBuffRe[18] = 18'd12;
	dataInBuffIm[18] = -18'd78;
	dataInBuffRe[19] = 18'd0;
	dataInBuffIm[19] = -18'd1357;
	
	
	
	
	expectedDataOutBuff[0] = 18'd15697;
	expectedDataOutBuff[1] = 18'd19616;
	expectedDataOutBuff[2] = 18'd115035;
	expectedDataOutBuff[3] = 18'd158777;
	expectedDataOutBuff[4] = 18'd148355;
	expectedDataOutBuff[5] = 18'd72510;
	expectedDataOutBuff[6] = 18'd126546;
	expectedDataOutBuff[7] = 18'd154320;
	expectedDataOutBuff[8] = 18'd67957;
	expectedDataOutBuff[9] = 18'd11547;
	expectedDataOutBuff[10] = 18'd11435;
	expectedDataOutBuff[11] = 18'd48373;
	expectedDataOutBuff[12] = 18'd45876;
	expectedDataOutBuff[13] = 18'd123;
	expectedDataOutBuff[14] = 18'd10019;
	expectedDataOutBuff[15] = 18'd3644;
	expectedDataOutBuff[16] = 18'd391;
	expectedDataOutBuff[17] = 18'd10327;
	expectedDataOutBuff[18] = 18'd81;
	expectedDataOutBuff[19] = 18'd1357;
	
	


	//Set enableModule high after RST_CYCLES clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end






// Instantiating the dut module.
absolute_value #(
	.DATA_WIDTH 	(DATA_WIDTH)
) dut (
	.clock			(clock),
	.enable			(enableModule),
	.dataInRe		(dataInRe),
	.dataInIm		(dataInIm),
	
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
