module counter
#(
	parameter BIT = 3,
	parameter BOUND = (1<<BIT)-1
)
(
	input clock, reset, enable,
	output reg [BIT-1:0] cnt
);

always @(posedge clock)
begin
	if (reset)
		cnt <= 0;
	else if (enable)
		if (cnt < BOUND) begin
			cnt <= cnt + 1;
		end else begin
			cnt <= 0;
		end
end
endmodule
