module vga_controller(clk, rst, vga_hs, vga_vs, vga_clk, bright, vga_blank_n, hcount,vcount, row, column, addr, letteraddr,numberaddr); // VGA controller 

	input clk, rst;
	output vga_hs, vga_vs;
	
	output reg vga_clk, vga_blank_n, bright; 
	
	output reg [9:0] hcount;
	output reg [9:0] vcount;
	output reg [5:0] addr; 
	output reg [2:0] letteraddr,numberaddr;
	output reg [5:0] column, row; 
	reg counter;
	
	// the values for the front, back porch of the horizantal and the vertical 
	
	parameter hs_start = 16;
	parameter hs_sync = 96;
	parameter hs_end = 48;
	parameter hs_total = 800;
	
	parameter vs_init = 480; //start of v location before the rest 
	parameter vs_start = 10;
	parameter vs_sync = 2;
	parameter vs_end = 33;
	parameter vs_total = 525;
	
	always@(posedge clk) begin
	
		if(rst == 1) begin // resetting all the counters when reset is low
			hcount <= 0;
			vcount <= 0;
			vga_clk <= 0;
			counter <= 0;
		end
		
		else if(counter == 1) begin // counter start
			hcount <= hcount + 1;
			 
			if(hcount == hs_total) begin // when the counter reaches the edge of the horizantal edge
				hcount <= 0;
				vcount <= vcount + 1; // increment the vertical when we reach the edge of the horizantal
				if(vcount == vs_total) 
				vcount <= 0; // reset vertical to 0 when we are done all the way down
			end
		end
		
		counter <= counter + 1;
		vga_clk <= ~vga_clk; // invert the 25 MHz clk
		
	end
	
	//setting the signals for the vertical and horizantal
	
	assign vga_hs = ~((hcount >= hs_start) & (hcount <hs_start+hs_sync)); 
	assign vga_vs = ~((vcount >= vs_init+vs_start) & (vcount < vs_init+vs_start+vs_sync));
	
	reg en;
	
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
	

endmodule 
