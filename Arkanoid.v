`timescale 1ns / 1ps
module Arkanoid(
	input iCLK_50,
	input btn_W, btn_E, btn_N, btn_S,
	input [3:0] iSW,
	input iROT_A, iROT_B,
	output oVGA_R, oVGA_G, oVGA_B, oHS, oVS,
	output [7:0] oLED
);

// generate a 25Mhz clock
reg clk_25;
always @(posedge iCLK_50)
	clk_25 = ~clk_25;


// Buttons
wire reset, start, btn_r, btn_l;
assign reset = btn_N;
syn_edge_detect sed1(iCLK_50, reset, btn_E, btn_r);
syn_edge_detect sed2(iCLK_50, reset, btn_W, btn_l);
syn_edge_detect sed3(iCLK_50, reset, btn_S, start);


// Rotation detection
wire rotary_event, rotary_right;
Rotation_direction r_dir(.CLK(iCLK_50), .ROT_A(iROT_A), .ROT_B(iROT_B),
	.rotary_event(rotary_event), .rotary_right(rotary_right));


// Game control
// Paddle control
paddle_control pd_control(.clock(iCLK_50), .reset(reset), .enable(), .rotary_event(rotary_event),
	.rotary_right(rotary_right), .speed(pd_sp), .paddle_x(), .paddle_y(), .length());

wire [5:0] radius;
wire [BALL_NUM-1:0] b_active;
wire [BALL_NUM*10-1:0] b_xs, b_ys;

state_control #(.BALL_NUM(BALL_NUM), .SHOT_NUM(SHOT_NUM)) s_control(.clock(iCLK_50),
	.b_active(b_active), .radius(radius), .o_bx(xs), .o_by(ys));



// Game display
wire [10:0] vcounter; // 0~479
wire [11:0] hcounter; // 0~639

wire [3:0] out_back, out_paddle, out_block, out_ball;

//draw_back d_back()
//draw_paddle d_paddle(.out(out_paddle), .vcounter(vcounter), .hcounter(hcounter), .x(), .size(), .seperate());
//draw_block d_block(.out(out_block), .vcounter(vcounter), .hcounter(hcounter),  );
draw_ball #(.CNT(BALL_NUM)) d_ball(.out(out_ball), .vcounter(vcounter), .hcounter(hcounter),
	.xs(b_xs), .ys(b_ys), .active(b_active), .radius(radius));
draw_game d_game(.clock(clk_25), .reset(reset), .visible(visible),
	.in_ball(out_ball), .in_block(4'b0), .in_paddle(4'b0), .in_back(4'b0), .oRGB({oVGA_R, oVGA_G, oVGA_B}));

VGA_control vga_c(.CLK(clk_25), .reset(reset), .vcounter(vcounter),
	.hcounter(hcounter), .visible(visible), .oHS(oHS), .oVS(oVS));

assign oLED = 0;
//assign oLED[1:0] = result;
//assign oLED[7:2] = hp;
endmodule
