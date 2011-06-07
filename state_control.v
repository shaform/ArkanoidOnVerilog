module state_control(
	input clock, reset, start, btn_l, btn_r,
	output [5:0] radius,
	output [9:0] o_bx1, o_by1, o_bx2, o_by2,
	output [1:0] b_active,
	output reg [9:0] o_sx, o_sy,
	output [1:0] s_active
);
localparam MAXX = 320;
localparam MAXY = 480;
localparam LEFT = 160;
localparam TOP = 0;
localparam PD_SZ = 10;
localparam PD_LEN = 20;
localparam UNIT = 2000000;
localparam CNT_MAX = 20;

localparam ST_INIT = 2'b00;
localparam ST_WAIT = 2'b01;
localparam ST_PLAY = 2'b10;
localparam ST_DEAD = 2'b11;
assign radius = 8;
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
reg [9:0] b_x[1:0], b_y[1:0], pd_x;
reg [9:0] b_ang_x[1:0], b_ang_y[1:0];
reg b_di_x[1:0], b_di_y[1:0];

assign o_bx1 = b_x[0];
assign o_bx2 = b_x[1];
assign o_by1 = b_y[0];
assign o_by2 = b_y[1];

// Speed control counters.
wire [40:0] b_cntx[1:0], b_cnty[1:0];
wire [1:0] b_rstx, b_rsty;

assign b_rstx[0] = reset || (b_cntx[0]*b_ang_x[0] >= UNIT);
assign b_rsty[0] = reset || (b_cnty[0]*b_ang_y[0] >= UNIT);
assign b_rstx[1] = reset || (b_cntx[1]*b_ang_x[1] >= UNIT);
assign b_rsty[1] = reset || (b_cnty[1]*b_ang_y[1] >= UNIT);
/*
always @(*)
begin : cnt_block
	integer j;
	for (j=0; j<2; j=j+1) begin
		b_rstx[j] = reset || (b_cntx[j]*b_ang_x[j] >= UNIT);
		b_rsty[j] = reset || (b_cnty[j]*b_ang_y[j] >= UNIT);
	end
end*/

counter #(40) cntx1(clock, b_rstx[0], 1'b1, b_cntx[0]);
counter #(40) cnty1(clock, b_rsty[0], 1'b1, b_cnty[0]);
counter #(40) cntx2(clock, b_rstx[1], 1'b1, b_cntx[1]);
counter #(40) cnty2(clock, b_rsty[1], 1'b1, b_cnty[1]);


// Ball Moving
always @(posedge clock)
begin : bmove_block
	integer i;
	for (i=0; i<2; i=i+1) begin
		if (reset) begin
			b_x[i] <= LEFT+MAXX/2;
			b_y[i] <= TOP+MAXY/2;
		end else case (state)
			default: begin
			//ST_PLAY: begin
				if (b_cntx[i]*b_ang_x[i] >= UNIT) begin
					if (b_di_x[i])
						b_x[i] <= b_x[i]-1;
					else
						b_x[i] <= b_x[i]+1;
				end

				if (b_cnty[i]*b_ang_y[i] >= UNIT) begin
					if (b_di_y[i])
						b_y[i] <= b_y[i]-1;
					else
						b_y[i] <= b_y[i]+1;
				end
			end/*
			ST_WAIT: begin
				b_x[i] <= LEFT+MAXX/2;//pd_x;
				b_y[i] <= TOP+MAXY/2;//MAXY-radius-PD_SZ;
			end
			default: begin
				//b_x[i] <= 10'bxxxxxxxxxx;
				//b_y[i] <= 10'bxxxxxxxxxx;
				b_x[i] <= LEFT+MAXX/2;//pd_x;
				b_y[i] <= TOP+MAXY/2;//MAXY-radius-PD_SZ;
			end*/
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
	end else begin : bounce_block
		integer i;
		for (i=0; i<2; i=i+1) begin
			if (LEFT + radius >= b_x[i]) begin
				if (b_di_x[i]) b_di_x[i] = 1'b0;
			end else if (b_x[i] + radius >= LEFT+MAXX) begin
				if (~b_di_x[i]) b_di_x[i] = 1'b1;
			end
			if (TOP + radius > b_y[i]) begin
				if (b_di_y[i]) b_di_y[i] = 1'b0;
			end else if (b_y[i] + radius >= TOP+MAXY) begin
				if (~b_di_y[i]) b_di_y[i] = 1'b1;
			end
		end
	end
end

endmodule
