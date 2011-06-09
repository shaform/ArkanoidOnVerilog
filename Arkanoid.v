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
wire [9:0] p_x, p_y;
wire reset, start, btn_r, btn_l;
wire rotary_event, rotary_right;
wire [5:0] b_radius, p_radius;
wire [1:0] b_active;
wire [BALL_NUM*10-1:0] b_x, b_y;
wire [10:0] vcounter; // 0~479
wire [11:0] hcounter; // 0~639
wire [3:0] out_back, out_paddle, out_block, out_ball, out_bmem, bm_block;
wire [4:0] out_row, out_col, bm_row, bm_col;
wire [1:0] bm_stage, bm_func;
wire bm_ready, bm_enable;




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
	.rotary_right(rotary_right), .speed(10), .radius(16), .paddle_x(p_x), .paddle_y(p_y));


state_control s_control(.clock(iCLK_50), .reset(reset), .start(start), .btn_l(btn_l), .btn_r(btn_r),
	.bm_ready(bm_ready), .bm_block(bm_block), 
	.p_x(p_x), .p_y(p_y), .p_radius(p_radius),
	.b_active(b_active), .b_radius(b_radius), .o_bx(b_x), .o_by(b_y),
	.bm_enable(bm_enable), .bm_row(bm_row), .bm_col(bm_col), .bm_func(bm_func), .bm_stage(bm_stage));

// Game display

//draw_back d_back()
//
block_memory b_mem(.clock(iCLK_50), .reset(reset), .enable(bm_enable),
	.row1(bm_row), .row2(out_row), .col1(bm_col), .col2(out_col),
	.func(bm_func), .stage(iSW[1:0]), .block1(bm_block), .block2(out_bmem), .ready(bm_ready));

draw_block d_block(.vcounter(vcounter), .hcounter(hcounter), .block(out_bmem),
	.sel_row(out_row), .sel_col(out_col), .out(out_block));
	
draw_ball d_ball(.out(out_ball), .vcounter(vcounter), .hcounter(hcounter),
	.xs(b_x), .ys(b_y), .active(2'b11), .radius(b_radius));

draw_game d_game(.clock(clk_25), .reset(reset), .visible(visible),
	.in_ball(out_ball), .in_block(out_block), .in_paddle(out_paddle), .in_back(4'b0), .oRGB({oVGA_R, oVGA_G, oVGA_B}));

draw_paddle d_paddle(.vcounter(vcounter), .hcounter(hcounter),
	.x(p_x), .y(p_y), .radius(p_radius), .out(out_paddle));

VGA_control vga_c(.CLK(clk_25), .reset(reset), .vcounter(vcounter), .hcounter(hcounter),
	.visible(visible), .oHS(oHS), .oVS(oVS));

assign reset = btn_N;
assign oLED = {5'b0, btn_r, btn_l, start};
//assign oLED[1:0] = result;
//assign oLED[7:2] = hp;
endmodule
