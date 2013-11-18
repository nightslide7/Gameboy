`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:16:12 11/13/2013 
// Design Name: 
// Module Name:    ugly_setup 
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

// FROM FRAMEBUFFER:
// gpuclk = fbclk
// gpuclk_rst_b = fbclk_rst_b
// gpuclk_ready = fbclk_ready
// clk = fclk
// top_rst_b = fclk_rst_b
module ugly_setup(//Outputs
						gpuclk, // 31.5 MHz clock
						gpuclk_rst_b,

						//Inputs
						clk27, 	// 27 MHz clock
						clk100, // 100 MHz clock
						top_rst_b
    );

	//Outputs
	output wire gpuclk; //31.5 MHz clock
	output wire gpuclk_rst_b;
	
	//Inputs
	input clk27; 	// 27 MHz clock
	input clk100; 	// 100 MHz clock
	input top_rst_b;
	
	localparam IODELAY_GRP = "IODELAY_MIG";
	localparam RST_SYNC_NUM = 25;
	
	wire gpuclk_ready;
	
	wire gpuclk_rst_cause_b = gpuclk_ready & top_rst_b;
	reg [15:0] gpuclk_rst_b_seq = 16'h0000;
	
	assign gpuclk_rst_b = gpuclk_rst_b_seq[15];
	
	// After top reset, wait 16 gpuclk ticks before gpuclk_rst_b is active
	always @(posedge gpuclk or negedge gpuclk_rst_cause_b) //gpuclk_rst_cause_b)
		if (!gpuclk_rst_cause_b)
			gpuclk_rst_b_seq <= 16'h0000;
		else
			gpuclk_rst_b_seq <= {gpuclk_rst_b_seq[14:0], 1'b1};
	
	// Generate 31.5MHz clock
	wire clk31p5_ready;
	wire clk31p5;
	clk31p5_dcm clk31p5_dcm_inst(
						//Outputs
				.clk31p5(clk31p5),
				.ready(clk31p5_ready),
						//Inputs
				.clk27(clk27), 
				.rst(~top_rst_b) // rst is active High
				);
	assign gpuclk = clk31p5;
	assign gpuclk_ready = clk31p5_ready;
	
	// DDR2_IDELAY_CTRL
	ddr2_idelay_ctrl_mod #(//Parameters
								  .IODELAY_GRP(IODELAY_GRP),
								  .RST_SYNC_NUM(RST_SYNC_NUM))
	idelay_ctrl_mod(	//Inputs
							.clk_100MHz(clk100),
							.rst_b(top_rst_b)
							);

/*			
	// Generate 25MHz clock
	wire clk25;
	wire clk25_ready;
	div4_dcm clk25_dcm(//Outputs
							.clk_div4(clk25),
							.ready(clk25_ready),
							 //Inputs
							.clk(clk), 
							.rst(~top_rst_b) //rst is active High
							);

	assign gpuclk = clk25;
	assign gpuclk_ready = clk25_ready;
*/							
endmodule
