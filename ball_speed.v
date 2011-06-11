module ball_speed(
	input clock,
	input [9:0] b_x, b_y, p_x,
	input [5:0] p_radius,
	input bd,
	output [3:0] b_sx, b_sy
);

reg [3:0] sx, sy;

always @(posedge clock)
begin
	if (b_x >= p_x+p_radius || b_x + p_radius < p_x) begin
		sx = 4'b1111;
		sy = 4'b0011;
	end else if (b_x >= p_x+p_radius/2 || b_x + p_radius/2 < p_x) begin
		sx = 4'b0111;
		sy = 4'b0111;
	end else begin
		sx = 4'b0011;
		sy = 4'b1111;
	end
end

assign b_sx = bd ? sx : 4'b0000;
assign b_sy = bd ? sy : 4'b0000;
endmodule
