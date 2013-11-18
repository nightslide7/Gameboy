`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:32:40 11/13/2013 
// Design Name: 
// Module Name:    pixclk_dcm 
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
module clk31p5_dcm(//outputs
						clk31p5, ready,
						//inputs
						clk27, rst );
	
	//outputs
	output clk31p5; //31.5MHz
	output ready;
	
	//inputs
	input clk27; //27MHz clock
	input rst; // Asynchronous active High reset
	 
	wire locked, clk0, clkfx;
	
	assign ready = locked;

	BUFG CLK2X_BUFG_INST (.I(clkfx),
								 .O(clk31p5));
								 
	DCM_BASE DCM_31p5_INST (.CLKIN(clk27),
								 .CLKFB(clk0),
								 .CLK0(clk0),
								 .RST(rst),
								 .CLKFX(clkfx),
								 .LOCKED(locked));
								 
	defparam DCM_31p5_INST.CLKFX_MULTIPLY = 7;
	defparam DCM_31p5_INST.CLKFX_DIVIDE = 6;
	defparam DCM_31p5_INST.CLK_FEEDBACK = "1X";
	defparam DCM_31p5_INST.CLKIN_PERIOD = 37.037; //clk27's period in ns
	defparam DCM_31p5_INST.CLKOUT_PHASE_SHIFT = "NONE";
	defparam DCM_31p5_INST.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam DCM_31p5_INST.DFS_FREQUENCY_MODE = "LOW";
	defparam DCM_31p5_INST.DLL_FREQUENCY_MODE = "LOW";
	defparam DCM_31p5_INST.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam DCM_31p5_INST.FACTORY_JF = 16'hF0F0;
	defparam DCM_31p5_INST.PHASE_SHIFT = 0;
	defparam DCM_31p5_INST.STARTUP_WAIT = "TRUE";

endmodule
