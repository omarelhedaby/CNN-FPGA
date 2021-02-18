module floatAdd_TB ();

reg [31:0] floatA;
reg [31:0] floatB;
wire [31:0] sum;

initial begin
	
	// 0.0004125 + 0.000000525
	#0
	floatA = 32'hbab1cf4b;
	floatB = 32'h3aaaad74;

	// 0.0004125 + 0
	#10
	floatA = 32'b00111001110110000100010011010000;
	floatB = 32'b00000000000000000000000000000000;

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
