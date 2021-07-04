module matched_filter #(
	parameter COEFF_LENGTH = 10000,
	parameter DATA_LENGTH = 33000,
	parameter DATA_WIDTH = 16
)(
	input clock,
	input enable,
	
	output reg signed [DATA_WIDTH - 1:0] filterOut
);


localparam COEFF = 1;
localparam DATA_IN = 2;







initial begin


end



read_MIF_file #(
	.LENGTH 				(COEFF_LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH),
	.DATA_TYPE 			(COEFF)

) MFCoeff (
	.clock				(clock),
	.enable				(),
	
	.coeffSetFlag		(),	
	.outputRe			(),
	.outputIm			()
);



read_MIF_file #(
	.LENGTH 				(COEFF_LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH),
	.DATA_TYPE 			(DATA_IN)

) MFDataIn (
	.clock				(clock),
	.enable				(),
	
	.coeffSetFlag		(),	
	.outputRe			(),
	.outputIm			()
);




setup_complex_FIR_coeff #(
	.LENGTH				(DATA_LENGTH),
	.DATA_WIDTH 		(DATA_WIDTH)
) coplexFIR (
	.clock				(clock),
	.enable				(),
	.coeffSetFlag		(),
	
	.coefficientOutRe	(),
	.coefficientOutIm	()
);














always @ (posedge clock) begin

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
