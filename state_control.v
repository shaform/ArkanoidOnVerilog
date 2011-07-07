module state_control
#(
	parameter BALL_NUM = 2,
	parameter SHOT_NUM = 2
)
(
	input clock, reset, start, btn_l, btn_r,
	input [3:0] iSW,
	input bm_ready,
	input [3:0] bm_block,
	input [9:0] p_x, p_y,
	output reg [5:0] p_radius, b_radius,
	output [BALL_NUM*10-1:0] o_bx, o_by,
	output reg [BALL_NUM-1:0] b_active,
	output reg [SHOT_NUM*2-1:0] o_sx, o_sy,
	output [SHOT_NUM-1:0] s_active,
	output reg bm_enable,
	output [4:0] bm_row, bm_col,
	output reg [1:0] bm_func,
	output [1:0] bm_stage,
	output reg [4:0] p_speed,
	output [9:0] g_x, g_y,
	output [3:0] g_kind,
	output g_active,
	output reg b_dis,
	output middle,
	output reg [5:0] hp,
	output dead, init,
	output reg win
);

`include "def.v"

localparam ST_INIT = 2'b00;
localparam ST_WAIT = 2'b01;
localparam ST_PLAY = 2'b10;
localparam ST_DEAD = 2'b11;


wire bm_empty;
wire load_stage;
reg b_sw;

wire [5:0] bl_radius;
reg [1:0] state, next_state;
wire [9:0] b_x[BALL_NUM-1:0], b_y[BALL_NUM-1:0];
wire [9:0] bl_x, bl_y;
wire [BALL_NUM-1:0] b_bd_p, b_bd_bl;
wire [1:0] b_bd_di_p[BALL_NUM-1:0], b_bd_di_bl[BALL_NUM-1:0], b_bd_di[BALL_NUM-1:0];
reg [1:0] stage, next_stage;

wire bl_enable, bl_rstc, bl_rstr;
assign bl_x = LEFT + 16 + bm_col*32;
assign bl_y = TOP + 8 + bm_row*16;
assign bm_stage = next_stage;
assign load_stage = (state == ST_INIT || (state == ST_PLAY && bm_empty)) && next_state == ST_WAIT;
assign middle = stage == 2'b11; 

wire paddle_size, paddle_speed, give_ball, ball_speed, ball_size, ball_display, get_shot, drop_block;

reg [9:0] g_inx, g_iny;

wire [UBIT-1+8:0] swcnt;
counter #(UBIT+8) cntsw(clock, reset, b_sw, swcnt);

gift_control g_control(clock, reset | (!b_active), |b_bd_bl, g_hit, bl_x, bl_y, g_kind, g_x, g_y, g_active,
	paddle_size, paddle_speed, give_ball, ball_speed, ball_size, ball_display, get_shot, drop_block);

bounce_detect g_bounce(g_active, g_x, g_y, 8, p_x, p_y, p_radius, PD_H, g_hit,);

always @(posedge clock)
begin
	if (reset) begin
		p_radius <= 16;
		b_radius <= 8;
		p_speed <= 1;
	end else begin
		if (paddle_size) begin
			if (p_radius == 16)
				p_radius <= 32;
			else if (p_radius == 32)
				p_radius <= 8;
			else
				p_radius <= 16;
		end
		if (paddle_speed) begin
			if (p_speed == 1)
				p_speed <= 3;
			else if (p_speed == 3)
				p_speed <= 5;
			else
				p_speed <= 1;
		end
		if (ball_size) begin
			if (b_radius == 8)
				b_radius <= 16;
			else
				b_radius <= 8;
		end
	end

end
assign init = state == ST_INIT;
assign dead = (state == ST_DEAD) && ~win;

always @(posedge clock)
begin
	if (reset)
		b_dis <= 1'b1;
	else if (b_sw)
		if (swcnt == 0) b_dis <= ~b_dis;
	else
		b_dis <= 1'b1;
end
always @(posedge clock)
begin
	if (reset)
		b_sw <= 1'b0;
	else if (ball_display)
		b_sw <= ~b_sw;
end

always @(posedge clock)
begin
	if (reset)
		hp <= 6'b111111;
	else if (state == ST_PLAY && !b_active)
		hp <= hp >> 1;
end
always @(posedge clock)
begin
	if (reset)
		win <= 1'b0;
	else if (stage == 2'b11 && bm_empty)
		win <= 1'b1;
end

assign floor = iSW[1];
wire [BALL_NUM-1:0]  b_dead;

always @(posedge clock)
begin : b_block
	integer i;
	if (reset)
		b_active <= 0;
	else if (next_state == ST_WAIT)
		b_active[0] <= 1'b1;
	for (i=0; i<BALL_NUM; i=i+1) begin
		if (b_dead[i] || b_bd_bl[i] && bm_block == 3'b001) b_active[i] <= 1'b0;
		if (give_ball) b_active[i] <= 1'b1;
	end
end


always @(*)
begin
	bm_enable = 1'b0;
	bm_func = 2'bxx;
	if ((state == ST_INIT && start ) || (state == ST_PLAY && bm_empty && next_state == ST_WAIT)) begin
		bm_enable = 1'b1;
		bm_func = F_LOAD;
	end else if (state == ST_PLAY && b_bd_bl && bm_block != 3'b111 && bm_block != 3'b001) begin
		bm_enable = 1'b1;
		bm_func = F_CLEAR;
	end else if (drop_block) begin
		bm_enable = 1'b1;
		bm_func = 2'b11;
	end else if (btn_l) begin
		bm_enable = 1'b1;
		bm_func = 2'b10;
	end else if (btn_r) begin
		bm_enable = 1'b1;
		bm_func = 2'b11;
	end
end

wire [3:0] b_sx[BALL_NUM-1:0], b_sy[BALL_NUM-1:0];



generate
genvar i;
for (i=0; i<BALL_NUM; i=i+1) begin : b_genblock
	ball_control ball(clock, reset, next_state == ST_WAIT || ~b_active[i], b_active[i], floor, b_radius, p_x, p_y-PD_H-b_radius, b_sx[i], b_sy[i], i,b_bd_p[i], b_bd_bl[i], b_bd_di[i], b_x[i], b_y[i], b_dead[i]);
	bounce_detect p_bounce(1'b1, b_x[i], b_y[i], b_radius, p_x, p_y, p_radius, PD_H, b_bd_p[i], b_bd_di_p[i]);
	bounce_detect bl_bounce(bm_block != 0 && bm_ready && b_active[i], b_x[i], b_y[i], b_radius, bl_x, bl_y, bl_radius, 8, b_bd_bl[i], b_bd_di_bl[i]);
	ball_speed b_speed(clock, b_x[i], b_y[i], p_x, p_radius, b_bd_p[i], b_sx[i], b_sy[i]);

	assign o_bx[i*10+9:i*10] = b_x[i];
	assign o_by[i*10+9:i*10] = b_y[i];
	assign b_bd_di[i] = b_bd_bl[i] ? b_bd_di_bl[i] : b_bd_di_p[i];
end
endgenerate

always @(posedge clock)
begin
	if (reset)
		state <= ST_INIT;
	else
		state <= next_state;
end

always @(*)
begin
	case (state)
		ST_INIT: begin
			if (start && bm_ready)
				next_state = ST_WAIT;
			else
				next_state = ST_INIT;
		end
		ST_WAIT: begin
			if (start && bm_ready)
				next_state = ST_PLAY;
			else
				next_state = ST_WAIT;
		end
		ST_PLAY: begin
			if (!(b_active || hp) || (stage == 2'b11 && bm_empty))
				next_state = ST_DEAD;
			else if (!b_active)
				next_state = ST_WAIT;
			else if (bm_empty)
				next_state = ST_WAIT;
			else
				next_state = ST_PLAY;
		end
		ST_DEAD: next_state = ST_DEAD;
		default:
			next_state = 2'bxx;
	endcase
end


always @(posedge clock)
begin
	if (reset)
		stage <= 2'b00;
	else if (load_stage)
		stage <= next_stage;
end
always @(*)
begin
	if (iSW[1:0] == 2'b11)
		next_stage = iSW[3:2];
	else if (state == ST_INIT)
		next_stage = 2'b00;
	else
		next_stage = (stage + 1)%4;
end

// block counter
assign bl_enable = bm_col >= 4'd9;
assign bl_rstc = reset || bl_enable;
assign bl_rstr = reset || (bm_row >= 5'd29 && bl_enable);
counter #(5) cntblc(clock, bl_rstc, 1'b1, bm_col);
counter #(5) cntblr(clock, bl_rstr, bl_enable, bm_row);

reg scan_empty;
always @(posedge clock)
begin
	if (reset || ~bm_ready || bm_enable || (bm_block && bm_block != 3'b111 && bm_block != 3'b001))
		scan_empty <= 1'b0;
	else if (bm_row == 0 && bm_col == 0)
		scan_empty <= 1'b1;
end

assign bm_empty = (reset || ~bm_ready || bm_block) ? 1'b0 : bm_row == 5'd29 && bm_col && scan_empty;
assign bl_radius = bm_block[2] ? 16 : 8;

endmodule
