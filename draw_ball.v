module draw_ball
#(parameter CNT = 3)
(
	input [10:0] vcounter,
	input [11:0] hcounter,
	input [CNT*10-1:0] xs, ys,
	input [CNT-1:0] active,
	input [5:0] radius,
	output [3:0] out
);
reg v, r, g, b;
assign out = {v, r, g, b};

always @(*)
begin : circle
	integer sq, i;
	v = 1'b0;
	sq = radius*radius;

	for (i=0; i<CNT; i=i+1) begin : forblock
	if (balls[i] && ~v) begin : ballblock
		integer dx, dy;
		dx = hcounter;
		dy = hcounter;
		dx = dx - xs[i*10+:10];
		dy = dy - ys[i*10+:10];
		if (dx*dx + dy*dy <= sq) begin
			v = 1'b1;
			r = 1'b1;
			g = 1'b1;
			b = 1'b1;
		end
	end
	end
end
endmodule
