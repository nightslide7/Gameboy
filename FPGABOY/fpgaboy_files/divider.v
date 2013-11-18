`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:28:01 11/11/2013 
// Design Name: 
// Module Name:    divider 
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
module divider #(parameter DELAY=50000000) 
	(//Input
	 reset, clock,
	 //Output
	 enable);
	
	//Input
	input wire reset;
	input wire clock;
	//Output
	output wire enable;
  
	reg [31:0] count;
	wire [31:0] next_count;

	always @(posedge clock) begin
		if (reset)
			count <= 32'b0;
		else
			count <= next_count;
	end
  
	assign enable = (count == DELAY - 1) ? 1'b1 : 1'b0;
	assign next_count = (count == DELAY - 1) ? 32'b0 : count + 1;

endmodule
