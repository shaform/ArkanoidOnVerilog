module draw_back (
	input [10:0] vcounter,
	input [11:0] hcounter,
	input dead, init,
	output reg [3:0] out
);
`include "def.v"
localparam WIDTH = 72;

wire draw;
wire [4:0] x, y;

reg [1:0] kind;

assign x = (hcounter-LEFT)/16;
assign y = (vcounter-TOP)/16;

word stg(.row(y),.col(x),.select(kind),.word(draw));

always @(*)
begin
	if (dead) 
		kind = 2'b01;
	else if (init)
		kind = 2'b00;
	//else if (win)
	//	kind = 2'b11;
	else
		kind = 2'bxx;
end		

always @(*)
begin
	if (vcounter >= TOP && vcounter < MAXY-160 && hcounter >= LEFT && hcounter < LEFT+MAXX )
		if (draw && dead)
			out = 4'b1011;
		else if (draw && init)
			out = 4'b1110;
		//else if (draw && win)
	//		out = 4'b1101;
		else
			out = 4'b0000;
			
	else if ((vcounter >= TOP+MAXY && vcounter < TOP+MAXY+WIDTH) || (vcounter < TOP && vcounter+WIDTH >= TOP)
		|| (hcounter >= LEFT+MAXX && hcounter < LEFT+MAXX+WIDTH) || (hcounter < LEFT && hcounter+WIDTH >= LEFT))
		out = 4'b1111;
	else
		out = 4'b0000;
	

	 
		
end

endmodule
