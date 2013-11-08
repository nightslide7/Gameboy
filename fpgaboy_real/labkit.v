///////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- Template Toplevel Module for Lab 4 (Spring 2007)
//
//
// Created: March 15, 2007
// Author: Nathan Ickes
//
///////////////////////////////////////////////////////////////////////////////
module labkit (
	       vga_out_red, vga_out_green, vga_out_blue, vga_out_sync_b,
	       vga_out_blank_b, vga_out_pixel_clock, vga_out_hsync,
	       vga_out_vsync,

	       clock_27mhz, //clock1, clock2,

	       disp_blank, disp_data_out, disp_clock, disp_rs, disp_ce_b,
	       disp_reset_b, disp_data_in,

	       button0, button1, button2, button3, button_enter, button_right,
	       button_left, button_down, button_up,

	       switch,

	       led, user1, user2);
   
   output [7:0] vga_out_red, vga_out_green, vga_out_blue;
   output 	vga_out_sync_b, vga_out_blank_b, vga_out_pixel_clock,
		vga_out_hsync, vga_out_vsync;
   
   input 	clock_27mhz;
   
   output 	disp_blank, disp_clock, disp_rs, disp_ce_b, disp_reset_b;
   input 	disp_data_in;
   output 	disp_data_out;
   
   input 	button0, button1, button2, button3, button_enter, button_right,
		button_left, button_down, button_up;
   input [7:0] 	switch;
   output [7:0] led;
   
   inout wire [31:0] user1;
   inout wire [31:0] user2;
   
   ////////////////////////////////////////////////////////////////////////////
		     //
   // Final Project Components
   //
   ////////////////////////////////////////////////////////////////////////////
   
   //
   // Core Clock: ~4.194304 MHz
   //
   
   wire 	     coreclk, core_clock;
   DCM core_clock_dcm (.CLKIN(clock_27mhz), .CLKFX(coreclk));
   defparam core_clock_dcm.CLKFX_DIVIDE = 9;
   defparam core_clock_dcm.CLKFX_MULTIPLY = 11;
   defparam core_clock_dcm.CLK_FEEDBACK = "NONE";
   //defparam core_clock_dcm.CLKIN_PERIOD = 37.037;
   BUFG core_clock_buf (.I(coreclk), .O(core_clock));
   
   wire 	     pixelclk, pixel_clock;
   DCM pixel_clock_dcm (.CLKIN(clock_27mhz), .CLKFX(pixelclk));
   defparam pixel_clock_dcm.CLKFX_DIVIDE = 6;
   defparam pixel_clock_dcm.CLKFX_MULTIPLY = 7;
   defparam pixel_clock_dcm.CLK_FEEDBACK = "NONE";
   BUFG pixel_clock_buf (.I(pixelclk), .O(pixel_clock));
   
   wire 	     reset_init, reset;
   SRL16 reset_sr(.D(1'b0), .CLK(clock_27mhz), .Q(reset_init),
		  .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
   defparam reset_sr.INIT = 16'hFFFF;
   
   //
   // Hex Display
   //
   
   wire [63:0] 	     display_data;
   
   display_16hex hex_display (reset, core_clock, display_data,
			      disp_blank, disp_clock, disp_rs, disp_ce_b,
			      disp_reset_b, disp_data_out);
   
   //
   // Buttons + Switches
   //
   
   wire 	     reset_sync, step_sync, left_sync, right_sync, save_sync, edit_sync;
   wire 	     step_enable, breakpoint_enable, debug_enable;
   
   debounce debounce_reset_sync(reset_init, core_clock, !switch[0], reset_sync);
   debounce debounce_step_sync(reset_init, core_clock, switch[3], step_sync);
   debounce debounce_left_sync(reset_init, core_clock, !button_left, left_sync);
   debounce debounce_right_sync(reset_init, core_clock, !button_right, right_sync);
   debounce debounce_save_sync(reset_init, core_clock, !button_up, save_sync);
   //debounce debounce_edit_sync(reset_init, core_clock, switch[3], edit_sync);
   
   assign edit_sync = 1;
   
   debounce debounce_step_enable(reset_init, core_clock, switch[1], step_enable);
   debounce debounce_breakpoint_enable(reset_init, core_clock, switch[2],
				       breakpoint_enable);
   
   assign reset = (reset_init || reset_sync);
   
   //
   // CPU I/O Pins
   //
   
   wire 	     reset_n, wait_n, int_n, nmi_n, busrq_n; // cpu inputs
   wire 	     m1_n, mreq_n, iorq_n, rd_n, wr_n, rfsh_n, halt_n, busak_n; // cpu outputs
   
   wire [15:0] 	     A; // cpu addr
   wire [7:0] 	     di; // cpu data in
   wire [7:0] 	     do; // cpu data out
   
   //
   // Breakpoint Module
   //
   
   wire [15:0] 	     breakpoint_addr;
   wire [15:0] 	     breakpoint_disp;
   
   breakpoint_module breakpoint(
				.reset(reset_init),
				.clock(core_clock),
				.button_left(left_sync),
				.button_right(right_sync),
				.breakpoint_save(save_sync),
				.breakpoint_edit(edit_sync),
				.bits(switch[7:4]),
				.display(breakpoint_disp),
				.breakpoint_addr(breakpoint_addr)
				);
   
   wire [4:0] 	     gb_state;
   
   assign debug_enable =
			step_enable ||
			(breakpoint_enable && A == breakpoint_addr && !m1_n && (!iorq_n || !mreq_n)) ||
			(!button_down && gb_state == breakpoint_addr);
   
   wire 	     clock;
   BUFGMUX clock_mux(.S(debug_enable), .O(clock),
		     .I0(core_clock), .I1(step_sync));
   
   //assign clock = clock_27mhz;
   
   //
   // TV80 CPU
   //
   
   reg [2:0] 	     clock_divider; // overflows every 8 cycles
   
   wire 	     clock_4mhz;
   BUFG divided_clock_buf (.I(clock_divider[2]), .O(clock_4mhz));
   //assign clock_4mhz = clock_27mhz;
   
   wire [15:0] 	     AF;
   wire [15:0] 	     BC;
   wire [15:0] 	     DE;
   wire [15:0] 	     HL;
   wire [15:0] 	     PC;
   wire [15:0] 	     SP;
   wire 	     IntE_FF1;
   wire 	     IntE_FF2;
   wire 	     INT_s;
   
   tv80s tv80_core(
		   .reset_n(reset_n),
		   .clk(clock_4mhz),
		   .wait_n(wait_n),
		   .int_n(int_n),
		   .nmi_n(nmi_n),
		   .busrq_n(busrq_n),
		   .m1_n(m1_n),
		   .mreq_n(mreq_n),
		   .iorq_n(iorq_n),
		   .rd_n(rd_n),
		   .wr_n(wr_n),
		   .rfsh_n(rfsh_n),
		   .halt_n(halt_n),
		   .busak_n(busak_n),
		   .A(A),
		   .di(di),
		   .do(do),
		   .ACC(AF[15:8]),
		   .F(AF[7:0]),
		   .BC(BC),
		   .DE(DE),
		   .HL(HL),
		   .PC(PC),
		   .SP(SP),
		   .IntE_FF1(IntE_FF1),
		   .IntE_FF2(IntE_FF2),
		   .INT_s(INT_s)
		   );
   
   assign reset_n = !reset;
   assign wait_n = 1'b1;
   assign nmi_n = 1'b1;
   assign busrq_n = 1'b1;
   
   //
   // Status LEDs + Core Debugging
   //
   
   assign display_data[63:48] = A[15:0];
   assign display_data[47:40] = di[7:0];
   assign display_data[39:32] = do[7:0];
   
   assign led[0] = m1_n;
   assign led[1] = mreq_n;
   assign led[2] = iorq_n;
   assign led[3] = int_n;
   assign led[4] = halt_n;
   assign led[5] = reset_n;
   assign led[6] = rd_n;
   assign led[7] = wr_n;

   //
   // MMU
   //
   
   wire [15:0] 	     A_video;
   wire [7:0] 	     di_video;
   wire 	     rd_n_video;
   wire 	     wr_n_video;
   wire [15:0] 	     current_dma_addr;
   wire [15:0] 	     current_dma_data;
   
   wire 	     mem_enable_interrupt;
   wire 	     mem_enable_timer;
   wire 	     mem_enable_video;
   wire 	     mem_enable_sound;
   wire 	     mem_enable_input;
   wire [7:0] 	     do_mmu;
   wire [7:0] 	     do_interrupt;
   wire [7:0] 	     do_timer;
   wire [7:0] 	     do_video;
   wire [7:0] 	     do_sound;
   wire [7:0] 	     do_input;

   memory_controller mmu(
			 .reset(reset),
			 .clock(clock),
			 .rd_n(rd_n),
			 .wr_n(wr_n),
			 .A(A),
			 .di(do), // TODO: make di and di names more specific
			 .do_interrupt(do_interrupt),
			 .do_timer(do_timer),
			 .do_video(do_video),
			 .do_sound(do_sound),
			 .do_input(do_input),
			 .A_video(A_video),
			 .di_video(di_video),
			 .rd_n_video(rd_n_video),
			 .wr_n_video(wr_n_video),
			 .button0(button0),
			 .button1(button1),
			 .button2(button2),
			 .button3(button3),
			 .button_enter(button_enter),
			 .enable_interrupt(mem_enable_interrupt),
			 .enable_timer(mem_enable_timer),
			 .enable_video(mem_enable_video),
			 .enable_sound(mem_enable_sound),
			 .enable_input(mem_enable_input),
			 .do(do_mmu),
			 .current_dma_addr(current_dma_addr),
			 .current_dma_data(current_dma_data),
      
			 .cart_wr_n(user2[2]),
			 .cart_rd_n(user2[3]),
			 .cart_mreq_n(user2[4]),
			 .cart_A(user2[20:5]),
			 .cart_data(user2[28:21]),
			 .cart_reset_n(user2[29])
			 );
   
   //
   // Interrupt Module
   //
   
   wire [4:0] 	     int_req;
   wire [4:0] 	     int_ack;
   wire [7:0] 	     jump_addr;
   
   interrupt_module interrupt(
			      .reset(reset),
			      .clock(clock),
			      .mem_enable(mem_enable_interrupt),
			      .rd_n(rd_n),
			      .wr_n(wr_n),
			      .m1_n(m1_n),
			      .int_n(int_n),
			      .iorq_n(iorq_n),
			      .int_ack(int_ack),
			      .int_req(int_req),
			      .jump_addr(jump_addr),
			      .A(A),
			      .di(do),
			      .do(do_interrupt)
			      );
   
   assign int_req[3] = 0;
   //assign int_req[4] = 0;
   
   assign di = (!iorq_n && !m1_n) ? jump_addr : do_mmu;
   
   //
   // Timer Module
   //
   
   timer_module timer(
		      .reset(reset),
		      .clock(clock_4mhz),
		      .mem_enable(mem_enable_timer),
		      .rd_n(rd_n),
		      .wr_n(wr_n),
		      .int_ack(int_ack[2]),
		      .int_req(int_req[2]),
		      .A(A),
		      .di(do),
		      .do(do_timer)
		      );
   
   //
   // Video Module
   //
   
   wire 	     gb_hsync, gb_vsync;
   wire [1:0] 	     gb_pixel_data;
   wire [7:0] 	     gb_pixel_count;
   wire [7:0] 	     gb_line_count;
   wire [7:0] 	     gb_pixel_cnt; // 0-454
   wire [7:0] 	     sprite_x_pos;
   wire [7:0] 	     sprite_y_pos;
   wire [6:0] 	     sprite_num;
   wire [7:0] 	     sprite_data1;
   wire [7:0] 	     sprite_data2;
   wire [1:0] 	     sprite_pixel;
   wire [1:0] 	     bg_pixel;
   wire [7:0] 	     oam_addrA;
   wire 	     gb_pixel_we;
   
   video_module video(
		      .reset(reset),
		      .clock(clock),
		      .mem_enable(mem_enable_video),
		      .rd_n(rd_n_video),
		      .wr_n(wr_n_video),
		      .int_vblank_ack(int_ack[0]),
		      .int_lcdc_ack(int_ack[1]),
		      .A(A_video),
		      .di(di_video),
		      .int_vblank_req(int_req[0]),
		      .int_lcdc_req(int_req[1]),
		      .hsync(gb_hsync),
		      .vsync(gb_vsync),
		      .pixel_count(gb_pixel_cnt),
		      .pixel_data(gb_pixel_data),
		      .pixel_data_count(gb_pixel_count),
		      .pixel_we(gb_pixel_we),
		      .sprite_x_pos(sprite_x_pos),
		      .sprite_y_pos(sprite_y_pos),
		      .sprite_num(sprite_num),
		      .sprite_data1(sprite_data1),
		      .sprite_data2(sprite_data2),
		      .sprite_pixel(sprite_pixel),
		      .bg_pixel(bg_pixel),
		      .oam_addrA(oam_addrA),
		      .line_count(gb_line_count),
		      .state(gb_state),
		      .do(do_video)
		      );
   
   wire 	     fb;
   
   video_converter converter(
			     .reset(reset),
			     .clock(pixel_clock),
			     .gb_clock(clock),
			     .pixel_data(gb_pixel_data),
			     .gb_pixel_count(gb_pixel_count),
			     .gb_line_count(gb_line_count),
			     .gb_hsync(gb_hsync),
			     .gb_vsync(gb_vsync),
			     .gb_we(gb_pixel_we),
			     .color( {vga_out_red, vga_out_green, vga_out_blue} ),
			     .sync_b(vga_out_sync_b),
			     .blank_b(vga_out_blank_b),
			     .pixel_clock(vga_out_pixel_clock),
			     .hsync(vga_out_hsync),
			     .vsync(vga_out_vsync)
			     );
   
   wire [7:0] 	     bs;
   
   input_controller ic(
		       .reset(reset),
		       .clock(clock_27mhz),
		       .controller_data(user1[2]),
		       .controller_latch(user1[1]),
		       .controller_clock(user1[0]),
		       .mem_enable(mem_enable_input),
		       .rd_n(rd_n),
		       .wr_n(wr_n),
		       .int_ack(int_ack[4]),
		       .int_req(int_req[4]),
		       .A(A),
		       .di(do),
		       .do(do_input),
		       .button_state(bs)
		       );

   reg [2:0] 	     disp_select;
   
   assign display_data[31:0] =
			      (disp_select == 0) ? { AF, BC } :
			      (disp_select == 1) ? { DE, HL } :
			      //(disp_select == 2) ? { 3'b0, gb_state, gb_line_count, 3'b0, gb_pixel_we, 3'b0,
//			      gb_vsync, 3'b0, !vga_out_vsync, 3'b0, fb } :
			      //(disp_select == 2) ? { 3'b0, bs[7], 3'b0, bs[6], 3'b0, bs[5], 3'b0, bs[4],
			      //
//			      3'b0, bs[3], 3'b0,
//	    bs[2], 3'b0, bs[1], 3'b0, bs[0] } :
			      (disp_select == 2) ? { PC, SP } :
			      (disp_select == 3) ? { 13'b0, IntE_FF2, IntE_FF1, INT_s, 3'b0, int_ack, 3'b0,
	    int_req } :
			      //(disp_select == 3) ? { 3'b0, gb_state, 1'b0, sprite_num, sprite_y_pos,
//			      oam_addrA} :
			      { 16'b0, breakpoint_disp };
   always @(posedge clock_27mhz)
     begin
	if (reset_init)
	  begin
	     disp_select <= 0;
	  end
	else
	  begin
	     if (!button0)
	       disp_select <= 0;
	     if (!button1)
		   disp_select <= 1;
	     if (!button2)
	       disp_select <= 2;
	     if (!button3)
	       disp_select <= 3;
	     if (!button_enter)
	       disp_select <= 4;
	  end
     end

   always @(posedge clock)
     begin
	if (reset_init)
	  begin
	     clock_divider <= 0;
	  end
	else
	  begin
	     clock_divider <=
			     (switch[6]) ?
			     clock_divider + 4 :
			     clock_divider + 1;
	  end
     end
endmodule
////////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- Debounce/Synchronize module
//
//
// Use your system clock for the clock input to produce a synchronous,
// debounced output
//
////////////////////////////////////////////////////////////////////////////////

module debounce (reset, clock, noisy, clean);
   parameter DELAY = 270000;
   // .01 sec with a 27Mhz clock
   input reset, clock, noisy;
   output clean;
   
   reg [18:0] count;
   reg 	      new, clean;
   
   always @(posedge clock)
     if (reset)
       begin
	  count <= 0;
	  new <= noisy;
	  clean <= noisy;
       end
     else if (noisy != new)
       begin
	  new <= noisy;
	  count <= 0;
       end
     else if (count == DELAY)
       clean <= new;
     else
       count <= count+1;
endmodule
