`timescale 1 ns / 10 ps

module convUnit(clk,reset,image,filter,result);

parameter DATA_WIDTH = 32;
parameter D = 1; //depth of the filter
parameter F = 5; //size of the filter

input clk, reset;
input [D*F*F*DATA_WIDTH-1:0] image, filter;
output [DATA_WIDTH-1:0] result;

reg [DATA_WIDTH-1:0] selectedInput1, selectedInput2;

integer i;


processingElement PE
	(
		.clk(clk),
		.reset(reset),
		.floatA(selectedInput1),
		.floatB(selectedInput2),
		.result(result)
	);

// The convolution is calculated in a sequential process to save hardware
// The result of the element wise matrix multiplication is finished after (F*F+2) cycles (2 cycles to reset the processing element and F*F cycles to accumulate the result of the F*F multiplications) 
always @ (posedge clk, posedge reset) begin
	if (reset == 1'b1) begin // reset
		selectedInput1 = 0;
		selectedInput2 = 0;
		i = 0;
	end else if (i > D*F*F-1) begin // if the convolution is finished but we still wait for other blocks to finsih, send zeros to the conv unit (in case of pipelining)
		selectedInput1 = 0;
		selectedInput2 = 0;
	end else begin // send one element of the image part and one element of the filter to be multiplied and accumulated
		selectedInput1 = image[DATA_WIDTH*i+:DATA_WIDTH];
		selectedInput2 = filter[DATA_WIDTH*i+:DATA_WIDTH];
		i = i + 1;
	end
end

endmodule
