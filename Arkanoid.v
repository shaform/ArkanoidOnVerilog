`timescale 1ns / 1ps
module Arkanoid(
	input iCLK_50,
	input btn_W, btn_E, btn_N, btn_S,
	input [3:0] iSW,
	input iROT_A, iROT_B,
	output oVGA_R, oVGA_G, oVGA_B, oHS, oVS,
	output [7:0] oLED
);
localparam BALL_NUM = 2;
localparam SHOT_NUM = 2;

reg clk_25;
wire middle, b_dis;
wire [4:0] p_speed;
wire [9:0] p_x, p_y, g_x, g_y;
wire reset, start, btn_r, btn_l;
wire rotary_event, rotary_right;
wire [5:0] b_radius, p_radius;
wire [1:0] b_active;
wire [2:0] g_kind;
wire g_active;
wire [BALL_NUM*10-1:0] b_x, b_y;
wire [10:0] vcounter; // 0~479
wire [11:0] hcounter; // 0~639
wire [3:0] out_back, out_paddle, out_block, out_ball, out_bmem, bm_block, out_gift;
wire [4:0] out_row, out_col, bm_row, bm_col;
wire [1:0] bm_stage, bm_func;
wire bm_ready, bm_enable;
wire st_init, st_dead;


// generate a 25Mhz clock
always @(posedge iCLK_50)
	clk_25 = ~clk_25;


// Buttons
syn_edge_detect sed1(iCLK_50, reset, btn_E, btn_r);
syn_edge_detect sed2(iCLK_50, reset, btn_W, btn_l);
syn_edge_detect sed3(iCLK_50, reset, btn_S, start);


// Rotation detection
Rotation_direction r_dir(.CLK(iCLK_50), .ROT_A(iROT_A), .ROT_B(iROT_B),
	.rotary_event(rotary_event), .rotary_right(rotary_right));

// Game control
// Paddle control
paddle_control pd_control(.clock(iCLK_50), .reset(reset), .enable(1'b1), .rotary_event(rotary_event),
	.rotary_right(rotary_right), .speed(p_speed), .radius(p_radius), .middle(middle), .paddle_x(p_x), .paddle_y(p_y));


state_control s_control(.clock(iCLK_50), .reset(reset), .start(start), .btn_l(btn_l), .btn_r(btn_r), .iSW(iSW),
	.bm_ready(bm_ready), .bm_block(bm_block), 
	.p_x(p_x), .p_y(p_y), .p_radius(p_radius),
	.b_active(b_active), .b_radius(b_radius), .o_bx(b_x), .o_by(b_y),
	.bm_enable(bm_enable), .bm_row(bm_row), .bm_col(bm_col), .bm_func(bm_func), .bm_stage(bm_stage),
	.g_x(g_x), .g_y(g_y), .g_kind(g_kind), .g_active(g_active),
	.middle(middle), .p_speed(p_speed), .b_dis(b_dis),
	.hp(oLED[7:2]), .dead(st_dead), .init(st_init), .win(st_win));

block_memory b_mem(.clock(iCLK_50), .reset(reset), .enable(bm_enable),
	.row1(bm_row), .row2(out_row), .col1(bm_col), .col2(out_col),
	.func(bm_func), .stage(bm_stage), .block1(bm_block), .block2(out_bmem), .ready(bm_ready));

// Game display

draw_game d_game(.clock(clk_25), .reset(reset), .visible(visible),
	.dead(st_dead), .init(st_init), .win(st_win),
	.in_ball(out_ball), .in_gift(out_gift), .in_block(out_block), .in_paddle(out_paddle), .in_back(out_back), .oRGB({oVGA_R, oVGA_G, oVGA_B}));

draw_back d_back(.out(out_back), .vcounter(vcounter), .hcounter(hcounter),
	.dead(st_dead), .init(st_init), .win(st_win));

draw_block d_block(.clock(clk_25), .vcounter(vcounter), .hcounter(hcounter), .block(out_bmem),
	.sel_row(out_row), .sel_col(out_col), .out(out_block));
	
draw_ball d_ball(.out(out_ball), .vcounter(vcounter), .hcounter(hcounter), .visible(b_dis),
	.xs(b_x), .ys(b_y), .active(b_active), .radius(b_radius));

draw_ball d_shot(.out(out_shot), .vcounter(vcounter), .hcounter(hcounter),
	.xs(s_x), .ys(s_y), .active(s_active), .radius(4));

draw_paddle d_paddle(.vcounter(vcounter), .hcounter(hcounter),
	.x(p_x), .y(p_y), .radius(p_radius), .out(out_paddle));

draw_gift d_gift(.vcounter(vcounter), .hcounter(hcounter),
	.x(g_x), .y(g_y), .kind(g_kind), .active(g_active), .out(out_gift));

VGA_control vga_c(.CLK(clk_25), .reset(reset), .vcounter(vcounter), .hcounter(hcounter),
	.visible(visible), .oHS(oHS), .oVS(oVS));


assign reset = btn_N;
assign oLED[1:0] = st_win ? 2'b11 : (st_dead ? 2'b01 : 2'b00);
endmodule
