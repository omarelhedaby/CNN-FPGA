`timescale 100 ns / 10 ps

module floatAdd_TB ();

reg [15:0] floatA;
reg [15:0] floatB;
wire [15:0] sum;

initial begin
	
	// 0.3 + 0.2
	#0
	floatA = 16'h34CD;
	floatB = 16'h3266;

	// 0.3 + 0
	#10
	floatA = 16'h34CD;
	floatB = 16'h0000;
	#10
	$stop;
end

floatAdd FADD
(
	.floatA(floatA),
	.floatB(floatB),
	.sum(sum)
);

endmodule

