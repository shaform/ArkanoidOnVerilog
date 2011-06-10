module block_memory(
	input clock, reset, enable,
	input [4:0] row1, row2, // 0~29
	input [4:0] col1, col2, // 0~9
	input [1:0] func,
	input [1:0] stage,
	output [2:0] block1, block2,
	output ready
);

`include "def.v"
localparam MAXROW = 30;
localparam READY = 2'b00;

reg write;
reg [4:0] cnt, addr1;
wire [4:0] addr2;
reg [1:0] state, next_state;
reg [1:0] rom_stage;
wire [29:0] rom_out, out1, out2;
reg [29:0] mem_out, last_out, w_data;
wire rom_enable, end_func, m_write;


assign ready = state == READY;
assign block1 = (out1 >> col1*3) & 3'b111;
assign block2 = (out2 >> col2*3) & 3'b111;

// memory control
assign addr2 = row2;
always @(*)
begin
	case (state)
		READY: addr1 = row1;
		F_LOAD: addr1 = cnt;
		default: begin
			if (write)
				addr1 = cnt;
			else if (state == F_PULL)
				addr1 = cnt+1;
			else
				addr1 = cnt-1;
		end
	endcase
end
assign m_write = state == READY ? enable && func == 2'b00 : write;
memory mem(clock, m_write, addr1, addr2, w_data, out1, out2);

assign rom_enable = state == F_LOAD;
stage_rom rom(clock, rom_enable, cnt, rom_stage, rom_out);


// counter
always @(posedge clock)
begin
	if (reset) begin
		cnt <= 5'b00000;
	end else if (state == READY) begin
		if (next_state == F_DROP)
			cnt <= 5'd29;
		else
			cnt <= 5'd0;
	end else if (write) begin
		if (state == F_DROP)
			cnt <= cnt - 1;
		else
			cnt <= cnt + 1;
	end
end

// state control
always @(posedge clock)
begin
	if (reset) state <= READY;
	else state <= next_state;
end


assign end_func = state == F_DROP ? cnt == 5'b00000 && write : (cnt == MAXROW-1 && write);
always @(*)
begin
	if (end_func)
		next_state = READY;
	else case (state)
		READY: next_state = enable ? func : READY;
		F_LOAD: next_state = F_LOAD;
		F_PULL: next_state = F_PULL;
		F_DROP: next_state = F_DROP;
		default: next_state = 2'bxx;
	endcase
end


// load stage
always @(posedge clock)
begin
	if (reset)
		rom_stage <= 2'b00;
	else if (enable && func == F_LOAD && ready)
		rom_stage <= stage;
end

// pull/drop
always @(posedge clock)
begin
	if (~write)
		case (state)
			F_PULL: begin
				if (cnt == 5'd29)
					mem_out <= 30'b000000000000000000000000000000;
				else
					mem_out <= out1;
			end
			F_DROP: begin
				if (cnt == 5'b00000)
					mem_out <= 30'b000000000000000000000000000000;
				else
					mem_out <= out1;
			end
			default: mem_out <= 30'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
	else
		mem_out <= 30'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
end


always @(*)
begin
	if (state == READY)
		w_data = out1 &(30'b111111111111111111111111111111 ^ (3'b111 << col1*3));
	else if (state == F_LOAD)
		w_data = rom_out;
	else
		w_data = mem_out;
end

always @(posedge clock)
begin
	if (ready)
		write <= 1'b0;
	else
		write <= ~write;
end


endmodule
