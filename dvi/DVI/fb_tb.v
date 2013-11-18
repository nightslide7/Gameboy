`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:01 10/11/2013 
// Design Name: 
// Module Name:    fb_tb 
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
module fb_tb();
  
	wire dvi_vs, dvi_hs;
	wire dvi_xclk_p, dvi_xclk_n;
	wire dvi_de, dvi_reset_b;
	wire dvi_sda, dvi_scl;
	wire [11:0] dvi_d; 
	
	wire led_out, iic_done; //TEST
   
	reg fclk, fclk_rst_b; 
	
   initial fclk = 0;
   always #5 fclk = ~fclk;
   
   fb_top top( //Outputs
					.dvi_vs (dvi_vs),
					.dvi_hs (dvi_hs), 
					.dvi_d (dvi_d), 
					.dvi_xclk_p (dvi_xclk_p),
					.dvi_xclk_n (dvi_xclk_n),
					.dvi_de (dvi_de), 
					.dvi_reset_b (dvi_reset_b), 
					
					.led_out (led_out), .iic_done (iic_done), //TEST
					
					//Inout
					.dvi_sda (dvi_sda), 
					.dvi_scl (dvi_scl), 
					//Input
					.fclk (fclk), 
					.fclk_rst_b (fclk_rst_b)
					 );
	
   initial begin
      fclk_rst_b = 0;
      repeat (10000) @(posedge fclk);
      fclk_rst_b = 1;
      repeat (100000) @(posedge fclk);
      #1 $finish;
   end


endmodule
