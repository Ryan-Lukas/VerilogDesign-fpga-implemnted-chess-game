
module bitGen2(bright,glyphData,counter,  g, b, r, hcount, vcount,lettervalue,numbervalue); // bitGen 1 that colors the whole screen depending on 8 switches colors

input bright; 
input [9:0] hcount, vcount;
input [39:0] glyphData;
input [0:39] lettervalue,numbervalue;
input [5:0] counter; 

reg [39:0]value;
 
output reg [7:0] r, g, b; // for red, green, blue

	//always block to determine where we are within the vga by hcount and vcount
	always@(*) begin 
		if(bright == 1) begin // start coloring when bright is on
			//glyph building
			if((hcount >= 320) && (hcount < 640) && (vcount >= 80) && (vcount < 400))begin
				//if glyph number is 1 then white
				if(glyphData[counter] == 1)begin 
				r = 8'd255;
				g = 8'd255;
				b = 8'd255;
			
					end 
				else if(glyphData[counter] == 0)begin 
						r = 8'd0;
						g = 8'd0;
						b = 8'd0;
					end 
				else begin 
						r = 8'd0;
						g = 8'd0;
						b = 8'd0;
					end
			end
			//building letters
			else if(((hcount >= 320 && hcount < 640) && (vcount >= 40 && vcount < 80)))begin //top section for letters
					if(lettervalue[counter] == 1)begin
						r = 8'd255;
						g = 8'd255;
						b = 8'd255;
					end
					else if(lettervalue[counter] == 0) begin
						r = 8'd75;
						g = 8'd25;
						b = 8'd0;
					end
					else begin 
						r = 8'd0;
						g = 8'd0;
						b = 8'd0;
					
					end 

				end
			//building numbers
			else if ((hcount >= 280 && hcount < 320 ) && (vcount >= 80 && vcount < 400))begin
					if(numbervalue[counter] == 1)begin
						r = 8'd255;
						g = 8'd255;
						b = 8'd255;
					end
					else if(numbervalue[counter] == 0) begin
						r = 8'd75;
						g = 8'd25;
						b = 8'd0;
					
					end
					else begin 
						r = 8'd0;
						g = 8'd0;
						b = 8'd0;
					
			
					end
			end
			//building boarder around chest board
			else if((hcount >= 280 && hcount < 320 && vcount >= 40 && vcount < 80) ||
				((hcount >= 280) && (hcount < 680) &&(vcount >= 400) && (vcount < 440))||
				((hcount >= 640) && (hcount < 680) && (vcount >= 40) && (vcount < 440)) )begin
					r = 8'd75;
						g = 8'd25;
						b = 8'd0;
			end
			else begin 
				r = 8'd0;
				g = 8'd0;
				b = 8'd0;
			end 
		end
		else begin
			r = 8'd0;
			g = 8'd0;
			b = 8'd0;	
			end
	end
	
endmodule 