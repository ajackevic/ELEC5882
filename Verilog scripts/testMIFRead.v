module testMIFRead #(
	parameter LENGTH = 10000,
	parameter DATA_WIDTH = 16

)(
	input clock,
	input enable,
	
	output reg coeffSetFlag,	
	output reg signed [DATA_WIDTH - 1:0] coeffOutRe,
	output reg signed [DATA_WIDTH - 1:0] coeffOutIm
);


reg signed [DATA_WIDTH-1:0] MIFBuffer [0:(LENGTH * 2) - 1];

reg signed [DATA_WIDTH-1:0] realCoeffBuffer [0:LENGTH - 1];
reg signed [DATA_WIDTH-1:0] imagCoeffBuffer [0:LENGTH - 1];
// Width is log2(LENGTH) rounded up
reg [13:0] coeffBufferCounter; 



reg [1:0] state;
localparam IDLE = 2'd0;
localparam MOVE_COEFF = 2'd1;
localparam STOP = 2'd2;
localparam EMPTY_STATE = 2'd3;




initial begin: initValues
	integer k;
	
	$readmemb("MFImpulseCoeff.mif", MIFBuffer);
	
	coeffBufferCounter = 14'd0;
	state = IDLE;
	coeffSetFlag = 1'd0;
	coeffOutRe =  {(DATA_WIDTH){1'd0}};
	coeffOutIm =  {(DATA_WIDTH){1'd0}};
	
	for (k = 0; k <= (LENGTH * 2) - 1 ; k = k + 2) begin
		realCoeffBuffer[coeffBufferCounter] = MIFBuffer[k];
		imagCoeffBuffer[coeffBufferCounter] = MIFBuffer[k+1];
		
		coeffBufferCounter = coeffBufferCounter + 14'd1;
	end
	
	coeffBufferCounter = 14'd0;
end


always @ (posedge clock) begin
	case(state)
	
	
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
		
		STOP: begin
		
			coeffOutRe <=  {(DATA_WIDTH){1'd0}};
			coeffOutIm <=  {(DATA_WIDTH){1'd0}};
			coeffSetFlag <= 1'd1;
			coeffBufferCounter <= 14'd0;
			
		end
		
		EMPTY_STATE: begin
			
		end
		
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
