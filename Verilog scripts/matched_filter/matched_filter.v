module matched_filter #(
	parameter COEFF_LENGTH = 10000,
	parameter DATA_LENGTH = 33000,
	parameter HT_COEFF_LENGTH = 27,
	parameter HT_DATA_WIDTH = 18,
	parameter DATA_WIDTH = 16
)(
	input clock,
	input enable,
	
	output reg signed [DATA_WIDTH - 1:0] filterOut  // This will need to be *3 ot *4?
);


localparam COEFF = 1;
localparam DATA_IN = 2;



reg enableMFCoeff;
reg enableMFDataIn;
reg enablecomplexFIR;
reg enableHT;


reg loadDataFlag;
reg stopDataLoadFlag;



wire coeffFinishedFlag;
wire dataInFinishedFlag;
wire signed [DATA_WIDTH - 1:0] coeffMIFOutRe;
wire signed [DATA_WIDTH - 1:0] coeffMIFOutIm;
wire signed [DATA_WIDTH - 1:0] dataMIFOutRe;
wire signed [DATA_WIDTH - 1:0] dataMIFOutIm;



wire MFOutputRe;
wire MFOutputIm;




reg [2:0] state;
localparam IDLE = 1;
localparam LOAD_COEFF = 2;
localparam LOAD_DATA = 3;
localparam STOP = 4;



initial begin

	enableMFCoeff <= 1'd0;
	enableMFDataIn <= 1'd0;
	enablecomplexFIR <= 1'd0;
	enableHT <= 1'd0;
	
	
	loadDataFlag <= 1'd0;
	stopDataLoadFlag <= 1'd0;
	
	
	state <= IDLE;
	filterOut <= {(DATA_WIDTH){1'd0}};
end





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





read_MIF_file #(
	.LENGTH 				(COEFF_LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH),
	.DATA_TYPE 			(DATA_IN)

) MFDataIn (
	.clock				(clock),
	.enable				(enableMFDataIn),
	
	.dataFinishedFlag	(dataInFinishedFlag),	
	.outputRe			(dataMIFOutRe),
	.outputIm			(dataMIFOutIm)
);




n_tap_complex_fir #(
	.LENGTH					(DATA_LENGTH),
	.DATA_WIDTH 			(DATA_WIDTH)
) coplexFIR (
	.clock					(clock),
	.loadCoefficients		(enablecomplexFIR),
	.coefficientsSetFlag	(dataFinishedFlag),
	.loadDataFlag			(loadDataFlag),
	.stopDataLoadFlag		(stopDataLoadFlag),
	.dataInRe				(),
	.dataInIm				(),
	.coeffInRe				(coeffMIFOutRe),
	.coeffInIm				(coeffMIFOutIm),
	
	.dataOutRe				(MFOutputRe),
	.dataOutIm				(MFOutputIm)
);





 hilbert_transform #(
	.LENGTH 				(HT_COEFF_LENGTH),
	.DATA_WIDTH 		(HT_DATA_WIDTH)
) hilbertTransform (
	.clock				(clock),
	.enable				(enableHT),
	.stopDataInFlag	(),
	.dataIn				(),
	
	.dataOutRe			(),
	.dataOutIm			()








always @ (posedge clock) begin
	case(state)
		
		IDLE: begin
			if(enable) begin
				state <= LOAD_COEFF;
			end
			else begin
				filterOut <= {(DATA_WIDTH){1'd0}}; // This will need to be *3 ot *4?
			end
		end
		
		LOAD_COEFF: begin
		
		end
		
		LOAD_DATA: begin
		
		end
		
		STOP: beign
		
		end
		
		default: beign
		
		end
		
	endcase
end

/*
 Right in this script I need to instantiate the n_tap_complex_fir module and setup_MF_coeff.
 I then need to pass on coefficient values from setup_MF_coeff to n_tap_complex_fir. Then I 
 need edit the script setup_MF_coeff so that its compatiable with two types of MIF file
 (have it based on pre set parameters). Hence that module can be used to read two MIF files,
 thus will need two instantiations. Once the coefficients are set (could potentially be done 
 in parallel), send through the x_t data to n_tap_complex_fir. The output should then go 
 through an ABS algorithm (obtains the absloute value of y_t).
*/

endmodule
