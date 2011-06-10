module shot_control(
	input clock, reset, shot,
	input [9:0] in_x, in_y,
	output reg [9:0] x, y,
	output reg active
);
`include "def.v"


always @ (posedge clock)
begin
    if (reset) begin
	    active = 1'b0;
    end else if ({shot,active} == 2'b10) begin
	    active = 1'b1;
	    x = in_x;
	    y = in_y;
    end else if (active) begin
	    if (y == TOP) 
			active = 1'b0;
	    else
			y = y+1;
    end	
end

endmodule
