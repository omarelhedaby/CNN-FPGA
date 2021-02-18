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
output [0:(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputConv; // output of the module

wire [0:(W-F+1)*DATA_WIDTH-1] finishVector;
wire [0:(W-F+1)*DATA_WIDTH-1] outputConvUnits; // output of the conv units and input to the row selector

reg internalReset;
reg [0:((H-F+1)*(W-F+1)*D*F*F*DATA_WIDTH)-1] receptiveField; // array of the matrices to be sent to conv units

integer i, k, l, m, address, counter;
reg [5:0] rowNumber; // determine the row that is calculated by the conv units

always @ (image) begin
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
	for (z = 0; z < (H-F+1); z = z + 1) begin 
		convUnit
		#(
			.D(D),
			.F(F)
		) CU
		(
			.clk(clk),
			.reset(internalReset),
			.image(receptiveField[(rowNumber*(W-F+1)*D*F*F*DATA_WIDTH + z*D*F*F*DATA_WIDTH)+:D*F*F*DATA_WIDTH]),
			.filter(filter),
			.result(outputConvUnits[z*DATA_WIDTH+:DATA_WIDTH])
		);
	end
endgenerate

rowSelector 
#(
	.H(H),
	.W(H),
	.F(F)
) RS
(
	.row(outputConvUnits),
	.rowNumber(rowNumber),
	.outputVector(outputConv),
	.finishVector(finishVector)
);

always @ (posedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		internalReset = 1'b1;
		rowNumber = 0;
		counter = 0;
	end else if (rowNumber < H-F+1) begin
		if (counter == D*F*F+2) begin
			rowNumber = rowNumber + 1;
			counter = 0;
			internalReset = 1'b1;
		end else begin
			internalReset = 0;
			counter = counter + 1;
		end
	end

end

endmodule
