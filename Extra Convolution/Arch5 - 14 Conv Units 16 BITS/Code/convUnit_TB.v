`timescale 100 ns / 10 ps

module convUnit_TB ();

reg clk, reset;
reg [1*5*5*16-1:0] image, filter; // we test with a filter whose size is 2*3*3 
wire [15:0] result;

localparam PERIOD = 100;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;
	reset = 1;
	// We test with an image part and a filter whose values are all 4 
	// The expected result is 400 generated after 25 clock cycles
	image =  400'h4400440044004400440044004400440044004400440044004400440044004400440044004400440044004400440044004400;
	filter = 400'h4400440044004400440044004400440044004400440044004400440044004400440044004400440044004400440044004400;
	
	#PERIOD
	reset = 0;
	
	#(27*PERIOD)
	$displayh(result);
	$stop;
end

convUnit 
#(
	.DATA_WIDTH(16),
	.D(1),
	.F(5)
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
