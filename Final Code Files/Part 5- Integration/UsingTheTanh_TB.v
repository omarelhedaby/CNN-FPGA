module UsingTheTanh_TB ();

reg clk, resetExternal;
reg [63:0]x;
wire [63:0]Output;
wire FinishedTanh;

localparam PERIOD = 100;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0 //starting the tanh 
	clk = 1'b1;
	resetExternal = 1'b1;
	// trying a random input(0.6,3)     where tanh(0.600000023842)=0.53704958, tanh(3)~=1
	x=64'b00111111000110011001100110011010_01000000010000000000000000000000;

	#(PERIOD/2)
	resetExternal = 1'b0;	
	
	#800
	// waiting for The final output which will be (0.57,1)
	if(Output==64'b00111111000010010110111101111011_00111111100000000000000000000000 && FinishedTanh==1'b1)begin 
	 $display("Result is right (for the full array of inputs)");	  
	  end
	  else begin 
	 $display("Result is Wrong");	 
	    end	 
	$stop;
end

UsingTheTanh UUT
(
  .x(x),
	.clk(clk),
	.Output(Output),
	.resetExternal(resetExternal),	
	.FinishedTanh(FinishedTanh)	
);

endmodule



