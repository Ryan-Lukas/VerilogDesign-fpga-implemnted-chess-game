`timescale 1ns/1ps

module testbench;
	
	reg reset;
	reg clk;
	
	processor  UUT(clk,reset);
	

initial begin
reset = 1;

#20;
reset = 0;

end

always begin 
clk <= 1;
#20;
clk <= 0;
#20;

end

	
endmodule
