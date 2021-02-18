`timescale 1 ns / 10 ps

module floatAdd (floatA,floatB,sum);
	
input [31:0] floatA, floatB;
output reg [31:0] sum;

reg sign;
reg [7:0] exponent;
reg [22:0] mantissa;
reg [7:0] exponentA, exponentB;
reg [23:0] fractionA, fractionB, fraction;	//fraction = {1,mantissa}
reg [7:0] shiftAmount;
reg cout;

always @ (floatA or floatB) begin
	exponentA = floatA[30:23];
	exponentB = floatB[30:23];
	fractionA = {1'b1,floatA[22:0]};
	fractionB = {1'b1,floatB[22:0]}; 
	
	exponent = exponentA;

	if (floatA == 0) begin						//special case (floatA = 0)
		sum = floatB;
	end else if (floatB == 0) begin					//special case (floatB = 0)
		sum = floatA;
	end else begin
		if (exponentB > exponentA) begin
			shiftAmount = exponentB - exponentA;
			fractionA = fractionA >> (shiftAmount);
			exponent = exponentB;
		end else if (exponentA > exponentB) begin 
			shiftAmount = exponentA - exponentB;
			fractionB = fractionB >> (shiftAmount);
			exponent = exponentA;
		end
		if (floatA[31] == floatB[31]) begin			//same sign
			{cout,fraction} = fractionA + fractionB;
			if (cout == 1'b1) begin
				{cout,fraction} = {cout,fraction} >> 1;
				exponent = exponent + 1;
			end
			sign = floatA[31];
		end else begin						//different signs
			if (floatA[31] == 1'b1) begin
				{cout,fraction} = fractionB - fractionA;
			end else begin
				{cout,fraction} = fractionA - fractionB;
			end
			sign = cout;
			if (cout == 1'b1) begin
				fraction = -fraction;
			end else begin
			end
			if (fraction [23] == 0) begin
				if (fraction[22] == 1'b1) begin
					fraction = fraction << 1;
					exponent = exponent - 1;
				end else if (fraction[21] == 1'b1) begin
					fraction = fraction << 2;
					exponent = exponent - 2;
				end else if (fraction[20] == 1'b1) begin
					fraction = fraction << 3;
					exponent = exponent - 3;
				end else if (fraction[19] == 1'b1) begin
					fraction = fraction << 4;
					exponent = exponent - 4;
				end else if (fraction[18] == 1'b1) begin
					fraction = fraction << 5;
					exponent = exponent - 5;
				end else if (fraction[17] == 1'b1) begin
					fraction = fraction << 6;
					exponent = exponent - 6;
				end else if (fraction[16] == 1'b1) begin
					fraction = fraction << 7;
					exponent = exponent - 7;
				end else if (fraction[15] == 1'b1) begin
					fraction = fraction << 8;
					exponent = exponent - 8;
				end else if (fraction[14] == 1'b1) begin
					fraction = fraction << 9;
					exponent = exponent - 9;
				end else if (fraction[13] == 1'b1) begin
					fraction = fraction << 10;
					exponent = exponent - 10;
				end else if (fraction[12] == 1'b1) begin
					fraction = fraction << 11;
					exponent = exponent - 11;
				end else if (fraction[11] == 1'b1) begin
					fraction = fraction << 12;
					exponent = exponent - 12;
				end else if (fraction[10] == 1'b1) begin
					fraction = fraction << 13;
					exponent = exponent - 13;
				end else if (fraction[9] == 1'b1) begin
					fraction = fraction << 14;
					exponent = exponent - 14;
				end else if (fraction[8] == 1'b1) begin
					fraction = fraction << 15;
					exponent = exponent - 15;
				end else if (fraction[7] == 1'b1) begin
					fraction = fraction << 16;
					exponent = exponent - 16;
				end else if (fraction[6] == 1'b1) begin
					fraction = fraction << 17;
					exponent = exponent - 17;
				end else if (fraction[5] == 1'b1) begin
					fraction = fraction << 18;
					exponent = exponent - 18;
				end else if (fraction[4] == 1'b1) begin
					fraction = fraction << 19;
					exponent = exponent - 19;
				end else if (fraction[3] == 1'b1) begin
					fraction = fraction << 20;
					exponent = exponent - 20;
				end else if (fraction[2] == 1'b1) begin
					fraction = fraction << 21;
					exponent = exponent - 21;
				end else if (fraction[1] == 1'b1) begin
					fraction = fraction << 22;
					exponent = exponent - 22;
				end else if (fraction[0] == 1'b1) begin
					fraction = fraction << 23;
					exponent = exponent - 23;
				end
			end
		end
		mantissa = fraction[22:0];
		sum = {sign,exponent,mantissa};			
	end		
end

endmodule
