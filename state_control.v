module state_control
#(
	parameter BALL_NUM = 3,
	parameter SHOT_NUM = 2
)
(
	input clock, reset,
	output [5:0] radius
	output reg [BALL_NUM*10-1:0] o_bx, o_by,
	output [BALL_NUM-1:0] b_active,
	output reg [SHOT_NUM*10-1:0] o_sx, o_sy,
	output [SHOT_NUM-1:0] s_active,
);
localparam TH_NUM = BALL_NUM + SHOT_NUM;
localparam MAXX = 639;
localparam MAXY = 479;
localparam PD_SZ = 5;
localparam PD_LEN = 20;
localparam UNIT = 10000;
localparam CNT_MAX = 20;

localparam ST_INIT =0;
localparam ST_WAIT =1;
localparam ST_PLAY =2;
localparam ST_DEAD =3;

wire [4:0] state;
assign state = ST_PLAY;
assign radius = 20;
assign balls = 3'b111;


// Threads control
reg [THREAD_NUM-1:0] th_turn;
shift_counter #(THREAD_NUM) s_cnt(clock, reset, 1'b1, th_turn);

// Ball control
wire [BALL_NUM-1:0] b_turn;
assign b_turn = th_turn[BALL_NUM-1:0];

reg [9:0] b_x[2:0], b_y[2:0];
reg [9:0] b_ang_x[2:0], b_ang_y[2:0];
reg b_di_x[2:0], b_di_y[2:0];

assign


// Speed control counters.
wire [CNT_MAX:0] b_cnt[BALL_NUM-1:0];
generate
	genvar i;
	for (i=0; i<BALL_NUM; i=i+1) begin : cnt_block
		counter #(.BIT(CNT_MAX), .BOUND(UNIT)) cnt(clock, reset, b_turn[i], b_cnt[i]);
	end
endgenerate

// Ball Moving
always @(posedge clock)
begin : bmove_block
	integer i;
	for (i=0; i<BALL_NUM; i=i+1) begin
		if (reset) begin
			b_x[i] <= MAXX/2;
			b_y[i] <= MAXY/2;
		end else if (enable && ball_turn[i])
			case (state)
				ST_PLAY: begin
					if (b_cnt[i]*b_ang_x[i] >= UNIT) begin
						if (b_di_x[i])
							b_x[i] <= b_x[i]-1;
						else
							b_x[i] <= b_x[i]+1;
					end

					if (b_cnt[i]*b_ang_y[i] >= UNIT) begin
						if (b_di_y[i])
							b_y[i] <= b_y[i]-1;
						else
							b_y[i] <= b_y[i]+1;
					end
				end
				ST_WAIT: begin
					b_x[i] <= pd_x;
					b_y[i] <= MAXY-radius-PD_SZ;
				end
			endcase
	end
end

always @(posedge clock)
begin
	if (reset) begin
		b_ang_x[0] = 5;
		b_ang_y[0] = 5;
		b_ang_x[1] = 10;
		b_ang_y[1] = 2;
		b_ang_x[2] = 4;
		b_ang_y[2] = 7;
	end else if (enable) begin : bounce_block
		integer i;
		for (i=0; i<2; i=i+1) begin
			if (ball_turn[i]) begin
				if (radius >= b_x[i]) begin
					if (b_ang_x[i][5]) b_ang_x[i][5] = 1'b0;
				end else if (b_x[i] + radius >= MAXX) begin
					if (~b_ang_x[i][5]) b_ang_x[i][5] = 1'b1;
				end
				if (radius > b_y[i]) begin
					if (b_ang_y[i][5]) b_ang_y[i][5] = 1'b0;
				end else if (b_y[i] + radius >= MAXY) begin
					if (~b_ang_y[i][5]) b_ang_y[i][5] = 1'b1;
				end
			end
		end
	end
end


// ball bouncing control
/*
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
*/
endmodule
