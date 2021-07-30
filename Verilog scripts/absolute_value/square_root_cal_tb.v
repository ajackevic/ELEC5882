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
reg [INPUT_DATA_WIDTH - 1:0] dataIn;
wire [OUTPUT_DATA_WIDTH - 1:0] dataOut;


// Local parameters used for the test bench.
reg signed [INPUT_DATA_WIDTH - 1:0] dataInBuff[0:9];
reg signed [INPUT_DATA_WIDTH:0] obtainedDataOutBuff [0:9];
reg signed [INPUT_DATA_WIDTH:0] expectedDataOutBuff [0:9];



// FSM
reg [1:0] state;
localparam IDLE = 0;
localparam SEND_DATA = 1;
localparam PRINT_RESULTS = 2;
localparam STOP = 3;





// Setting the init values.
initial begin
	clock = 1'd0;
	enableModule = 1'd0;
	dataIn = 72'd0;
	state = IDLE;
	
	
	// Setting the values of dataIn buffer.
	dataInBuff[0] = 72'd45646;
	dataInBuff[1] = 72'd454536;
	dataInBuff[2] = 72'd258211;
	dataInBuff[3] = 72'd213247;
	dataInBuff[4] = 72'd25810;
	dataInBuff[5] = 72'd4;
	dataInBuff[6] = 72'd5688;
	dataInBuff[7] = 72'd86542;
	dataInBuff[8] = 72'd756787;
	dataInBuff[9] = 72'd123;

	
	
	expectedDataOutBuff[0] = 36'd213;
	expectedDataOutBuff[1] = 36'd674;
	expectedDataOutBuff[2] = 36'd508;
	expectedDataOutBuff[3] = 36'd461;
	expectedDataOutBuff[4] = 36'd160;
	expectedDataOutBuff[5] = 36'd2;
	expectedDataOutBuff[6] = 36'd75;
	expectedDataOutBuff[7] = 36'd294;
	expectedDataOutBuff[8] = 36'd869;
	expectedDataOutBuff[9] = 36'd11;

	
	
	// Set enableModule high after RST_CYCLES number of clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end





// Instantiating the dut module.
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
