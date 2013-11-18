`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:11:53 11/13/2013 
// Design Name: 
// Module Name:    clk_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clk_tb();
	
	reg clk, rst_b;
	wire clk_out, ready;
	
	initial clk = 0;
	always #5 clk = ~clk;

	clk31p5_dcm clk_dcm_inst(//Outputs
						.clk31p5(clk_out), //31.5MHz
						.ready(ready),
	
						//Inputs
						.clk27(clk), //27MHz clock
						.rst(~rst_b) // rst is an asynchronous active High reset
						);
	
	initial begin
		rst_b = 0;
		repeat (4) @(posedge clk);
		rst_b = 1;
		repeat (2000) @(posedge clk);
		$finish;		
	end
	
endmodule
