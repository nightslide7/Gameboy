`default_nettype none
`timescale 1ns / 1ps
  module video_converter(
			 input wire reset,
			 input wire clock,
			 input wire gb_clock,
			 // run on gb_clock
			 input wire[1:0] pixel_data,
			 input wire[7:0] gb_pixel_count,
			 input wire[7:0] gb_line_count,
			 input wire gb_hsync, // active high
			 input wire gb_vsync, // active high
			 input wire gb_we,

			 // run on clock
			 output wire[23:0] color,
			 output wire sync_b,
			 output wire blank_b,
			 output wire pixel_clock,
			 output wire hsync,
			 output wire vsync
			 );
   // game boy screen size
   parameter GB_SCREEN_WIDTH = 10'd160;
   parameter GB_SCREEN_HEIGHT = 10'd144;
   // toggle for which is the front buffer
   // 0 -> buffer1 is front buffer
   // 1 -> buffer2 is front buffer
   reg 				     front_buffer;
   //wire[14:0] read_addr;
   wire [14:0] 			     write_addr;
   wire [1:0] 			     read_data;
   //wire[1:0] write_data;
   wire [14:0] 			     b1_addr;
   wire 			     b1_clk;
   wire [1:0] 			     b1_din;
   wire [1:0] 			     b1_dout;
   wire 			     b1_we;   // active high
   wire [14:0] 			     b2_addr;
   wire 			     b2_clk;
   wire [1:0] 			     b2_din;
   wire [1:0] 			     b2_dout;
   wire 			     b2_we;   // active high
   reg [1:0] 			     last_pixel_data;
   reg [14:0] 			     last_write_addr;
   reg 				     write_enable;
   
   assign b1_we = front_buffer ? (gb_we) : 0;
   assign b2_we = front_buffer ? 0 : (gb_we);
   assign read_data = (front_buffer) ? b2_dout : b1_dout;
   //assign pixel_data = (front_buffer) ? b1_din : b2_din;
   assign b1_din = (front_buffer) ? pixel_data : 0;
   assign b2_din = (front_buffer) ? 0 : pixel_data;
   
   BUFGMUX clock_mux_b1(.S(front_buffer), .O(b1_clk),
			.I0(clock), .I1(gb_clock));
   BUFGMUX clock_mux_b2(.S(front_buffer), .O(b2_clk),
			.I0(gb_clock), .I1(clock));
   // internal buffer ram
   frame_buffer buffer1(
			b1_addr,
			b1_clk,
			b1_din,
			b1_dout,
			b1_we
			);
   frame_buffer buffer2(
			b2_addr,
			b2_clk,
			b2_din,
			b2_dout,
			b2_we
			);
   reg 				     gb_last_vsync;
   reg 				     gb_last_hsync;
   // handle writing into the back_buffer
   always @ (posedge gb_clock)
     begin
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
   wire [9:0] pixel_count, line_count;
   vga_controller vgac(clock, reset, my_hsync, my_vsync, pixel_count, line_count);
   // write to our current counter
   //assign write_addr = my_line_count * 160 + my_pixel_count;
   assign write_addr = gb_line_count * 160 + gb_pixel_count;
   parameter X_OFFSET = 160;
   parameter Y_OFFSET = 76;
   // read from where the vga wants to read
   wire [14:0] buffer_pos = ((line_count - Y_OFFSET) >> 1) * 160 +
	       ((pixel_count - X_OFFSET) >> 1);
   assign b1_addr = (front_buffer) ? write_addr : buffer_pos;
   assign b2_addr = (front_buffer) ? buffer_pos : write_addr;
   // delay the outputs by two clocks
   reg [2:0]   hdelay, vdelay;
   always @ (posedge clock) begin
     if(reset) begin
	hdelay <= 3'b111;
	vdelay <= 3'b111;
     end else begin
	hdelay <=   {hdelay[1:0], my_hsync};
	vdelay <=   {vdelay[1:0], my_vsync};
     end
   end

   // generate a gameboy color
   // 00 -> white
   // 01 -> light gray
   // 10 -> dark gray
   // 11 -> black

   wire [7:0] my_color = (pixel_count >= X_OFFSET && line_count >= 
			  Y_OFFSET && pixel_count < X_OFFSET +
			  320 && line_count < Y_OFFSET + 288) ?
	      (read_data == 2'b00) ? 8'b11111111 :
	      ((read_data == 2'b01) ? 8'b10101010 :
	       ((read_data == 2'b10) ? 8'b01010101 : 8'b00000000)) :
	      8'b00000000;
   
   assign color[7:0] = my_color;
   assign color[15:8] = my_color;
   assign color[23:16] = my_color;

   assign sync_b = hdelay[2] ^ vdelay[2];
   assign blank_b = (pixel_count[9:0] < 640) && (line_count[9:0] < 480);
   assign pixel_clock = ~clock;
   assign hsync = hdelay[2];
   assign vsync = vdelay[2];
endmodule