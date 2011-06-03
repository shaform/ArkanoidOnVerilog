module state_control(
	input [9:0] x, y,
	input [5:0] radius, ang_x, ang_y,
	output [9:0] o_x, o_y,
	output [5:0] o_ang_x, o_ang_y,
	output drop
);

localparam MAXX = 639;
localparam MAXY = 479;
localparam ST_INIT;
localparam ST_WAIT;
localparam ST_PLAY;
localparam ST_DEAD;




reg [BALL_NUM-1:0] ball_turn;

// Speed control counters.
reg [10:0] b_cnt[BALL_NUM-1:0];
always @(posedge clock)
begin : ball_count
	integer i;
	for (i=0; i<BALL_NUM; i=i+1) begin
		if (reset)
			b_cnt[i] <= 0;
		else if (enable && ball_turn[i])
			if (b_cnt[i] < UNIT) begin
				b_cnt[i] <= b_cnt[i] + 1;
			end else begin
				b_cnt[i] <= 0;
			end
	end
end

// Ball Moving
always @(posedge clock)
begin : ball_move
	integer i;
	for (i=0; i<BALL_NUM; i=i+1) begin
		if (reset) begin
			b_x[i] <= MAXX/2;
			b_y[i] <= MAXY/2;
		end else if (enable && ball_turn[i])
			case (state)
				ST_PLAY: begin
					if (b_cnt[i] >= UNIT/b_ang_x[i]) begin
						if (b_di_x[i])
							b_x[i] <= b_x[i]-1;
						else
							b_x[i] <= b_x[i]+1;
					end

					if (b_cnt[i] >= UNIT/b_ang_y[i]) begin
						if (b_di_y[i])
							b_y[i] <= b_y[i]-1;
						else
							b_y[i] <= b_y[i]+1;
					end
				end
				ST_WAIT: begin
					b_x[i] <= pd_x;
					b_y[i] <= MAXY-b_radius-PD_SZ;
				end
			endcase
	end
end



// ball bouncing control

always @(*) begin
	crash = 1'b0;

	for (i=0; i<MAXROW; i=i+1)
	for (j=0; j<MAXCOL; j=j+1) begin
		if (blocks[i*MAXROW*4+j+:4]) begin
			crash = 1'b1;
			crash_row = i;
			crash_col = j;
		end
	end

end

always @(posedge clock)
begin
	if (reset) begin

	end else if (enable) begin







		// next turn
		ball_turn <= {ball_turn[BALL_NUM-2:0], ball_turn[BALL_NUM-1]};
	end
end


// ball moving
x <= x + ang_x;
y <= y + ang_y;
// block bounce
// paddle bounce

// wall bounce

if (radius > x) begin
	if (ang_x[5]) ang_x[5] = 1'b0;
end else if (x + radius > MAXX) begin
	if (~ang_x[5]) ang_x[5] = 1'b1;
end
if (radius > y) begin
	if (ang_y[5]) ang_y[5] = 1'b0;
end else if (y > radius + MAXY) beign
	drop = 1;
	// death !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	// death !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	// death !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end

endmodule
