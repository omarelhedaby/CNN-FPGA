module floatReciprocal(number,enable,clk,output_rec,ack);

parameter DATA_WIDTH=32;
input [DATA_WIDTH-1:0] number; //the number that we need to get the 1/number of
input clk,enable; 
output reg[DATA_WIDTH-1:0] output_rec; // = 1/number
output reg ack;

wire [DATA_WIDTH-1:0] Ddash; // D' = Mantissa of D and exponent of -1
wire [DATA_WIDTH-1:0] P2Ddash; // (-32/17) * D'
wire [DATA_WIDTH-1:0] Xi ; // X[i]= 43/17 - (32/17)D'
wire [DATA_WIDTH-1:0] Xip1; //X[i+1]
wire [DATA_WIDTH-1:0] out0; // Xi*D
wire [DATA_WIDTH-1:0] out1; // 1-Xi*D
wire [DATA_WIDTH-1:0] out2; // X*(1-Xi*D)
reg  [DATA_WIDTH-1:0] mux;

localparam P1=32'b01000000001101001011010010110101; // 43/17
localparam P2=32'b10111111111100001111000011110001; // -32/17

assign Ddash={{1'b0,8'b01111110},number[22:0]};

floatMult FM1 (P2,Ddash,P2Ddash); // -(32/17)* D'
floatAdd FADD1 (P2Ddash,P1,Xi); // 43/17 * (-32/17)D'
floatMult FM2 (mux,Ddash,out0); // Xi*D'
floatAdd FSUB1 (32'b00111111100000000000000000000000,{1'b1,out0[DATA_WIDTH-2:0]},out1); // 1-Xi*D
floatMult FM3 (mux,out1,out2); // X*(1-Xi*D)
floatAdd FADD2 (mux,out2,Xip1); //Xi+Xi*(1-D*Xi)

/*always @(number) begin
	//when a new input is entered the ack signal is reset and the mux is Xi
	ack=1'b0; //reset finish bit
	reset=1'b1;
end*/


always @ (negedge clk) begin
	if (enable==1'b0) begin
		mux=Xi;
		ack=1'b0;
	end
	else begin 
		if(mux==Xip1) begin
			ack=1'b1; //set ack bit to show that the division is done
			output_rec={{number[31],8'b11111101-number[30:23]},Xip1[22:0]}; //sign of number, new exponent, mantissa of Xip1
		end 
		else begin
			mux=Xip1; //continue until ack is 1
		end
	end
	
end

endmodule



