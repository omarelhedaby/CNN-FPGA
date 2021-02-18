`timescale 1 ns / 10 ps

module convLayerSingle(clk,reset,image,filter,outputConv);

parameter DATA_WIDTH = 32;
parameter D = 1; //Depth of the filter
parameter H = 32; //Height of the image
parameter W = 32; //Width of the image
parameter F = 5; //Size of the filter

input clk, reset;
input [0:D*H*W*DATA_WIDTH-1] image;
input [0:D*F*F*DATA_WIDTH-1] filter;
output [0:(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputConv;

reg [0:(H-F+1)*(W-F+1)*F*F*D*DATA_WIDTH-1] receptiveField; // array of the matrices to be sent to conv units

integer i, k, l, m, address;

always @ (*) begin
	address = 0; // To fill the receptiveFiled vector	
	for (m = 0; m < (H-F+1); m = m + 1) begin //Loop on the first 28 rows of the image (in case of a D*32*32 image)
		for (l = 0; l < (W-F+1); l = l +1) begin //Loop on the the first 28 columns of the image (in case of a D*32*32 image)
			for (k = 0; k < D; k = k + 1) begin //Loop on the depth of the image
				for (i = 0; i < F; i = i + 1) begin						
					receptiveField[address*F*DATA_WIDTH+:F*DATA_WIDTH] = image[m*W*DATA_WIDTH+l*DATA_WIDTH+k*H*W*DATA_WIDTH+i*W*DATA_WIDTH+:F*DATA_WIDTH]; //fill the receptiveField with the corresponding image part
					address = address + 1;
				end
			end
		end
	end
end

genvar z;

generate 
	for (z = 0; z < (H-F+1)*(W-F+1); z = z + 1) begin //generate 28*28 conv units (in case of a D*32*32 image) and send to them the filter and the corresponding image part
		convUnit
		#(
			.D(D),
			.F(F)
		) CU
		(
			.clk(clk),
			.reset(reset),
			.image(receptiveField[z*D*F*F*DATA_WIDTH+:D*F*F*DATA_WIDTH]),
			.filter(filter),
			.result(outputConv[z*DATA_WIDTH+:DATA_WIDTH])
		);
	end
endgenerate

endmodule
