module Rotation_direction(
	input CLK, ROT_A, ROT_B,
	output reg rotary_event, rotary_right
);
reg r1, r2, dr;
reg [1:0] reg_r;

always @(posedge CLK)
	reg_r <= {ROT_B, ROT_A};

always @(posedge CLK)
begin
	case (reg_r)
		2'b00: r1 <= 1'b0;
		2'b01: r2 <= 1'b0;
		2'b10: r2 <= 1'b1;
		2'b11: r1 <= 1'b1;
	endcase
end

always @(posedge CLK)
begin
	dr <= r1;
	if(r1 & ~dr)
	begin
		rotary_event <= 1'b1;
		rotary_right  <= r2;
	end else begin
		rotary_event <= 1'b0;
	end
end

endmodule
