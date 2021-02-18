`timescale 1 ns / 10 ps

module rowSelector(row,rowNumber,outputVector,finishVector);

parameter DATA_WIDTH = 32;
parameter H = 32; //Height of the image
parameter W = 32; //Width of the image
parameter F = 5; //Size of the filter

input [0:(W-F+1)*DATA_WIDTH-1] row;
input [5:0] rowNumber;
output reg [0:(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputVector;
output reg [0:(W-F+1)*DATA_WIDTH-1] finishVector;

always @(row, rowNumber) begin
	case (rowNumber)
		6'b000001 : outputVector[1*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b000010 : outputVector[2*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b000011 : outputVector[3*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b000100 : outputVector[4*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b000101 : outputVector[5*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b000110 : outputVector[6*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b000111 : outputVector[7*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b001000 : outputVector[8*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b001001 : outputVector[9*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b001010 : outputVector[10*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b001011 : outputVector[11*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b001100 : outputVector[12*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b001101 : outputVector[13*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b001110 : outputVector[14*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b001111 : outputVector[15*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b010000 : outputVector[16*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b010001 : outputVector[17*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b010010 : outputVector[18*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b010011 : outputVector[19*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b010100 : outputVector[20*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b010101 : outputVector[21*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b010110 : outputVector[22*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b010111 : outputVector[23*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b011000 : outputVector[24*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b011001 : outputVector[25*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b011010 : outputVector[26*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
		6'b011011 : outputVector[27*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;	
		6'b011100 : finishVector = row;			
		default : outputVector[0*(H-F+1)*DATA_WIDTH+:(W-F+1)*DATA_WIDTH] = row;
	endcase
end

endmodule
