module gift_control(
	input clock, reset, enable,
	// The gift position
	input [9:0] in_x, in_y,
	output [2:0] kind,
	output [9:0] x, y,
	output active
);
`include "def.v"
localparam INC = 3'b000;
localparam DEC = 3'b001;
localparam SPU = 3'b010;
localparam SPD = 3'b011;
localparam HID = 3'b100;
localparam SOT = 3'b101;
localparam DRP = 3'b110;
localparam MUL = 3'b111;

wire [31:0] rand_num;
wire [4:0] num; // 25% to get gift

wire [UBIT-1:0] cnt;
assign rst = reset || cnt >= UNIT;
counter #(UBIT) cnt0(clock, rst, enable, cntx);

rand r_gen(clock, reset, rand_num)

assign num = rand_num%32;


// set active value
always @ (posedge clock)  
begin
	if (reset || y >= TOP+MAXY) 
		active = 1'b0;
	else if (enable && num[4:3] == 2'b00) 
		active = 1'b1;
	    
end

always @ (posedge clock)
begin
	case(num)
		5'b00000: kind = INC;
		5'b00001: kind = DEC;
		5'b00010: kind = SPU;
		5'b00011: kind = SPD;
		5'b00100: kind = HID;
		5'b00101: kind = SOT;
		5'b00110: kind = DRP;
		5'b00111: kind = MUL;
		default: kind = 3'bxxx;
	default:
end




always @(posedge clock)
begin
	if (active) begin
		y <= y+1;
	end else if (enable) begin
		x <= in_x;
		y <= in_y;
	end
end

endmodule
