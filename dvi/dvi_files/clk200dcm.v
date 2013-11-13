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
module CLK200DCM(	//outputs
					clk200, ready,
					//inputs
					fclk, rst );
	
	//outputs
	output clk200, ready;
	//inputs
	input fclk, rst;
	 
	wire locked, clk0, clk2x;
	
	assign ready = locked;

	BUFG CLK2X_BUFG_INST (.I(clk2x),
								 .O(clk200));
								 
	DCM_BASE DCM_SP_INST (.CLKIN(fclk),
								 .CLKFB(clk0),
								 .CLK0(clk0),
								 .RST(rst),
								 .CLK2X(clk2x),
								 .LOCKED(locked));
								 
	defparam DCM_SP_INST.CLK_FEEDBACK = "1X";
	//defparam DCM_SP_INST.CLKDV_DIVIDE = 4;
	//defparam DCM_SP_INST.CLKIN_DIVIDE_BY_2 = "FALSE";
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
