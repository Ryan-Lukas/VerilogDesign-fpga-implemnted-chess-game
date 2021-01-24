 module decoder(clk,rst,opcode,opcodeex,conditions,bitpattern,regwrite,instrEn,Aregmux,busmuxchooser,shiftmux,finalmux,increment,dmemwrite,jal,psreg, displace,replace,concatselect,changevalue,unconditional);
	input clk,rst;
	input [3:0] opcode,opcodeex,bitpattern;
	input [4:0] conditions;
	output reg regwrite,instrEn,Aregmux,shiftmux,increment,dmemwrite,jal,displace,psreg,replace,concatselect,changevalue,unconditional;
	output reg [1:0] finalmux,busmuxchooser;
	
	//states for the different instructions 
	parameter Fetch = 5'b00001;
	parameter Decode = 5'b00010;
	parameter ALUi = 5'b00011;
	parameter ALUWRITE1 = 5'b00100;
	parameter WRITE = 5'b00101;
	parameter LSHIMUX = 5'b00110;
	parameter LSHFINAL = 5'b00111;
	parameter LUISHIFT = 5'b01000;
	parameter LOADMUX = 5'b01001;
	parameter STOREWRITE = 5'b01010;
	parameter BRANCHCOND = 5'b01011;
	parameter SHIFTOPEX = 5'b01100;
	parameter JALWRITE = 5'b01101;
	parameter JCONDWRITE = 5'b01110;
	parameter BCONDDISPLACE = 5'b01111;
	parameter MOVIWRITE = 5'b10000;
	parameter INCREMENT = 5'b10001;
	parameter MOV = 5'b10010;
	parameter MOVWRITE = 5'b10011;
	parameter DECODE2 = 5'b10100;
	parameter ALUicmp = 5'b10101;
	parameter ALUifinal = 5'b10110;
	parameter ALUWRITE1final = 5'b10111;
	parameter WRITEFINAL = 5'b11000;
	parameter LSHIMUXfinal = 5'b11001;
	parameter LSHfinal2 = 5'b11010;
	parameter LUISHIFTfinal = 5'b11011;
	parameter LOADMUXfinal = 5'b11100;
	parameter MOVWRITEfinal = 5'b11101;
	
	parameter MOVEORALU = 4'b0000;
	
	
	parameter  ADDI = 4'b0101;
	parameter ADDUI = 4'b0110;
	parameter SUBI = 4'b1001;
	parameter CMPI = 4'b1011;
	parameter ANDI = 4'b0001;
	parameter ORI = 4'b0010;
	parameter XORI = 4'b0011;
	parameter SHIFTERS = 4'b1000;
	parameter MOVI = 4'b1101;
	parameter LUI = 4'b1111;
	parameter BRANCHES = 4'b0100;
	parameter BCOND = 4'b1100;
	parameter LSH = 4'b0100;
	parameter LSHI = 4'b000x;
	parameter JAL = 4'b1000;
	parameter JCOND = 4'b1100;
	parameter STORE = 4'b0100;
	parameter LOAD = 4'b0000;
	parameter MOVE = 4'b1101;
	 
		parameter EQ = 4'b0000, NE =4'b0001, GE= 4'b1101, GT = 4'b0110, LE = 4'b0111, LT = 4'b1100, UNCOND = 4'b1110;
	
reg [4:0] state,nextstate;

//fetch next state
always@(posedge clk, posedge rst)begin
	if(rst == 1) state <= Fetch;
      else state <= nextstate;

end

//next state after current state
always@(*)begin
	case(state)
		Fetch: nextstate <= Decode;
		
		//opcode chooses next state
		Decode:	case(opcode)
			MOVEORALU: nextstate <= DECODE2;
			ORI: nextstate <= ALUi;
			XORI: nextstate <= ALUi;
			BRANCHES: nextstate <= BRANCHCOND;
			ADDI: nextstate <= ALUi;
			ADDUI: nextstate <= ALUi;
			SHIFTERS: nextstate <= SHIFTOPEX;
			SUBI: nextstate <= ALUi;
			CMPI: nextstate <= ALUicmp;
			BCOND: nextstate <= BCONDDISPLACE;
			MOVI: nextstate <= MOVIWRITE;
			LUI: nextstate <= LUISHIFT;
			ANDI: nextstate <= ALUi;
			
			default: nextstate <= Fetch;
		endcase
		
		
		
		
	
		
		
		ALUi: nextstate <= ALUifinal;
		
		ALUifinal: nextstate <= INCREMENT;
		
		ALUWRITE1: nextstate <= ALUWRITE1final;
		
		ALUWRITE1final: nextstate <= INCREMENT;
		
		WRITE: nextstate <= WRITEFINAL;
		
		WRITEFINAL: nextstate <= INCREMENT;
		
		SHIFTOPEX: begin
			case(opcodeex)
			LSH: nextstate <= LSHFINAL;
			LSHI: nextstate <= LSHIMUX;
			
			default: nextstate <= Fetch;
		endcase
		end
		
		LSHFINAL: nextstate <= LSHfinal2;
		
		LSHfinal2: nextstate <= INCREMENT;
		
		LSHIMUX: nextstate <= LSHIMUXfinal;
		
		LSHIMUXfinal: nextstate <= INCREMENT;
		
		LUISHIFT: nextstate <= LUISHIFTfinal;
		
		LUISHIFTfinal: nextstate <= INCREMENT;
		
		//bcondition next state from opcode ex
		BRANCHCOND: case (opcodeex)
			LOAD: nextstate <= LOADMUX;
			STORE: nextstate <= STOREWRITE;
			JAL: nextstate <= JALWRITE;
			JCOND: nextstate <= JCONDWRITE;
			
			default: nextstate <= Fetch;
		endcase
		
		LOADMUX: nextstate <= LOADMUXfinal;
		
		LOADMUXfinal: nextstate <= INCREMENT;
		
		STOREWRITE: nextstate <= INCREMENT;
		
		JALWRITE: nextstate <= INCREMENT;
		
		JCONDWRITE: nextstate <= INCREMENT;
		
		BCONDDISPLACE: nextstate <= INCREMENT;
		
		MOVIWRITE: nextstate <= INCREMENT;	
			
		INCREMENT: nextstate <= Fetch;
		

		//decode 2 state for the specific move operation
		DECODE2: case(opcodeex)
			4'b0000: nextstate <= INCREMENT;
			MOVE: nextstate <= MOVWRITE;
			default: nextstate <= ALUWRITE1;
		endcase 
		
		MOVWRITE: nextstate <= MOVWRITEfinal;
		
		MOVWRITEfinal: nextstate <= INCREMENT;
		
		ALUicmp: nextstate <= INCREMENT;
		
		default: nextstate <= Fetch;
		
		
	endcase
