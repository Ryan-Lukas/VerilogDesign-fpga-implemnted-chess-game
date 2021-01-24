
//the instruction reg has line by line instruction 32 bits from instruction mem
module instructionreg #(parameter WIDTH = 16)(clk, en, instruction, opcode,rdest, immediate, opcodeex,rsrc);
input clk, en;
input [WIDTH-1:0] instruction;

output [3:0] opcode;
output [3:0] rdest;
output [7:0] immediate;

output reg[3:0] opcodeex;
output reg[4:0] rsrc;

//takes in instruction split up to each section					 				 
register  #(4) opcodereg(clk,en, instruction[15:12], opcode); //opcode reg

register  #(4) rdestreg(clk,en,instruction[11:8],rdest); // destination reg

register  #(8) immreg(clk,en,instruction[7:0],immediate); // immediet reg

always@(immediate)begin
opcodeex = immediate[7:4];
rsrc =immediate[3:0];
end

endmodule

