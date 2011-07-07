module draw_ball
#(
	parameter BALL_NUM = 2
)
(
	input [10:0] vcounter,
	input [11:0] hcounter,
	input visible,
	input [BALL_NUM*10-1:0] xs, ys,
	input [1:0] active,
	input [5:0] radius,
	output reg [3:0] out
);

always @(*)
begin : circle
	integer i;
	out = 4'b0000;
	for (i=0; i<2; i=i+1) begin : forblock
		if (active[i] && visible) begin : ballblock
			integer dx, dy;
			dx = hcounter;
			dy = vcounter;
			dx = dx - xs[i*10+:10];
			dy = dy - ys[i*10+:10];
			if (dx*dx + dy*dy <= radius*radius) begin
				out = 4'b1111;
			end
		end
	end
end
endmodule
