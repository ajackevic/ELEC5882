/*

 hilbert_transform_tb.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module is a test bench for the script hilbert_transform.v. It tests 
 wheather the DUT module outputs the correct output values for the applied data.

*/


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
reg signed [DATA_WIDTH - 1: 0] dataInBuf [0:29];




// FSM states.
reg [1:0] state;
localparam [1:0] IDLE = 2'd0;
localparam [1:0] SEND_VALUES = 2'd1;
localparam [1:0] DISPLAY_RESULTS = 2'd2;
localparam [1:0] STOP = 2'd3;



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
	
	dataInBuff[0] = -18'd123;
	dataInBuff[1] = 18'd12111;
	dataInBuff[2] = 18'd891;
	dataInBuff[3] = 18'd9;
	dataInBuff[4] = 18'd0;
	dataInBuff[5] = 18'd511;
	dataInBuff[6] = 18'd1241;
	dataInBuff[7] = -18'd7819;
	dataInBuff[8] = -18'd76;
	dataInBuff[9] = 18'd1111;
	dataInBuff[10] = 18'd9861;
	dataInBuff[11] = -18'd90;
	dataInBuff[12] = -18'd8191;
	dataInBuff[13] = -18'd88910;
	dataInBuff[14] = 18'd888;
	dataInBuff[15] = -18'd9901;
	dataInBuff[16] = 18'd12;
	dataInBuff[17] = 18'd11111;
	dataInBuff[18] = -18'd1231;
	dataInBuff[19] = -18'd131072;
	dataInBuff[20] = -18'd131072;
	dataInBuff[21] = -18'd131072;
	dataInBuff[22] = 18'd89700;
	dataInBuff[23] = -18'd12;
	dataInBuff[24] = 18'd35111;
	dataInBuff[25] = -18'd78819;
	dataInBuff[26] = 18'd1;
	dataInBuff[27] = 18'd99719;
	dataInBuff[28] = 18'd999;
	dataInBuff[29] = -18'd666;

	
	
	repeat(RST_CYCLES) @ (posedge clock);
	enable = 1'd1;
end





// Set the initial value of the clock.
initial begin
	clock <= 0;
	state <= IDLE;
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






always @ (posedge clock) begin
	case(state) 
		IDLE: begin
			if(enable) begin
			
			end
		end
		
		SEND_VALUES: begin
		
		end
	
		DISPLAY_RESULTS: begin
		
		end
		
		STOP: begin
		
		end
		
		default: begin
		
		end	
	
	endcase
end

endmodule
