
module integrationFC (clk,reset,iFCinput,CNNoutput);

parameter DATA_WIDTH = 32;
parameter IntIn = 120;
parameter FC_1_out = 84;
parameter FC_2_out = 10;

input clk, reset;
input [IntIn*DATA_WIDTH-1:0] iFCinput;
output [FC_2_out*DATA_WIDTH-1:0] CNNoutput;

wire [FC_1_out*DATA_WIDTH-1:0] fc1Out;
wire [FC_1_out*DATA_WIDTH-1:0] fc1OutTanh;

wire [FC_2_out*DATA_WIDTH-1:0] fc2Out;
wire [FC_2_out*DATA_WIDTH-1:0] fc2OutSMax;

wire [DATA_WIDTH*FC_1_out-1:0] wFC1;
wire [DATA_WIDTH*FC_2_out-1:0] wFC2;

reg FC1reset;
reg FC2reset;
reg TanhReset;
wire TanhFlag;
reg SMaxEnable;
wire DoneFlag;

integer counter;
reg [7:0] address1;
reg [7:0] address2;

weightMemory 
#(.INPUT_NODES(IntIn),
  .OUTPUT_NODES(FC_1_out),
  .file("C:/Users/ahmed/Desktop/Logic Design 2 Project/Parameters With No Seperators/weightsdense_1_IEEE.txt"))
  W1(
    .clk(clk),
    .address(address1),
    .weights(wFC1)
    );
    
weightMemory 
#(.INPUT_NODES(FC_1_out),
  .OUTPUT_NODES(FC_2_out),
  .file("C:/Users/ahmed/Desktop/Logic Design 2 Project/Parameters With No Seperators/weightsdense_2_IEEE.txt"))
  W2(
    .clk(clk),
    .address(address2),
    .weights(wFC2)
    );  
    
layer
#(.INPUT_NODES(IntIn),
  .OUTPUT_NODES(FC_1_out))
 FC1(
    .clk(clk),
    .reset(FC1reset),
    .input_fc(iFCinput),
    .weights(wFC1),
    .output_fc(fc1Out)
    );

layer
#(.INPUT_NODES(FC_1_out),
  .OUTPUT_NODES(FC_2_out))
 FC2(
    .clk(clk),
    .reset(FC2reset),
    .input_fc(fc1OutTanh),
    .weights(wFC2),
    .output_fc(fc2Out)
    );
    
UsingTheTanh
#(.nofinputs(FC_1_out))
Tanh1(
      .x(fc1Out),
      .clk(clk),
      .Output(fc1OutTanh),
      .resetExternal(TanhReset),
      .FinishedTanh(TanhFlag)
      );

softmax SMax(
      .inputs(fc2Out),
      .clk(clk),
      .enable(SMaxEnable),
      .outputs(CNNoutput),
      .ackSoft(DoneFlag)
      );

always @(posedge clk or posedge reset) begin
  if (reset == 1'b1) begin
    FC1reset = 1'b1;
    FC2reset = 1'b1;
    TanhReset = 1'b1;
    SMaxEnable = 1'b0;
    counter = 0;
    address1 = -1;
    address2 = -1;
  end
  else begin
      counter = counter + 1;
    if (counter > 0 && counter < IntIn + 10) begin
       FC1reset = 1'b0;
    end
    else if (counter > IntIn + 10 && counter < IntIn + 12 + FC_1_out*6) begin
       TanhReset = 1'b0;
       address2 = -3;
    end
    else if (counter > IntIn + 12 + FC_1_out*6 && counter < IntIn + 12 + FC_1_out*6 + FC_1_out + 10) begin
       FC2reset = 1'b0;
    end
    else if (counter > IntIn + 12 + FC_1_out*6 + FC_1_out + 10) begin
       SMaxEnable = 1'b1;
    end
    if (address1 != 8'hfe) begin
      address1 = address1 + 1;
    end
    else
      address1 = 8'hfe;
    address2 = address2 + 1;
  end
end

endmodule  