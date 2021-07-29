/*

 hilbert_transform_tb.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module is a test bench for the script hilbert_transform.v. It tests 
 wheather the DUT module outputs the correct output values for the applied data.
 The expected data in obtained from MATLAB. The results are printed in the transcript.

*/


module hilbert_transform_tb;




// Parameters for creating the 50MHz clock signal.
localparam NUM_CYCLES = 500;
localparam CLOCK_FREQ = 50000000;
localparam RST_CYCLES = 20;
localparam LENGTH = 27;
localparam DATA_WIDTH = 12;



// Creating the local parameters for the dut modle.
reg clock;
reg enable;
reg stopDataInFlag;
reg [5:0] counter;
reg signed [DATA_WIDTH - 1:0] dataIn;
wire signed [(DATA_WIDTH * 3) - 1:0] dataOutRe;
wire signed [(DATA_WIDTH * 3) - 1:0] dataOutIm;



// Creating the local parameters for testing aspect.
reg signed [DATA_WIDTH - 1: 0] dataInBuff [0:29];
reg signed [(DATA_WIDTH * 3) - 1: 0] expectedOutBufRe [0:29];
reg signed [(DATA_WIDTH * 3) - 1: 0] expectedOutBufIm [0:29];
reg signed [(DATA_WIDTH * 3) - 1: 0] obtainedOutBufRe [0:29];
reg signed [(DATA_WIDTH * 3) - 1: 0] obtainedOutBufIm [0:29];
reg signed testFailedFlag;



// FSM states.
reg [1:0] state;
localparam [1:0] IDLE = 2'd0;
localparam [1:0] SEND_VALUES = 2'd1;
localparam [1:0] CHECK_RESULTS = 2'd2;
localparam [1:0] DISPLAY_RESULTS = 2'd3;








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





// Setting the initial values of the test bench.
initial begin
	enable = 1'd0;
	stopDataInFlag = 1'd0;
	testFailedFlag = 1'd0;
	counter = 6'd0;
	dataIn = 12'd0;
	state = IDLE;
	
	// Setting the dataIn to a buffer.
	dataInBuff[0] = -12'd123;
	dataInBuff[1] = 12'd2000;
	dataInBuff[2] = 12'd891;
	dataInBuff[3] = 12'd9;
	dataInBuff[4] = 12'd0;
	dataInBuff[5] = 12'd511;
	dataInBuff[6] = 12'd1241;
	dataInBuff[7] = -12'd1567;
	dataInBuff[8] = -12'd76;
	dataInBuff[9] = 12'd1111;
	dataInBuff[10] = 12'd154;
	dataInBuff[11] = -12'd90;
	dataInBuff[12] = -12'd1239;
	dataInBuff[13] = -12'd1111;
	dataInBuff[14] = 12'd888;
	dataInBuff[15] = -12'd653;
	dataInBuff[16] = 12'd12;
	dataInBuff[17] = 12'd462;
	dataInBuff[18] = -12'd1231;
	dataInBuff[19] = -12'd1047;
	dataInBuff[20] = -12'd2044;
	dataInBuff[21] = -12'd2047;
	dataInBuff[22] = 12'd897;
	dataInBuff[23] = -12'd12;
	dataInBuff[24] = 12'd111;
	dataInBuff[25] = -12'd9;
	dataInBuff[26] = 12'd1;
	dataInBuff[27] = 12'd719;
	dataInBuff[28] = 12'd999;
	dataInBuff[29] = -12'd666;
	
	
	
	// Setting the expected real output to a buffer.
	expectedOutBufRe[0] = -36'd123;
	expectedOutBufRe[1] = 36'd2000;
	expectedOutBufRe[2] = 36'd891;
	expectedOutBufRe[3] = 36'd9;
	expectedOutBufRe[4] = 36'd0;
	expectedOutBufRe[5] = 36'd511;
	expectedOutBufRe[6] = 36'd1241;
	expectedOutBufRe[7] = -36'd1567;
	expectedOutBufRe[8] = -36'd76;
	expectedOutBufRe[9] = 36'd1111;
	expectedOutBufRe[10] = 36'd154;
	expectedOutBufRe[11] = -36'd90;
	expectedOutBufRe[12] = -36'd1239;
	expectedOutBufRe[13] = -36'd1111;
	expectedOutBufRe[14] = 36'd888;
	expectedOutBufRe[15] = -36'd653;
	expectedOutBufRe[16] = 36'd12;
	expectedOutBufRe[17] = 36'd462;
	expectedOutBufRe[18] = -36'd1231;
	expectedOutBufRe[19] = -36'd1047;
	expectedOutBufRe[20] = -36'd2044;
	expectedOutBufRe[21] = -36'd2047;
	expectedOutBufRe[22] = 36'd897;
	expectedOutBufRe[23] = -36'd12;
	expectedOutBufRe[24] = 36'd111;
	expectedOutBufRe[25] = -36'd9;
	expectedOutBufRe[26] = 36'd1;
	expectedOutBufRe[27] = 36'd719;
	expectedOutBufRe[28] = 36'd999;
	expectedOutBufRe[29] = -36'd666;
	
	
	
	// Setting the expected imaginary output to a buffer.
	expectedOutBufIm[0] = 36'd3075;
	expectedOutBufIm[1] = -36'd50000;
	expectedOutBufIm[2] = -36'd16002;
	expectedOutBufIm[3] = -36'd102225;
	expectedOutBufIm[4] = -36'd33141;
	expectedOutBufIm[5] = -36'd213234;
	expectedOutBufIm[6] = -36'd97862;
	expectedOutBufIm[7] = -36'd349786;
	expectedOutBufIm[8] = -36'd183179;
	expectedOutBufIm[9] = -36'd642587;
	expectedOutBufIm[10] = -36'd333333;
	expectedOutBufIm[11] = -36'd1241091;
	expectedOutBufIm[12] = -36'd501670;
	expectedOutBufIm[13] = -36'd4000755;
	expectedOutBufIm[14] = -36'd2405268;
	expectedOutBufIm[15] = 36'd4082876;
	expectedOutBufIm[16] = 36'd1021736;
	expectedOutBufIm[17] = 36'd1005284;
	expectedOutBufIm[18] = -36'd1824225;
	expectedOutBufIm[19] = 36'd4445650;
	expectedOutBufIm[20] = 36'd3175030;
	expectedOutBufIm[21] = -36'd4131095;
	expectedOutBufIm[22] = 36'd1150050;
	expectedOutBufIm[23] = 36'd2840122;
	expectedOutBufIm[24] = 36'd3065563;
	expectedOutBufIm[25] = 36'd3100240;
	expectedOutBufIm[26] = -36'd3291358;
	expectedOutBufIm[27] = -36'd403851;
	expectedOutBufIm[28] = 36'd2402470;
	expectedOutBufIm[29] = -36'd1608079;
	
	
	// Setting enable high after RST_CYCLES clock cycles.
	repeat(RST_CYCLES) @ (posedge clock);
	enable = 1'd1;
