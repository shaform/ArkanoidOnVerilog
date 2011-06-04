module shift_counter
#(
	parameter BIT = 3
)
(
	input clock, reset, enable,
	output reg [BIT-1:0] cnt
);

always @(posedge clock)
begin
	if (reset)
		cnt <= 1;
	else if (enable)
		cnt <= {cnt[BIT-2:0], cnt[BIT-1]};
end
endmodule
