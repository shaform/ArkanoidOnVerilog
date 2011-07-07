module edge_detect(
	input clock, reset, in,
	output edge_out
);
reg prev;

always @(posedge clock)
begin
	if (reset) prev <= 0;
	else prev <= in;
end

assign edge_out = in & ~prev;
endmodule
