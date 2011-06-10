module gift_control(
	input clock, reset, lost,
	input [9:0] paddle_x, paddle_y,
	// The gift position
	output [2:0]kind,
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

wire [31:0] rand_num;
wire [4:0] num; // 25% to get gift

rand r_gen(clock, reset, rand_num)

assign num = rand_num%32;


// set active value
always @ (posedge clock)  
begin
	if (reset) 
		active = 1'b0;
	else if (num[4:3] == 2'b00) 
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
	default:
end

endmodule
