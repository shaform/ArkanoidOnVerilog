module gift_control(
	input clock, reset, enable, hit,
	// The gift position
	input [9:0] in_x, in_y,
	output reg [2:0] kind,
	output reg [9:0] x, y,
	output reg active,
	// control signal
	output reg paddle_size, paddle_speed, give_ball, ball_speed, ball_size, ball_display, get_shot, drop_block

);
`include "def.v"
localparam CHP = 3'b000; // change paddle size
localparam SPP = 3'b001; // change paddle speed
localparam GBL = 3'b010; // give one ball
localparam SPB = 3'b011; // change ball speed
localparam CHB = 3'b100; // change ball size
localparam HID = 3'b101; // change ball display
localparam SOT = 3'b110; // get shot capacity
localparam DRP = 3'b111; // drop the blocks

wire [31:0] num;
wire [UBIT-1:0] cnt;
assign rst = reset || cnt >= UNIT/10;
counter #(UBIT) cnt0(clock, rst, active, cnt);

rand r_gen(clock, reset, num);


// set active value
always @ (posedge clock)  
begin
	if (reset || y >= TOP+MAXY || hit)
		active <= 1'b0;
	else if (enable && num[15:14] == 2'b00) 
		active <= 1'b1;
	    
end


always @(posedge clock)
begin
	if (active) begin
		if (rst) y <= y+1;
	end else if (enable) begin
		x <= in_x;
		y <= in_y;
		kind <= num[2:0];
	end
end

always @(posedge clock)
begin
	if (active && hit) begin
		if (kind == CHP) paddle_size <= 1'b1;
		if (kind == SPP) paddle_speed <= 1'b1;
		if (kind == GBL) give_ball <= 1'b1;
		if (kind == SPB) ball_speed <= 1'b1;
		if (kind == CHB) ball_size <= 1'b1;
		if (kind == HID) ball_display <= 1'b1;
		if (kind == SOT) get_shot <= 1'b1;
		if (kind == DRP) drop_block <= 1'b1;
	end else begin
		paddle_size <= 1'b0;
		paddle_speed <= 1'b0;
		give_ball <= 1'b0;
		ball_speed <= 1'b0;
		ball_size <= 1'b0;
		ball_display <= 1'b0;
		get_shot <= 1'b0;
		drop_block <= 1'b0;
	end
end

endmodule
