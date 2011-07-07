module block_control
#(
	parameter BALL_NUM,
	parameter SHOT_NUM
)
(
	input clock, reset,
	input [BALL_NUM*10-1:0] i_bx, i_by,
	input [BALL_NUM-1:0] b_active,
	input [5:0] b_radius,
	input [SHOT_NUM*10-1:0] i_sx, i_sy,
	input [SHOT_NUM-1:0] s_active,
	input [5:0] s_radius,
	input [3:0] block,
	output [6:0] row, col,
	output [BALL_NUM-1:0] d_ball,
	output [SHOT_NUM-1:0] d_shot,
	output destroy,
	output [9:0] d_x, d_y
);
// size: 20*10
// 32*48 blocks
localparam WIDTH = 20;
localparam HEIGHT = 10;
localparam ROW = 48;
localparam COL = 32;
localparam TOTAL = ROW*COL;

// Block counter
always @(posedge clock)
begin
	if (reset) begin
		row <= 7'b0;
		col <= 7'b0;
	end else begin
		if (col >= COL-1) begin
			col <= 0;
			if (row >= ROW-1) begin
				row <= 0;
			end else begin
				row <= row + 1;
			end
		end else begin
			col <= col + 1;
		end
	end
end


always @(*)
begin : bounce_check
	integer i;
	for (i=0; i<BALL_NUM; i=i+1) begin
		if (b_active[i]) begin
		end
	end
end

assign destroy = | {d_ball, d_shot};
assign d_x = WIDTH*COL + WIDTH/2;
assign d_y = HEIGHT*ROW + HEIGHT/2;

endmodule
