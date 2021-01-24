module PCcounter(increment,clk,rst,immwire,displace,adatawire,jal,pccount,oldpc,replace,unconditional);
	input increment,clk,rst,displace,displace,jal,replace,unconditional;
	input [15:0] immwire,adatawire;
	
	output reg[15:0] pccount,oldpc;


always@(posedge rst,posedge clk)begin
	
	
	//active high reset
	if(rst == 1)begin
		pccount <= 16'd0;
		oldpc <= 16'b0;
	end
	//increment 
	else if(increment == 1)begin
		oldpc <= pccount + 1 ;
		pccount <= pccount + 1;

		end
	//jal jump
	else if (jal == 1)begin	
		oldpc <= pccount + 1 ;
		pccount <= adatawire; // might need to be changed to bdatatwire
		end
	//displace jump
	else if(displace == 1 )begin
		oldpc <= pccount + 1 ;
		pccount <= immwire + pccount;

		end
	//replace jump
	else if(replace == 1) begin
		oldpc <= pccount + 1 ;
		pccount <= adatawire; 
end
	//unconditional jump
	else if (unconditional == 1)begin
		oldpc <= pccount + 1 ;
		pccount <= adatawire;

	end
	else begin
		pccount <= pccount;
	end
	
	
	
	
	
	
	
	
	

end

endmodule
