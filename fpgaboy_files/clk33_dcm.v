`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:49:51 11/19/2013 
// Design Name: 
// Module Name:    clk33_dcm 
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
module clk33_dcm(//outputs
						clk33, ready,
						//inputs
						clk11, rst );
	
	//outputs
	output clk33; //33MHz clock
	output ready;
	
	//inputs
	input clk11; //11MHz clock
	input rst; // Asynchronous active High reset
	 
	wire locked, clk0, clkfx;
	
	assign ready = locked;

	BUFG CLK_BUFG_INST (.I(clkfx),
								 .O(clk33));
								 
	DCM_BASE DCM_MULT_INST (.CLKIN(clk11),
								 .CLKFB(clk0),
								 .CLK0(clk0),
								 .RST(rst),
								 .CLKFX(clkfx),
								 .LOCKED(locked));
								 
	defparam DCM_MULT_INST.CLKFX_MULTIPLY = 3;
	defparam DCM_MULT_INST.CLKFX_DIVIDE = 1;
	defparam DCM_MULT_INST.CLK_FEEDBACK = "1X";
	defparam DCM_MULT_INST.CLKIN_PERIOD = 90.909; //clk11's period in ns
	defparam DCM_MULT_INST.CLKOUT_PHASE_SHIFT = "NONE";
	defparam DCM_MULT_INST.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam DCM_MULT_INST.DFS_FREQUENCY_MODE = "LOW";
	defparam DCM_MULT_INST.DLL_FREQUENCY_MODE = "LOW";
	defparam DCM_MULT_INST.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam DCM_MULT_INST.FACTORY_JF = 16'hF0F0;
	defparam DCM_MULT_INST.PHASE_SHIFT = 0;
	defparam DCM_MULT_INST.STARTUP_WAIT = "TRUE";

endmodule
