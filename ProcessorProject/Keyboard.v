module Keyboard(switch, clk,clock, data, hex0, hex1, hex2, hex3, current, destination, userEn);
input clk, clock;
input data; 
input switch;
wire[7:0] key1out, key2out, key3out, key4out, key1, key2, key3, key4;
wire [7:0] out1, out2, out3, out4; 
wire en, key1en, key2en, key3en, key4en; 
wire enable;
output [6:0] hex0, hex1, hex2, hex3;
output [15:0] current, destination, userEn; 

//gets the keyboard information 
Keyboard_Receiver U1(.clk(clk),.clock(clock), .data(data), .key1out(key1out), .key2out(key2out), .key3out(key3out), .key4out(key4out), .en(en), .key1en(key1en), .key2en(key2en), .key3en(key3en), .key4en(key4en), .userEn(userEn));

//registers to hold the 8 bit key value 
keyRegister U2(.clk(clock), .en(key1en), .d(key1out), .q(key1));
keyRegister U3(.clk(clock), .en(key2en), .d(key2out), .q(key2));
keyRegister U4(.clk(clock), .en(key3en), .d(key3out), .q(key3));
keyRegister U5(.clk(clock), .en(key4en), .d(key4out), .q(key4));



hexToSevenSeg U6(.en(en), .value(key1), .sevenSeg(hex3));//left most hex number
hexToSevenSeg U7(.en(en), .value(key2), .sevenSeg(hex2));//second the left
hexToSevenSeg U8(.en(en), .value(key3), .sevenSeg(hex1));//second from the right 
hexToSevenSeg U9(.en(en), .value(key4), .sevenSeg(hex0));//right most hex number 



//decodes the keys to send to the processor 
keyBoardDecoder U10(.en(en), .key1(key1), .key2(key2), .key3(key3), .key4(key4), .current(current), .destination(destination));




endmodule 