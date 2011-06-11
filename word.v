module word(
	input [3:0] row, col,
	input [1:0] select,
	output word
);

reg [15:0] data;
always @(posedge clock)
begin 
	case (select)
		2'b00: case(row) // waiting to start.
				4'b0000: data = 16'b0000000000000000;
				4'b0001: data = 16'b0000000000000000;
				4'b0010: data = 16'b0000000000000000;
				4'b0011: data = 16'b0000000000000000;
				4'b0100: data = 16'b0000000000000000;
				4'b0101: data = 16'b0000000000000000;
				4'b0110: data = 16'b0000000000000000;
				4'b0111: data = 16'b0000000000000000;
				4'b1000: data = 16'b0000000000000000;
				4'b1001: data = 16'b0000000000000000;
				4'b1010: data = 16'b0000000000000000;
				4'b1011: data = 16'b0000000000000000;
				4'b1100: data = 16'b0000000000000000;
				4'b1101: data = 16'b0000000000000000;
				4'b1110: data = 16'b0000000000000000;
				4'b1111: data = 16'b0000000000000000;
				default: data = 16'bxxxxxxxxxxxxxxxx;
			endcase
		2'b01: case(row) // lose
				4'b0000: data = 16'b0000000000000000;
				4'b0001: data = 16'b0000000000000000;
				4'b0010: data = 16'b0000000000000000;
				4'b0011: data = 16'b0000000000000000;
				4'b0100: data = 16'b0000000000000000;
				4'b0101: data = 16'b0000000000000000;
				4'b0110: data = 16'b0000000000000000;
				4'b0111: data = 16'b0000000000000000;
				4'b1000: data = 16'b0000000000000000;
				4'b1001: data = 16'b0000000000000000;
				4'b1010: data = 16'b0000000000000000;
				4'b1011: data = 16'b0000000000000000;
				4'b1100: data = 16'b0000000000000000;
				4'b1101: data = 16'b0000000000000000;
				4'b1110: data = 16'b0000000000000000;
				4'b1111: data = 16'b0000000000000000;
				default: data = 16'bxxxxxxxxxxxxxxxx;
			endcase
		2'b10: case(row) // nothing
				default: data = 16'bxxxxxxxxxxxxxxxx;
		       endcase
		2'b11: case(row) // win
				4'b0000: data = 16'b0000000000000000;
				4'b0001: data = 16'b0000000000000000;
				4'b0010: data = 16'b0000000000000000;
				4'b0011: data = 16'b0000000000000000;
				4'b0100: data = 16'b0000000000000000;
				4'b0101: data = 16'b0000000000000000;
				4'b0110: data = 16'b0000000000000000;
				4'b0111: data = 16'b0000000000000000;
				4'b1000: data = 16'b0000000000000000;
				4'b1001: data = 16'b0000000000000000;
				4'b1010: data = 16'b0000000000000000;
				4'b1011: data = 16'b0000000000000000;
				4'b1100: data = 16'b0000000000000000;
				4'b1101: data = 16'b0000000000000000;
				4'b1110: data = 16'b0000000000000000;
				4'b1111: data = 16'b0000000000000000;
				default: data = 16'bxxxxxxxxxxxxxxxx;
		       endcase
		default: data <= 16'bxxxxxxxxxxxxxxxx;
	endcase
end

assign word = data[~col];

endmodule
