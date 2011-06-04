module paddle_control
(
	input clock, reset, enable, rotary_event, rotary_right,
	input [4:0] speed,
	input [9:0] length,
	output reg [9:0] paddle_x, paddle_y
);
localparam PD_SZ = 10;
localparam MAXX = 320;
localparam MAXY = 480;
localparam LEFT = 160;
localparam TOP = 0;

always @(posedge clock)
begin
	if (reset) begin
		paddle_x <= LEFT + MAXX/2;
		paddle_y <= TOP + MAXY-PD_SZ/2;
	end
	else if (enable && rotary_event) begin
		if (rotary_right) begin
			if (paddle_x + length/2 + speed < LEFT + MAXX)
				paddle_x <= paddle_x + length/2 + speed;
			else
				paddle_x <= LEFT + MAXX - length/2;
		end else begin
			if (paddle_x > LEFT + length/2 + speed)
				paddle_x <= paddle_x - length/2 - speed;
			else
				paddle_x <= LEFT + length/2;
		end
	end
end

endmodule
