`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:52:13 11/13/2013 
// Design Name: 
// Module Name:    ddr2_idelay_ctrl_mod 
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
module ddr2_idelay_ctrl_mod( //Inputs
									  clk_100MHz, rst_b );
	
	parameter IODELAY_GRP = "IODELAY_GRP";
	parameter RST_SYNC_NUM = 25;
	
	//Inputs
	input clk_100MHz, rst_b;

	reg [RST_SYNC_NUM-1:0] rst200_sync_r;
	wire clk200, rst200;
	wire clk200_ready, idelay_ctrl_rdy;
								 
	// Generate 200MHz clock
	x2_dcm x2(	//Outputs
					.x2_clk(clk200), 
					.ready(clk200_ready),
					//Inputs
					.clk100(clk_100MHz),
					.rst(~rst_b) //rst is active High
					);
	
	// ddr2_idelay_ctrl
	ddr2_idelay_ctrl #
   (
    .IODELAY_GRP (IODELAY_GRP)
   )
   u_ddr2_idelay_ctrl
   (
   .rst200 (rst200),
   .clk200 (clk200),
   .idelay_ctrl_rdy (idelay_ctrl_rdy)
   );																				
	
	always @(posedge clk200 or negedge rst_b)
		if (!rst_b) rst200_sync_r <= {RST_SYNC_NUM{1'b1}};
		else rst200_sync_r <= rst200_sync_r << 1;
		
	assign rst200  = rst200_sync_r[RST_SYNC_NUM-1];

endmodule
