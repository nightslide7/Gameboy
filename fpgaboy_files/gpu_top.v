`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:23:03 11/11/2013 
// Design Name: 
// Module Name:    gpu_top 
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
module gpu_top(//Outputs
					do_video,					//MMU Outputs
					mode_video,
					int_req,						//INT Outputs
					dvi_d, dvi_vs, dvi_hs,	//DIV Outputs
					dvi_xclk_p, dvi_xclk_n,	//DIV Outputs
					dvi_de, dvi_reset_b,		//DIV Outputs
					
					
					//Inouts
					dvi_sda, dvi_scl, 
					//Inputs
					clk27, clk33, clk100, top_rst_b,
					mem_enable_video, 		//MMU Inputs
					rd_n_video, wr_n_video, //MMU Inputs
					A_video, di_video,		//MMU Inputs
					int_ack, 					//INT Inputs
					
					
					
					//TEST
					led_out, iic_done, //TEST output
					switches78 //, clk,//TEST input
					);
		
	//Outputs
	output  [7:0]	do_video;			//MMU Outputs
	output  [1:0]	mode_video;
	output  [1:0] 	int_req;				//INT Outputs
	output [11:0] 	dvi_d;				//DIV Outputs
	output 			dvi_vs, dvi_hs, 	//DIV Outputs
						dvi_xclk_p, 		//DIV Outputs
						dvi_xclk_n, 		//DIV Outputs
						dvi_de, 				//DIV Outputs
						dvi_reset_b;		//DIV Outputs
	
	//Inouts
	inout dvi_sda, dvi_scl;
	
	//Inputs
	input clk27, clk33, clk100, top_rst_b;
	input mem_enable_video;		 		//MMU Inputs
	input rd_n_video, wr_n_video;		//MMU Inputs
	input [15:0]	A_video;				//MMU Inputs
	input  [7:0]	di_video;			//MMU Inputs
	input  [1:0]	int_ack;				//INT Inputs
	
	//TEST
	output led_out, iic_done; //TEST
	input [1:0] switches78; //TEST
	
	
	//
	// Video Module
	//
	wire gpuclk;
	wire gb_hsync, gb_vsync;
	wire[1:0] gb_pixel_data;
	wire[7:0] gb_pixel_count;
	wire[7:0] gb_line_count;
	wire[7:0] gb_pixel_cnt; // 0-454
	wire[7:0] sprite_x_pos;
	wire[7:0] sprite_y_pos;
	wire[6:0] sprite_num;
	wire[7:0] sprite_data1;
	wire[7:0] sprite_data2;
	wire[1:0] sprite_pixel;
	wire[1:0] bg_pixel;
	wire[7:0] oam_addrA;
	wire gb_pixel_we;
	
	wire  [7:0]	pixel_r, pixel_g, pixel_b;						
	wire			dvi_pixel_clk,				//31.5MHz
					dvi_sync_b,						
					dvi_blank_b,					
					hsync,							
					vsync,							
					gpuclk_rst_b;					
	
	video_module video(//Outputs
				.int_vblank_req(int_req[0]), 		//INT Outputs
				.int_lcdc_req(int_req[1]),   		//INT Outputs
				.hsync(gb_hsync),		  					//CONVERTER Outputs
				.vsync(gb_vsync), 						//CONVERTER Outputs
				.line_count(gb_line_count),			//CONVERTER Outputs
				.pixel_count(gb_pixel_cnt),  			//CONVERTER Outputs
				.pixel_data_count(gb_pixel_count), 	//CONVERTER Outputs
				.pixel_data(gb_pixel_data),			//CONVERTER Outputs
				.pixel_we(gb_pixel_we),					//CONVERTER Outputs
				.do(do_video),							//MMU Outputs
						  
							  //Inputs
				.reset(~top_rst_b), 					//reset is asserted High
				.clock(clk33), 						//33MHz clock
				.mem_enable(mem_enable_video), 	//MMU Inputs
				.rd_n(rd_n_video), 					//MMU Inputs
				.wr_n(wr_n_video), 					//MMU Inputs
				.A(A_video), 							//MMU Inputs
				.di(di_video),							//MMU Inputs
				.int_vblank_ack(int_ack[0]), 		//INT Inputs
				.int_lcdc_ack(int_ack[1]),			//INT Inputs
						  
							  //TESTING
				.mode(mode_video), 					//TEST Outputs
				.state(),//gb_state), 					//TEST Outputs
				.debug_out(), 							//TEST Outputs
				.sprite_y_pos(),//sprite_y_pos), 		//TEST Outputs
				.sprite_x_pos(),//sprite_x_pos), 		//TEST Outputs
				.sprite_num(),//sprite_num),			//TEST Outputs
				.sprite_data1(),//sprite_data1), 		//TEST Outputs
				.sprite_data2(),//sprite_data2), 		//TEST Outputs
				.sprite_pixel(),//sprite_pixel), 		//TEST Outputs
				.bg_pixel(),//bg_pixel), 				//TEST Outputs
				.oam_addrA()//oam_addrA)				//TEST Outputs
								);
	
	video_converter converter(
						//Outputs
				// run on clock
				.color( {pixel_r, pixel_g, pixel_b} ),	//DVI_MOD Outputs
				.pixel_clock(dvi_pixel_clk),//31.5MHz	//DVI_MOD Outputs
				//.sync_b(dvi_sync_b),							//DVI_MOD Outputs
				.blank_b(dvi_blank_b),						//DVI_MOD Outputs
				.hsync(hsync),									//DVI_MOD Outputs
				.vsync(vsync),									//DVI_MOD Outputs
				
						//Inputs
				.reset(~gpuclk_rst_b),//reset is asserted High
				.clock(gpuclk), 	//31.5MHz clock
				.gb_clock(clk33), 	//33MHz clock
				// run on gb_clock
				.pixel_data(gb_pixel_data), 				//VIDEO_MOD Inputs
				.gb_pixel_count(gb_pixel_count),			//VIDEO_MOD Inputs
				.gb_line_count(gb_line_count),			//VIDEO_MOD Inputs
				.gb_hsync(gb_hsync), 						//VIDEO_MOD Inputs		
				.gb_vsync(gb_vsync),							//VIDEO_MOD Inputs		
				.gb_we(gb_pixel_we)							//VIDEO_MOD Inputs		
				);
	
	dvi_module dvi(	
						//Outputs
				.dvi_vs(dvi_vs), 								//GPU Outputs
				.dvi_hs(dvi_hs),								//GPU Outputs
				.dvi_d(dvi_d),									//GPU Outputs
				.dvi_xclk_p(dvi_xclk_p), 					//GPU Outputs
				.dvi_xclk_n(dvi_xclk_n),					//GPU Outputs
				.dvi_de(dvi_de),								//GPU Outputs
				.dvi_reset_b(dvi_reset_b),					//GPU Outputs
				.iic_done(iic_done),							//TEST Outputs
	
						//Inouts
				.dvi_sda(dvi_sda),							//GPU Inouts
				.dvi_scl(dvi_scl),							//GPU Inouts
	
						//Inputs
				.pixel_clk(dvi_pixel_clk),					//31.5MHz clock
				.gpuclk_rst_b(gpuclk_rst_b), 							//Generated reset
				.hsync(hsync), 								//VIDEO_CONV Inputs
				.vsync(vsync), 								//VIDEO_CONV Inputs
				.blank_b(dvi_blank_b),							//VIDEO_CONV Inputs
				.pixel_r(pixel_r), 							//VIDEO_CONV Inputs
				.pixel_b(pixel_b), 							//VIDEO_CONV Inputs
				.pixel_g(pixel_g )							//VIDEO_CONV Inputs
				);
					
	ugly_setup setup(	
						//Outputs
				.gpuclk(gpuclk), // 31.5 MHz clock
				.gpuclk_rst_b(gpuclk_rst_b),
//				gpuclk_ready,
						//Inputs
				.clk100(clk100), // 100 MHz clock
				.clk27(clk27), // 27 MHz clock
				.top_rst_b(top_rst_b)
				);

endmodule
