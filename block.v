module block(
	input clock, reset,
	// row: 0~47, col: 0~31
	input [6:0] row,
	input [6:0] col,
	// only activates when enable = 1
	input enable,
	// func: 2'b00=clear, 2'b01=load, 2'b10=dropdown, 2'b11=pullup
	input [1:0] func,
	// The kind of brick, 0 = empty.
	// One cell is 3-bit number.
	output [2:0] out,
	input [2:0] in,
	output reg busy
);
// 320 * 480 game
localparam ROW = 24;
localparam COL = 32;
localparam TOTAL = ROW*COL;

localparam CLEAR = 2'b00;
localparam LOAD = 2'b01;
localparam DROP = 2'b10;
localparam PULL = 2'b11;

reg [ROW-1:0] line[COL*3-1:0];
reg [1:0] int_func;

always @(posedge clock)
begin : block
	//integer i;
	if (busy
	else if (reset) begin
		busy <= 1'b1;
		cnt <= 
		int_func <= CLEAR;
	end else if (enable) begin
		case (func)
			CLEAR: line <= line & ~(4608'b0 | (3'b111 << (row*COL*3 + col*3)));
			LOAD: line <= (line & ~(4608'b0 | (3'b111 << (row*COL*3 + col*3)))) | (in << (row*COL*3 + col*3));
			DROP: begin
				line <= {96'b0, line[0+:TOTAL-COL*3]};
			end
			PULL: begin
			       line <= {line[COL*3+:TOTAL-COL*3], 96'b0};
			end
		endcase
	end
end

assign out = reset ? 4'b0 : ((line >> (row*COL*3 + col*3)) & 4'b1111) ;

endmodule
