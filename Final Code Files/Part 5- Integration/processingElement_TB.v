`timescale 1 ns / 10 ps

module processingElement_TB();

reg clk,reset;
reg [31:0] floatA, floatB;
wire [31:0] result;

localparam PERIOD = 100;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;
	reset = 1;
	// A = 2 , B = 3
	floatA = 32'b01000000000000000000000000000000;
	floatB = 32'b01000000010000000000000000000000;

	#(PERIOD/4)
	reset = 0;

	// A = 1 , B = 5
	#(3*PERIOD/4)
	floatA = 32'b00111111100000000000000000000000;
	floatB = 32'b01000000101000000000000000000000;

	#(3*PERIOD/2)
	reset = 1;

	#(PERIOD)
	$stop;	
end

processingElement PE 
(
	.clk(clk),
	.reset(reset),
	.floatA(floatA),
	.floatB(floatB),
	.result(result)
);

endmodule
