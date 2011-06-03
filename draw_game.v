module draw_game(
	input clock, reset,
	input visible,
	input [3:0] in_ball, in_block, in_paddle, in_back,
	output o_r, o_g, o_b
);
reg [2:0] oRGB;

assign {o_r, o_g, o_b} = oRGB;

always @(posedge clock) begin
	if (reset || ~visible) begin
		oRGB <= 3'b000;
	end else begin
		if (in_ball[3])
			oRGB <= in_ball[2:0];
		else if (in_block[3])
			oRGB <= in_block[2:0];
		else if (in_paddle[3])
			oRGB <= in_paddle[2:0];
		else if (in_back[3])
			oRGB <= in_back[2:0];
		else
			oRGB <= 3'b000;
	end
end

endmodule
