`timescale 1ns / 1ps
module Arkanoid(
	input iCLK_50,
	input [3:0] iSW,
	input BTN_WEST,
	input BTN_EAST,
	input BTN_NORTH,
	input BTN_SOUTH,
	output wire oVGA_R,
	output wire oVGA_G,
	output wire oVGA_B,
	output oHS,
	output oVS,
	output [7:0] oLED
);
parameter THREAD = 8;

reg oCLK_25;
wire reset, start, btn_r, btn_l;
wire [3:0] out_paddle, out_block, out_ball;

// 0~479
wire [10:0] vcounter;
// 0~639
wire [11:0] hcounter;

assign oLED[1:0] = result;
assign oLED[7:2] = hp;


assign reset = BTN_NORTH;
syn_edge_detect sed1(oCLK_25, reset, BTN_EAST, btn_r);
syn_edge_detect sed2(oCLK_25, reset, BTN_WEST, btn_l);
syn_edge_detect sed3(oCLK_25, reset, BTN_SOUTH, start);

// generate a 25Mhz clock
always @(posedge iCLK_50)
	oCLK_25 = ~oCLK_25;

VGA_control vga_c(.CLK(oCLK_25), .reset(reset), .vcounter(vcounter),
	.hcounter(hcounter), .visible(visible), .oHS(oHS), .oVS(oVS));


state_control s_control(.clock(iCLK_50), .enable(oCLK_25));

draw_game d_game(.reset(reset), .vcounter(vcounter), .hcounter(hcounter), .visible(visible),
	.in_ball(out_ball), in_block(out_block), in_paddle(out_paddle));
draw_ball d_ball(.out(out_ball), .vcounter(vcounter), .hcounter(hcounter), .xs(), .ys(), .balls(), .size());
draw_block d_block(.out(out_block), .vcounter(vcounter), .hcounter(hcounter),  );
draw_paddle d_paddle(.out(out_paddle), .vcounter(vcounter), .hcounter(hcounter), .x(), .size(), .seperate());

endmodule
