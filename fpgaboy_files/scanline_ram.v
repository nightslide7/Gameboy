`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:04:16 11/18/2013 
// Design Name: 
// Module Name:    scanline_ram 
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
module scanline_ram(//Outputs
					rd_dataA, rd_dataB,
					//Inputs
					clk,
					wr_enA, wr_enB,
					addrA, addrB,					
					wr_dataA, wr_dataB
					);
	//Outputs
	output [7:0] rd_dataA, rd_dataB;
	//Inputs
	input clk;
	input wr_enA, wr_enB;
	input [4:0] addrA, addrB;
	input [7:0] wr_dataA, wr_dataB;
	
	reg [7:0] RAM [0:19];
	
	always @(posedge clk) begin
		if (wr_enA) RAM[addrA] <= wr_dataA;
		if (wr_enB) RAM[addrB] <= wr_dataB;
	end
	
	assign rd_dataA = RAM[addrA];
	assign rd_dataB = RAM[addrB];

endmodule
