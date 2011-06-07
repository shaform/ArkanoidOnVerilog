module draw_paddle(
	input [10:0] vcounter,
	input [11:0] hcounter,
	input [9:0] x, y,
	input [5:0] radius,
	output reg [3:0] out
);

localparam PD_H = 8;
localparam LEFT = 160;
localparam TOP = 0;
localparam MAXX = 320;
localparam MAXY = 480;

wire range;
assign range = hcounter >= x-radius && hcounter < x+radius && vcounter >= y-PD_H && vcounter < y+PD_H;

always @(*)
begin
	if (range) out = 4'b1010;
	else out = 4'b0000;
end
endmodule