end





// Set the initial value of the clock.
initial begin
	clock <= 0;
end




// Setting the parameters of the clock.
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




// Creating the integer n which is then used in the FSM state DISPLAY_RESULTS.
integer n;
always @ (posedge clock) begin
	case(state) 
	
	
		// State IDLE. This state waits until enable is set high before transistioning to the state SEND_VALUES.
		IDLE: begin
			if(enable) begin
				state <= SEND_VALUES;
			end
		end
		
		
		// State SEND_VALUES. This state sends the dataIn value from the buffer to the dut module.
		// Additionally it stores the corresponding output to the buffers obtained OutBuf Re and Im. When the variable 
		// counter is equal to 35, the state transitions to CHECK_RESULTS.
		SEND_VALUES: begin
		
			// If counter is equal to 35, reset the counter and transition to the state CHECK_RESULTS.
			if(counter == 6'd35) begin
				state = CHECK_RESULTS;
				counter = 6'd0;
			end
			
			// If counter is not equal to 35, do the following opperation.
			else begin
			
				// Send the values of dataIn buffer to dataIn. When all the values were sent (29of them), set dataIn to 0.
				if(counter <= 6'd29) begin
					dataIn = dataInBuff[counter];
				end
				else begin
					dataIn = 12'd0;
				end
				
				
				// After dataIn is first applied, it takes 5 clock cycles for the output to be shown. Thus the outputs are 
				// only stored in obtainedOutBuf Re and Im after 5 clock cycles have passed.
				if(counter >= 6'd5) begin
					obtainedOutBufRe[counter - 6'd5] = dataOutRe;
					obtainedOutBufIm[counter - 6'd5] = dataOutIm;
				end
				
			end
			
			// Increment the counter by 1.
			counter = counter + 6'd1;	
		end
		
		
		// State CHECK_RESULTS. This state checks the obtained values with the expected values. If the values do not match,
		// the variable testFailedFlag is set high. If counter is equal to 29, the state transitions to DISPLAY_RESULTS.
		CHECK_RESULTS: begin
		
			// When counter is equal to 29, transition to DISPLAY_RESULTS.
			if(counter == 6'd29) begin
				state = DISPLAY_RESULTS;
			end
			else begin
				// Check if the corresponding obtained buffer values are equal to the expected buffer values. If not the 
				// variable testFailedFlag is set high.
				if((obtainedOutBufRe[counter] != expectedOutBufRe[counter]) || (obtainedOutBufIm[counter] != expectedOutBufIm[counter])) begin
					testFailedFlag = 1'd1;
				end
			end
		
			// Increment the variable counter by 1.
			counter = counter + 6'd1;
		end
	
	
		// State DISPLAY_RESULTS. This state prints the transcript of the test bench. After all the information is printed, 
		// the simulation is stoped.
		DISPLAY_RESULTS: begin
			$display("This is a test bench for the module hilbert_transform_tb. \n \n",
						"It tests whether the Hilbert transforms performs its main opperation correctly. \n \n",
						"It utalises the setup_HT_coeff modules to set up the dut modules coefficients and then \n \n",
						"supplies the input data to the module. The corresponding output of the module is then checked with \n \n",
						"outputs obtained from MATLAB. \n \n"
			);
			
			// Check if testFailedFlag is high, is so print the test failed, else it passed.
			if(testFailedFlag) begin
				$display("Test results: FAILED \n \n");
			end
			else begin
				$display("Test results: PASSED \n \n");
			end
			
			
			// Display all the expected and aquired results.
			for (n = 0; n <= 29; n = n + 1) begin
				$display("Real Data Out:     %d   Expected Value:%d   Obtained Value:%d", n+1, expectedOutBufRe[n], obtainedOutBufRe[n]);
				$display("Imaginary Data Out:%d   Expected Value:%d   Obtained Value:%d", n+1, expectedOutBufIm[n], obtainedOutBufIm[n]);
			end
			
			// Stop the simulation.
			$stop;
		end

		
		// State default. This state resets all the parameters if the FSM is in an unkown state.
		default: begin
			enable = 1'd0;
			stopDataInFlag = 1'd0;
			testFailedFlag = 1'd0;
			counter = 6'd0;
			dataIn = 12'd0;
			state = IDLE;
		end	
	
	endcase
end

endmodule
