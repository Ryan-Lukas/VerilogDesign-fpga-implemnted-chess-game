// Quartus Prime Verilog Template
// Single port RAM with single read/write address 

module DMem 
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=8)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr,
	input [15:0] current, destination, userEn,
	input we, clk,rst, 
	input [5:0]glyphselect,
	output [15:0] glyph,
	output [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];


	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_reg;
	reg[5:0] addr_gl_reg;


initial
//initial read of building chest board
$readmemh("C:\\Users\\zahid\\OneDrive\\Documents\\CSECE 3710\\Processor\\glyphmem2.dat", ram);
	

	always @ (posedge clk)
	begin
		if(rst == 1)begin
			//reset chest board
			$readmemh("C:\\Users\\zahid\\OneDrive\\Documents\\CSECE 3710\\Processor\\glyphmem2.dat", ram);
		end
		// Write
	 if (we)
			ram[addr] <= data;
	
	
	ram[8'd255] <= current; 
	ram[8'd254] <= destination; 
	ram[8'd253] <= userEn;	
	
	
		addr_reg <= addr;
		addr_gl_reg <= glyphselect;
	end

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
//	// blocks in Single Port mode.  
//	
//	
	assign q = ram[addr_reg];
	assign glyph = ram[{2'd0, glyphselect}];

endmodule
