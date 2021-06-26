


module hilbert_transform #(
	parameter LENGTH = 27,
	parameter DATA_WIDTH = 18
)(
	input clock,
	input enable,
	input stopDataInFlag,
	input signed [DATA_WIDTH - 1:0] dataIn,
	
	output reg [(DATA_WIDTH * 2) - 1:0] dataOutRe,
	output reg [(DATA_WIDTH * 2) - 1:0] dataOutIm
);

assign dataOutRe = dataIn;

// Local parameters for the module setup_HT_coeff.
reg loadCoeff;
wire coeffSetFlag;
wire [DATA_WIDTH - 1:0] HTCoeffOut;



// Local parameter for the module n_tap_fir.
reg loadFIRDataFlag;
reg stopFIRDataFlag;
reg [DATA_WIDTH - 1:0] dataFIRIn;
wire [(DATA_WIDTH * 2) - 1:0] FIRDataOut;



// Create the FSM.
reg [2:0] state;
localparam IDLE = 3'd0;
localparam LOAD_FIR_COEFF = 3'd1;
localparam MAIN_OPP = 3'd2;
localparam STOP = 3'd3;



// Set the initial local parameters and outputs.
initial begin
	state <= IDLE;
	loadCoeff <= 1'd0;
	loadFIRDataFlag <= 1'd0;
	stopFIRDataFlag <= 1'd0;
	dataFIRIn <= {(DATA_WIDTH){1'd0}};

	
	dataOutRe <= {(DATA_WIDTH * 2){1'd0}};
	dataOutIm <= {(DATA_WIDTH * 2){1'd0}};
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



// Instantiating the FIR module. This module performs the convelution opperation
// between coeffIn and dataIn. The output product is dataOut.
n_tap_fir #(
	.LENGTH					(LENGTH),
	.DATA_WIDTH				(DATA_WIDTH)
)FIRFilter(
	.clock					(clock),
	.loadCoefficients		(loadCoeff), // This might need to be one clock cycle behind.
	.coefficientsSetFlag	(coeffSetFlag), // All ref to coefficients should be changed to coeff. This applies not just to this module.
	.loadDataFlag			(loadFIRDataFlag),
	.stopDataLoadFlag		(stopFIRDataFlag),
	.coeffIn					(HTCoeffOut),
	.dataIn					(dataFIRIn),
	
	.dataOut					(FIRDataOut)
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
				dataOutRe <= {(DATA_WIDTH * 2){1'd0}};
				dataOutIm <= {(DATA_WIDTH * 2){1'd0}};
			end
		end
		
		
		// State LOAD_FIR_COEFF. This state waits until the coeffSetFlag is set high 
		// before transistioning to state MAIN_OPP, whilst setting loadCoeff low. 
		// Hence this state only transistions to the next state once all the coefficients
		// have been passed through to the FIR module.
		LOAD_FIR_COEFF: begin
			if(coeffSetFlag) begin
				state <= MAIN_OPP;
				loadFIRDataFlag <= 1'd1;
				loadCoeff <= 1'd0;
			end
			else begin
				dataOutRe <= {(DATA_WIDTH * 2){1'd0}};
				dataOutIm <= {(DATA_WIDTH * 2){1'd0}};
			end
		end
		
		
		// State MAIN_OPP. This state passes through the dataIn values to the FIR 
		// module through the variabel dataFIRIn. These values are then conveluted
		// with the coefficients. If stopDataInFlag is set high, the state will 
		// transistion to STOP.
		MAIN_OPP: begin		
			if(stopDataInFlag) begin
				state <= STOP;
			end
			else begin
				dataFIRIn <= dataIn;
				dataOutIm <= FIRDataOut;
			end
		end
		
		
		// State STOP. This state stops the FIR and HT opperation as well as 
		// setting some of the local variables and outputs to 0.
		STOP: begin
			loadFIRDataFlag <= 1'd0;
			stopFIRDataFlag <= 1'd1;
			dataFIRIn <= {(DATA_WIDTH){1'd0}};
			dataOutRe <= {(DATA_WIDTH * 2){1'd0}};
			dataOutIm <= {(DATA_WIDTH * 2){1'd0}};
		end
		
		
		// State Default. This state exsists purley just incase the FSM is in
		// an unkown state. It resets the initial values.
		default: begin
			state <= IDLE;
			loadCoeff <= 1'd0;
			loadFIRDataFlag <= 1'd0;
			stopFIRDataFlag <= 1'd0;
			dataFIRIn <= {(DATA_WIDTH){1'd0}};

			
			dataOutRe <= {(DATA_WIDTH * 2){1'd0}};
			dataOutIm <= {(DATA_WIDTH * 2){1'd0}};
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
