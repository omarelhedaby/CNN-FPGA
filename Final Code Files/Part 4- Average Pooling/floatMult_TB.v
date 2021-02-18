`timescale 100 ns / 10 ps

module floatMult_TB ();

reg [15:0] floatA;
reg [15:0] floatB;
wire [15:0] product;

initial begin
	
	// 4 * 5
	#0
	floatA = 16'b0100010000000000;
	floatB = 16'b0100010100000000;

	// 0.0004125 * 0
	#10
	floatA = 16'b0000111011000010;
	floatB = 16'b0000000000000000;

	#10
	$stop;
end

floatMult FM
(
	.floatA(floatA),
	.floatB(floatB),
	.product(product)
);

endmodule
