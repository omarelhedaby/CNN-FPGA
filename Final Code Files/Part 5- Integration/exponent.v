module exponent (x,clk,enable,output_exp,ack);
parameter DATA_WIDTH=32;
localparam taylor_iter=7;
input [DATA_WIDTH-1:0] x;
input clk;
input enable;
output reg ack;
output reg [DATA_WIDTH-1:0] output_exp;

reg [DATA_WIDTH*taylor_iter-1:0] divisors; // 1/6 1/5 1/4 1/3 1/2 1 1
reg [DATA_WIDTH-1:0] mult1; //is 1 in the first cycle and then the output of the second multiplication in the rest
reg [DATA_WIDTH-1:0] one_or_x; //one in the first cycle and then x for the rest
wire [DATA_WIDTH-1:0] out_m1; //output of the first multiplication which is either with 1 or x
wire [DATA_WIDTH-1:0] out_m2; //the output of the second muliplication and the input of the first
wire [DATA_WIDTH-1:0] output_add1;
reg [DATA_WIDTH-1:0] out_reg; //the output of the Addition each cycle 

floatMult FM1 (mult1,one_or_x,out_m1); 
floatMult FM2 (out_m1,divisors[31:0],out_m2); 
floatAdd FADD1 (out_m2,out_reg,output_add1); 

always @ (posedge clk) begin
    if(enable==1'b0) begin
        one_or_x=32'b00111111100000000000000000000000; //initially 1
        mult1=32'b00111111100000000000000000000000; //initially 1
        out_reg=32'b00000000000000000000000000000000; //initially 0
        output_exp=32'b00000000000000000000000000000000; //output zero until ack is 1
        divisors=224'b00111110001010101010101010101011_00111110010011001100110011001101_00111110100000000000000000000000_00111110101010101010101010101011_00111111000000000000000000000000_00111111100000000000000000000000_00111111100000000000000000000000;
        ack=1'b0; // acknowledge is 0 at the beginning
    end 
    else begin
	   one_or_x=x;
	   mult1=out_m2; //get the output of the second multiplication to multiply with x
	   divisors=divisors>>32; //shift 32 bit to divide the out_m1 with the new number to compute the factorial
	   out_reg=output_add1;
	   if(divisors==224'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000) 
	   begin
		  output_exp=output_add1;
		  ack=1'b1;
	   end
	  end
end

endmodule 