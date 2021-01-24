VerilogDesign-chess-game
==============

Ryan Lukas

ECE 3700 - Digital System Design - Spring 2019

*Verilog*

Background
------------

Designed and modeled CPU architecture within a FPGA using Verilog to implement a modern digital chess game. We used MIPS assembly language and an assembler to convert the MIPS instructions for verilog to comprehend.

Best Contribution
------------

With over 50 different glyphs that the CPU should choose from to be presented, we had to come up with a way to easily select which glyph is needed where ever the horizontal and vertical count is while the VGA is updating the screen. Within this, I've created a way that uses modulous to easily select while glyph is needed without using over a few hundred if statements. Below is the given code that I worked on and was going over a way to possibly use this code universally with glyph selection.

```
always@* begin 
		letteraddr = 0; 
		addr = 0;
		column = 0;
		row = 0;
		numberaddr = 0;
		if((hcount >= 30) && (hcount <= 680) && (vcount >= 40) && (vcount <= 440)) begin // the pixels for to fill the screen
			vga_blank_n = 1;
			bright =1; // when the bright signal is on, color
			
			//modulous for row and column
			row = vcount % 40;
			column = hcount % 40;
			
			// getting letter, number and glyph address
			letteraddr = ((hcount%320)/40);
			numberaddr = ((vcount/40)-2);
			if( addr > 63)
				addr = 0;
			else
				addr = ((hcount % 320) / 40) + ((vcount / 40)-2)*8;
	
		end

		else begin 
			vga_blank_n = 0;
			bright=0; // when the bright signal is 0 >> dark mode
			
		end
	end

```

