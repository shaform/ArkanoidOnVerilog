module paddle_control(
	input clock, reset, enable, rotary_event, rotary_right,
	input [4:0] speed,
	input [5:0] radius,
	input middle,
	output reg [9:0] paddle_x, paddle_y
);

localparam PD_H = 8;
localparam MAXX = 320;
localparam MAXY = 480;
localparam LEFT = 160;
localparam TOP = 0;

reg [9:0] next_x, next_y;

always @(*)
begin
	if (middle)
		paddle_y = TOP+MAXY/2-PD_H;
	else
		paddle_y = TOP+MAXY-PD_H;

end

always @(posedge clock)
begin
	if (reset) begin
		paddle_x <= LEFT + MAXX/2;
	end else begin
		paddle_x <= next_x;
	end
end

always @(*)
begin
	if (enable && rotary_event) begin
		if (rotary_right) begin
			if (paddle_x + radius + speed < LEFT + MAXX)
				next_x = paddle_x + radius + speed;
			else
				next_x = LEFT + MAXX - radius;
		end else begin
			if (paddle_x > LEFT + radius + speed)
				next_x = paddle_x - radius - speed;
			else
				next_x = LEFT + radius;
		end
	end else begin
		if (paddle_x + radius >= LEFT + MAXX)
			next_x = LEFT + MAXX - radius;
		else if (paddle_x < LEFT + radius)
			next_x = LEFT + radius;
		else
			next_x = paddle_x;
	end

end

endmodule
