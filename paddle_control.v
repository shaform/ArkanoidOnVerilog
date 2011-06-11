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
	end
	else if (enable && rotary_event) begin
		if (rotary_right) begin
			if (paddle_x + radius + speed < LEFT + MAXX)
				paddle_x <= paddle_x + radius + speed;
			else
				paddle_x <= LEFT + MAXX - radius;
		end else begin
			if (paddle_x > LEFT + radius + speed)
				paddle_x <= paddle_x - radius - speed;
			else
				paddle_x <= LEFT + radius;
		end
	end
end

endmodule
