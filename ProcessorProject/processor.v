module processor(switch, keyData, keyboardclk, clk, reset,r, g, b, vga_hs, vga_vs, vga_clk, vga_blank_n, hex0, hex1, hex2, hex3);
	//top level 
	
	input clk,reset;
	input keyData, keyboardclk;
	input switch;
	output [7:0] r,g,b;
	output vga_hs, vga_vs, vga_clk,vga_blank_n;
	wire [15:0] data,PCcount;
	
	wire bright;
	wire [9:0] hcount, vcount;
	wire [5:0] column, row; 
	wire [5:0] glyphselect;
	wire [15:0] glyph;
	wire [39:0] glyphData, lettervalue,numbervalue;
	wire [2:0] letteraddr,numberaddr;
	output [6:0] hex0, hex1, hex2, hex3;
	wire [15:0] current, destination, userEn; 
	
	//instruction memory
	InstructMem in(.clk(clk),.adr(PCcount),.memdata(data));

	//datapath
	DataPath path(.instructionData(data),.clk(clk),.rst(reset),.PCcount(PCcount),.glyphselect(glyphselect),.glyph(glyph), .current(current), .destination(destination), .userEn(userEn));
	
	//vga controller
	vga_controller U1(.clk(clk), .rst(reset), .bright(bright), .vga_blank_n(vga_blank_n), .vga_clk(vga_clk), .vga_vs(vga_vs), .vga_hs(vga_hs), .hcount(hcount), .vcount(vcount), .column(column), .row(row), .addr(glyphselect), .letteraddr(letteraddr), .numberaddr(numberaddr));
	
	//glyph rom
	GLYPH_ROM2 U2(.piece(glyph),.addr(glyphselect), .row(row), .value(glyphData));
	
	//letter rom
	LETTER_ROM u4(.letteraddr(letteraddr),.row(row),.lettervalue(lettervalue));

	//bitgen
	bitGen2 U3(.bright(bright), .glyphData(glyphData), .r(r), .g(g), .b(b),.hcount(hcount), .vcount(vcount), .counter(column),.lettervalue(lettervalue), .numbervalue(numbervalue));

	//number rom
	NUMBER_ROM u5(.numberaddr(numberaddr),.row(row),.numbervalue(numbervalue));
	
	//keyboard 
	Keyboard u6(.switch(switch),.clk(keyboardclk),.clock(clk), .data(keyData), .hex0(hex0), .hex1(hex1), .hex2(hex2), .hex3(hex3), .current(current), .destination(destination), .userEn(userEn));
	
	endmodule

