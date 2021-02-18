`timescale 1ps/1ps
module floatReciprocal_tb();
localparam DATA_WIDTH=32;
reg [DATA_WIDTH-1:0] num;
reg clk,enable;
wire [DATA_WIDTH-1:0] output_rec;
wire ack;

floatReciprocal #(.DATA_WIDTH(DATA_WIDTH))  FA (.number(num),.clk(clk),.output_rec(output_rec),.ack(ack),.enable(enable));

localparam PERIOD = 100;

always 
	#(PERIOD/2) clk = ~clk;


initial begin
	clk=1'b1; //positive edge first
	num=32'b00111110101100001010001111010111; //0.345
	enable=1'b0;
	#(PERIOD);
	enable=1'b1;
	while( ack!=1'b1) begin
		#(PERIOD);
	end
	//output is 2.89855074883
	num=32'b10111110111111101111100111011011;
	enable=1'b0;
	#(PERIOD);
	enable=1'b1; 
	while (ack!=1'b1) begin
		#(PERIOD);
	end
	//output is -2.00803232193
	$stop;
end

endmodule

