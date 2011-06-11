module shot_control(
	input clock, reset, shot,
	input [9:0] in_x, in_y,
	output reg [9:0] x, y,
	output reg active
);
`include "def.v"

wire [UBIT-1:0] cnt;
assign rst = reset || cnt >= UNIT;
counter #(UBIT) cnt0(clock, rst, enable, cntx);


always @(posedge clock)
begin
	if (reset || y <= TOP) begin
		active <= 1'b0;
	end else if (shot) begin
		active <= 1'b1;
	end
end

always @(posedge clock)
begin
	if (active) begin
		y <= y-1;
	end else if (shot) begin
		x <= in_x;
		y <= in_y;
	end
end

endmodule
