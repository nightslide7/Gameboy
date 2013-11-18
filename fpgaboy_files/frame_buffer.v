`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:52:14 11/18/2013 
// Design Name: 
// Module Name:    frame_buffer 
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
module frame_buffer(	//Outputs
							dout, //pixel data out
							//Inputs
							clk, // Either gpuclk(31.5MHz) or gb_clock(33MHz)
							we,
							din, //pixel data in
							addr //[14:0] to be able to hold 160*144 pix
							);	
	//Outputs
	output wire [1:0] dout; //pixel data out
	//Inputs
	input clk; // Either gpuclk(31.5MHz) or gb_clock(33MHz)
	input we;
	input [1:0] din; //pixel data in
	input [14:0] addr; //[14:0] to be able to hold 160*144 pix
	
	reg [1:0] buffer [0:32767];
	
	always @(posedge clk)
		if(we) buffer[addr] <= din;

	assign dout = buffer[addr];
	
endmodule
