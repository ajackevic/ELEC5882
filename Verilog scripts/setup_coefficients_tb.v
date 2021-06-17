module setup_coefficients_tb;


// Parameters for creating the 50MHz clock signal
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 10;

// Parameters for the dut module.
localparam LENGTH = 20;
localparam DATA_WIDTH = 8;


// Local parameters for the dut module.
reg clock;
reg enableModule; 
wire filterSetFlag;
wire signed [DATA_WIDTH-1:0] coefficientOut;


// Local parameters for interacting with the dut output.
// Counter length should be log2(LENGTH).
reg [4:0] coefficientCounter
reg signed [DATA_WIDTH - 1:0] expectedOutputs [0:LENGTH - 1];


// FSM states.
reg [1:0] state;
localparam [1:0] IDLE = 2'd0;
localparam [1:0] CHECK_COEFFICIENTS = 2'd1;
localparam [1:0] DISPLAY_RESULTS = 2'd2;



// Set the initial value of the clock.
initial begin
	clock = 0;
	enableModule = 0;
	
	// Set the expected outputs
	expectedOutputs[0] = 8'd34;
	expectedOutputs[1] = 8'd34;
	expectedOutputs[2] = 8'd0;
	expectedOutputs[3] = 8'd49;
	expectedOutputs[4] = 8'd125;
	expectedOutputs[5] = -8'd77;
	expectedOutputs[6] = -8'd51;
	expectedOutputs[7] = 8'd8;
	expectedOutputs[8] = 8'd98;
	expectedOutputs[9] = 8'd109;
	expectedOutputs[10] = -8'd91;
	expectedOutputs[11] = -8'd3;
	expectedOutputs[12] = 8'd9;
	expectedOutputs[13] = 8'd1;
	expectedOutputs[14] = 8'd59;
	expectedOutputs[15] = 8'd75;
	expectedOutputs[16] = 8'd19;
	expectedOutputs[17] = 8'd58;
	expectedOutputs[18] = -8'd97;
	expectedOutputs[19] = 8'd10;
	
	
	repeat(RST_CYCLES) @ (posedge clock);
	enableModule = 1'd1;
end



setupCoefficients # (
	.LENGTH				(LENGTH),
	.DATA_WIDTH			(DATA_WIDTH),
) dut (
	.clock				(clock),
	.enable				(enableModule),
	
	.filterSetFlag		(filterSetFlag),
	.coefficientOut	(coefficientOut)
);



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
			if(enableModule) begin
				state <= CHECK_COEFFICIENTS;
			end
		end
		
		CHECK_COEFFICIENTS: begin
			
		end
		
		DISPLAY_RESULTS: begin
		
		end
		
		default: beign
		
		end
	
	endcase
end



endmodule
