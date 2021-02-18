`timescale 100 ns / 10 ps

module processingElement16_TB();

reg clk,reset;
reg [15:0] floatA, floatB;
wire [15:0] result;

localparam PERIOD = 100;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;
	reset = 1;
	// A = 2 , B = 3
	floatA = 16'h4000;
	floatB = 16'h4200;

	#PERIOD
	reset = 0;

	#(2*PERIOD)
	$stop;	
end

processingElement16 PE 
(
	.clk(clk),
	.reset(reset),
	.floatA(floatA),
	.floatB(floatB),
	.result(result)
);

endmodule
