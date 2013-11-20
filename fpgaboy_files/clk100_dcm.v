`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:09:00 11/18/2013 
// Design Name: 
// Module Name:    clk100_dcm 
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
module clk100_dcm(//outputs
						clk100, ready,
						//inputs
						clk25, rst );
	
	//outputs
	output clk100; //100MHz clock
	output ready;
	
	//inputs
	input clk25; //25MHz clock
	input rst; // Asynchronous active High reset
	 
	wire locked, clk0, clkfx;
	
	assign ready = locked;

	BUFG CLK_BUFG_INST (.I(clkfx),
								 .O(clk100));
								 
	DCM_BASE DCM_MULT_INST (.CLKIN(clk25),
								 .CLKFB(clk0),
								 .CLK0(clk0),
								 .RST(rst),
								 .CLKFX(clkfx),
								 .LOCKED(locked));
								 
	defparam DCM_MULT_INST.CLKFX_MULTIPLY = 4;
	defparam DCM_MULT_INST.CLKFX_DIVIDE = 1;
	defparam DCM_MULT_INST.CLK_FEEDBACK = "1X";
	defparam DCM_MULT_INST.CLKIN_PERIOD = 40; //clk25's period in ns
	defparam DCM_MULT_INST.CLKOUT_PHASE_SHIFT = "NONE";
	defparam DCM_MULT_INST.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam DCM_MULT_INST.DFS_FREQUENCY_MODE = "LOW";
	defparam DCM_MULT_INST.DLL_FREQUENCY_MODE = "LOW";
	defparam DCM_MULT_INST.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam DCM_MULT_INST.FACTORY_JF = 16'hF0F0;
	defparam DCM_MULT_INST.PHASE_SHIFT = 0;
	defparam DCM_MULT_INST.STARTUP_WAIT = "TRUE";

endmodule
