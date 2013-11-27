`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:58 10/28/2013 
// Design Name: 
// Module Name:    tb 
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
module tb(input clka,
			 input wea,
			 input [14:0] addra,
			 input [7:0] dina,
			 output [7:0] douta
    );
	 
dram drm(
  .clka(clka), // input clka
  .wea(wea), // input [0 : 0] wea
  .addra(addra), // input [14 : 0] addra
  .dina(dina), // input [7 : 0] dina
  .douta(douta)); // output [7 : 0] douta
endmodule
