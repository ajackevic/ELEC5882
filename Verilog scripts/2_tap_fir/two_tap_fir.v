module two_tap_fir(
	input clock,
	input startTransistion,
	output reg [9:0] dataOut
);

// Continuous input signal x for now is just a pre-set array.
// Coefficient values are pre-set to. This script just test the concept of the
// FIR filter
reg [7:0] input_x [0:2];
reg [7:0] input_coef [0:2];
reg [7:0] buffer [0:2]
reg fifoCounter [0:2];       // A counter 3 bits wide


reg [2:0] state;
reg [2:0] IDLE = 3'd0;
reg [2:0] START = 3'd1;
reg [2:0] STOP = 3'd2;
reg [2:0] RESET = 3'd3;



initial begin
	dataOut = 0;

	input_x[0] = 8'd200;
	input_x[1] = 8'd15;
	input_x[2] = 8'd169;

	input_coef[0] = 8'd5;
	input_coef[1] = 8'd153;
	input_coef[3] = 8'd98;

	buffer[0] = 0;
	buffer[1] = 0;
	buffer[2] = 0;

	fifoCounter = 0;

	state = IDLE;
end

always @(posedge clock) begin
 case(state)
	IDLE: begin
		if(startTransistion == 1) begin
			state = START;
		end
	end
	START: begin

  end
  STOP: begin

  end
  RESET: begin

  end


end
endmodule
