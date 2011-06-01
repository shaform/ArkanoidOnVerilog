module syn_edge_detect(
	input clock, reset, in,
	output edge_out
);
reg [5:0] syn_in;

edge_detect ed(clock, reset, syn_in[5], edge_out);
always @(posedge clock)
begin
	if (reset)
		syn_in <= 0;
	else
		syn_in <= {syn_in[4:0], in};
end

endmodule
