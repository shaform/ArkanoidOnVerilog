module ball_control(
	input clock, reset, load, enable, floor,
	input [5:0] radius,
	input [9:0] load_x, load_y,
	input [3:0] s_x, s_y,
	input [5:0] seed,
	input bd_p, bd_bl,
	input [1:0] bd_di,
	output reg [9:0] x, y,
	output dead
);
`include "def.v"


wire rstx, rsty;
wire [UBIT-1:0] cntx, cnty;
wire [31:0] rnum;
reg di_x, di_y;
reg [5:0] ang_x, ang_y;
wire [5:0] next_ang_x, next_ang_y;

assign rstx = reset || cntx*ang_x >= UNIT;
assign rsty = reset || cnty*ang_y >= UNIT;
assign bd = bd_p | bd_bl;

counter #(UBIT) cnt0(clock, rstx, enable, cntx);
counter #(UBIT) cnt1(clock, rsty, enable, cnty);
rand rnd(clock, reset, rnum);


// Ball moving

always @(posedge clock)
begin
	if (reset) begin
		x <= LEFT+MAXX;
		y <= TOP+MAXY;
	end else if (load) begin
		x <= load_x;
		y <= load_y;
	end else if (enable) begin
		if (rstx) begin
			if (di_x)
				x <= x-1;
			else
				x <= x+1;
		end
		if (rsty) begin
			if (di_y)
				y <= y-1;
			else
				y <= y+1;
		end

	end
end

// Ball bouncing
always @(posedge clock)
begin
	if (reset) begin
		di_x <= 1'b0;
		di_y <= 1'b0;
	end else if (enable) begin
		if (bd) begin
			case (bd_di)
				B_UP: di_y <= 1'b1;
				B_RIGHT: di_x <= 1'b0;
				B_DOWN: di_y <= 1'b0;
				B_LEFT: di_x <= 1'b1;
			endcase
		end

		// bounce wall take priority ($note. nonblocking assignment of
		// the same variable can be used in the same always block.)
		if (LEFT + radius >= x) // bounce left side
			di_x <= 1'b0;
		else if (x + radius >= LEFT+MAXX) // bounce right side
			di_x <= 1'b1;


		if (TOP + radius > y) // bounce top side
			di_y <= 1'b0;
		else if (floor && y + radius >= TOP+MAXY) // bounce down side
			di_y <= 1'b1;

	end
end

// Ball speeding
always @(posedge clock)
begin
	if (reset) begin
		ang_x <= rnum[7:4] ? rnum[7:4] : 5;
		ang_y <= rnum[11:8] ? rnum[11:8] : 6;
	end else if (load) begin
		ang_x <= rnum[7:4] + seed ? rnum[7:4] : 5;
		ang_y <= rnum[11:8] - seed ? rnum[11:8] : 6;
	end else if (enable && bd) begin
		if (s_x) ang_x <= next_ang_x ? next_ang_x : ang_x;
		if (s_y) ang_y <= next_ang_y ? next_ang_y : ang_y;

	end
	if (ang_x == 0) ang_x <= 5;
	if (ang_y == 0) ang_y <= 6;
end

assign next_ang_x = rnum[1:0] + s_x;
assign next_ang_y = rnum[3:2] + s_y;

assign dead = y >= TOP+MAXY;

endmodule
