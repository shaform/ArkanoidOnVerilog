module bounce_detect(
	input enable,
	input [9:0] b_x, b_y,
	input [5:0] b_radius,
	input [9:0] w_x, w_y,
	input [5:0] w_radiusx, w_radiusy,
	output reg bounced,
	output reg [1:0] direction
);
`include "def.v"


wire range_x, range_y;
assign range_x = b_x < b_radius + w_x + w_radiusx && b_x + b_radius + w_radiusx >= w_x;
assign range_y = b_y < b_radius + w_y + w_radiusy && b_y + b_radius + w_radiusy >= w_y;


always @(*)
begin
	if (range_x && range_y && enable) begin
		bounced = 1'b1;
		if (b_x < w_x && b_x + b_radius/2 + w_radiusx < w_x)
			direction = B_LEFT;
		else if (b_x > w_x && b_x > b_radius/2 + w_x + w_radiusx)
			direction = B_RIGHT;
		else if (b_y < w_y)
			direction = B_UP;
		else
			direction = B_DOWN;
	end else begin
		bounced = 1'b0;
		direction = 2'bxx;
	end
end

endmodule
