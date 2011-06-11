module draw_back (
	input [10:0] vcounter,
	input [11:0] hcounter,
	input dead, init,
	output reg [3:0] out
);
`include "def.v"
localparam WIDTH = 16;

always @(*)
begin
	if ((vcounter >= TOP+MAXY && vcounter < TOP+MAXY+WIDTH) || (vcounter < TOP && vcounter+WIDTH >= TOP)
		|| (hcounter >= LEFT+MAXX && hcounter < LEFT+MAXX+WIDTH) || (hcounter < LEFT && hcounter+WIDTH >= LEFT))
		out = 4'b1111;
	else
		out = 4'b0000;
end

endmodule
