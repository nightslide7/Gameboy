`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:14 11/09/2013 
// Design Name: 
// Module Name:    video_converter 
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

// Converter just takes the original image and translates it into about
// the middle of the screen.
module video_converter( //Outputs
						// run on clock
						color, pixel_clock, 	//DVI_MOD Outputs
						//sync_b, 					//DVI_MOD Outputs
						blank_b,					//DVI_MOD Outputs
						hsync, vsync,			//DVI_MOD Outputs

								//Inputs
						reset, //~gpuclk_rst_b from setup
						clock, //clk31p5 31.5MHz clock (gpuclk)
						gb_clock, //clk33 33MHz clock
						// run on gb_clock
						pixel_data, 							//VIDEO_MOD Inputs
						gb_pixel_count, gb_line_count,	//VIDEO_MOD Inputs
						gb_hsync, gb_vsync, gb_we			//VIDEO_MOD Inputs								
							);

	//Outputs
	// run on clock
	output wire[23:0] color; 			//DVI_MOD Outputs
	output wire pixel_clock; 			//DVI_MOD Outputs
//	output wire sync_b, blank_b;
	output wire blank_b;					//DVI_MOD Outputs
	output wire hsync, vsync;			//DVI_MOD Outputs
	
	//Inputs
	input reset, clock, gb_clock;
	// run on gb_clock
	input [1:0] pixel_data; 							//VIDEO_MOD Inputs
	input [7:0] gb_pixel_count, gb_line_count;	//VIDEO_MOD Inputs
	input gb_hsync, gb_vsync, gb_we;					//VIDEO_MOD Inputs		

	// game boy screen size
	parameter GB_SCREEN_WIDTH = 10'd160;
	parameter GB_SCREEN_HEIGHT = 10'd144;

	// toggle for which is the front buffer
	// 0 -> buffer1 is front buffer
	// 1 -> buffer2 is front buffer
	reg front_buffer;

	//wire[14:0] read_addr;
	wire[14:0] write_addr;
	wire[1:0] read_data;
	//wire[1:0] write_data;
	wire[14:0] b1_addr;
	wire b1_clk;
	wire[1:0] b1_din;
	wire[1:0] b1_dout;
	wire b1_we; // active high

	wire[14:0] b2_addr;
	wire b2_clk;
	wire[1:0] b2_din;
	wire[1:0] b2_dout;
	wire b2_we; // active high
	
	reg[1:0] last_pixel_data;
	reg[14:0] last_write_addr;

	reg write_enable;

	assign b1_we = front_buffer ? (gb_we) : 0;
	assign b2_we = front_buffer ? 0 : (gb_we);

	assign read_data = (front_buffer) ? b2_dout : b1_dout;
	//assign pixel_data = (front_buffer) ? b1_din : b2_din;
	assign b1_din = (front_buffer) ? pixel_data : 0;
	assign b2_din = (front_buffer) ? 0 : pixel_data;

	// If front_buffer, buffer1 clk is gb_clock
	// otherwise is pixel_clock
	BUFGMUX clock_mux_b1(.S(front_buffer), .O(b1_clk),
								.I0(clock), .I1(gb_clock));

	// If front_buffer, buffer2 clk is pixel_clock
	// otherwise, is gb_clock
	BUFGMUX clock_mux_b2(.S(front_buffer), .O(b2_clk),
								.I0(gb_clock), .I1(clock));

	// internal buffer ram
	frame_buffer buffer1(
					//Outputs
					.dout(b1_dout), //[1:0]
					//Inputs
					.clk(b1_clk),
					.we(b1_we),
					.din(b1_din), //[1:0]
					.addr(b1_addr) //[14:0] to be able to hold 160*144 pix
					);

	frame_buffer buffer2(
					//Outputs
					.dout(b2_dout), //[1:0]
					//Inputs
					.clk(b2_clk),
					.we(b2_we),
					.din(b2_din), //[1:0]
					.addr(b2_addr) //[14:0] to be able to hold 160*144 pix
					);

	reg gb_last_vsync;
	reg gb_last_hsync;

	// handle writing into the back_buffer
	always @ (posedge gb_clock) begin
		if(reset) begin
			front_buffer <= 0;
			gb_last_vsync <= 0;
		end else begin
			gb_last_vsync <= gb_vsync;
		end

		// detect positive vsync edge
		if(~gb_last_vsync && gb_vsync) begin
			front_buffer <= ~front_buffer;
		end
	end


	// detect vsync edge
	// handle output to the vga module
	wire my_hsync, my_vsync;
	//wire [9:0] pixel_count, line_count;
	wire [11:0] pixel_count, line_count;
//	vga_controller vgac(clock, reset, my_hsync, my_vsync, pixel_count, line_count);

	wire border;
	sync_gen dvi_sync(//Outputs
						.vs(my_vsync),
						.hs(my_hsync),
						.border(border),
						.x(pixel_count),
						.y(line_count),
							//Inputs
						.gpuclk(clock),
						.gpuclk_rst_b(~reset)
							);
	// write to our current counter
	//assign write_addr = my_line_count * 160 + my_pixel_count;
	assign write_addr = gb_line_count * 160 + gb_pixel_count;

	parameter X_OFFSET = 160;
	parameter Y_OFFSET = 76;

	// read from where the dvi wants to read from the buffer
	wire[14:0] buffer_pos = ((line_count - Y_OFFSET) >> 1) * 160 + 
									((pixel_count - X_OFFSET) >> 1);

	assign b1_addr = (front_buffer) ? write_addr : buffer_pos;
	assign b2_addr = (front_buffer) ? buffer_pos : write_addr;

	// delay the outputs by two clocks
	reg [2:0] hdelay, vdelay;
	
	always @ (posedge clock) begin
		if(reset) begin
			hdelay <= 3'b111;
			vdelay <= 3'b111;
		end else begin
			hdelay <= {hdelay[1:0], my_hsync};
			vdelay <= {vdelay[1:0], my_vsync};
		end
	end
	
	// generate a gameboy color
	// 00 -> white
	// 01 -> light gray
	// 10 -> dark gray
	// 11 -> black

	wire [7:0] my_color = (pixel_count >= X_OFFSET && 
								line_count >= Y_OFFSET && 
								pixel_count < X_OFFSET + 320 && 
								line_count < Y_OFFSET + 288) ? 
								
								(read_data == 2'b00) ? 8'hFF: //white
								((read_data == 2'b01) ? 8'hAA: //light gray
								((read_data == 2'b10) ? 8'h55: //dark gray
								8'h00)) : 8'h00; //black
								
	assign color[7:0] = my_color;
	assign color[15:8] = my_color;
	assign color[23:16] = my_color;
	
	//assign sync_b = hdelay[2] ^ vdelay[2];
	assign blank_b = ~border; //(pixel_count[9:0] < 640) && (line_count[9:0] < 480);
	assign pixel_clock = ~clock;

	assign hsync = hdelay[2];
	assign vsync = vdelay[2];
	
endmodule




