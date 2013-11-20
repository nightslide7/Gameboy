`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:59:17 11/18/2013 
// Design Name: 
// Module Name:    gpu_tb 
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
module gpu_tb();
	
	//GPU Outputs
	wire  [7:0]	do_video;			//MMU Outputs
	wire  [1:0]	mode_video;
	wire  [1:0] int_req;				//INT Outputs
	wire [11:0] dvi_d;				//DIV Outputs
	wire 			dvi_vs, dvi_hs, 	//DIV Outputs
					dvi_xclk_p, 		//DIV Outputs
					dvi_xclk_n, 		//DIV Outputs
					dvi_de, 				//DIV Outputs
					dvi_reset_b;		//DIV Outputs
	
	//GPU Inouts
	wire dvi_sda, dvi_scl;
	
	//GPU Inputs
	wire clk27, clk33, clk100, top_rst_b;
	reg mem_enable_video;		 		// asserted anytime want to interact with GPU memory
	reg rd_n_video, wr_n_video;		//read and write enable (active low)
	// address (if has to do with GPU memory, will be routed to the right place)
	reg [15:0]	A_video;				
	reg  [7:0]	di_video;			// write data
	reg  [1:0]	int_ack;				// interrupt ack
	
	//GPU TEST
	wire led_out, iic_done, fbclk_ready; //TEST
	reg [1:0] switches78; //TEST
	
	gpu_top dut(	//Outputs
				.do_video(do_video),					//MMU Outputs
				.mode_video(mode_video),
				.int_req(int_req),						//INT Outputs
				.dvi_d(dvi_d), 						//DIV Outputs
				.dvi_vs(dvi_vs), 						//DIV Outputs
				.dvi_hs(dvi_hs),						//DIV Outputs
				.dvi_xclk_p(dvi_xclk_p), 				//DIV Outputs
				.dvi_xclk_n(dvi_xclk_n),					//DIV Outputs
				.dvi_de(dvi_de), 						//DIV Outputs
				.dvi_reset_b(dvi_reset_b),				//DIV Outputs
					
				//Inouts
				.dvi_sda(dvi_sda), 
				.dvi_scl(dvi_scl), 
				
				//Inputs
				.clk27(clk27), 
				.clk33(clk33), 
				.clk100(clk100), 
				.top_rst_b(top_rst_b),
				.mem_enable_video(mem_enable_video), 		//MMU Inputs
				.rd_n_video(rd_n_video), //MMU Inputs
				.wr_n_video(wr_n_video), //MMU Inputs
				.A_video(A_video), //MMU Inputs
				.di_video(di_video),		//MMU Inputs
				.int_ack(int_ack), 					//INT Inputs
									
				//TEST
				.led_out(led_out), //TEST input
				.iic_done(iic_done), //TEST input
				.switches78(switches78) //TEST input
				);
	
	reg clk; //1MHz clock
	reg clk_rst_b;
	
	//Generate 1MHz clock
	initial clk = 0;
	always #500 clk = ~clk; //1MHz clock
	
	wire clk27_ready;
	mult_dcm #(.FREQ(27)) clk27MHz(
				//Outputs
				.clk_out(clk27), //27MHz
				.ready(clk27_ready),
				//Inputs
				.clk1(clk), //1MHz clock
				.rst(~clk_rst_b) //rst is active High
				);
	
	wire clk11, clk11_ready;
	mult_dcm #(.FREQ(11)) clk11MHz(
				//Outputs
				.clk_out(clk11), //11MHz
				.ready(clk11_ready),
				//Inputs
				.clk1(clk), //1MHz clock
				.rst(~clk_rst_b) //rst is active High
				);
				
	wire clk33_ready;
	reg clk33_rst_b;
	clk33_dcm clk33MHz(
				//Outputs
				.clk33(clk33), //33MHz
				.ready(clk33_ready),
				//Inputs
				.clk11(clk11), //11MHz clock
				.rst(~clk33_rst_b) //rst is active High
				);
	
	wire clk25, clk25_ready;
	mult_dcm #(.FREQ(25)) clk25MHz(
				//Outputs
				.clk_out(clk25), //25MHz
				.ready(clk25_ready),
				//Inputs
				.clk1(clk), //1MHz clock
				.rst(~clk_rst_b) //rst is active High
				);
	
	wire clk100_ready;
	reg clk100_rst_b;
	clk100_dcm clk100MHz(
				//Outputs
				.clk100(clk100), //27MHz
				.ready(clk100_ready),
				//Inputs
				.clk25(clk25), //25MHz clock
				.rst(~clk100_rst_b) //rst is active High
				);
	
	assign top_rst_b = clk27_ready & clk33_ready & clk100_ready;
	
	initial begin
		mem_enable_video = 0;
		rd_n_video = 1;
		wr_n_video = 1;
		A_video = 0;
		di_video = 0;
		int_ack = 0;
		clk_rst_b = 0;
		repeat (4) @(posedge clk);
		clk_rst_b = 1;
		repeat (15) @(posedge clk);
		clk100_rst_b = 1;
		clk33_rst_b = 1;
		repeat (4) @(posedge clk);
		repeat (200) @(posedge clk);
		$finish;		
	end


endmodule
