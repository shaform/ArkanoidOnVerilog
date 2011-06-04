module gift_control(
	input clock, reset, lost,
	input [9:0] paddle_x, paddle_y,
	// The gift position
	output kind,
	output [9:0] o_x, o_y,
	output active
);
localparam PD_SZ = 10;
localparam INC = 3'b000;
localparam DEC = 3'b001;
localparam SPU = 3'b010;
localparam SPD = 3'b011;
localparam HID = 3'b100;
localparam SOT = 3'b101;
localparam DRP = 3'b110;
localparam MUL = 3'b111;

rand r_gen(clock, reset)


always @(posedge 

endmodule
