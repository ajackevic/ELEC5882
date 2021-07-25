/*

 matched_filter.v
 --------------
 By: Augustas Jackevic
 Date: July 2021

 Module Description:
 -------------------
This module creates the matched filter. The matched filter is the convolution operation
between the input data and the matched filter impulse response (very over-simplified). Both
 signals are applied through a hilbert transform filter (removed the negative frequencies) and then 
convoluted. The hilbert transform is required to avoid aliasing. Due to the hilbert transform, a
 complex signal is acquired thus a complex FIR filter is utilised for the convolution.
 
 In this module, the matched filter coefficients are acquired from the MFImpulseCoeff MIF file (coefficients
 are obtained from MATLAB), and the input data is read from the MFInputData MIF file. This data is then applied
 through the hilbert transform module to acquire a complex signal. The coefficients are loaded to the complex
 FIR filter and the data in complex signal is then applied to the FIR filter, with the output being the convelution
 product between the matched filter impulse response coefficients and the applied data in.


*/


module matched_filter #(
	parameter COEFF_LENGTH = 800,
	parameter DATA_LENGTH = 7700,
	parameter HT_COEFF_LENGTH = 27,
	parameter DATA_WIDTH = 18
	// It should be noted the stated parameters must match the values in the MATLAB script. 
)(
	input clock,
	input enable,
	
	output signed [70:0] MFOutput
);


// Local parameters for the module read_MIF_file.
localparam COEFF = 1;
localparam DATA_IN = 2;


// Enable regs for the instantiated modules.
reg enableMFCoeff;
reg enableMFDataIn;
reg enablecomplexFIRCoeff;
reg enableHT;
reg enableComplexFIRData;
reg enableSquar;

reg [141:0] absInputValue;


// A reg for informing the complex FIR filter when the data is about to be stopped.
reg stopDataLoadFlag;


// Output ports for the instantiated modules.
wire coeffFinishedFlag;
wire dataInFinishedFlag;
wire signed [DATA_WIDTH - 1:0] coeffMIFOutRe;
wire signed [DATA_WIDTH - 1:0] coeffMIFOutIm;
wire signed [DATA_WIDTH - 1:0] dataMIFOutRe;

wire signed [(DATA_WIDTH * 3) - 1:0] HTOutRe;
wire signed [(DATA_WIDTH * 3) - 1:0] HTOutIm;

wire signed [(DATA_WIDTH * 4) - 1:0] MFOutputRe;
wire signed [(DATA_WIDTH * 4) - 1:0] MFOutputIm;



// FSM
reg [2:0] state;
localparam IDLE = 1;
localparam SET_ENABLE = 2;
localparam STOP = 3;




// Set the initial values of the local parameters.
initial begin

	enableMFCoeff <= 1'd0;
	enableMFDataIn <= 1'd0;
	enablecomplexFIRCoeff <= 1'd0;
	enableHT <= 1'd0;
	enableSquar <= 1'd0;
	
	
	enableComplexFIRData <= 1'd0;
	stopDataLoadFlag <= 1'd0;
	
	absInputValue <= 141'd0;
	
	
	state <= IDLE;
end




// Instantiating the module read_MIF_file. This is used to read the coefficients from the MFImpulseCoeff.mif file.
read_MIF_file #(
	.LENGTH 				(COEFF_LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH),
	.DATA_TYPE 			(COEFF)

) MFCoeff (
	.clock				(clock),
	.enable				(enableMFCoeff),
	
	.dataFinishedFlag	(coeffFinishedFlag),	
	.outputRe			(coeffMIFOutRe),
	.outputIm			(coeffMIFOutIm)
);




// Instantiating the module read_MIF_file. This is used to read the data in from the MFInputData.mif file. 
read_MIF_file #(
	.LENGTH 				(DATA_LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH),
	.DATA_TYPE 			(DATA_IN)

) MFDataIn (
	.clock				(clock),
	.enable				(enableMFDataIn),
	
	.dataFinishedFlag	(dataInFinishedFlag),	
	.outputRe			(dataMIFOutRe),
	.outputIm			() // This port is ignored as all data is passed through outputRe.
);




// Instantiating the module n_tap_complex_fir. This is used for the main opperation of the matched filter
// between the complex input data and the complex impulse reponse of the matched filter.
n_tap_complex_fir #(
	.LENGTH					(COEFF_LENGTH * 2),
	.DATA_WIDTH 			(DATA_WIDTH)
) coplexFIR (
	.clock					(clock),
	.loadCoeff				(enablecomplexFIRCoeff),
	.coeffSetFlag			(coeffFinishedFlag),
	.loadDataFlag			(enableComplexFIRData),
	.stopDataLoadFlag		(stopDataLoadFlag),
	.dataInRe				(HTOutRe),
	.dataInIm				(HTOutIm),
	.coeffInRe				(coeffMIFOutRe),
	.coeffInIm				(coeffMIFOutIm),
	
	.dataOutRe				(MFOutputRe),
	.dataOutIm				(MFOutputIm)
);




// Instantiating the module hilbert_transform. This is used to aquire a complex signal from a real signal 
// by performing hilbert transform filtering of the data aquired from MFInputData.mif.
 hilbert_transform #(
	.LENGTH 				(HT_COEFF_LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH)
) hilbertTransform (
	.clock				(clock),
	.enable				(enableHT),
	.stopDataInFlag	(),
	.dataIn				(dataMIFOutRe),
	
	.dataOutRe			(HTOutRe),
	.dataOutIm			(HTOutIm)
);






square_root_cal #(
	.INPUT_DATA_WIDTH		(142),
	.OUTPUT_DATA_WIDTH	(71)
) squr(
	.clock					(clock),
	.enable					(enableSquar),
	.inputData				(absInputValue),
	
	.outputData				(MFOutput)
);




always @ (posedge clock) begin
	case(state)
		
		// State IDLE. This state waits until enable is set before transistioning to LOAD_COEFF.
		IDLE: begin
			if(enable) begin
				state <= SET_ENABLE;
			end
		end
		
		
		// State LOAD_COEFF. This state enables the majority of the enable regs for the instantiated modules.
		SET_ENABLE: begin
						
			if(coeffFinishedFlag) begin
			
				enableMFCoeff <= 1'd0;
				state <= STOP;
				enableMFDataIn <= 1'd1;
				enableHT <= 1'd1;
				
			end
			else begin
				enableMFCoeff <= 1'd1;
				enableMFDataIn <= 1'd1;
				enablecomplexFIRCoeff <= 1'd1;
				enableHT <= 1'd1;
				enableComplexFIRData <= 1'd1;
				enableSquar <= 1'd1;
			end
			
			absInputValue <= (MFOutputRe * MFOutputRe) + (MFOutputIm * MFOutputIm);
		end
		
		
		// State STOP. 
		STOP: begin
		
		end
		
		
		// State default. This state sets the default values just incase the FSM is in an unknown state.
		default: begin
			enableMFCoeff <= 1'd0;
			enableMFDataIn <= 1'd0;
			enablecomplexFIRCoeff <= 1'd0;
			enableHT <= 1'd0;
			
			
			enableComplexFIRData <= 1'd0;
			stopDataLoadFlag <= 1'd0;
			
			
			state <= IDLE;
		end
		
	endcase
end

endmodule
