module rand(
	input clock, reset,
	output reg [31:0] num
);
always @(posedge clock)
begin
	if (reset)
		num <= 55332;
	else
		num <= 18000 * (num & 65535) + (num >> 16);
end
endmodule
