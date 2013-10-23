`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:51 10/15/2013 
// Design Name: 
// Module Name:    FBDCM 
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
module FBDCM(	//outputs
					fbclk, ready,
					//inputs
					fclk, rst );
	
	//outputs
	output fbclk, ready;
	//inputs
	input fclk, rst;
	 
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
	defparam DCM_SP_INST.CLKDV_DIVIDE = 4;
	defparam DCM_SP_INST.CLKIN_DIVIDE_BY_2 = "FALSE";
	defparam DCM_SP_INST.CLKIN_PERIOD = 10.000;
	defparam DCM_SP_INST.CLKOUT_PHASE_SHIFT = "NONE";
	defparam DCM_SP_INST.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam DCM_SP_INST.DFS_FREQUENCY_MODE = "LOW";
	defparam DCM_SP_INST.DLL_FREQUENCY_MODE = "LOW";
	defparam DCM_SP_INST.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam DCM_SP_INST.FACTORY_JF = 16'hF0F0;
	defparam DCM_SP_INST.PHASE_SHIFT = 0;
	defparam DCM_SP_INST.STARTUP_WAIT = "TRUE";

	
endmodule
