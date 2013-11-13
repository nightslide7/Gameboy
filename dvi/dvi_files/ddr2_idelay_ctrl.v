`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:43:11 10/25/2013 
// Design Name: 
// Module Name:    ddr2_idelay_ctrl 
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

module ddr2_idelay_ctrl #
  (
   // Following parameters are for 72-bit RDIMM design (for ML561 Reference
   // board design). Actual values may be different. Actual parameters values
   // are passed from design top module mig module. Please refer to
   // the mig module for actual values.
   parameter IODELAY_GRP = "IODELAY_MIG"
   )

  (//outputs
	idelay_ctrl_rdy,
   //inputs
   clk200, rst200);

	output idelay_ctrl_rdy;
	input clk200, rst200;
	
  (* IODELAY_GROUP = IODELAY_GRP *) IDELAYCTRL u_idelayctrl
    (
     .RDY(idelay_ctrl_rdy),
     .REFCLK(clk200),
     .RST(rst200)
     );

endmodule