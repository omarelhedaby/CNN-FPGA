module UsingTheTanh(x,clk,Output,resetExternal,FinishedTanh);
parameter DATA_WIDTH=32;
parameter nofinputs=784;// deterimining the no of inputs entering the function
input resetExternal;// controlling this layer
input  signed [nofinputs*DATA_WIDTH-1:0] x;
input clk;
output reg FinishedTanh;
reg reset;// for the inner tanh
output reg [nofinputs*DATA_WIDTH-1:0]Output;
wire [DATA_WIDTH-1:0]OutputTemp;
reg [7:0]counter=0;
wire Finished;
reg [7:0]i;
// the inner tanh taking inputs in 32 bits and then increment using the i operator
HyperBolicTangent TanhArray (x[DATA_WIDTH*i+:DATA_WIDTH],reset,clk,OutputTemp,Finished);
 
 
always@(posedge clk)
begin 
// if the external reset =1 then make everything to 0
if(resetExternal==1) begin reset=1;i=0;FinishedTanh=0; end
//checking if the tanh is not finished so continue your operation and low down the reset to continue
  else if(FinishedTanh==0) begin 
    if(reset==1)begin reset=0; end 
    // if it is finished then store the output of the tanh and increment the input forward
      else if (Finished==1)begin Output[DATA_WIDTH*i+:DATA_WIDTH]=OutputTemp;reset=1;i=i+1;end
// check if all the inputs are finished then the layer is OK
if(i==nofinputs)
  begin FinishedTanh=1;end
end 

end
endmodule 
