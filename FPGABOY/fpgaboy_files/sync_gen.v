`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:35:21 11/11/2013 
// Design Name: 
// Module Name:    sync_gen 
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

module sync_gen(/*AUTOARG*/
   // Outputs
   vs, hs, border,
	x, y, //TEST
	
   // Inputs
   gpuclk, gpuclk_rst_b
   );

output reg vs, hs;
output reg border;
output reg [11:0] x, y; //TEST

input gpuclk;
input gpuclk_rst_b;

parameter XRES = 640;
parameter XFPORCH = 24;
parameter XSYNC = 40;
parameter XBPORCH = 128;

parameter YRES = 480;
parameter YFPORCH = 11;//9;
parameter YSYNC = 2;//3;
parameter YBPORCH = 31;//28;

//reg [11:0] x, y;

/*
parameter XRES = 1600;
parameter XFPORCH = 64;
parameter XSYNC = 192;
parameter XBPORCH = 304;

parameter YRES = 1200;
parameter YFPORCH = 1;
parameter YSYNC = 3;
parameter YBPORCH = 46;
*/


always @(posedge gpuclk) begin
	if (!gpuclk_rst_b) begin
		x <= 0;
		y <= 0;
	end
	else begin
		if (x >= (XRES + XFPORCH + XSYNC + XBPORCH)) begin
			if (y >= (YRES + YFPORCH + YSYNC + YBPORCH))
				y <= 0;
			else
				y <= y + 1;
				x <= 0;
			end 
		else
			x <= x + 1;
		end
	end

always @(*) begin
	hs = (x >= (XRES + XFPORCH)) && (x < (XRES + XFPORCH + XSYNC));
	vs = (y >= (YRES + YFPORCH)) && (y < (YRES + YFPORCH + YSYNC));
	border = (x >= XRES) || (y >= YRES);
end

endmodule
