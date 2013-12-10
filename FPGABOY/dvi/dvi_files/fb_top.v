`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:30:57 10/12/2013 
// Design Name: 
// Module Name:    fb_top 
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
module fb_top(dvi_vs, dvi_hs, dvi_d, dvi_xclk_p,
   dvi_xclk_n, dvi_de, dvi_reset_b,
	
	led_out, iic_done, fbclk_ready, //TEST
	
	switches78, clk,//TEST
	
	dvi_sda, dvi_scl, 
	fclk, fclk_rst_b);

	output dvi_vs, dvi_hs; 
	output [11:0] dvi_d;
	output dvi_xclk_p, dvi_xclk_n, dvi_de, dvi_reset_b;
	
	output led_out, iic_done, fbclk_ready; //TEST
	input [1:0] switches78; //TEST
	input clk; //TEST
	wire fake_clk; //TEST
	
	inout dvi_sda, dvi_scl;
	
	input fclk, fclk_rst_b;
	
	localparam IODELAY_GRP = "IODELAY_MIG";
	localparam RST_SYNC_NUM = 25;
	
	//wire usrclk;
	wire fbclk;
	assign fbclk = clk; //TEST
	reg [RST_SYNC_NUM-1:0]     rst200_sync_r;
	wire rst200, clk200, clk200_ready, idelay_ctrl_rdy;
	//wire fclk_rst_b;//, fbclk_ready;
	//wire fclk, fclk_rst_b, fbclk_ready;
	
	//IBUF IBUF_INST (.I(fclk_rst),
	//					 .O(fclk_rst_b));
								 
	wire fbclk_rst_cause_b = (fbclk_ready) & fclk_rst_b;
	
	reg [15:0] fbclk_rst_b_seq = 16'h0000;
	
	wire fbclk_rst_b = fbclk_rst_b_seq[15];
	
	always @(posedge fbclk or negedge fbclk_rst_cause_b)
		if (!fbclk_rst_cause_b)
			fbclk_rst_b_seq <= 16'h0000;
		else
			fbclk_rst_b_seq <= {fbclk_rst_b_seq[14:0], 1'b1};

   Framebuffer fb(/*AUTOARG*/
		// Outputs
		.dvi_vs (dvi_vs), 
		.dvi_hs (dvi_hs), 
		.dvi_d (dvi_d),
		.dvi_xclk_p (dvi_xclk_p), 
		.dvi_xclk_n (dvi_xclk_n), 
		.dvi_de (dvi_de), 
		.dvi_reset_b (dvi_reset_b),
		
		.led_out (led_out), .iic_done (iic_done),//TEST
		
		// Inouts
		.dvi_sda (dvi_sda), 
		.dvi_scl (dvi_scl),
		
		// Inputs
		.switches78 (switches78), //TEST
		.fbclk (fbclk),
		.fbclk_rst_b (fbclk_rst_b),
		.fbclk_ready (fbclk_ready)
);

	FBDCM fbdcm(.fclk(fclk),//clk),//fclk),
		.fbclk(fake_clk),//fbclk),
		.rst(~fclk_rst_b),		
		.ready(fbclk_ready));		
		
	CLK200DCM clk200dcm(.fclk(fclk),
		.clk200(clk200),
		.rst(~fclk_rst_b),		
		.ready(clk200_ready));
		
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
	
	always @(posedge clk200 or negedge fclk_rst_b)//locked)
    if (!fclk_rst_b)//locked)
      rst200_sync_r <= {RST_SYNC_NUM{1'b1}};
    else
      rst200_sync_r <= rst200_sync_r << 1;
		
	assign rst200  = rst200_sync_r[RST_SYNC_NUM-1];
	
endmodule
/*
module FBDCM(input fclk, output fbclk, input rst, output ready);

	wire locked, clk0, clkdv;
	assign ready = locked;

	BUFG CLKDV_BUFG_INST (.I(clkdv),
								 .O(fbclk));
								 
	DCM_BASE DCM_SP_INST (.CLKIN(fclk),
								 .CLKFB(clk0),
								 .CLK0(clk0),
								 .RST(rst),
								 .CLKDV(clkdv),
								 .LOCKED(locked));
								 
	defparam DCM_SP_INST.CLK_FEEDBACK = "1X";
	defparam DCM_SP_INST.CLKDV_DIVIDE = 5;
	defparam DCM_SP_INST.CLKIN_DIVIDE_BY_2 = "FALSE";
	defparam DCM_SP_INST.CLKIN_PERIOD = 8.000;
	defparam DCM_SP_INST.CLKOUT_PHASE_SHIFT = "NONE";
	defparam DCM_SP_INST.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam DCM_SP_INST.DFS_FREQUENCY_MODE = "LOW";
	defparam DCM_SP_INST.DLL_FREQUENCY_MODE = "LOW";
	defparam DCM_SP_INST.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam DCM_SP_INST.FACTORY_JF = 16'hF0F0;
	defparam DCM_SP_INST.PHASE_SHIFT = 0;
	defparam DCM_SP_INST.STARTUP_WAIT = "TRUE";
	
endmodule
*/