
module softmax1(inputs,clk,enable,outputs,ackSoft);
parameter DATA_WIDTH=32;
localparam inputNum=10;
input [DATA_WIDTH*inputNum-1:0] inputs;
input clk;
input enable;
output reg [DATA_WIDTH*inputNum-1:0] outputs;
output reg ackSoft;

wire [DATA_WIDTH-1:0] expSum;
wire [DATA_WIDTH-1:0] expReciprocal;
wire [DATA_WIDTH-1:0] outMul;
wire [DATA_WIDTH*inputNum-1:0] exponents ;
wire [inputNum-1:0] acksExp; //acknowledge signals of exponents 
wire ackDiv; //ack signal of the division unit
wire [DATA_WIDTH-1:0] expSums [inputNum:0]; //used in the multiple adders to connected to each other
reg [3:0] mulCounter;

assign expSums[0]=32'b00000000000000000000000000000000; //first one is zero to move the flow
assign expSum=expSums[inputNum]; //last one in the sum

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
endgenerate //generating 10 parallel adding modules to get the sum of the exponents

floatReciprocal #(.DATA_WIDTH(DATA_WIDTH)) FR (.number(expSum),.clk(clk),.output_rec(expReciprocal),.ack(ackDiv),.enable(acksExp[0]));//getting reciprocal of the sum of exponents
//reciprocal activated when exponent finished
floatMult FM1 (exponents[DATA_WIDTH*mulCounter+:DATA_WIDTH],expReciprocal,outMul); //multiplication with reciprocal

always @ (negedge clk) begin
	if(enable==1'b1) begin
		if(ackSoft==1'b0) begin 
			if(ackDiv==1'b1) begin //check if the reciprocal is ready
				if(mulCounter<4'b1010) begin
					outputs[DATA_WIDTH*mulCounter+:DATA_WIDTH]=outMul;
					mulCounter=mulCounter+1;
				end
				else begin
					ackSoft=1'b1;
				end
			end
		end
	end
	else begin
		//if enable is off reset all counters and acks
		mulCounter=4'b0000;
		ackSoft=1'b0;
	end
	
end

endmodule


 