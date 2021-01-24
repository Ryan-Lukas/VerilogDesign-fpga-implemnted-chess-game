module SignExtender #(parameter WIDTH = 16) (B,opCode, SEOutput);
input [7:0] B;
input [3:0] opCode;
output reg [WIDTH -1:0] SEOutput;

always@(*)begin
	if(opCode == 0101 || opCode == 0110 || opCode == 1110|| opCode == 1001 || opCode == 1011) begin 
		if(B[7] == 1)
			SEOutput = {8'b11111111, B}; //sign extend bottom 8 bits with 1's
		if(B[7] == 0)
			SEOutput = {8'b00000000, B}; //sign extend bottom 8 bits with 0's
	end 
	else begin 
		SEOutput = {8'b00000000, B};
	end

end 

endmodule 