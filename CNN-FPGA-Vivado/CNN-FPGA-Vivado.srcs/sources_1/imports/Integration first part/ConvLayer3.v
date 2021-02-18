`timescale 100 ns / 10 ps

module convLayer3(clk,reset,image,filter,outputConv);

parameter DATA_WIDTH = 16;
parameter D = 16; //Depth of the filter
parameter H = 5; //Height of the image
parameter W = 5; //Width of the image
parameter F = 5; //Size of the filter
parameter K = 120; //Number of filters

input clk, reset;
input [0:D*H*W*DATA_WIDTH-1] image;
input [0:K*D*F*F*DATA_WIDTH-1] filter;
output [0:K*DATA_WIDTH-1] outputConv; // output of the module

genvar n;

generate //generating 120 convolution units
	for (n = 0; n < 120; n = n + 1) begin 
		convUnit
		#(
			.D(D),
			.F(F)
		) CU
		(
			.clk(clk),
			.reset(reset),
			.image(image),
			.filter(filter[n*D*F*F*DATA_WIDTH+:D*F*F*DATA_WIDTH]),
			.result(outputConv[n*DATA_WIDTH+:DATA_WIDTH])
		);
	end
endgenerate

endmodule