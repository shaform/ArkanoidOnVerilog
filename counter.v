module counter
#(parameter BIT = 3)
(
	input clock, reset, enable,
	output reg [BIT-1:0] cnt
);

always @(posedge clock)
begin
	if (reset)
		cnt <= 0;
	else if (enable) begin
		cnt <= cnt + 1;
	end
end
endmodule
