module HyperBolicTangent_TB ();

reg clk, reset;
reg [15:0]x;
wire [15:0]OutputFinal;
wire Finished;

localparam PERIOD = 100;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0 //starting the tanh 
	clk = 1'b1;
	reset = 1'b1;
	// trying a random input(0.600000023842)     where tanh(0.600000023842)=0.53704958
	x=16'b0011100011001101;

	#(PERIOD/2)
	reset = 0;	
	
	#400
	// waiting for 4 clock cycles then checking the output with approx.(0.53685)
	if(OutputFinal==32'b00111111000010010110111101111011 && Finished==1'b1)begin 
	 $display("Result is Right [Not in convergence region]");	  
	  end
	  else begin 
	 $display("Result is Wrong");	 
	    end	 
	    //trying another input which will be in the convergence region(3)  the output will be converged to 1    and reseting the function again
	    x=16'b0100001000000000;
	    
		reset = 1'b1;
		#(PERIOD/2)
		reset=1'b0;
		#200
		// checking if the output is 1
		if(OutputFinal==32'b00111111100000000000000000000000)begin 
	 $display("Result is Right [ convergence region]");	  
	  end
	  else begin 
	 $display("Result is Wrong ");	 
	    end	
	$stop;
end

HyperBolicTangent UUT
(
  .x(x),
	.clk(clk),
	.reset(reset),
	.OutputFinal(OutputFinal),
	.Finished(Finished)	
);

endmodule

