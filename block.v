module block(
	input clock, reset,
	// row: 0~xx, col: 0~yy
	input [] row, col,
	// func: 4'b0000=nop, 4'b0011=read, 4'b0101=write, 4'b0111=load(stage)
	//       4'b1001=dropdown, 4'b1011=pullup, 4'b1101=nop, 4'b1111=nop
	input [3:0] func,
	// The kind of brick, 0 = empty.
	// When load, the stage number.
	input [3:0] in,
	// The kind of brick, 0 = empty.
	output [3:0] out
);

endmodule
