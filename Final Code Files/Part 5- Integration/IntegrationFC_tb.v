module integrationFC_tb();

reg clk, reset;
reg [32*120-1:0] inputTest;
wire [10*32-1:0] outPutTest;

localparam PERIOD = 100;

always
	#(PERIOD/2) clk = ~clk;

initial begin
  
  #0
  clk = 1'b0;
  reset = 1'b1;
  inputTest = 3840'h3d75c1ee3e8c6d1e3e4d21793f7893ea3f3f1d823ee949c73f5371a83f6841cc3f081b113e6059a73ef4c5da3e6881e43eddc9c53f5cfbb93f346b6a3ee8c1db3f5f8fbd3f233b433f3573643f206f483e9ce93e3f7be1fc3e80010c3f35d96f3f1787273f0b3b103e7af20f3f6dbbe03f240f453eaf19503f5885b23f26a9503ebdf58c3d43018d3e8dd11c3b8701113eff3e033f39436c3e5cd1c83f5c1fb83e4c197e3f77c5ef3f7e03f73eb66d7a3e2ed17c3f5a4db13eca699c3f1bcd363dff822c3f1225203eb90d7c3f43cd8a3e7a31e83e43e1873ea921473d8471063f222b493ede05ab3f0c55113d62e1c73e9611343f5da3c23dc9f1933f1f87383f2747523edd39b93f71b3e13f7e85fd3e46c1a03f37ad6d3f42177f3eba41813e3c115e3f5ab9b23f5455a83e9d794a3d8dd11c3ef4f9e43f51e3a83f2211453f0c4d123f23a54c3f284f4c3f538fac3f59ffb53d94212d3eb0915c3f4051873e8c51113f3d377e3f7725f63f41797d3ef3fdf83d24014c3f2ae3503f5823b83f18d3393f1bc9363f68bbd43d8e211e3f32e5693db9816e3f3e29843f4d17943f16a7263f51439e3ed8cda73cefc1fa3f08850a3f46dd8b3df401c53eb5f56a3f692fd33f4a11993bed01e13f5481a13ea4b1463e97a93b3f0937193e95dd2b;
  #(PERIOD)
  reset = 1'b0;
  #(PERIOD*(1000))
  
  $stop;
  
end

integrationFC UUT (
                .clk(clk),
                .reset(reset),
                .iFCinput(inputTest),
                .CNNoutput(outPutTest)
                );

endmodule 