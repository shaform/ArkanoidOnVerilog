module memory(
	input clock, write,
	input [4:0] addr1, addr2,
	input [71:0] in,
	output [71:0] out1, out2
);

reg [72-1:0] ram [31:0];

always @(posedge clock) begin 
	if (write) 
		ram[addr1] <= in; 
end 
assign out1 = ram[addr1]; 
assign out2 = ram[addr2]; 

endmodule
