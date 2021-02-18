`timescale 1ps/1ps
module exponent_tb();
localparam DATA_WIDTH=32;
reg [DATA_WIDTH-1:0] x;
reg clk;
reg enable;
wire [DATA_WIDTH-1:0] output_exp;
wire ack; 
exponent #(.DATA_WIDTH(DATA_WIDTH)) exp (.x(x),.clk(clk),.output_exp(output_exp),.ack(ack),.enable(enable));

localparam PERIOD = 100;
always 
	#(PERIOD/2) clk = ~clk;

initial begin
	clk=1'b1;
	x=32'b00111111010101100110110011110100; //0.8376
	enable=1'b0;
	#(PERIOD);
	enable=1'b1;
	while (ack!=1'b1) begin //7 clock cycles to finish
		#(PERIOD);
	end
	//output is 2.31074953079 and real should be 2.310814361840001 
	x=32'b10111111011101011100001010001111; //-0.96
	enable=1'b0;
   	#(PERIOD);
   	enable=1'b1;
    	while (ack!=1'b1) begin //7 clock cycles to finish
        	#(PERIOD);
    	end
	//output is 0.383025914431 and real should be 0.38289288597511206
end

endmodule
