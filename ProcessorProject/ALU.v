
// from the regfile, the alu takes care of the arithmetic and logical operations
	module ALU #(parameter WIDTH = 16) (A, B, opCode, L, C, Z, N, F, AluOutput); // 19 operations 
	
	input [WIDTH-1:0] A,B;
	
	input [3:0] opCode;
	
	
	reg [WIDTH:0] result; 
	
	output reg [WIDTH-1:0] AluOutput; 
	output reg L,C, Z, N, F; //Co is our carry flag 
	
	parameter[4:0] ADD = 5'b00000, ADDI = 5'b00001, ADDU = 5'b00010, ADDUI = 5'b00011, MUL = 5'b00100, SUB = 5'b00101, SUBI = 5'b00110, 
	CMP = 5'b00111, CMPI = 5'b01000, AND = 5'b01001, ANDI = 5'b01010, OR = 5'b01011, ORI = 5'b01100, XOR = 5'b01101, XORI = 5'b01110; 
	
	always @ (*) begin 
	
	AluOutput = 16'd0; // setting up the output 0 to start off to avoid inverted latches. 
	L=0;
	C=0;
	Z=0;
	N=0;
	F=0;
	result=17'd0;
	
	case(opCode) 
	
	ADD: begin 
	result = A + B;
	AluOutput = result[15:0];
	if(result[WIDTH] == 1'b1)//check for overflow 
		C = 1'b1;
	else 
		C = 1'b0;
	if(A[15] == 1'b1 && B[15] == 1'b1 && AluOutput[15] == 1'b0)
		F = 1'b1;
	else if(A[15] == 1'b0 && B[15] == 1'b0 && AluOutput[15] == 1'b1)
		F = 1'b1;
	else 
		F = 1'b0;
	end
	
	ADDI: begin 
	result = B + A;
	AluOutput = result[15:0];
	if(result[WIDTH] == 1'b1)
		C = 1'b1;
	else 
	C = 1'b0;
	if(A[15] == 1'b1 && B[15] == 1'b1 && AluOutput[15] == 1'b0)//check for overflow 
		F = 1'b1;
	else if(A[15] == 1'b0 && B[15] == 1'b0 && AluOutput[15] == 1'b1)//check for over flow 
		F = 1'b1;
	else 
		F = 1'b0;
	end
	
	ADDU: begin 
	result = A + B;
	AluOutput = result[15:0];
	if(result[WIDTH] == 1'b1)//check for a carry 
		C = 1'b1;
	else 
		C = 1'b0;
	end
	
	ADDUI: begin 

	result = B + A;
	AluOutput = result[15:0];
	if(result[WIDTH] == 1'b1)//check for carry 
		C = 1'b1;
	else 
		C = 1'b0;
	end
	
	MUL: begin 
	AluOutput = A * B;
	end
	
	SUB:begin 
	result = A - B;
	AluOutput = result[15:0];
	if(result[WIDTH] == 1'b1)//check for carry 
		C = 1'b1;
	else 
		C = 1'b0;
	if(A[15] == 1'b0 && B[15] == 1'b1 && AluOutput[15] == 1'b1)//check for overflow 
		F = 1'b1;
	else if(A[15] == 1'b1 && B[15] == 1'b0 && AluOutput[15] == 1'b0)//check for overflow 
		F = 1'b1;
	else 
		F = 1'b0;
	end
	
	SUBI:begin 

	result = B-A;
	AluOutput = result[15:0];
	if(result[WIDTH] == 1'b1)//check for carry 
		C = 1'b1;
	else 
		C = 1'b0;
	if(A[15] == 1'b0 && B[15] == 1'b1 && AluOutput[15] == 1'b1)//check for overflow
		F = 1'b1;
	else if(A[15] == 1'b1 && B[15] == 1'b0 && AluOutput[15] == 1'b0)//check for overflow 
		F = 1'b1;
	else 
		F = 1'b0;
	end
	
	CMP:begin 
	if(A==B)//check if equal
		Z=1'b1;
	else if(A<B)//check if less than 
		L = 1'b1;
	else if(A>B)
		L= 1'b0;
	if(A[15] == 1'b1 && B[15] == 1'b0)//check if is not less than 
		N = 1'b1;
	else if(A[15] == 1'b0 && B[15] == 1'b1)//check if it is not less than 
		N = 1'b0;
	else if(A[15] == B[15])begin 
			if(A<B)
				N = 1'b1;
			else if(A>B)
				N= 1'b0;
		end 
	end
	
	CMPI:begin 
	if(A==B)//check if equal
		Z=1'b1;
	else if(A>B)//check if greater 
		L = 1'b1;
	else if(A<B)//check if less tahn 
		L= 1'b0;
	if(A[15] == 1'b1 && B[15] == 1'b0)//check for the neg flag 
		N = 1'b1;
	else if(A[15] == 1'b0 && B[15] == 1'b1)//check for the neg flag 
		N = 1'b0;
	else if(A[15] == B[15])begin 
			if(A<B)
				N = 1'b1;
			else if(A>B)
				N= 1'b0;
		end 
	end
	

	
	AND:begin 
	AluOutput = A&B;
	end
	
	ANDI:begin 

	AluOutput = A&B;
	end
	
	OR:begin 
	AluOutput = A|B;
	end
	
	ORI:begin

	AluOutput = A|B;
	end
	
	XOR:begin 
	AluOutput = A^B;
	end
	
	XORI:begin 

	AluOutput = A^B;
	end
	
	
	default:begin 
	AluOutput = 16'd0; // setting up the output 0 to start off to avoid inverted latches. 
	L=0;
	C=0;
	Z=0;
	N=0;
	F=0;
	result=17'd0;
	end 
	
	endcase 
	
	end 
	
	endmodule 