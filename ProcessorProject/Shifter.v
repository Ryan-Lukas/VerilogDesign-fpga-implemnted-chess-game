module Shifter #(parameter WIDTH = 16)(A, amount, opCode, opCodeExt, ShifterOutput);
input [WIDTH - 1: 0] A;
input [3:0] opCode, opCodeExt, amount;
output reg [WIDTH - 1: 0] ShifterOutput;

always@(*)begin 
	
	if(opCode == 4'b1000 && opCodeExt == 4'b0100 && amount[3] == 1)//logical shift right
		ShifterOutput = A >> amount;
	else if(opCode == 4'b1000 && opCodeExt == 4'b0100 && amount[3] == 0)//logical shift left 
		ShifterOutput = A >> amount;
	else if(opCode == 4'b1000 && opCodeExt[0]==0)//logical shift left immediate 
		ShifterOutput = A << amount;
	else if(opCode == 4'b1000 && opCodeExt[0]==1)//logical shift right immediate
		ShifterOutput = A >> amount;
	else if(opCode == 4'b1111)
		ShifterOutput = A << 8;
	else
		ShifterOutput = 16'd0;

end 

endmodule 