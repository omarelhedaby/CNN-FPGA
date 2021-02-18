`timescale 1 ns / 10 ps

module convLayerMulti(clk,reset,image,filters,outputConv);

parameter DATA_WIDTH = 32;
parameter D = 1; //Depth of image and filter
parameter H = 32; //Height of image
parameter W = 32; //Width of image
parameter F = 5; //Size of filter
parameter K = 6; //Number of filters applied

input clk, reset;
input [0:D*H*W*DATA_WIDTH-1] image;
input [0:K*D*F*F*DATA_WIDTH-1] filters;
output [0:K*(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputConv;

genvar i;

generate
	for (i = 0; i < K; i = i + 1) begin //We generate K single conv layers (K = number of filters) and send to each layer the image and the corresponding filter
		convLayerSingle UUT 
		(
			.clk(clk),
	     		.reset(reset),
	     		.image(image),
	    		.filter(filters[D*F*F*DATA_WIDTH*i+:D*F*F*DATA_WIDTH]),
	     		.outputConv(outputConv[(H-F+1)*(W-F+1)*DATA_WIDTH*i+:(H-F+1)*(W-F+1)*DATA_WIDTH])
      		);
  	end
endgenerate


endmodule
