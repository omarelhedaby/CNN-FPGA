`timescale 1 ns / 10 ps

module floatMult_TB ();

reg [31:0] floatA;
reg [31:0] floatB;
wire [31:0] product;

initial begin
	
	// 0.0004125 * 0.000000525
	#0
	floatA = 32'b00111001110110000100010011010000;
	floatB = 32'b00110101000011001110110110111010;

	// 0.0004125 * 0
	#10
	floatA = 32'b00111001110110000100010011010000;
	floatB = 32'b00000000000000000000000000000000;

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
