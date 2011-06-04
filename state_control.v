module state_control
#(
	parameter BALL_NUM = 3,
	parameter SHOT_NUM = 2
)
(
	input clock, reset, start, btn_l, btn_r,
	output [5:0] radius,
	output reg [19:0] o_bx, o_by,
	output [1:0] b_active,
	output reg [19:0] o_sx, o_sy,
	output [1:0] s_active
);
localparam MAXX = 320;
localparam MAXY = 480;
localparam LEFT = 160;
localparam TOP = 0;
localparam PD_SZ = 10;
localparam PD_LEN = 20;
localparam UNIT = 10000;
localparam CNT_MAX = 20;

localparam ST_INIT = 2'b00;
localparam ST_WAIT = 2'b01;
localparam ST_PLAY = 2'b10;
localparam ST_DEAD = 2'b11;

reg [1:0] state, next_state;
always @(posedge clock)
begin
	if (reset)
		state <= ST_INIT;
	else
		state <= next_state;
end

always @(*)
begin
	case (state)
		ST_INIT: begin
			if (start)
				next_state = ST_WAIT;
			else
				next_state = ST_INIT;
		end
		ST_WAIT: begin
			if (start)
				next_state = ST_PLAY;
			else
				next_state = ST_WAIT;
		end
		ST_PLAY: next_state = ST_PLAY;
		ST_DEAD: next_state = ST_DEAD;
		default:
			next_state = 2'bxx;
	endcase
end


// Ball control
reg [9:0] b_x[2:0], b_y[2:0], pd_x;
reg [9:0] b_ang_x[2:0], b_ang_y[2:0];
reg b_di_x[2:0], b_di_y[2:0];



// Speed control counters.
wire [CNT_MAX:0] b_cnt[BALL_NUM-1:0];
generate
	genvar i;
	for (i=0; i<BALL_NUM; i=i+1) begin : cnt_block
		counter #(.BIT(CNT_MAX), .BOUND(UNIT)) cnt(clock, reset, 1'b1, b_cnt[i]);
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
		end else case (state)
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
			default: begin
				b_x[i] <= 10'bxxxxxxxxxx;
				b_y[i] <= 10'bxxxxxxxxxx;
			end
		endcase
	end
end

// Ball bouncing
always @(posedge clock)
begin
	if (reset) begin
		b_ang_x[0] = 5;
		b_ang_y[0] = 5;
		b_ang_x[1] = 10;
		b_ang_y[1] = 2;
		b_ang_x[2] = 4;
		b_ang_y[2] = 7;
	end else begin : bounce_block
		integer i;
		for (i=0; i<BALL_NUM; i=i+1) begin
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

endmodule
