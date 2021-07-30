/*

 read_MIF_file_tb.v
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
 
 Set DATA_TYPE to 1 to load the coeff and 2 to load the input data.


*/



// Setting the time unit for this module.
`timescale 1 ns/100 ps


module read_MIF_file_tb;




// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 1000000;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

// Parameters for the dut module.
localparam LENGTH = 800;
localparam DATA_WIDTH = 12;




// Local parameters for the dut module.
reg clock;
reg enableModule;
wire signed [DATA_WIDTH-1:0] outputValueRe;
wire signed [DATA_WIDTH-1:0] outputValueIm;
wire dataFinishedFlag;



// Local parameters for the test bench.
reg signed [DATA_WIDTH - 1: 0] obtainedOutBuff [0:19];
reg signed [DATA_WIDTH - 1: 0] expectedOutBuff [0:19];
reg [4:0] counter;
reg testFailedFlag;




// FSM
reg [1:0] state;
localparam IDLE = 0;
localparam READ_DATA = 1;
localparam PRINT_RESULTS = 2;
localparam STOP = 3;



// Setting the init values.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	counter = 5'd0;
	testFailedFlag = 1'd0;
	state = IDLE;
	
	
	
	expectedOutBuff[0] = 12'd1026;
	expectedOutBuff[1] = 12'd1769;
	expectedOutBuff[2] = 12'd3;
	expectedOutBuff[3] = 12'd2046;
	expectedOutBuff[4] = -12'd1022;
	expectedOutBuff[5] = 12'd1516;
	expectedOutBuff[6] = -12'd1451;
	expectedOutBuff[7] = 12'd424;
	expectedOutBuff[8] = -12'd1037;
	expectedOutBuff[9] = 12'd659;
	expectedOutBuff[10] = 12'd1377;
	expectedOutBuff[11] = 12'd58;
	expectedOutBuff[12] = 12'd1410;
	expectedOutBuff[13] = 12'd130;
	expectedOutBuff[14] = 12'd1433;
	expectedOutBuff[15] = 12'd358;
	expectedOutBuff[16] = 12'd1446;
	expectedOutBuff[17] = 12'd624;
	expectedOutBuff[18] = 12'd1451;
	expectedOutBuff[19] = 12'd1082;
	
	
	
	// Set enableModule to 1 after RST_CYCLES clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end




// Connecting the instantiated dut module.
read_MIF_file #(
	.LENGTH 				(LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH),
	.DATA_TYPE			(1)

) dut (
	.clock				(clock),
	.enable				(enableModule),
	
	.dataFinishedFlag	(dataFinishedFlag),
	.outputRe			(outputValueRe),
	.outputIm			(outputValueIm)
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




integer n;
always @ (posedge clock) begin
	case(state)
		
		
		IDLE: begin
			if(enableModule) begin
				state = READ_DATA;
			end
		end
		
		READ_DATA: begin
		
		end
		
		PRINT_RESULTS: begin
		
		end
		
		STOP: begin
		
		end
		
		default: begin
		
		end
		
	endcase
end

endmodule
