module psregister #(parameter WIDTH =5)
               (input                  clk, en,
                input      [WIDTH-1:0] d,
                output reg [WIDTH-1:0] q);

   always @(posedge clk)begin
	//register for the flag 
	if (en)
	q <= d;
	else
	q <= q;
	

	
end
	endmodule
	