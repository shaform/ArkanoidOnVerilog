module paddle_control
#(
	parameter PD_SZ = 5,
)
(
	input clock, reset, enable, rotary_event, rotary_right,
	input [4:0] speed,
	input [9:0] length,
	output reg [9:0] paddle_x, paddle_y
);

localparam MAXX = 639;
localparam MAXY = 479;

always @(posedge clock)
begin
	if (reset) begin
		paddle_x <= MAXX/2;
		paddle_y <= MAXY-PD_SZ/2;
	end
	else if (enable && rotary_event) begin
		if (rotary_right) begin
			if (paddle_x + length/2 + speed < MAXX)
				paddle_x <= paddle_x + length/2 + speed;
			else
				paddle_x <= MAXX - length/2;
		end else begin
			if (paddle_x > length/2 + speed)
				paddle_x <= paddle_x - length/2 - speed;
			else
				paddle_x <= length/2;
		end
	end
end

endmodule
