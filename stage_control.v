module stage_control(
);

// stage control
always @(posedge clock)
begin
	if (reset)
		stage <= 2'b00;
	else if (load_stage)
		stage <= next_stage;
end
always @(*)
begin
	if (iSW[1:0] == 2'b11)
		next_stage = iSW[3:2];
	else if (state == ST_INIT)
		next_stage = 2'b00;
	else
		next_stage = (stage + 1)%4;
end
endmodule
