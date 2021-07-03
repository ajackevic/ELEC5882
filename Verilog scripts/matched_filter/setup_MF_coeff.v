/*

 setup_MF_coeff.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
 This module sets up the coefficients for the matched filter impulse response. When
 FIR filter. The coefficients are aquired through the MIF file MFImpulseCoeff.mif. The
 MIF file was produced by the script MFImpulseCoeffMIF.m. The coefficients will be 
 passed on as soon as enable is set, and once all the values are passed through coeffOutRe 
 and coeffOutIm the coeffSetFlag is then set.


*/

module setup_MF_coeff #(
	parameter LENGTH = 10000,
	parameter DATA_WIDTH = 16

)(
	input clock,
	input enable,
	
	output reg coeffSetFlag,	
	output reg signed [DATA_WIDTH - 1:0] coeffOutRe,
	output reg signed [DATA_WIDTH - 1:0] coeffOutIm
);

// Local buffer parameters.
reg signed [DATA_WIDTH-1:0] MIFBuffer [0:(LENGTH * 2) - 1];
reg signed [DATA_WIDTH-1:0] realCoeffBuffer [0:LENGTH - 1];
reg signed [DATA_WIDTH-1:0] imagCoeffBuffer [0:LENGTH - 1];


// Width is equal to log2(LENGTH). The value is then rounded up.
reg [13:0] coeffBufferCounter; 


// FSM.
reg [1:0] state;
localparam IDLE = 2'd0;
localparam MOVE_COEFF = 2'd1;
localparam STOP = 2'd2;
localparam EMPTY_STATE = 2'd3;



// Set the initial values.
initial begin: initValues
	integer k;
	
	// Read the MIF file and transfer is contents to the variable MIFBuffer.
	$readmemb("MFImpulseCoeff.mif", MIFBuffer);
	
	// Setting the local parameters + ouputs to 0.
	coeffBufferCounter = 14'd0;
	state = IDLE;
	coeffSetFlag = 1'd0;
	coeffOutRe =  {(DATA_WIDTH){1'd0}};
	coeffOutIm =  {(DATA_WIDTH){1'd0}};
	
	// Transfer the values in MIFBuffer to the variables realCoeffBuffer and imagCoeffBuffer.
	// The MIF file is structured real coeff then imag coeff (one coefficient set) then repeat 
	// 9999 times more.
	for (k = 0; k <= (LENGTH * 2) - 1 ; k = k + 2) begin
		realCoeffBuffer[coeffBufferCounter] = MIFBuffer[k];
		imagCoeffBuffer[coeffBufferCounter] = MIFBuffer[k+1];
		
		coeffBufferCounter = coeffBufferCounter + 14'd1;
	end
	
	// Reset coeffBufferCounter once more so that it can then be used in the FSM.
	coeffBufferCounter = 14'd0;
end


always @ (posedge clock) begin
	case(state)
	
		// State IDLE. This state is responsiable for waiting until enable is set to transistion to 
		// the state MOVE_COEFF. If not set, the outputs of the module are set to 0.
		IDLE: begin
		
			if(enable) begin
				state <= MOVE_COEFF;
			end
			else begin
				coeffOutRe <=  {(DATA_WIDTH){1'd0}};
				coeffOutIm <=  {(DATA_WIDTH){1'd0}};
				coeffSetFlag <= 1'd0;
			end
			
		end
		
		
		// State MOVE_COEFF. This state is repsponsiable for pushing through the values from real 
		// and imag CoeffBuffer to the output coeffOutRe and coeffOutIm. Once all the coeff have 
		// been passed through the state transistions to STOP.
		MOVE_COEFF: begin
		
			if(coeffBufferCounter == LENGTH) begin
				state <= STOP;
				coeffSetFlag <= 1'd1;
			end
			else begin
				coeffOutRe <= realCoeffBuffer[coeffBufferCounter];
				coeffOutIm <= imagCoeffBuffer[coeffBufferCounter];
				coeffBufferCounter <= coeffBufferCounter + 14'd1;
			end
			
		end
		
		
		// State STOP. This state is responsiable for setting the oputputs to 0 (appart from coeffSetFlag).
		STOP: begin
		
			coeffOutRe <=  {(DATA_WIDTH){1'd0}};
			coeffOutIm <=  {(DATA_WIDTH){1'd0}};
			coeffSetFlag <= 1'd1;
			coeffBufferCounter <= 14'd0;
			
		end
		
		
		// State EMPTY_STATE. This state was added to removed any infered latched from quartus.
		EMPTY_STATE: begin
			
		end
		
		
		// State default. This state resets the local parameters and outputs just incase the FSM is 
		// in an undefined state.
		default: begin
		
			coeffOutRe <=  {(DATA_WIDTH){1'd0}};
			coeffOutIm <=  {(DATA_WIDTH){1'd0}};
			coeffBufferCounter <= 14'd0;
			coeffSetFlag <= 1'd0;
			state <= IDLE;
			
		end
		
	endcase
end


endmodule
