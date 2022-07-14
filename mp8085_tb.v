`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:02:10 11/23/2020
// Design Name:   mp8085_v1
// Module Name:   D:/verilog_codes/mp8085/mp8085_ver1/mp8085_tb.v
// Project Name:  mp8085_ver1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mp8085_v1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mp8085_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [7:0] acc_out;

	// Instantiate the Unit Under Test (UUT)
	mp8085_v1 uut (
		.clk(clk), 
		.reset(reset), 
		.acc_out(acc_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#20 reset = 0;
        
		// Add stimulus here

	end
	always
	#10 clk = ~clk;
      
endmodule

