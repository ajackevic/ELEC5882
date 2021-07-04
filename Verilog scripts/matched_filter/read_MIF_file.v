/*

 read_MIF_file.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
 This module sets up the coefficients for the matched filter impulse response. When
 FIR filter. The coefficients are aquired through the MIF file MFImpulseCoeff.mif. The
 MIF file was produced by the script MFImpulseCoeffMIF.m. The coefficients will be 
 passed on as soon as enable is set, and once all the values are passed through outputRe 
 and outputIm the coeffSetFlag is then set.


*/

module read_MIF_file #(
	parameter LENGTH = 10000,
	parameter DATA_WIDTH = 16,
	parameter DATA_TYPE = 1			// 1 is for coefficient, 2 is for input data.

)(
	input clock,
	input enable,
	
	output reg coeffSetFlag,	
	output reg signed [DATA_WIDTH - 1:0] outputRe,
	output reg signed [DATA_WIDTH - 1:0] outputIm
);

// Local buffer parameters.
reg signed [DATA_WIDTH-1:0] MIFBuffer [0:(LENGTH * 2) - 1];
reg signed [DATA_WIDTH-1:0] realCoeffBuffer [0:(LENGTH*(DATA_TYPE)) - 1];
reg signed [DATA_WIDTH-1:0] imagCoeffBuffer [0:(LENGTH*(2-DATA_TYPE)) - 1];


// Width is equal to log2(LENGTH). The value is then rounded up.
reg [19:0] coeffBufferCounter; 


// FSM.
reg [1:0] state;
localparam IDLE = 2'd0;
localparam MOVE_COEFF = 2'd1;
localparam MOVE_DATA_IN = 2'd2;
localparam STOP = 2'd3;



// Set the initial values.
initial begin: initValues
	integer k;
	
	
	// Setting the local parameters + ouputs to 0.
	coeffBufferCounter = 20'd0;
	state = IDLE;
	coeffSetFlag = 1'd0;
	outputRe =  {(DATA_WIDTH){1'd0}};
	outputIm =  {(DATA_WIDTH){1'd0}};
	
	
	
	// Read the MIF file and transfer is contents to the variable MIFBuffer.
	if(DATA_TYPE == 2) begin
		$readmemb("MFInputData.mif", MIFBuffer);
		
		// Transfer the values of MIFBuffer to the buffer variables realCoeffBuffer 
		// and imagCoeffBuffer. This is done for LENGTH*2 amount of times. Only need
		// realCoeffBuffer, hence imagCoeffBuffer is set to 0.
		for (k = 0; k <= (LENGTH * 2) - 1 ; k = k + 1) begin
			realCoeffBuffer[coeffBufferCounter] = MIFBuffer[k];
			imagCoeffBuffer[coeffBufferCounter] = {(DATA_WIDTH){1'd0}};
		
			coeffBufferCounter = coeffBufferCounter + 20'd1;
		end
		
	end
	else begin
		$readmemb("MFImpulseCoeff.mif", MIFBuffer);
		
		// Transfer the values in MIFBuffer to the variables realCoeffBuffer and imagCoeffBuffer.
		// The MIF file is structured real coeff then imag coeff (one coefficient set) then repeat 
		// 9999 times more.
		for (k = 0; k <= (LENGTH * 2) - 1 ; k = k + 2) begin
			realCoeffBuffer[coeffBufferCounter] = MIFBuffer[k];
			imagCoeffBuffer[coeffBufferCounter] = MIFBuffer[k+1];
		
			coeffBufferCounter = coeffBufferCounter + 20'd1;
		end
		
	end	
	
	
	// Reset coeffBufferCounter once more so that it can then be used in the FSM.
	coeffBufferCounter = 20'd0;
end


always @ (posedge clock) begin
	case(state)
	
		// State IDLE. This state is responsiable for waiting until enable is set to transistion to 
		// the state MOVE_COEFF. If not set, the outputs of the module are set to 0.
		IDLE: begin
		
			if(enable && DATA_TYPE == 1) begin
				state <= MOVE_COEFF;
			end
			else if(enable && DATA_TYPE == 2) begin
				state <= MOVE_DATA_IN;
			end
			else begin
				outputRe <=  {(DATA_WIDTH){1'd0}};
				outputIm <=  {(DATA_WIDTH){1'd0}};
				coeffSetFlag <= 1'd0;
			end
			
		end
		
		
		// State MOVE_COEFF. This state is repsponsiable for pushing through the values from real 
		// and imag CoeffBuffer to the output outputRe and outputIm. Once all the coeff have 
		// been passed through the state transistions to STOP.
		MOVE_COEFF: begin
		
			if(coeffBufferCounter == LENGTH) begin
				state <= STOP;
				coeffSetFlag <= 1'd1;
			end
			else begin
				outputRe <= realCoeffBuffer[coeffBufferCounter];
				outputIm <= imagCoeffBuffer[coeffBufferCounter];
				coeffBufferCounter <= coeffBufferCounter + 20'd1;
			end
			
		end
		
		
		// State MOVE_DATA_IN. This state is similar to MOVE_COEFF, except it pushes the value in
		// realCoeffBuffer to outputRe and sets outputIm to 0. Once all the values are passed 
		// through it transistions to state STOP.	
		MOVE_DATA_IN: begin
		
			if(coeffBufferCounter == LENGTH * 2) begin
				state <= STOP;
				coeffSetFlag <= 1'd1;
			end
			else begin
				outputRe <= realCoeffBuffer[coeffBufferCounter];
				outputIm <= {(DATA_WIDTH){1'd0}};
				coeffBufferCounter <= coeffBufferCounter + 20'd1;
			end
			
		end
		
		
		
		// State STOP. This state is responsiable for setting the oputputs to 0 (appart from coeffSetFlag).
		STOP: begin
		
			outputRe <=  {(DATA_WIDTH){1'd0}};
			outputIm <=  {(DATA_WIDTH){1'd0}};
			coeffSetFlag <= 1'd1;
			coeffBufferCounter <= 20'd0;
			
		end
		
		
		// State default. This state resets the local parameters and outputs just incase the FSM is 
		// in an undefined state.
		default: begin
		
			outputRe <=  {(DATA_WIDTH){1'd0}};
			outputIm <=  {(DATA_WIDTH){1'd0}};
			coeffBufferCounter <= 20'd0;
			coeffSetFlag <= 1'd0;
			state <= IDLE;
			
		end
		
	endcase
end


endmodule
