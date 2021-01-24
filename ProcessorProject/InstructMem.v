module InstructMem #(parameter WIDTH = 16, RAM_ADDR_BITS = 6)
   (input clk,
    input [RAM_ADDR_BITS-1:0] adr,
    output reg [WIDTH-1:0] memdata
    );

   reg [WIDTH-1:0] mips_ram [(2**RAM_ADDR_BITS)-1:0];

 initial

 // The following $readmemh statement is only necessary if you wish
 // to initialize the RAM contents via an external file (use
 // $readmemb for binary data). The fib.dat file is a list of bytes,
 // one per line, starting at address 0.  Note that in order to
 // synthesize correctly, fib.dat must have exactly 256 lines
 // (bytes). If that's the case, then the resulting bitstream will
 // correctly initialize the synthesized block RAM with the data. 
 $readmemh("C:\\Users\\zahid\\OneDrive\\Documents\\CSECE 3710\\Processor\\instructions.dat", mips_ram);

 // This "always" block simulates as a RAM, and synthesizes to a block
 // RAM on the Spartan-3E part. Note that the RAM is clocked. Reading
 // and writing happen on the rising clock edge. This is very important
 // to keep in mind when you're using the RAM in your system! 

    always @(adr)begin 
         memdata <= mips_ram[adr];
		end
		
endmodule
