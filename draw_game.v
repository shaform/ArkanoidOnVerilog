module draw_game(
	input clock, reset,
	input visible,
	input dead, init, win,
	input [3:0] in_ball, in_gift, in_block, in_paddle, in_back,
	output reg [2:0] oRGB
);

always @(posedge clock) begin
	if (reset || ~visible) begin
		oRGB <= 3'b000;
	end else begin
		if (dead | init | win)
			if (in_back[3]) oRGB <= in_back[2:0];
			else oRGB <= 3'b000;
		else if (in_ball[3])
			oRGB <= in_ball[2:0];
		else if (in_block[3])
			oRGB <= in_block[2:0];
		else if (in_gift[3])
			oRGB <= in_gift[2:0];
		else if (in_paddle[3])
			oRGB <= in_paddle[2:0];
		else if (in_back[3])
			oRGB <= in_back[2:0];
		else
			oRGB <= 3'b000;
	end
end
endmodule
