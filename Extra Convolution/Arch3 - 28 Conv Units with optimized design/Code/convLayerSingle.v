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
output reg [0:(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputConv; // output of the module

wire [0:(W-F+1)*DATA_WIDTH-1] outputConvUnits; // output of the conv units and input to the row selector

reg internalReset;
wire [0:((W-F+1)*D*F*F*DATA_WIDTH)-1] receptiveField; // array of the matrices to be sent to conv units


integer counter;
reg [5:0] rowNumber; // determine the row that is calculated by the conv units

RFselector
#(
	.DATA_WIDTH(DATA_WIDTH),
	.D(D),
	.H(H),
	.W(W),
	.F(F)
) RF
(
	.image(image),
	.rowNumber(rowNumber),
	.receptiveField(receptiveField)
);

genvar n;

generate 
	for (n = 0; n < (H-F+1); n = n + 1) begin 
		convUnit
		#(
			.D(D),
			.F(F)
		) CU
		(
			.clk(clk),
			.reset(internalReset),
			.image(receptiveField[n*D*F*F*DATA_WIDTH+:D*F*F*DATA_WIDTH]),
			.filter(filter),
			.result(outputConvUnits[n*DATA_WIDTH+:DATA_WIDTH])
		);
	end
endgenerate

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

always @ (*) begin
	outputConv[rowNumber*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = outputConvUnits;
end

endmodule
