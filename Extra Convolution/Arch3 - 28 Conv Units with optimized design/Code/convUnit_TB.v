`timescale 1 ns / 10 ps

module convUnit_TB ();

reg clk, reset;
reg [2*3*3*32-1:0] image, filter; // we test with a filter whose size is 2*3*3 
wire [31:0] result;

localparam PERIOD = 100;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;
	reset = 1;
	// We test with an image part and a filter whose values are all 4 
	// The expected result is 288 generated after 20 clock cycles
	image = 4800'h408000004080000040800000408000004080000040800000408000004080000040800000408000004080000040800000408000004080000040800000408000004080000040800000;
	filter = 4800'h408000004080000040800000408000004080000040800000408000004080000040800000408000004080000040800000408000004080000040800000408000004080000040800000;
	
	#PERIOD
	reset = 0;
	
	#(20*PERIOD)
	$displayh(result);
	$stop;
end

convUnit 
#(
	.DATA_WIDTH(32),
	.D(2),
	.F(3)
)
UUT
(
	.clk(clk),
	.reset(reset),
	.image(image),
	.filter(filter),
	.result(result)
);

endmodule
