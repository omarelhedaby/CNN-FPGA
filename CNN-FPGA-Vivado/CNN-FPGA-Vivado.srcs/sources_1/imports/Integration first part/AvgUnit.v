`timescale 1 ns / 10 ps

module AvgUnit (numA,numB,numC,numD,AvgOut);
  
parameter DATA_WIDTH = 16;

input [DATA_WIDTH-1:0] numA,numB,numC,numD;
output [DATA_WIDTH-1:0] AvgOut;

wire [DATA_WIDTH-1:0] add1result;
wire [DATA_WIDTH-1:0] add2result;
wire [DATA_WIDTH-1:0] add3result;
reg [DATA_WIDTH-1:0] quarter = 16'b0011010000000000;



floatAdd16 FADD1 (numA,numB,add1result);
floatAdd16 FADD2 (add1result,numC,add2result);
floatAdd16 FADD3 (add2result,numD,add3result);  
floatMult16 FM (add3result,quarter,AvgOut);  

endmodule