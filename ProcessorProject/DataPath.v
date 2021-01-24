
//top module code for the entire data path
module DataPath #(parameter WIDTH = 16)(instructionData,clk,rst,PCcount,glyphselect,glyph, current, destination, userEn);
	input clk,rst;
	input [WIDTH-1:0] instructionData;
	input [5:0] glyphselect; 
	input [15:0] current, destination, userEn;
	output [15:0] glyph;
	output [15:0]PCcount;
	
	
	wire instructEn,regwrite,aregmux,L,C,Z,N,F,jal,increment,DMemwrite,displace,psreg,concatselect,changevalue,unconditional, replace;
	wire [1:0] busmuxchooser,finalmux;
	wire [3:0]  opcodewire,opcodeexwire  ;
	wire [3:0] rdestwire,rsrcwire,opdecodewire;
	wire [4:0] conditions;
	wire [7:0] immwire;
	wire [15:0] Immwire,adatawire,bdatawire,muxchoice,Aluout,shiftmuxwire,shiftout,dmemout,muxoutputwire,BUS,oldpc,concatvalue,muxchooserwire;
	
	//instruction register
	instructionreg inreg(.clk(clk),.en(instructEn),.instruction(instructionData),.opcode(opcodewire),.rdest(rdestwire),.immediate(immwire),.opcodeex(opcodeexwire),.rsrc(rsrcwire));
   
	SignExtender signex(.B(immwire),.opCode(opcodewire), .SEOutput(Immwire));
	//regfile 
	regfile rfile(.clk(clk),.regwrite(regwrite),.ra1(rsrcwire),.ra2(rdestwire),.wa(rdestwire),.wd(BUS),.rd1(adatawire),.rd2(bdatawire));
	
	//multiplexor
	mux aorimtoalu(.d0(adatawire),.d1(Immwire),.s(aregmux),.y(muxchoice));
	
	//ALU
	ALU a(.A(muxchoice),.B(bdatawire),.opCode(opdecodewire),.L(L),.C(C),.Z(Z),.N(N),.F(F),.AluOutput(Aluout));
	
	psregister regforconditions(.clk(clk), .en(psreg), .d({L,C,Z,N,F}), .q(conditions));
	
	
	//alu controller
	AluControl controlera(.opCode(opcodewire), .opCodeExt(opcodeexwire), .controlOutput(opdecodewire));
	
	
	//multiplexor for the shifter
	mux shift(.d0(bdatawire),.d1(Immwire),.s(shiftmux),.y(shiftmuxwire));
	
	//how to get amount
	Shifter shifter(.A(shiftmuxwire), .amount(1'b1), .opCode(opcodewire), .opCodeExt(opcodeexwire), .ShifterOutput(shiftout));
	
	//increment,clk,rst,immwire,displace,adatawire,jal,pccount,oldpc,replace,jcond,bcond);
	//PC counter
	PCcounter counter(.increment(increment),.clk(clk),.rst(rst),.immwire(Immwire),.displace(displace),.adatawire(adatawire),.jal(jal),.pccount(PCcount),.oldpc(oldpc),.replace(replace),.unconditional(unconditional));
	

	// data memory
	DMem memory(.data(bdatawire),.addr(adatawire),.we(DMemwrite),.clk(clk),.q(dmemout),.glyphselect(glyphselect),.glyph(glyph),.rst(rst), .current(current), .destination(destination), .userEn(userEn));
	
	
	//decoder
	decoder dec(.clk(clk),.rst(rst),.opcode(opcodewire),.opcodeex(opcodeexwire),.conditions(conditions),.bitpattern(rdestwire),.regwrite(regwrite),.instrEn(instructEn),.Aregmux(aregmux),.busmuxchooser(busmuxchooser),.shiftmux(shiftmux),.finalmux(finalmux),.increment(increment),.dmemwrite(DMemwrite),.jal(jal),.psreg(psreg),.displace(displace),.replace(replace),.concatselect(concatselect),.changevalue(changevalue),.unconditional(unconditional));
	
	
	muxthree busMux(.d(adatawire),.d0(dmemout),.d1(Aluout),.d2(concatvalue),.s(busmuxchooser),.y(muxoutputwire));
	

	muxthree intoReg(.d(PCcount),.d0(muxchooserwire),.d1(Immwire),.d2(oldpc),.s(finalmux),.y(BUS));
	
	mux concat(.d0(shiftout),.d1({shiftout[15:8],bdatawire[7:0]}),.s(concatselect),.y(concatvalue));
	
	register busregister(.clk(clk),.en(changevalue),.d(muxoutputwire),.q(muxchooserwire));
	
	

	
endmodule
