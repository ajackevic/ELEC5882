/*

 hilbert_transform.v
 --------------
 By: Augustas Jackevic
 Date: June 2021

 Module Description:
 -------------------
 This module is the design of a hilbert transform through the use of FIR filters.
 From the input signal dataIn, an analytic signal (shift by +90 degrees) is created,
 thus forming the real output signal dataOutRe and the imaginary output signal dataOutIm.
 The module setup_HT_coeff is used to load the coefficients to the module n_tap_fir. An FIR
 of 27 taps is used as that is considered sufficient for the required results.

*/


module hilbert_transform #(
	parameter LENGTH = 27,
	parameter DATA_WIDTH = 18
)(
	input clock,
	input enable,
	input stopDataInFlag,
	input signed [DATA_WIDTH - 1:0] dataIn,
	
	output reg signed [(DATA_WIDTH * 2) - 1:0] dataOutRe,
	output reg signed [(DATA_WIDTH * 2) - 1:0] dataOutIm
);


reg signed [DATA_WIDTH - 1:0] dataInBuf [0:2];

// Local parameters for the module setup_HT_coeff.
reg loadCoeff;
wire coeffSetFlag;
wire [DATA_WIDTH - 1:0] HTCoeffOut;



// Local parameter for the module n_tap_fir.
reg loadFIRDataFlag;
reg stopFIRDataFlag;
reg [DATA_WIDTH - 1:0] dataFIRIn;
reg loadCoeffFIRFlag;
wire [(DATA_WIDTH * 2) - 1:0] FIRDataOut;



// Create the FSM.
reg [1:0] state;
localparam IDLE = 2'd0;
localparam LOAD_FIR_COEFF = 2'd1;
localparam MAIN_OPP = 2'd2;
localparam STOP = 2'd3;



// Set the initial local parameters and outputs.
initial begin: init_values

	integer k;
	for (k = 0; k <= 2 ; k = k + 1) begin
		dataInBuf[k] <= 0;
	end

	state <= IDLE;
	loadCoeff <= 1'd0;
	loadFIRDataFlag <= 1'd0;
	stopFIRDataFlag <= 1'd0;
	loadCoeffFIRFlag <= 1'd0;
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
	.coefficientsSetFlag	(loadCoeffFIRFlag), // All ref to coefficients should be changed to coeff. This applies not just to this module.
	.loadDataFlag			(loadFIRDataFlag),
	.stopDataLoadFlag		(stopFIRDataFlag),
	.coeffIn					(HTCoeffOut),
	.dataIn					(dataFIRIn),
	
	.dataOut					(FIRDataOut)
);


integer n;
always @ (posedge clock) begin
	case(state)
	
		// State IDLE. This state waits till enable is set high before transistioning
		// to LOAD_FIR_COEFF. If enable is set low, it sets the outputs to low.
		IDLE: begin
			if(enable) begin
				state <= LOAD_FIR_COEFF;
				loadCoeff <= 1'd1;
				loadCoeffFIRFlag <= 1'd1;
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
			//if(coeffSetFlag) begin
				state <= MAIN_OPP;
				loadFIRDataFlag <= 1'd1;
				loadCoeffFIRFlag <= 1'd0;
			//	loadCoeff <= 1'd0;
				dataOutRe <= {(DATA_WIDTH * 2){1'd0}};
				dataOutIm <= {(DATA_WIDTH * 2){1'd0}};
			//end
			//else begin
			//	dataOutRe <= {(DATA_WIDTH * 2){1'd0}};
			//	dataOutIm <= {(DATA_WIDTH * 2){1'd0}};
			//end
		end
		
		
		// State MAIN_OPP. This state passes through the dataIn values to the FIR 
		// module through the variabel dataFIRIn. These values are then conveluted
		// with the coefficients. If stopDataInFlag is set high, the state will 
		// transistion to STOP.
		MAIN_OPP: begin		
			if(coeffSetFlag) begin
				loadCoeff <= 1'd0;
			end
		
		
			if(stopDataInFlag) begin
				state <= STOP;
			end
			else begin
				dataFIRIn <= dataIn;
				dataOutIm <= FIRDataOut;
				dataInBuf[0] <= dataIn;
				dataOutRe <= dataInBuf[2];
				
				for (n = 0; n < 2; n = n + 1) begin
					
					dataInBuf[n+1] <= dataInBuf[n];
				end
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

endmodule
