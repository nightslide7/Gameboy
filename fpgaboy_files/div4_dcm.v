`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:20:58 11/11/2013 
// Design Name: 
// Module Name:    div4_dcm 
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
module div4_dcm(//outputs
					clk_div4, ready,
					//inputs
					clk, rst );
	
	//outputs
	output clk_div4, ready;
	//inputs
	input clk, rst; //asynchronous active High reset
	 
	wire locked, clk0, clkdv;
	
	assign ready = locked;

	BUFG CLKDV_BUFG_INST (.I(clkdv),
								 .O(clk_div4));
								 
	DCM_BASE DCM_DIV4_INST (.CLKIN(clk),
								 .CLKFB(clk0),
								 .CLK0(clk0),
								 .RST(rst),
								 .CLKDV(clkdv),
								 .LOCKED(locked));
								 
	defparam DCM_DIV4_INST.CLK_FEEDBACK = "1X";
	defparam DCM_DIV4_INST.CLKDV_DIVIDE = 4;
	defparam DCM_DIV4_INST.CLKIN_DIVIDE_BY_2 = "FALSE";
	defparam DCM_DIV4_INST.CLKIN_PERIOD = 10.000; //nanoseconds
	defparam DCM_DIV4_INST.CLKOUT_PHASE_SHIFT = "NONE";
	defparam DCM_DIV4_INST.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam DCM_DIV4_INST.DFS_FREQUENCY_MODE = "LOW";
	defparam DCM_DIV4_INST.DLL_FREQUENCY_MODE = "LOW";
	defparam DCM_DIV4_INST.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam DCM_DIV4_INST.FACTORY_JF = 16'hF0F0;
	defparam DCM_DIV4_INST.PHASE_SHIFT = 0;
	defparam DCM_DIV4_INST.STARTUP_WAIT = "TRUE";

endmodule
