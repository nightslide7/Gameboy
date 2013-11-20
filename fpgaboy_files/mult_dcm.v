`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:51:14 11/18/2013 
// Design Name: 
// Module Name:    mult_dcm 
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
module mult_dcm(//outputs
						clk_out, ready,
						//inputs
						clk1, rst );
	
	parameter FREQ = 1;
	
	//outputs
	output clk_out; //1*freq MHz
	output ready;
	
	//inputs
	input clk1; //1MHz clock
	input rst; // Asynchronous active High reset
	 
	wire locked, clk0, clkfx;
	
	assign ready = locked;

	BUFG CLK_BUFG_INST (.I(clkfx),
								 .O(clk_out));
								 
	DCM_BASE DCM_MULT_INST (.CLKIN(clk1),
								 .CLKFB(clk0),
								 .CLK0(clk0),
								 .RST(rst),
								 .CLKFX(clkfx),
								 .LOCKED(locked));
								 
	defparam DCM_MULT_INST.CLKFX_MULTIPLY = FREQ;
	defparam DCM_MULT_INST.CLKFX_DIVIDE = 1;
	defparam DCM_MULT_INST.CLK_FEEDBACK = "1X";
	defparam DCM_MULT_INST.CLKIN_PERIOD = 1000; //clk1's period in ns
	defparam DCM_MULT_INST.CLKOUT_PHASE_SHIFT = "NONE";
	defparam DCM_MULT_INST.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam DCM_MULT_INST.DFS_FREQUENCY_MODE = "LOW";
	defparam DCM_MULT_INST.DLL_FREQUENCY_MODE = "LOW";
	defparam DCM_MULT_INST.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam DCM_MULT_INST.FACTORY_JF = 16'hF0F0;
	defparam DCM_MULT_INST.PHASE_SHIFT = 0;
	defparam DCM_MULT_INST.STARTUP_WAIT = "TRUE";

endmodule
