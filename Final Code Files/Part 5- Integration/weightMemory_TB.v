`timescale 1 ns / 10 ps

module weightMemroy_TB();

reg clk;
reg [6:0] address;
wire [32*32-1:0] weights;

localparam PERIOD = 100;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;
	address = 0;

	#PERIOD
	address = 1;

	#PERIOD 
	address = 2;

	#PERIOD
	address = 32;

	#PERIOD
	$stop;
end

weightMemory UUT
(
	.clk(clk),
	.address(address),
	.weights(weights)
);

endmodule
