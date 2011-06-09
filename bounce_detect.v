module bounce_detect(
	input [9:0] b_x, b_y,
	input [5:0] b_radius,
	input [9:0] w_x, w_y,
	input [5:0] w_radiusx, w_radiusy,
	output reg bounced,
	output reg [1:0] direction
);

localparam UP = 2'b00;
localparam RIGHT = 2'b01;
localparam DOWN = 2'b10;
localparam LEFT = 2'b11;

wire range_x, range_y;
assign range_x = b_x < b_radius + w_x + w_radiusx && b_x + b_radius + w_radiusx >= w_x;
assign range_y = b_y < b_radius + w_y + w_radiusy && b_y + b_radius + w_radiusy >= w_y;


always @(*)
begin
	if (range_x && range_y) begin
		bounced = 1'b1;
		if (b_x < w_x && b_x + b_radius/2 + w_radiusx < w_x)
			direction = LEFT;
		else if (b_x > w_x && b_x > b_radius/2 + w_x + w_radiusx)
			direction = RIGHT;
		else if (b_y < w_y)
			direction = UP;
		else
			direction = DOWN;
	end else begin
		bounced = 1'b0;
		direction = 2'bxx;
	end
end

endmodule
