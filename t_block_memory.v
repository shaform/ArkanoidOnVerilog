`timescale 1ns / 1ps
module t_block_memory;

	// Inputs
	reg clock;
	reg reset;
	reg enable;
	reg [4:0] row1;
	reg [4:0] row2;
	reg [4:0] col1;
	reg [4:0] col2;
	reg [1:0] func;
	reg [1:0] stage;

	// Outputs
	wire [2:0] block1;
	wire [2:0] block2;
	wire busy;

	// Instantiate the Unit Under Test (UUT)
	block_memory uut (
		.clock(clock), 
		.reset(reset), 
		.enable(enable), 
		.row1(row1), 
		.row2(row2), 
		.col1(col1), 
		.col2(col2), 
		.func(func), 
		.stage(stage), 
		.block1(block1), 
		.block2(block2), 
		.busy(busy)
	);
	always #1 clock = ~clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		enable = 0;
		row1 = 0;
		row2 = 0;
		col1 = 0;
		col2 = 0;
		func = 0;
		stage = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		#10;
		reset = 0;
		#10;
		// Load stage testing.
		enable = 1;
		func = 1;
		#10;
		enable = 0;
		func = 0;
		#200;
		// Clear testing.
		col1 = 8;
		row1 = 8;
		enable = 1;
		func = 0;
		#10;
		// Drop testing.
		enable = 1;
		func = 2;
		#10
		enable = 0;
		#100;
		func = 3;
		enable = 1;
		#10;
		enable = 0;
		#200;
	end
endmodule

