module AluControl(opCode, opCodeExt, controlOutput);
input [3:0]opCode, opCodeExt;
output reg [4:0] controlOutput;


always @(*)begin 
	controlOutput = 5'b00000;
	if(opCode == 4'b0000 && opCodeExt == 4'b0101)//if it is add
		controlOutput = 5'b00000;
	else if(opCode == 4'b0101)//if it is addi
		controlOutput = 5'b00001;
	else if(opCode == 4'b0000 && opCodeExt == 4'b0110)//if it is addu
		controlOutput = 5'b00010;
	else if(opCode == 4'b0110)//if it is addui
		controlOutput = 5'b00011;
	else if(opCode == 4'b0000 && opCodeExt == 4'b1110)//if it is mul
		controlOutput = 5'b00100;
	else if(opCode == 4'b0000 && opCodeExt == 4'b1001)//if it is sub
		controlOutput = 5'b00101;
	else if(opCode == 4'b1001)//if it is subi
		controlOutput = 5'b00110;
	else if(opCode == 4'b0000 && opCodeExt == 4'b1011)//if it is cmp
		controlOutput = 5'b00111;
	else if(opCode == 4'b1011)//if it is cmpi
		controlOutput = 5'b01000;
	else if(opCode == 4'b0000 && opCodeExt == 4'b0001)//if it is and
		controlOutput = 5'b01001;
	else if(opCode == 4'b0001)//if it is andi
		controlOutput = 5'b01010;
	else if(opCode == 4'b0000 && opCodeExt == 4'b0010)//if it is or
		controlOutput = 5'b01011;
	else if(opCode == 4'b0010)//if it is ori
		controlOutput = 5'b01100;
	else if(opCode == 4'b0000 && opCodeExt == 4'b0011)//if it is xor
		controlOutput = 5'b01101;
	else if(opCode == 4'b0011)//if it is xori
		controlOutput = 5'b01110;

end


endmodule 