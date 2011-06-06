module draw_block(
	input vcounter,
	input hcounter,
	input [2:0] block,
	output [4:0] sel_row, sel_col,
	output [3:0] out
);

parameter left=64;
parameter down=0;
reg r, g, b, v;
assign out = {v, r, g, b};

assign sel_col=(hcounter-left)/32;
assign sel_row=(vcounter-down)/16;

always @(*)
begin 
	if(hcounter>=left & hcounter<left+320 & vcounter>=down & vcounter<480) 
	begin 
		//no fill ,no block here
		if(block==3'b000) {v,r,g,b}=4'b0000; 
		//16*16 block here
		else if(~block[2])
		begin : tenmulten
			integer i,j;                                             
			i=(hcounter-left)%32;                                     //00000000111111111111111100000000
			j=(vcounter-down)%16;												 //00000000122222222222222100000000
																						 //................................
			if(i>8 && i<23) begin												 //00000000122222222222222100000000
				//draw the line of block (black in color)					 //00000000111111111111111100000000
				if(j==0 || j==15) {v,r,g,b}=4'b1000; 						 //0:no fill 	1:line	2:body (shown as 1 in actual value)
				//color of block body
				//determine the color
				//-----------------------------------------------
				if(j>0  && j<15 ) begin
					case(block[1:0])
					2'b00: {v,r,g,b}=4'b0000; //<-- block=3'b000 --> impossible to happen here
					2'b01: {v,r,g,b}=4'b1100; //red
					2'b10: {v,r,g,b}=4'b1110; //yellow
					2'b11: {v,r,g,b}=4'b1101; //pink
					endcase
				end
				//-----------------------------------------------
			end else if(i==8 || i==23) {v,r,g,b}=4'b1000; 
			else {v,r,g,b}=4'b0000;
			
		end
		//32*16 block here
		else if(block[2])
		begin : twentymulten
			integer i,j;
			i=(hcounter-left)%32;
			j=(vcounter-down)%16;
			//draw line of 20*10
			if(i==0 || i==31 || j==0 || j==15) {v,r,g,b}=4'b1000;
			//color of block body
			//determine the color

			//------------------------------------------------------
			else if(i>0 && i<31 && j>0 && j<15) begin
				case(block[1:0])
				2'b00: {v,r,g,b}=4'b1001; //blue
				2'b01: {v,r,g,b}=4'b1011; //green+blue=?
				2'b10: {v,r,g,b}=4'b1010; //green
				2'b11: {v,r,g,b}=4'b1111; //white?!
				endcase
			end
			//------------------------------------------------------
			
		end
		
	end
end


endmodule
