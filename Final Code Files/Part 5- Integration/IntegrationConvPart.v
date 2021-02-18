
module integrationFC (clk,reset,CNNinput,Conv1F,Conv2F,Conv3F,iConvOutput);

parameter DATA_WIDTH = 16;
parameter ImgInW = 32;
parameter ImgInH = 32;
parameter Conv1Out = 28;
parameter AvgP1out = 14;
parameter Conv2Out = 10;
parameter Kernel = 5;
parameter AvgP2out = 5;
parameter Conv3Out = 1;
parameter DepthC1 = 6;
parameter DepthC2 = 16;
parameter DepthC3 = 120;

integer counter;

input clk, reset;
input [ImgInW*ImgInH*DATA_WIDTH-1:0] CNNinput;
input [Kernel*Kernel*DepthC1*DATA_WIDTH-1:0] Conv1F;
input [DepthC2*Kernel*Kernel*DepthC1*DATA_WIDTH-1:0] Conv2F;
input [DepthC3*Kernel*Kernel*DepthC2*DATA_WIDTH-1:0] Conv3F;
output [DepthC3*DATA_WIDTH-1:0] iConvOutput;

reg C1rst,C2rst,C3rst,AP1rst,AP2rst,Tanh1Reset,Tanh2Reset,Tanh3Reset;
wire Tanh1Flag,Tanh2Flag,Tanh3Flag;

wire [Conv1Out*Conv1Out*DepthC1*DATA_WIDTH-1:0] C1out;
wire [Conv1Out*Conv1Out*DepthC1*DATA_WIDTH-1:0] C1outTanH;

wire [AvgP1out*AvgP1out*DepthC1*DATA_WIDTH-1:0] AP1out;

wire [Conv2Out*Conv2Out*DepthC2*DATA_WIDTH-1:0] C2out;
wire [Conv2Out*Conv2Out*DepthC2*DATA_WIDTH-1:0] C2outTanH;

wire [AvgP2out*AvgP2out*DepthC2*DATA_WIDTH-1:0] AP2out;

wire [Conv3Out*Conv3Out*DepthC3*DATA_WIDTH-1:0] C3out;

convLayerMulti C1
(
	.clk(clk),
	.reset(reset),
	.image(CNNinput),
	.filters(Conv1F),
	.outputConv(C1out)
);

UsingTheTanh
#(.nofinputs(Conv1Out*Conv1Out*DepthC1))
Tanh1(
      .x(C1out),
      .clk(clk),
      .Output(C1outTanH),
      .resetExternal(Tanh1Reset),
      .FinishedTanh(Tanh1Flag)
      );

AvgPoolMulti AP1
  (
    .clk(clk),
    .reset(reset),
    .apInput(C1outTanH),
    .apOutput(AP1out)
  );

convLayerMulti
#(
  .DATA_WIDTH(16),
  .D(6),
  .H(14),
  .W(14),
  .F(5),
  .K(16)
) C2 
(
	.clk(clk),
	.reset(reset),
	.image(AP1out),
	.filters(Conv2F),
	.outputConv(C2out)
);

UsingTheTanh
#(.nofinputs(Conv2Out*Conv2Out*DepthC2))
Tanh2(
      .x(C2out),
      .clk(clk),
      .Output(C2outTanH),
      .resetExternal(Tanh2Reset),
      .FinishedTanh(Tanh2Flag)
      );

AvgPoolMulti 
  #(
  .D(16),
  .H(10),
  .W(10)
  ) AP2
  (
    .clk(clk),
    .reset(reset),
    .apInput(C2outTanH),
    .apOutput(AP2out)
  );

convLayer3 C3 
(
	.clk(clk),
	.reset(reset),
	.image(AP2out),
	.filter(Conv3F),
	.outputConv(C3out)
);

UsingTheTanh
#(.nofinputs(Conv3Out*Conv3Out*DepthC3))
Tanh3(
      .x(C3out),
      .clk(clk),
      .Output(iConvOutput),
      .resetExternal(Tanh3Reset),
      .FinishedTanh(Tanh3Flag)
      );

always @(posedge clk or posedge reset) begin
  if (reset == 1'b1) begin
    C1rst = 1'b1;
    C2rst = 1'b1;
    C3rst = 1'b1;
    AP1rst = 1'b1;
    AP2rst = 1'b1;
    Tanh1Reset = 1'b1;
    Tanh2Reset = 1'b1;
    Tanh3Reset = 1'b1;
    counter = 0;
  end
else begin
  counter = counter + 1;
  if (counter > 0 && counter < 7*1457) begin
       C1rst = 1'b0;
    end
  else if (counter > 7*1457 && counter < 7*1457+6*784*6) begin
       Tanh1Reset = 1'b0;
    end
  else if (counter > 7*1457+6*784*6 && counter < 7*1457+6*784*6+8) begin
       AP1rst = 1'b0;
    end
  else if (counter > 7*1457+6*784*6+8 && counter < 7*1457+6*784*6+8+18*22*152) begin
       C2rst = 1'b0;
    end 
  else if (counter > 7*1457+6*784*6+8+18*22*152 && counter < 7*1457+6*784*6+8+18*22*152 + 6*1600) begin
      Tanh2Reset = 1'b0;
    end
  else if (counter > 7*1457+6*784*6+8+18*22*152 + 6*1600 && counter < 7*1457+6*784*6+8+18*22*152 + 6*1600 + 20) begin
       AP2rst = 1'b0;
    end
  else if (counter > 7*1457+6*784*6+8+18*22*152 + 6*1600 + 20 && counter < 7*1457+6*784*6+8+18*22*152 + 6*1600 + 20 + 30) begin
       C3rst = 1'b0;
    end   
  else begin
       Tanh3Reset = 1'b0;
    end 
  end
end

endmodule