module muxthree(d,d0,d1,d2,s,y);
		
		input [15:0] d,d0,d1,d2;
		input [1:0] s;
		output [15:0] y;
	
	assign y = s[1] ? (s[0] ? d2 : d1) : (s[0] ? d0 : d); 
endmodule
