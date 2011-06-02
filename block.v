module block(
	input clock, reset,
	// row: 0~xx, col: 0~yy
	input [9:0] row,
	input [19:0] col,
	// only activates when enable = 1
	input enable,
	// func: 2'b00=clear, 2'b01=load, 2'b10=dropdown, 2'b11=pullup
	input [1:0] func,
	// The kind of brick, 0 = empty.
	// One cell is 4-bit number.
	output [TOTAL_NUM_OF_CELLS*4-1:0] out
);
/*
* 06/02   17:00 Shaform
* changed write to clear, since the write function is actually not needed.
* removed input [3:0] in
*/
reg [19:0] line[9:0];

//parameter for func
parameter clear=2'b00;
parameter load=2'b01;
parameter dropdown=2'b10;
parameter pushup=2'b11;

//parameter for out 
parameter normal=4'b0001;
parameter bonus=4'b0010;
parameter stage=4'b0100;
parameter push=4'b1000;

always @(*) begin
    case(func)
    write:begin
	    line[0]=20'b11111111111111111111;
	    line[1]=20'b10000000000000000001;
	    line[2]=20'b10000000000000000001;
	    line[3]=20'b10000000000000000001;
	    line[4]=20'b10000000000000000001;
	    line[5]=20'b10000000000000000001;
	    line[6]=20'b10000000000000000001;
	    line[7]=20'b10000000000000000001;
	    line[8]=20'b10000000000000000001;
	    line[9]=20'b11111111111111111111;
	    out=normal;
    load:begin
	   line[0]=20'b11111111111111111111;
    dropdown:
    pushup:
    endcase
end

assign  = (reset == 1) ? 1'b0 : (line[row] >> (~col)) % 2;

endmodule
