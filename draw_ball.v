module draw_ball(
	input [10:0] vcounter,
	input [11:0] hcounter,
	input [9:0] x1, y1, x2, y2,
	input [1:0] active,
	input [5:0] radius,
	output reg [3:0] out
);
wire [19:0] xs, ys;
assign xs = {x2, x1};
assign ys = {y2, y1};

always @(*)
begin : circle
	integer i, sq;
	out = 4'b0000;
	sq = radius*radius;
	for (i=0; i<2; i=i+1) begin : forblock
		if (active[i]) begin : ballblock
			integer dx, dy;
			dx = hcounter;
			dy = vcounter;
			dx = dx - xs[i*10+:10];
			dy = dy - ys[i*10+:10];
			if (dx*dx + dy*dy <= sq) begin
				out = 4'b1111;
			end
		end
	end
end
endmodule
