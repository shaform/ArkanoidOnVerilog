module draw_back (
	input [10:0] vcounter,
	input [11:0] hcounter,
	input dead, init, win,
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
	else if (win)
		kind = 2'b11;
	else
		kind = 2'bxx;
end		

always @(*)
begin
	if (vcounter >= TOP && vcounter < MAXY-160 && hcounter >= LEFT && hcounter < LEFT+MAXX )
		if (draw && dead && vcounter >= TOP && vcounter < 112)
			out = 4'b1011;
		else if (draw && dead && vcounter >= 112 && vcounter <= 223)
			out = 4'b1100;
		else if (draw && dead && vcounter > 223 && vcounter < MAXY-160)
			out = 4'b1010;
		else if (draw && init && hcounter >= LEFT+80 && hcounter < LEFT-80+MAXX && vcounter >= 112 && vcounter <= 112+32)
			out = 4'b1100;
		else if (draw && init && vcounter >= TOP && vcounter <= 180)
			out = 4'b1110;
		else if (draw && init && vcounter > 180 && vcounter < MAXY-160)
			out = 4'b1100;
		else if (draw && win && hcounter >= LEFT && hcounter < LEFT+224 && vcounter >= TOP && vcounter <= 160 )
			out = 4'b1101;
		else if (draw && win && hcounter >= LEFT+224 && hcounter < LEFT+320 && vcounter >= TOP && vcounter < 176)
			out = 4'b1110;
		else if (draw && win && vcounter >= 176 && vcounter <320)
			out = 4'b1011;
		else
			out = 4'b0000;
			
	else if ((vcounter >= TOP+MAXY && vcounter < TOP+MAXY+WIDTH) || (vcounter < TOP && vcounter+WIDTH >= TOP)
		|| (hcounter >= LEFT+MAXX && hcounter < LEFT+MAXX+WIDTH) || (hcounter < LEFT && hcounter+WIDTH >= LEFT))
		out = 4'b1111;
	else
		out = 4'b0000;
	

	 
		
end

endmodule