end

//control line activation
always@(*)begin 
	regwrite <= 0;
	instrEn <= 0;
	Aregmux <= 0;
	shiftmux <= 0;
	increment <= 0;
	dmemwrite <= 0;
	jal <=0;
	displace <=0;
	finalmux <= 2'b00;
	busmuxchooser <= 2'b00;
	psreg <= 0;
	replace <= 0;
	concatselect <= 0;
	changevalue <= 0;
	unconditional <= 0;
	//check the state and set the correct signal 
	case(state)
		Fetch: instrEn <= 1;
		
		Decode: begin 
		end
		
		
		ALUi:begin
		changevalue <= 1;
		Aregmux <= 1;
		busmuxchooser <= 2'b10;
		end
		
		ALUifinal:begin	
		finalmux <= 2'b01;
		regwrite <= 1;
		end

		ALUWRITE1:begin
		busmuxchooser <= 2'b10;
		changevalue <= 1;
		end
		
		ALUWRITE1final: begin
		
		finalmux <= 2'b01;
		regwrite <= 1;
		
		end
		
		WRITE:begin
			changevalue <= 1;
		end
		
		WRITEFINAL:begin
		finalmux <= 2'b01;
		regwrite <= 1;
		end
		
		LSHIMUX: begin
		changevalue <= 1;
		shiftmux <= 1;
		busmuxchooser <= 2'b11;
		end
		
		LSHIMUXfinal:begin
		finalmux <= 2'b01;
		regwrite <= 1;
		end
		
		LSHFINAL:begin
			busmuxchooser <= 2'b11;
			changevalue <= 1;
		end
		
		LSHfinal2:begin
			finalmux <= 2'b01;
			regwrite <= 1;	
		end
		

		
		LUISHIFT: begin
		shiftmux <= 1;
		busmuxchooser <= 2'b11;
		concatselect <= 1;
		changevalue <= 1;
		end
		
		LUISHIFTfinal: begin
		finalmux <= 2'b01;
		regwrite <= 1;
		end
		
		LOADMUX: begin
		busmuxchooser <= 2'b01;
		changevalue <= 1;
		end
		
		LOADMUXfinal: begin
		finalmux <= 2'b01;
		regwrite <= 1;
		end
		
		
		STOREWRITE: dmemwrite <= 1;
		
		JALWRITE: begin
			jal <= 1;
			regwrite <= 1;
			finalmux <= 2'b11;
		end
		
		//condition check from alu for the specific jump operation 
		JCONDWRITE: begin
			case(bitpattern)
		
			EQ:begin	
				if(conditions[2])
					replace <= 1;
			end
			
			NE:begin
			
				if(conditions[2] == 0)
					replace <= 1;
			
			end
			
			GE:begin
			
				if(conditions[2] || conditions[1])
					replace <= 1;
			
			end
			
			GT:begin
			
				if(conditions[1])
					replace <= 1;
			
			end
			
			LE:begin
			
				if(conditions[1] == 0)
					replace <= 1;
			
			end
			
			LT:begin
			
				if(conditions[1] == 0 && conditions[2] == 0)
					replace <= 1;
			
			end
			
			UNCOND:begin
				unconditional <= 1;
			
			end
			
		
		
		default: begin
		replace <= 0;
		displace <= 0;
		end
	
	endcase
		
		end
		
		//condition check from alu
		BCONDDISPLACE: begin
		case(bitpattern)
		
		EQ:begin
				if(conditions[2])
					displace <= 1;
			end
			
		NE:begin
			
				if(conditions[2])
					displace <= 1;
			
		end
			
		GE:begin
				if(conditions[2] || conditions[1])
					displace <= 1;
			end
			
		GT:begin
				if(conditions[1])
					displace <= 1;

			end
			
		LE:begin
			if(conditions[1] == 0)
					displace <= 1;

			end
			
		LT:begin
			
				if(conditions[1] == 0 && conditions[2] == 0)
					displace <= 1;
			
			end
			
		UNCOND:begin
			unconditional <= 1;
		
		end
			
		
		
		default: begin
		replace <= 0;
		displace <= 0;
		end
	
		endcase
		
		end
		
		MOVIWRITE:begin
			finalmux <= 2'b10;
			regwrite <= 1;
		end
		
		INCREMENT: increment <= 1;
		
		MOVWRITE: begin
			changevalue <= 1;

		end
		
		MOVWRITEfinal:begin
			finalmux <= 2'b01;
			regwrite <= 1;
		end
		
		ALUicmp: begin
		Aregmux <= 1;
		psreg <= 1;
		end
		
		
	endcase
	
	

end
	
endmodule
