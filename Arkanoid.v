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
wire [9:0] p_x, p_y;

// Game control
// Paddle control
paddle_control pd_control(.clock(iCLK_50), .reset(reset), .enable(1'b1), .rotary_event(rotary_event),
	.rotary_right(rotary_right), .speed(10), .radius(16), .paddle_x(p_x), .paddle_y(p_y));

wire [5:0] radius;
wire [1:0] b_active;
wire [9:0] b_x1, b_y1, b_x2, b_y2;

state_control s_control(.clock(iCLK_50), .b_active(b_active), .radius(radius), 
.o_bx1(b_x1), .o_by1(b_y1), .o_bx2(b_x2), .o_by2(b_y2));



// Game display
wire [10:0] vcounter; // 0~479
wire [11:0] hcounter; // 0~639
wire [3:0] out_back, out_paddle, out_block, out_ball, out_bmem;
wire [4:0] out_row, out_col;

//draw_back d_back()
//draw_paddle d_paddle(.out(out_paddle), .vcounter(vcounter), .hcounter(hcounter), .x(), .size(), .seperate());
block_memory b_mem(.clock(iCLK_50), .reset(reset), .enable(1'b1),
.row1(), .row2(out_row), .col1(), .col2(out_col),
.func(2'b01), .stage(2'b11), .block1(), .block2(out_bmem), .busy());

draw_block d_block(.vcounter(vcounter), .hcounter(hcounter), .block(out_bmem),
	.sel_row(out_row), .sel_col(out_col), .out(out_block));
	
draw_ball d_ball(.out(out_ball), .vcounter(vcounter), .hcounter(hcounter),
	.x1(b_x1), .y1(b_y1), .x2(b_x2) , .y2(b_y2), .active(3'b111), .radius(8));

draw_game d_game(.clock(clk_25), .reset(reset), .visible(visible),
	.in_ball(out_ball), .in_block(out_block), .in_paddle(out_paddle), .in_back(4'b0), .oRGB({oVGA_R, oVGA_G, oVGA_B}));
draw_paddle d_paddle(.vcounter(vcounter), .hcounter(hcounter),
	.x(p_x), .y(p_y), .radius(16), .out(out_paddle));

VGA_control vga_c(.CLK(clk_25), .reset(reset), .vcounter(vcounter),

	.hcounter(hcounter), .visible(visible), .oHS(oHS), .oVS(oVS));

assign oLED = 0;
//assign oLED[1:0] = result;
//assign oLED[7:2] = hp;
endmodule
