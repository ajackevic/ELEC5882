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
