module VGA_control(
	input CLK, reset,
	output reg [10:0] vcounter,
	output reg [11:0] hcounter,
	output reg visible, oHS, oVS
);
always @(posedge CLK, posedge reset)
begin
	if (reset) begin
		hcounter <= 0;
		vcounter <= 0;
	end else begin
		hcounter <= hcounter + 1;
		if (hcounter >= 11'd800)
		begin
			hcounter <= 0;
			vcounter <= vcounter + 1;
		end
		if (vcounter >= 10'd525)
			vcounter <= 0;
	end
end

always @(posedge CLK, posedge reset)
begin
	if (reset) begin
		visible <= 0;
		oHS <= 0;
		oVS <= 0;
	end else begin
		visible <= hcounter >= 11'd0 & hcounter < 11'd640 & vcounter >= 10'd0 & vcounter < 10'd480;
		oHS <= hcounter < 11'd656 | hcounter >= 11'd752;
		oVS <= vcounter < 10'd490 | vcounter >= 10'd492;
	end
end
endmodule
