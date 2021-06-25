


module hilbert_transform #(
	parameter LENGTH = 27,
	parameter DATA_WIDTH = 18
)(
	input clock,
	input enable,
	input dataIn,
	input stopDataIn,
	
	output reg [DATA_WIDTH - 1:0] dataOutRe,
	output reg [DATA_WIDTH - 1:0] dataOutIm
);



// Local parameters for the module setup_HT_coeff.
reg loadCoeff;
wire coeffSetFlag;
wire [DATA_WIDTH - 1:0] HTCoeffOut;



// Create the FSM.
reg [2:0] state;
localparam IDLE = 3'd0;
localparam LOAD_FIR_COEFF = 3'd0;
localparam MAIN_OPP = 3'd0;
localparam STOP = 3'd0;




// Set the initial local parameters and outputs.
initial begin
	state <= IDLE;
	loadCoeff <= 1'd0;

	
	dataOutRe <= {(DATA_WIDTH){1'd0}};
	dataOutIm <= {(DATA_WIDTH){1'd0}};
end




// Instantiating the setup of the hilber transfer coefficient module. This 
// module passes the LENGTH amount of coefficients through coefficientOut.
setup_HT_coeff #(
	.LENGTH 			 (LENGTH),
	.DATA_WIDTH 	 (DATA_WIDTH)
)Coefficients(
	.clock			 (clock),
	.enable			 (loadCoeff),
	
	.coeffSetFlag	 (coeffSetFlag),
	.coefficientOut (HTCoeffOut)
);



always @ (posedge clock) begin
	case(state)
	
		// State IDLE. This state waits till enable is set high before transistioning
		// to LOAD_FIR_COEFF. If enable is set low, it sets the outputs to low.
		IDLE: begin
			if(enable) begin
				state <= LOAD_FIR_COEFF;
				loadCoeff <= 1'd1;
			end
			else begin
				dataOutRe <= {(DATA_WIDTH){1'd0}};
				dataOutIm <= {(DATA_WIDTH){1'd0}};
			end
		end
		
		
		LOAD_FIR_COEFF: begin
		
		
		
			if(coeffSetFlag) begin
				state <= MAIN_OPP;
				loadCoeff <= 1'd0;
			end
			
		end
		
		
		MAIN_OPP: begin
		
		end
		
		
		STOP: begin
		
		end
		
		
		default: begin
		
		end
	endcase
end



/* Need to find out if the HT is only needed for the input signal or if it
   will also be needed for the impulse response. Though I think it doesn't
	really change the opperation of this script. An FSM is needed, the 
	coefficients need to be loaded (pased on parameters). Need to call n_tap_fir,
	perform the conv opperation, delay the real signal by n, make sure the two signals 
	leave at the same time. Have an output flag when all the the data is passed,
	as the conv will added n extra length to the signal that went througih the n_tap_fir.
	Andhence ignore the data that is outputed after the flag is raised. If this is only
	for the input signal, then the flag will never need to be raised as the input data
	will always be coming.
*/

endmodule
