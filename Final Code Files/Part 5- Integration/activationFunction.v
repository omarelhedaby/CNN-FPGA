module activationFunction(clk,reset,en,input_fc,output_fc);

parameter DATA_WIDTH = 32;
parameter OUTPUT_NODES = 32;

input clk, reset, en;
input [DATA_WIDTH*OUTPUT_NODES-1:0] input_fc;
output reg [DATA_WIDTH*OUTPUT_NODES-1:0] output_fc;

integer i;

always @ (negedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		output_fc = 0;
	end else begin
		if (en == 1'b1) begin
			for (i = 0; i < OUTPUT_NODES; i = i + 1) begin
				if (input_fc[DATA_WIDTH*i-1+DATA_WIDTH] == 1'b1) begin
					output_fc[DATA_WIDTH*i+:DATA_WIDTH] = 0;
				end else begin
					output_fc[DATA_WIDTH*i+:DATA_WIDTH] = input_fc[DATA_WIDTH*i+:DATA_WIDTH];
				end
			end
		end
	end
end

endmodule
