module hexToSevenSeg(en, value, sevenSeg);
input [7:0] value;
output reg [6:0] sevenSeg; 
input en; 

//letters that we will be using
parameter A = 8'h1C, B = 8'h32, C = 8'h21, D = 8'h23, E = 8'h24, F = 8'h2B, G = 8'h34, H = 8'h33, 
one = 8'h16, two = 8'h1E, three = 8'h26, four = 8'h25, five = 8'h2E, six = 8'h36, seven = 8'h3D, eight = 8'h3E;

always@(*)begin 
if(en) begin 
case(value) //check the value and print the correct hex
	A: sevenSeg = 7'b0001000;
	B: sevenSeg = 7'b0000011;
	C: sevenSeg = 7'b1000110;
	D: sevenSeg = 7'b0100001;
	E: sevenSeg = 7'b0000110;
	F: sevenSeg = 7'b0001110;
	G: sevenSeg = 7'b0010000;
	H: sevenSeg = 7'b0001001;
	one: sevenSeg = 7'b1111001;
	two: sevenSeg = 7'b0100100;
	three: sevenSeg = 7'b0110000;
	four: sevenSeg = 7'b0011001;
	five: sevenSeg = 7'b0010010;
	six: sevenSeg = 7'b0000010;
	seven: sevenSeg = 7'b1111000;
	eight: sevenSeg = 7'b0000000;
	default: sevenSeg = 7'b1111111;
endcase 
end
else
	sevenSeg = 7'b1111111;
end 

endmodule 