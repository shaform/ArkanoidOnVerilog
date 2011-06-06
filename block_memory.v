module block_memory(
	input clock, reset, enable,
	input [4:0] row1, row2, // 0~29
	input [4:0] col1, col2, // 0~9
	input [1:0] func,
	input [1:0] stage,
	output [2:0] block1, block2,
	output busy
);

localparam MAXROW = 30;
localparam READY = 2'b00;
localparam LOAD = 2'b01;
localparam PULL = 2'b10;
localparam DROP = 2'b11;


// state control
reg [1:0] state, next_state;

always @(posedge clock)
begin
	if (reset) state <= READY;
	else state <= next_state;
end

always @(*)
begin
	case (state)
		READY: next_state = enable ? func : READY;
		LOAD: next_state = cnt < MAXROW ? LOAD : READY;
		PULL: next_state = cnt < MAXROW ? PULL : READY;
		DROP: next_state = cnt < MAXROW ? DROP : READY;
	endcase
end




// stage control
reg [1:0] rom_stage;
wire [29:0] rom_out;
reg [29:0] w_data;
assign load_rom = state == LOAD;
always @(*)
begin
	if (state == LOAD)
		w_data = rom_out;
	else
		w_data = w_out;
end
always @(posedge clock)
begin
	if (reset)
		rom_stage <= 2'b00;
	else if (enable && func == LOAD)
		rom_stage <= stage;
end

stage_rom(clock, load_rom, r_cnt, rom_stage, rom_out);


// functional control
assign busy = state != READY;

// memory control
wire [29:0] in, out1, out2;
assign block1 = (out1 >> col1*3) & 3'b111;
assign block2 = (out2 >> col2*3) & 3'b111;

always @(posedge clock)
begin
	if (state == READY) begin
		w_cnt <= 5'b00000;
		r_cnt <= 5'b00000;
	end else if (write) begin
		w_cnt <= w_cnt + 1;
	end else begin
		r_cnt <= r_cnt + 1;
	end
end

always @(posedge clock)
begin
	if (state == READY)
		write <= 1'b0;
	else
		write <= ~write;
end

assign addr = busy ? w_row : row1;
memory mem(clock, write, addr, row2, w_data, out1, out2);

endmodule
