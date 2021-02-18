
module HyperBolicTangent (x,reset,clk,OutputFinal,Finished);
parameter DATA_WIDTH=32;
localparam taylor_iter=4;//I chose 5 Taylor Coefficients to undergo my tanh operation
input signed [DATA_WIDTH-1:0] x;

input clk;
input reset;
output reg Finished;
output reg[DATA_WIDTH-1:0]  OutputFinal;
reg [DATA_WIDTH*taylor_iter-1:0] Coefficients ; //-17/315 2/15 -1/3 1
wire [DATA_WIDTH-1:0] Xsquared; //To always generate a squared version of the input to increment the power by 2 always.
reg [DATA_WIDTH-1:0] ForXSqOrOne; //For Multiplying The power of X(1 or X^2)
reg [DATA_WIDTH-1:0] ForMultPrevious; //output of the first multiplication which is either with 1 or x(X or Output1)
wire [DATA_WIDTH-1:0] OutputOne; //the output of Mulitplying the X term with its corresponding power coeff.
wire [DATA_WIDTH-1:0] OutOfCoeffMult; //the output of Mulitplying the X term with its corresponding power coeff.
reg  [DATA_WIDTH-1:0] OutputAdditionInAlways;
wire [DATA_WIDTH-1:0] OutputAddition; //the output of the Addition each cycle 

floatMult MSquaring (x,x,Xsquared);//Generating x^2
floatMult MGeneratingXterm (ForXSqOrOne,ForMultPrevious,OutputOne); //Generating the X term [x,x^3,x^5,...]
floatMult MTheCoefficientTerm (OutputOne,Coefficients[DATA_WIDTH-1:0],OutOfCoeffMult); //Multiplying the X term by its corresponding coeff.
floatAdd FADD1 (OutOfCoeffMult,OutputAdditionInAlways,OutputAddition); //Adding the new term to the previous one     ex: x-1/3*(x^3)
reg [DATA_WIDTH-1:0] AbsFloat; //To generate an absolute value of the input[For Checking the convergence]

always @ (posedge clk) begin
AbsFloat=x;//Here i hold the input then i make it positive whatever its sign to be able to compare to implement the rule |x|>pi/2   which is the convergence rule
AbsFloat[31]=0;
if(AbsFloat>32'sb00111111110010001111010111000011)begin 
  //The Finished bit is for letting the bigger module know that the tanh is finished
  if (x[31]==0)begin 
    OutputFinal= 32'b00111111100000000000000000000000;Finished =1'b 1;//here i assign it an immediate value of Positive Floating one
  end 
    if (x[31]==1)begin 
    OutputFinal= 32'b10111111100000000000000000000000;Finished =1'b 1;//here i assign it an immediate value of Negative Floating one
    end
end
//here i handle the case of it equals +- pi/2    so i got the exact value and handle it also immediately
else if (AbsFloat==32'sb00111111110010001111010111000011)
  begin 
    if (x[31]==0)begin 
  OutputFinal=32'b00111111110010001111010111000011;Finished=1'b 1;
  end
  else begin 
  OutputFinal=32'b10111111110010001111010111000011;Finished=1'b 1;
  end
  end
else begin 
  //First instance of the tanh
  if(reset==1'b1)begin  
	Coefficients=128'b10111101010111010000110111010001_00111110000010001000100010001001_10111110101010101010101010101011_00111111100000000000000000000000;//the 4 coefficients of taylor expansion
	ForXSqOrOne=32'b00111111100000000000000000000000; //initially 1
	OutputAdditionInAlways=32'b00000000000000000000000000000000; //initially 0
	ForMultPrevious=x;
Finished=0;
end
else begin
 	ForXSqOrOne=Xsquared;
	ForMultPrevious=OutputOne; //get the output of the second multiplication to multiply with x
	Coefficients=Coefficients>>32; //shift 32 bit to divide the out_m1 with the new number to compute the factorial
  OutputAdditionInAlways=OutputAddition;
  Finished=0;
end
// the end of the tanh
if(Coefficients==128'b00000000000000000000000000000000_00000000000000000000000000000000_00000000000000000000000000000000_00000000000000000000000000000000)begin 
	OutputFinal=OutputAddition;
	Finished =1'b 1;
end
end 
end
endmodule 
