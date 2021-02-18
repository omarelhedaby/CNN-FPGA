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
output reg [0:K*(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputConv;

reg [0:2*D*F*F*DATA_WIDTH-1] inputFilters;
wire [0:2*(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputSingleLayers;

reg internalReset;

integer filterSet, counter, outputCounter;

genvar i;

generate
	for (i = 0; i < 2; i = i + 1) begin 
		convLayerSingle UUT 
		(
			.clk(clk),
	     		.reset(internalReset),
	     		.image(image),
	    		.filter(inputFilters[i*D*F*F*DATA_WIDTH+:D*F*F*DATA_WIDTH]),
	     		.outputConv(outputSingleLayers[i*(H-F+1)*(W-F+1)*DATA_WIDTH+:(H-F+1)*(W-F+1)*DATA_WIDTH])
      		);
  	end
endgenerate

always @ (posedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		internalReset = 1'b1;
		filterSet = 0;
		counter = 0;
		outputCounter = 0;		
	end else if (filterSet < K/2) begin
		if (counter == ((((H-F+1)*(W-F+1))/((H-F+1)/2))*28+1)) begin
			outputCounter = outputCounter + 1;
			counter = 0;
			internalReset = 1'b1;
			filterSet = filterSet + 1;
		end else begin
			internalReset = 0;
			counter = counter + 1;
		end
	end
end

always @ (*) begin
	inputFilters = filters[filterSet*2*D*F*F*DATA_WIDTH+:D*F*F*DATA_WIDTH];
	outputConv[outputCounter*2*(H-F+1)*(W-F+1)*DATA_WIDTH+:2*(H-F+1)*(W-F+1)*DATA_WIDTH] = outputSingleLayers;
end

endmodule
