module draw_gift(
	input [10:0] vcounter,
	input [11:0] hcounter,
	input [9:0] x, y,
	input [2:0] kind,
	input active,
	output reg [3:0] out
);
`include "def.v"
wire range;
assign range = hcounter >= LEFT && hcounter < LEFT+MAXX && vcounter >= TOP && vcounter < TOP+MAXY;

always @(*)
begin
	if (range && active) begin 
			if (hcounter < x + PD_H && hcounter + PD_H >= x && vcounter < y + PD_H && vcounter + PD_H >= y) begin
				if (hcounter + PD_H == x || hcounter == x + PD_H - 1 || vcounter + PD_H == y || vcounter == y + PD_H - 1)
					out = 4'b1111;
				else
					out = {1'b1, kind};
			end else
				out = 4'b0000;
	end else
		out = 4'b0000;
end
endmodule
