`timescale 1 ns / 10 ps

module AvgPoolMulti(clk, reset, apInput, apOutput);

parameter DATA_WIDTH = 16;
parameter D = 6;
parameter H = 28;
parameter W = 28;

input reset,clk;
input [0:H*W*D*DATA_WIDTH-1] apInput;
output reg [0:(H/2)*(W/2)*D*DATA_WIDTH-1] apOutput;

reg [0:H*W*DATA_WIDTH-1] apInput_s;
wire [0:(H/2)*(W/2)*DATA_WIDTH-1] apOutput_s;
integer counter;


avgPoolSingle
  #(
      .DATA_WIDTH(DATA_WIDTH),
      .InputH(H),
      .InputW(W)
  ) avgPool
  (
      .aPoolIn(apInput_s),
      .aPoolOut(apOutput_s)
  );

always @ (posedge clk or posedge reset) begin
  if (reset == 1'b1) begin
    counter = 0;
  end
  else if (counter<D) begin 
    counter = counter+1;
  end
end

always @ (*) begin
  apInput_s = apInput[counter*H*W*DATA_WIDTH+:H*W*DATA_WIDTH];
  apOutput[counter*(H/2)*(W/2)*DATA_WIDTH+:(H/2)*(W/2)*DATA_WIDTH] = apOutput_s;
end

endmodule