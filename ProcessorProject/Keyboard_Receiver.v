module Keyboard_Receiver(clk,clock, data, key1out, key2out, key3out, key4out, en, key1en,key2en,key3en, key4en, userEn);
input clk, clock;
input data; 
output reg [7:0] key1out, key2out, key3out, key4out;
output reg en, key1en, key2en, key3en, key4en;  
output reg [15:0] userEn;
reg [7:0] data_curr, data_pre;
reg [3:0] b; 
reg [2:0] count; 
reg flag; 



initial begin 
b = 4'd1;
data_curr = 8'd0;
data_enter = 8'd0;
data_pre = 8'd0;
flag = 0; 
count = 0; 
end 

always@(negedge clk)
	begin 
		case(b)//get the 1 bit value on every negedge of the clock 
			1:;
			2:begin 
				data_curr[0] <= data;
			end 
			3:begin 
				data_curr[1] <= data;
			end 
			4:begin 
				data_curr[2] <= data;
			end 
			5:begin 
				data_curr[3] <= data;
			end 
			6:begin 
				data_curr[4] <= data;
			end 
			7:begin 
				data_curr[5] <= data;
			end 
			8:begin 
				data_curr[6] <= data;
			end 
			9:begin 
				data_curr[7] <= data;
			end 
			10: begin 
				flag <= 1;
			end
			11: flag <= 0;

			
		endcase 
		if(b<=10)
			b <= b+1; 
		else if(b==11)
			b <= 1;
	end

	always@(posedge flag )begin 
		if(data_curr == 8'hF0 && count == 0)begin //get first key 
			en = 0; 
			key1out = data_pre;
			key1en = 1; 
			count = count + 1;
			userEn = 16'd0;
			end 
		else if(data_curr == 8'hF0 && count == 1)begin //get second key 
			en = 0; 
			key2out = data_pre;
			key2en = 1; 
			count = count + 1; 
			userEn = 16'd0;
		end 
		else if(data_curr == 8'hF0 && count == 2)begin//get third key 
			en = 0; 
			key3out = data_pre;
			key3en = 1; 
			count = count + 1;
			userEn = 16'd0;
		end 
		else if(data_curr == 8'hF0 && count == 3)begin //get the last key to enable the move 
			key4out = data_pre;
			key4en = 1; 
			userEn = 16'd1;
			en = 1;
		end 
		else if(data_curr == 8'h66)begin //if backspace then clear everything 
			key1out = 8'd0; 
			key3out = 8'd0; 
			key4out = 8'd0; 
			key2out = 8'd0;
			key1en = 1; 
			key2en = 1; 
			key3en = 1; 
			key4en = 1; 
			count = 0; 
			en=0;
			userEn = 16'd0;
		end 
		else begin 
			data_pre = data_curr;
			userEn = 16'd0;
		end 
	end 

endmodule 