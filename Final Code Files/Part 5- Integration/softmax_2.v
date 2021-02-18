

module softmax2(inputs,clk,enable,outputs,ackSoft);
parameter DATA_WIDTH=32;
localparam inputNum=10;
input [DATA_WIDTH*inputNum-1:0] inputs;
input clk;
input enable;
output [DATA_WIDTH*inputNum-1:0] outputs;
output ackSoft;

wire [DATA_WIDTH-1:0] expSum;
wire [DATA_WIDTH-1:0] expReciprocal;
wire [DATA_WIDTH*inputNum-1:0] exponents ;
wire [inputNum-1:0] acksExp; //acknowledge signals of exponents 
wire ackDiv; //ack signal of the division unit
wire [DATA_WIDTH-1:0] expSums [inputNum:0]; //used in the multiple adders to connected to each other

assign expSums[0]=32'b00000000000000000000000000000000; //first one is zero to move the flow
assign expSum=expSums[inputNum]; //last one in the sum
assign ackSoft=ackDiv;

genvar i;
generate
	for (i = 0; i < inputNum; i = i + 1) begin
		exponent #(.DATA_WIDTH(DATA_WIDTH)) exp (
		.x(inputs[DATA_WIDTH*i+:DATA_WIDTH]),
		.enable(enable),
		.clk(clk),
		.output_exp(exponents[DATA_WIDTH*i+:DATA_WIDTH]),
		.ack(acksExp[i]));
	end
endgenerate //generating 10 parallel exponent modules 

genvar j;
generate 
	for (j = 0; j < inputNum; j = j + 1) begin
		floatAdd FADD1 (exponents[DATA_WIDTH*j+:DATA_WIDTH],expSums[j],expSums[j+1]);
	end
endgenerate //generating 10 parallel adding modules to get the exponent sum

floatReciprocal #(.DATA_WIDTH(DATA_WIDTH)) FR (.number(expSum),.clk(clk),.output_rec(expReciprocal),.ack(ackDiv),.enable(acksExp[0]));// get the reciprocal of the exponent sum
//reciprocal activated when exponent finished
genvar z;
generate
	for (z = 0; z < inputNum; z = z + 1) begin
		floatMult FM1 (exponents[DATA_WIDTH*z+:DATA_WIDTH],expReciprocal,outputs[DATA_WIDTH*z+:DATA_WIDTH]); //multiplication with reciprocal
	end
endgenerate //generating 10 multiplication unit to multiply every exponent with the reciprocal


endmodule


 