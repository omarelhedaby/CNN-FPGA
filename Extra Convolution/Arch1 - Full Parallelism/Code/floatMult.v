`timescale 1 ns / 10 ps

module floatMult (floatA,floatB,product);

input [31:0] floatA, floatB;
output reg [31:0] product;

reg sign;
reg [7:0] exponent;
reg [22:0] mantissa;
reg [23:0] fractionA, fractionB;	//fraction = {1,mantissa}
reg [47:0] fraction;

always @ (floatA or floatB) begin
	if (floatA == 0 || floatB == 0) begin
		product = 0;
	end else begin
		sign = floatA[31] ^ floatB[31];
		exponent = floatA[30:23] + floatB[30:23] - 8'd127 + 8'd2;
	
		fractionA = {1'b1,floatA[22:0]};
		fractionB = {1'b1,floatB[22:0]};
		fraction = fractionA * fractionB;
		
		if (fraction[47] == 1'b1) begin
			fraction = fraction << 1;
			exponent = exponent - 1; 
		end else if (fraction[46] == 1'b1) begin
			fraction = fraction << 2;
			exponent = exponent - 2;
		end else if (fraction[45] == 1'b1) begin
			fraction = fraction << 3;
			exponent = exponent - 3;
		end else if (fraction[44] == 1'b1) begin
			fraction = fraction << 4;
			exponent = exponent - 4;
		end else if (fraction[43] == 1'b1) begin
			fraction = fraction << 5;
			exponent = exponent - 5;
		end else if (fraction[42] == 1'b1) begin
			fraction = fraction << 6;
			exponent = exponent - 6;
		end else if (fraction[41] == 1'b1) begin
			fraction = fraction << 7;
			exponent = exponent - 7;
		end else if (fraction[40] == 1'b1) begin
			fraction = fraction << 8;
			exponent = exponent - 8;
		end else if (fraction[39] == 1'b1) begin
			fraction = fraction << 9;
			exponent = exponent - 9;
		end else if (fraction[38] == 1'b0) begin
			fraction = fraction << 10;
			exponent = exponent - 10;
		end else if (fraction[37] == 1'b1) begin
			fraction = fraction << 11;
			exponent = exponent - 11;
		end else if (fraction[36] == 1'b1) begin
			fraction = fraction << 12;
			exponent = exponent - 12;
		end else if (fraction[35] == 1'b1) begin
			fraction = fraction << 13;
			exponent = exponent - 13;
		end else if (fraction[34] == 1'b1) begin
			fraction = fraction << 14;
			exponent = exponent - 14;
		end else if (fraction[33] == 1'b1) begin
			fraction = fraction << 15;
			exponent = exponent - 15;
		end else if (fraction[32] == 1'b1) begin
			fraction = fraction << 16;
			exponent = exponent - 16;
		end else if (fraction[31] == 1'b1) begin
			fraction = fraction << 17;
			exponent = exponent - 17;
		end else if (fraction[30] == 1'b1) begin
			fraction = fraction << 18;
			exponent = exponent - 18;
		end else if (fraction[29] == 1'b0) begin
			fraction = fraction << 19;
			exponent = exponent - 19;
		end else if (fraction[28] == 1'b1) begin
			fraction = fraction << 20;
			exponent = exponent - 20;
		end else if (fraction[27] == 1'b1) begin
			fraction = fraction << 21;
			exponent = exponent - 21;
		end else if (fraction[26] == 1'b1) begin
			fraction = fraction << 22;
			exponent = exponent - 22;
		end else if (fraction[25] == 1'b1) begin
			fraction = fraction << 23;
			exponent = exponent - 23;
		end
	
		mantissa = fraction[47:25];
		product = {sign,exponent,mantissa};
	end
end

endmodule
