module keyBoardDecoder(en, key1, key2, key3, key4, current, destination);
input [7:0] key1, key2, key3, key4; 
input en; 
output reg [15:0] current, destination;


parameter A = 8'h1C, B = 8'h32, C = 8'h21, D = 8'h23, E = 8'h24, F = 8'h2B, G = 8'h34, H = 8'h33, 
one = 8'h16, two = 8'h1E, three = 8'h26, four = 8'h25, five = 8'h2E, six = 8'h36, seven = 8'h3D, eight = 8'h3E;
always@(*)begin
	if(en)begin 
		case(key1)
			A:begin
				case(key2)
				one: current = 16'd56;
				two: current = 16'd48;
				three:current= 16'd40;
				four: current= 16'd32;
				five: current= 16'd24;
				six: current= 	16'd16;
				seven:current= 16'd8;
				eight:current= 16'd0;
				default: current = 16'd64;
				endcase 
			end 
			B:begin 
				case(key2)
				one: current = 	16'd57;
				two: current = 	16'd49;
				three: current = 	16'd41;
				four: current = 	16'd33;
				five: current = 	16'd25;
				six: current = 	16'd17;
				seven: current = 	16'd9;
				eight: current = 	16'd1;
				default: current = 16'd64;
				endcase 
			
			end
			C: begin 
				case(key2)
				one: current = 	16'd58;
				two: current = 	16'd50;
				three: current =	16'd42;
				four: current = 	16'd34;
				five: current = 	16'd26;
				six: current = 	16'd18;
				seven: current = 	16'd10;
				eight: current = 	16'd2;
				default: current = 16'd64;
				endcase 
			
			end
			D: begin 
				case(key2)
				one: current = 	16'd59;
				two: current = 	16'd51;
				three: current = 	16'd43;
				four: current = 	16'd35;
				five: current = 	16'd27;
				six: current = 	16'd19;
				seven: current = 	16'd11;
				eight: current = 	16'd3;
				default: current = 16'd64;
				endcase 
			
			end
			E: begin 
				case(key2)
				one: current = 	16'd60;
				two: current = 	16'd52;
				three: current = 	16'd44;
				four: current = 	16'd36;
				five: current = 	16'd28;
				six: current = 	16'd20;
				seven: current = 	16'd12;
				eight: current = 	16'd4;
				default: current = 16'd64;
				endcase 
			
			end 
			F: begin 
				case(key2)
				one: current = 	16'd61;
				two: current = 	16'd53;
				three: current = 	16'd45;
				four: current = 	16'd37;
				five: current = 	16'd29;
				six: current = 	16'd21;
				seven: current = 	16'd13;
				eight: current = 	16'd5;
				default: current = 16'd64;
				endcase 
			
			end 
			G: begin 
				case(key2)
				one: current = 	16'd62;
				two: current = 	16'd54;
				three: current = 	16'd46;
				four: current = 	16'd38;
				five: current = 	16'd30;
				six: current = 	16'd22;
				seven: current = 	16'd14;
				eight: current = 	16'd6;
				default: current = 16'd64;
				endcase 
			
			end 
			H:begin 
				case(key2)
				one: current = 	16'd63;
				two: current = 	16'd55;
				three: current = 	16'd47;
				four: current = 	16'd39;
				five: current = 	16'd31;
				six: current = 	16'd23;
				seven: current = 	16'd15;
				eight: current = 	16'd7;
				default: current = 16'd64;
				endcase 
			end 
			default: current = 16'd64; 
			endcase 
	end
	else current = 16'd64;
end 

always@(*)begin
	if(en)begin 
		case(key3)
			A:begin
				case(key4)
				one: destination = 	16'd56;
				two: destination = 	16'd48;
				three: destination = 16'd40;
				four: destination = 	16'd32;
				five: destination = 	16'd24;
				six: destination = 	16'd16;
				seven: destination = 16'd8;
				eight: destination = 16'd64;
				default: destination = 16'd64;
				endcase 
			end 
			B:begin 
				case(key4)
				one: destination = 	16'd57;
				two: destination = 	16'd49;
				three: destination = 16'd41;
				four: destination = 	16'd33;
				five: destination = 	16'd25;
				six: destination = 	16'd17;
				seven: destination = 16'd9;
				eight: destination = 16'd1;
				default: destination = 16'd64;
				endcase 
			
			end
			C: begin 
				case(key4)
				one: destination = 	16'd58;
				two: destination = 	16'd50;
				three: destination = 16'd42;
				four: destination = 	16'd34;
				five: destination = 	16'd26;
				six: destination = 	16'd18;
				seven: destination = 16'd10;
				eight: destination = 16'd2;
				default: destination = 16'd64;
				endcase 
			
			end
			D: begin 
				case(key4)
				one: destination = 	16'd59;
				two: destination = 	16'd51;
				three: destination = 16'd43;
				four: destination = 	16'd35;
				five: destination = 	16'd27;
				six: destination = 	16'd19;
				seven: destination = 16'd11;
				eight: destination = 16'd3;
				default: destination = 16'd64;
				endcase 
			
			end
			E: begin 
				case(key4)
				one: destination = 	16'd60;
				two: destination = 	16'd52;
				three: destination = 16'd44;
				four: destination = 	16'd36;
				five: destination = 	16'd28;
				six: destination = 	16'd20;
				seven: destination = 16'd12;
				eight: destination = 16'd4;
				default: destination = 16'd64;
				endcase 
			
			end 
			F: begin 
				case(key4)
				one: destination = 	16'd61;
				two: destination = 	16'd53;
				three: destination = 16'd45;
				four: destination = 	16'd37;
				five: destination = 	16'd29;
				six: destination = 	16'd21;
				seven: destination = 16'd13;
				eight: destination = 16'd5;
				default: destination = 16'd64;
				endcase 
			
			end 
			G: begin 
				case(key4)
				one: destination = 	16'd62;
				two: destination = 	16'd54;
				three: destination = 16'd46;
				four: destination = 	16'd38;
				five: destination = 	16'd30;
				six: destination = 	16'd22;
				seven: destination = 16'd14;
				eight: destination = 16'd6;
				default: destination = 16'd64;
				endcase 
			
			end 
			H:begin 
				case(key4)
				one: destination = 	16'd63;
				two: destination = 	16'd55;
				three: destination = 16'd47;
				four: destination = 	16'd39;
				five: destination = 	16'd31;
				six: destination = 	16'd23;
				seven: destination = 16'd15;
				eight: destination = 16'd7;
				default: destination = 16'd64;
				endcase 
			end 
			default: destination = 16'd64; 
			endcase 
	end
	else destination = 16'd64;
end 

endmodule 