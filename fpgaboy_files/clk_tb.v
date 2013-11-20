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
	always #500 clk = ~clk; //1MHz clock
/*
	clk31p5_dcm clk_dcm_inst(//Outputs
						.clk31p5(clk_out), //31.5MHz
						.ready(ready),
	
						//Inputs
						.clk27(clk), //27MHz clock
						.rst(~rst_b) // rst is an asynchronous active High reset
						);
*/
	mult_dcm #(.FREQ(27)) clk27MHz(
				//Outputs
				.clk_out(clk_out), //27MHz
				.ready(ready),
				//Inputs
				.clk1(clk), //1MHz clock
				.rst(~rst_b) //rst is active High
				);
				
	wire clk25, clk100;
	wire clk25_ready, clk100_ready;
	reg clk100_rst_b;
	
	mult_dcm #(.FREQ(25)) clk25MHz(
				//Outputs
				.clk_out(clk25), //25MHz
				.ready(clk25_ready),
				//Inputs
				.clk1(clk), //1MHz clock
				.rst(~rst_b) //rst is active High
				);
	clk100_dcm clk100MHz(
				//Outputs
				.clk100(clk100), //27MHz
				.ready(clk100_ready),
				//Inputs
				.clk25(clk25), //1MHz clock
				.rst(~clk100_rst_b) //rst is active High
				);
				
	initial begin
		rst_b = 0;
		clk100_rst_b = 0;
		repeat (4) @(posedge clk);
		rst_b = 1;
		repeat (15) @(posedge clk);
		clk100_rst_b = 1;
		repeat (2000) @(posedge clk);
		$finish;		
	end
	
endmodule
