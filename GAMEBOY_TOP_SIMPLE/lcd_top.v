// The Flash memory stores bytes from the hex -> mcs file as follows:
// Little Endian
// Notice that the Flash clock should be 1 for asynchronous read mode, which is
// the default mode.

// The CPU's clock is 4194304 Hz, or 2^22 Hz.

`include "cpu.vh"
`default_nettype none

module lcd_top_flashcart(CLK_33MHZ_FPGA,
	       CLK_27MHZ_FPGA,
	       USER_CLK,
	       GPIO_SW_C,
	       GPIO_SW_E,
	       GPIO_SW_S,
	       GPIO_SW_W,
	       GPIO_SW_N,
               GPIO_LED_S, GPIO_LED_N, GPIO_LED_E, GPIO_LED_W, GPIO_LED_C,
               GPIO_LED_7, GPIO_LED_6, GPIO_LED_5, GPIO_LED_4, GPIO_LED_3,
	       GPIO_LED_2, GPIO_LED_1, GPIO_LED_0,
               GPIO_DIP_SW8, GPIO_DIP_SW7, GPIO_DIP_SW6, GPIO_DIP_SW5,
               GPIO_DIP_SW4, GPIO_DIP_SW3, GPIO_DIP_SW2, GPIO_DIP_SW1,
	       LCD_FPGA_RS, LCD_FPGA_RW, LCD_FPGA_E,
	       LCD_FPGA_DB7, LCD_FPGA_DB6, LCD_FPGA_DB5, LCD_FPGA_DB4,
               flash_wait, flash_d, flash_a, flash_adv_n, flash_ce_n, 
               flash_oe_n, flash_we_n, flash_clk,
	       strobe, ac97_sync, ac97_reset_b,
	       ac97_bitclk, ac97_sdata_in, ac97_sdata_out,
	       rotary_inc_a, rotary_inc_b,
	       dvi_d, dvi_vs, dvi_hs, dvi_xclk_p, dvi_xclk_n, dvi_reset_b,
	       dvi_de,
	       dvi_sda, dvi_scl,
/*	       HDR1_2, HDR1_6, HDR1_8, HDR1_10,
               HDR1_12, HDR1_14, HDR1_16, HDR1_18,
               HDR1_20, HDR1_22, HDR1_24, HDR1_26,
               HDR1_28, HDR1_30, HDR1_32, HDR1_34,
               HDR1_36, HDR1_38, HDR1_40, HDR1_42,
               HDR1_44, HDR1_46, HDR1_48, HDR1_50,
               HDR1_52, HDR1_54, HDR1_56, HDR1_58,
               HDR1_60, HDR1_64*/
);
   parameter
     I_HILO = 4, I_SERIAL = 3, I_TIMA = 2, I_LCDC = 1, I_VBLANK = 0;
  
   input CLK_33MHZ_FPGA, CLK_27MHZ_FPGA, USER_CLK;
//   input USER_CLK;
   /* switch C is reset, E is clear, S is resetFSM, W is nextString */
   input GPIO_SW_C, GPIO_SW_E, GPIO_SW_S, GPIO_SW_W, GPIO_SW_N;	
   output GPIO_LED_C, GPIO_LED_E, GPIO_LED_S, GPIO_LED_W, GPIO_LED_N;
   output LCD_FPGA_RW, LCD_FPGA_RS, LCD_FPGA_E, LCD_FPGA_DB7, LCD_FPGA_DB6,
          LCD_FPGA_DB5, LCD_FPGA_DB4;

   input wire [15:0] flash_d;
   input wire flash_wait;
   output wire [23:0] flash_a;
   output wire        flash_adv_n;
   output wire        flash_ce_n, flash_oe_n, flash_we_n, flash_clk;
   
   output wire 	      strobe, ac97_sync, ac97_reset_b, ac97_sdata_out;
   input wire 	      ac97_bitclk, ac97_sdata_in;
   input wire 	      rotary_inc_a, rotary_inc_b;
   output [11:0] 	dvi_d;			//DIV Outputs
   output 		dvi_vs, dvi_hs, 	//DIV Outputs
			dvi_xclk_p, 		//DIV Outputs
			dvi_xclk_n, 		//DIV Outputs
			dvi_de, 		//DIV Outputs
			dvi_reset_b;		//DIV Outputs
   inout 		dvi_sda, dvi_scl;
/*   output wire 		HDR1_2, HDR1_6, HDR1_8, HDR1_10;
   output wire 		HDR1_12, HDR1_14, HDR1_16, HDR1_18;
   output wire 		HDR1_20, HDR1_22, HDR1_24, HDR1_26;
   output wire 		HDR1_28, HDR1_30, HDR1_32, HDR1_34;
   output wire 		HDR1_36, HDR1_38, HDR1_40, HDR1_42;
   input 		HDR1_44, HDR1_46, HDR1_48, HDR1_50;
   input 		HDR1_52, HDR1_54, HDR1_56, HDR1_58;
   output wire 		HDR1_60, HDR1_64;*/
   wire   clock;

   assign clock = CLK_33MHZ_FPGA;
   assign flash_clk = 1'h1;
   
   wire [2:0] control_out; //rs, rw, en
   wire [3:0] out;
   wire       reset;
   
   wire       writeStart;
   wire       writeDone;
   wire       initDone;
   wire [7:0] data;
//   reg        clearAll;
   wire       nextString;
   
   assign reset = GPIO_SW_C;
//   assign GPIO_LED_C = reset;
   //assign resetFSM = GPIO_SW_S;
   //assign clearAll = GPIO_SW_E;
   //assign nextString = GPIO_SW_W;
   
   assign LCD_FPGA_DB7 = out[3];
   assign LCD_FPGA_DB6 = out[2];
   assign LCD_FPGA_DB5 = out[1];
   assign LCD_FPGA_DB4 = out[0];	
   
   assign LCD_FPGA_RS = control_out[2];
   assign LCD_FPGA_RW = control_out[1];
   assign LCD_FPGA_E  = control_out[0];


   assign flash_ce_n = 1'h0;
   assign flash_oe_n = 1'h0;
   assign flash_we_n = 1'h1;

   output wire GPIO_LED_7, GPIO_LED_6, GPIO_LED_5, GPIO_LED_4, GPIO_LED_3;
   output wire GPIO_LED_2, GPIO_LED_1, GPIO_LED_0;

   input wire GPIO_DIP_SW8, GPIO_DIP_SW7, GPIO_DIP_SW6, GPIO_DIP_SW5;
   input wire GPIO_DIP_SW4, GPIO_DIP_SW3, GPIO_DIP_SW2, GPIO_DIP_SW1;

/*   wire       bram_we;
   wire [15:0] bram_addr;
   wire [7:0]  bram_data_in;
   wire [7:0]  bram_data_out;
   
   blockram br(.clka(clock),
               .wea(bram_we),
               .addra(bram_addr),
               .dina(bram_data_in),
               .douta(bram_data_out));*/
   wire [7:0] 	  bp_addr_disp, bp_addr_part_in;
   wire 	  bp_hi_lo_sel_in, bp_hi_lo_disp_in, hi_lo_disp;
   wire [15:0] 	  bp_addr;
   wire 	  bp_step, bp_continue;
   
   // Breakpoint module controls
   //   assign bp_hi_lo_sel_in = GPIO_SW_E;
   //   assign bp_hi_lo_disp_in = GPIO_SW_W;
   assign {GPIO_LED_0, GPIO_LED_1, GPIO_LED_2, GPIO_LED_3, GPIO_LED_4,
           GPIO_LED_5, GPIO_LED_6, GPIO_LED_7} = bp_addr_disp;
   assign bp_addr_part_in = {GPIO_DIP_SW1, GPIO_DIP_SW2, GPIO_DIP_SW3,
                             GPIO_DIP_SW4, GPIO_DIP_SW5, GPIO_DIP_SW6,
                             GPIO_DIP_SW7, GPIO_DIP_SW8};
   assign GPIO_LED_C = hi_lo_disp;

   
`define cdisp0 3'd0
`define cdisp1 3'd1
`define cdisp2 3'd2
`define cdisp3 3'd3
`define cwait 3'd4

//   reg [15:0] curr_data, next_data;
   wire [7:0] A_data, instruction;
   wire [79:0] regs_data;
//   wire [95:0] print_data;
//   wire [39:0] print_data;
   wire [63:0] print_data;

//   wire [95:0] print_data;
//   assign print_data = {A_data, instruction, regs_data};

   
//   reg [3:0]   display_hex_data_in;
//   reg        display_hex_start;
   
   wire        clearAll;
   wire [3:0]  display_hex_data_in;
   wire        display_hex_start;

   
   wire       display_hex_done;
   
   reg [2:0]  cstate, next_cstate;
//   reg [15:0] count, next_count;
   wire       button_down;

   wire       halt;
   wire       cpu_clock;

   wire       display_signal_done;
   reg        display_signal_start;
   display_signal #(16)
   sig_disp(// Outputs
            .display_hex_data_in(display_hex_data_in),
            .display_hex_start(display_hex_start),
            .display_signal_done(display_signal_done),
            .clearAll(clearAll),
            // Inputs
            .display_signal_data(print_data),
            .display_hex_done(display_hex_done),
            .display_signal_start(display_signal_start),
            .clock(clock),
            .reset(reset)
            );

   always @(*) begin
      display_signal_start = 1'b0;
      next_cstate = `cdisp0;
      case (cstate)
        `cdisp0: begin
           if (~display_signal_done) begin
              display_signal_start = 1'b1;
              next_cstate = `cdisp0;
           end else if (~halt) begin
              next_cstate = `cdisp1;
           end else begin
              next_cstate = `cwait;
           end
        end
        `cdisp1: begin
           if (halt || button_down) begin
//           if (cpu_clock || button_down) begin //button_down) begin
              next_cstate = `cdisp0;
           end else begin
              next_cstate = `cdisp1;
           end
        end
        `cwait: begin
           if (button_down) begin
              next_cstate = `cdisp0;
           end else begin
              next_cstate = `cwait;
           end
//           next_cstate = `cdisp0;
        end
      endcase
   end
  

  always @(posedge clock or posedge reset) begin
      if (reset) begin
         cstate <= `cdisp0;
      end else begin
         cstate <= next_cstate;
      end
   end

   assign button_down = bp_hi_lo_disp_in;

   button #(.delay_cycles(2400000)) 
   addr_disp_button(.pressed(bp_hi_lo_disp_in),
                    .pressed_disp(GPIO_LED_E),
                    .button_input(GPIO_SW_E),
                    .clock(cpu_clock),
                    .reset(reset));

   button #(.delay_cycles(2400000)) 
   addr_sel_button(.pressed(bp_hi_lo_sel_in),
                   .pressed_disp(GPIO_LED_W),
                   .button_input(GPIO_SW_W),
                   .clock(cpu_clock),
                   .reset(reset));
   
   button #(.delay_cycles(2400000)) 
   step_button(.pressed(bp_step),
               .pressed_disp(GPIO_LED_N),
               .button_input(GPIO_SW_N),
               .clock(cpu_clock),
               .reset(reset));

   button #(.delay_cycles(2400000)) 
   continue_button(.pressed(bp_continue),
                   .pressed_disp(GPIO_LED_S),
                   .button_input(GPIO_SW_S),
                   .clock(cpu_clock),
                   .reset(reset));

/*   button #(.delay_cycles(6000000)) inc_button(.pressed(button_down),
                                                .button_input(GPIO_SW_S),
                                                .clock(clock),
                                                .reset(reset));*/
   
   lcd_control lcd(.rst(reset), .clk(clock), .control(control_out), .sf_d(out),
		   .writeStart(writeStart), .initDone(initDone),
                   .writeDone(writeDone), 
		   .dataIn(data), 
		   .clearAll(clearAll));
   
   display_hex hex_decoder(// Outputs
                           .lcd_dataIn          (data[7:0]),
                           .lcd_writeStart      (writeStart),
                           .display_hex_done    (display_hex_done),
                           // Inputs
                           .display_hex_data_in (display_hex_data_in),
                           .display_hex_start   (display_hex_start),
                           .clock               (clock),
                           .reset               (reset),
                           .lcd_initDone        (initDone),
                           .lcd_writeDone       (writeDone));

   wire mem_we, mem_re;
   wire cpu_mem_we, cpu_mem_re;
   
   wire [15:0] addr_ext;
   wire [7:0]  data_ext;
   

/*
`define MAX_VCOUNT 9'd440
   
   reg [7:0]   FF44_data;
   reg [8:0]   v_count;

   always @(posedge cpu_clock or posedge reset) begin
      if (reset) begin
         v_count <= 9'd0;
         FF44_data <= 8'd0;
      end else begin
         if (v_count >= `MAX_VCOUNT) begin//9'd440) begin
            v_count <= 9'd0;
            if (FF44_data >= 8'd153) begin
               FF44_data <= 8'd0;
            end else  begin
               FF44_data <= FF44_data + 8'd1;
            end
         end
         v_count <= v_count + 9'd1;
      end
   end
   
   wire        FF44_read;
   assign FF44_read = (addr_ext == 16'hff44) & mem_re;*/
 
   
//   assign data_ext = (mem_we) ? 8'bzzzzzzzz : flash_d[7:0];
//   assign data_ext = (mem_we) ? 8'bzzzzzzzz : (addr_in_flash ? 
//                                               flash_d[7:0] :
//                                               bram_data_out[7:0]);
     

   // Timers, DMA ////////////////////////////////////////////////////////////

   wire        timer_reg_addr; // addr_ext == timer MMIO address
   
   wire        dma_mem_re, dma_mem_we, cpu_mem_disable;
   
   dma gb80_dma(.dma_mem_re(dma_mem_re),
                .dma_mem_we(dma_mem_we),
                .addr_ext(addr_ext),
                .data_ext(data_ext),
                .mem_we(cpu_mem_we),
                .mem_re(cpu_mem_re),
                .cpu_mem_disable(cpu_mem_disable),
                .clock(cpu_clock),
                .reset(reset));

   assign mem_we = cpu_mem_we | dma_mem_we;
   assign mem_re = cpu_mem_re | dma_mem_re;
   
   assign timer_reg_addr = (addr_ext == `MMIO_DIV) |
                           (addr_ext == `MMIO_TMA) |
                           (addr_ext == `MMIO_TIMA) |
                           (addr_ext == `MMIO_TAC);

   wire        timer_interrupt;
   wire [1:0]  int_req, int_ack;
   
   wire [4:0]  IE_data, IF_in, IF_data, IE_in, IF_in_int;
   wire        IE_load, IF_load;
   
   wire        addr_in_IF, addr_in_IE;
   assign addr_in_IF = addr_ext == `MMIO_IF;
   assign addr_in_IE = addr_ext == `MMIO_IE;
   
   assign IF_in_int[I_TIMA] = timer_interrupt | (IF_data[I_TIMA] & IF_load);
   assign IF_in_int[I_VBLANK] = int_req[0] | (IF_data[I_VBLANK] & IF_load);
   assign IF_in_int[I_LCDC] = int_req[1] | (IF_data[I_LCDC] & IF_load);
   assign IF_in_int[I_HILO] = 1'b0;
   assign IF_in_int[I_SERIAL] = 1'b0;
   
   assign IF_load = timer_interrupt | int_req[0] | int_req[1];

   assign IF_in = (addr_in_IF & mem_we) ?
                  data_ext :
                  IF_in_int;

   // IE loading is taken care of CPU-internally
   assign IE_load = 1'b0;
   assign IE_in = 5'd0;

   // However, IE/IF reading is done out here

   
   assign int_ack[1] = IF_data[I_LCDC];
   assign int_ack[0] = IF_data[I_VBLANK];
   
   timers tima_module(// Outputs
                      .timer_interrupt  (timer_interrupt),
                      // Inouts
                      .addr_ext         (addr_ext[15:0]),
                      .data_ext         (data_ext[7:0]),
                      // Inputs
                      .mem_re           (mem_re),
                      .mem_we           (mem_we),
                      .clock            (cpu_clock),
                      .reset            (reset));


   wire [7:0]  F_data;
   wire [7:0]  high_mem_data;
   wire [16:0] high_mem_addr;
   wire        debug_halt;
   
   cpu gb80_cpu(.mem_we(cpu_mem_we),
                .mem_re(cpu_mem_re),
                .halt(halt),
                .debug_halt(debug_halt),
                .addr_ext(addr_ext),
                .data_ext(data_ext),
                .clock(cpu_clock),
                .reset(reset),
                .A_data(A_data),
                .F_data(F_data),
                .high_mem_data(high_mem_data[7:0]),
                .high_mem_addr(high_mem_addr[15:0]),
                .instruction(instruction),
                .regs_data(regs_data),
                .IF_data(IF_data),
                .IE_data(IE_data),
                .IF_in(IF_in),
                .IE_in(IE_in),
                .IF_load(IF_load),
                .IE_load(IE_load),
                .cpu_mem_disable(cpu_mem_disable),
                .bp_addr(bp_addr),
                .bp_step(bp_step),
                .bp_continue(bp_continue));

   my_clock_divider #(.DIV_SIZE(2), .DIV_OVER_TWO(4)) //~4.125MHz
   cdiv(.clock_out(cpu_clock),
        .clock_in(clock));
   
   breakpoints #(.reset_addr(16'hffff))
   bpmod(.bp_addr(bp_addr[15:0]),
         .bp_addr_disp(bp_addr_disp[7:0]),
         // Inputs
         .bp_addr_part_in(bp_addr_part_in[7:0]),
         .bp_hi_lo_sel_in(bp_hi_lo_sel_in),
         .bp_hi_lo_disp_in(bp_hi_lo_disp_in),
         .hi_lo_disp(hi_lo_disp),
         .reset(1'b0),
         .clock(cpu_clock));

   wire [7:0]  bootstrap_reg_data;
   wire        addr_in_bootstrap_reg;
   assign addr_in_bootstrap_reg = addr_ext == `MMIO_BOOTSTRAP;
   register #(8) bootstrap_reg(.d(data_ext),
                               .q(bootstrap_reg_data),
                               .load(addr_in_bootstrap_reg & mem_we),
                               .reset(reset),
                               .clock(cpu_clock));
   
   wire        addr_in_flash;
   assign addr_in_flash = (bootstrap_reg_data[0]) ? 
                          0 : addr_ext < 16'h104;

   /* The GPU */
   wire        video_reg_w_enable;
   wire [7:0]  video_reg_data_in;
   wire [7:0]  video_reg_data_out;
   wire [15:0] video_reg_addr;

   assign video_reg_data_in = data_ext;
   assign video_reg_addr = addr_ext;
   /* NOTE: FF46 is DMA register */
   assign video_reg_w_enable = (addr_ext >= 16'hFF40 && addr_ext <= 16'hFF4B);
   
   wire        video_vram_w_enable;
   wire [7:0]  video_vram_data_in;
   wire [7:0]  video_vram_data_out;
   wire [15:0] video_vram_addr;

   assign video_vram_data_in = data_ext;
   assign video_vram_addr = addr_ext;
   assign video_vram_w_enable = (addr_ext >= 16'h8000 && addr_ext <= 16'h9FFF);
   
   wire        video_oam_w_enable;
   wire [7:0]  video_oam_data_in;
   wire [7:0]  video_oam_data_out;
   wire [15:0] video_oam_addr;

   assign video_oam_data_in = data_ext;
   assign video_oam_addr = addr_ext;
   assign video_oam_w_enable = (addr_ext >= 16'hFE00 && addr_ext <= 16'hFE9F);

   wire [1:0]  mode_video;
   wire [7:0]  do_video;
   wire        mem_enable_video;
   assign mem_enable_video = video_reg_w_enable || video_vram_w_enable ||
			     video_oam_w_enable;

   gpu_top gpu (// Outputs
		.do_video		(do_video[7:0]),
		.mode_video		(mode_video[1:0]),
		.int_req		(int_req[1:0]),
		.dvi_d			(dvi_d[11:0]),
		.dvi_vs			(dvi_vs),
		.dvi_hs			(dvi_hs),
		.dvi_xclk_p		(dvi_xclk_p),
		.dvi_xclk_n		(dvi_xclk_n),
		.dvi_de			(dvi_de),
		.dvi_reset_b		(dvi_reset_b),
		.led_out		(),
		.iic_done		(),
		// Inouts
		.dvi_sda		(dvi_sda),
		.dvi_scl		(dvi_scl),
		// Inputs
		.clk27			(CLK_27MHZ_FPGA),
		.clk33			(CLK_33MHZ_FPGA),
		.clk100			(USER_CLK),
		.top_rst_b		(~reset),
		.mem_enable_video	(mem_enable_video),
		.rd_n_video		(~mem_re),
		.wr_n_video		(~mem_we),
		.A_video		(addr_ext),
		.di_video		(data_ext),
		.int_ack		(int_ack[1:0]),
		.switches78		());

   /* Sound registers */
   wire        reg_w_enable;
   wire [7:0]  reg_data_in;
   wire [7:0]  reg_data_out;
   wire [15:0] reg_addr;

   assign reg_w_enable = ((addr_ext >= 16'hFF10 && addr_ext <= 16'hFF1E) ||
			  (addr_ext >= 16'hFF30 && addr_ext <= 16'hFF3F) ||
			  (addr_ext >= 16'hFF20 && addr_ext <= 16'hFF26));
   assign reg_data_in = data_ext;
   assign reg_addr = addr_ext;

   audio_top audio(.square_wave_enable(1'b1), 
		   .sample_no(1'b1),
		   .ac97_bitclk(ac97_bitclk),
		   .ac97_sdata_in(ac97_sdata_in),
		   .rotary_inc_a(rotary_inc_a),
		   .rotary_inc_b(rotary_inc_b),
		   .ac97_sdata_out(ac97_sdata_out),
		   .ac97_sync(ac97_sync),
		   .ac97_reset_b(ac97_reset_b),
		   .reset(reset),
/*		   .flash_wait(flash_wait),
		   .flash_d(flash_d),
		   .flash_a(flash_a),
		   .flash_adv_n(flash_adv_n),
		   .flash_ce_n(flash_ce_n),
		   .flash_clk(flash_clk),
		   .flash_oe_n(flash_oe_n),
		   .flash_we_n(flash_we_n),*/
		   .strobe(strobe),
		   .reg_addr(reg_addr),
		   .reg_data(reg_data_in),
		   .reg_w_enable(reg_w_enable)
		  );

   /* The cartridge */
   wire        addr_in_cart;
  /* assign addr_in_cart = (~bootstrap_reg_data[0]) ?
                         (16'h104 <= addr_ext) && 
                         (addr_ext <= `MEM_CART_END) :
                         ((`MEM_CART_START <= addr_ext) && 
                         (addr_ext <= `MEM_CART_END));*/
   assign addr_in_cart = (bootstrap_reg_data[0]) ?
                         ((`MEM_CART_START <= addr_ext) &&
                          (addr_ext <= `MEM_CART_END)) :
                         ((16'h104 <= addr_ext) &&
                          (addr_ext <= `MEM_CART_END));
   
   wire [7:0]  cart_data;
   wire [15:0] cart_address;
   wire        cart_w_enable_l, cart_r_enable_l, cart_reset_l, cart_cs_sram_l;
   assign cart_address = addr_ext + 16'h104;
   assign cart_w_enable_l = 1;
   assign cart_r_enable_l = 0;
   assign cart_reset_l = 1;
   assign cart_cs_sram_l = 1;

   assign flash_a = (addr_in_cart) ?
                    {8'd0, cart_address} :
                    {8'd0, addr_ext};
   assign flash_adv_n = ~mem_re;

   assign cart_data = flash_d[7:0];
   
/*   cartridge cart (
		   // Outputs
		   .HDR1_2		(HDR1_2),
		   .HDR1_6		(HDR1_6),
		   .HDR1_8		(HDR1_8),
		   .HDR1_10		(HDR1_10),
		   .HDR1_12		(HDR1_12),
		   .HDR1_14		(HDR1_14),
		   .HDR1_16		(HDR1_16),
		   .HDR1_18		(HDR1_18),
		   .HDR1_20		(HDR1_20),
		   .HDR1_22		(HDR1_22),
		   .HDR1_24		(HDR1_24),
		   .HDR1_26		(HDR1_26),
		   .HDR1_28		(HDR1_28),
		   .HDR1_30		(HDR1_30),
		   .HDR1_32		(HDR1_32),
		   .HDR1_34		(HDR1_34),
		   .HDR1_36		(HDR1_36),
		   .HDR1_38		(HDR1_38),
		   .HDR1_40		(HDR1_40),
		   .HDR1_42		(HDR1_42),
		   .HDR1_60		(HDR1_60),
		   .HDR1_64		(HDR1_64),
		   .cart_data		(cart_data[7:0]),
		   // Inputs
		   .HDR1_44		(HDR1_44),
		   .HDR1_46		(HDR1_46),
		   .HDR1_48		(HDR1_48),
		   .HDR1_50		(HDR1_50),
		   .HDR1_52		(HDR1_52),
		   .HDR1_54		(HDR1_54),
		   .HDR1_56		(HDR1_56),
		   .HDR1_58		(HDR1_58),
		   .cart_address	(cart_address[15:0]),
		   .clock		(cpu_clock),
		   .cart_w_enable_l	(cart_w_enable_l),
		   .cart_r_enable_l	(cart_r_enable_l),
		   .cart_reset_l	(cart_reset_l),
		   .cart_cs_sram_l	(cart_cs_sram_l));*/
   
   wire        addr_in_controller;
   assign addr_in_controller = (addr_ext == `MMIO_CONTROLLER);
   
   wire        addr_in_wram, addr_in_junk;
   wire        addr_in_dma, addr_in_tima;

   wire        addr_in_echo;
   assign addr_in_echo = (`MEM_ECHO_START <= addr_ext) & 
                         (addr_ext <= `MEM_ECHO_END);
   
   assign addr_in_wram = (`MEM_WRAM_START <= addr_ext) & 
                         (addr_ext <= `MEM_WRAM_END);
   assign addr_in_dma = addr_ext == `MMIO_DMA;
   assign addr_in_tima = timer_reg_addr;
   assign addr_in_junk = ~addr_in_flash & ~reg_w_enable &
                         ~timer_reg_addr & ~addr_in_wram &
                         ~addr_in_dma & ~addr_in_tima & 
			 ~video_reg_w_enable & ~video_vram_w_enable &
			 ~video_oam_w_enable & ~addr_in_bootstrap_reg & 
                         ~addr_in_cart & ~addr_in_echo;

   wire        wram_we;
   wire [12:0] wram_addr;
   wire [7:0]  wram_data_in;
   wire [7:0]  wram_data_out;
   
   wire [15:0] wram_addr_long;
   assign wram_data_in = data_ext;
   assign wram_we = addr_in_wram & mem_we;
   assign wram_addr_long = (addr_in_echo) ? 
                           addr_ext - `MEM_ECHO_START : 
                           addr_ext - `MEM_WRAM_START;
   assign wram_addr = wram_addr_long[12:0]; // 8192 elts

   blockram8192
     br_wram(.clka(clock),//cpu_clock),
             .wea(wram_we),
             .addra(wram_addr),
             .dina(wram_data_in),
             .douta(wram_data_out));

/*   tristate #(8) gating_ff44(.out(data_ext),
			     .in(FF44_data),
			     .en(FF44_read&~mem_we));*/
   tristate #(8) gating_flash(.out(data_ext),
			      .in(flash_d[7:0]),
			      .en(addr_in_flash & ~mem_we));
/*   tristate #(8) gating_bram(.out(data_ext),
			     .in(bram_data_out),
			     .en(~video_reg_w_enable&~video_vram_w_enable&~video_oam_w_enable&~addr_in_flash&~reg_w_enable&~mem_we));*/
   tristate #(8) gating_wram(.out(data_ext),
			     .in(wram_data_out),
			     .en((addr_in_wram | addr_in_echo) & ~mem_we &
				 (mem_re | dma_mem_re)));
   tristate #(8) gating_junk(.out(data_ext),
			     .in(8'h00),
			     .en(addr_in_junk & ~mem_we));
   tristate #(8) gating_sound_regs(.out(data_ext),
				   .in(reg_data_in), //FIX THIS: regs need output
				   .en(reg_w_enable&~mem_we));
   tristate #(8) gating_video_regs(.out(data_ext),
				   .in(do_video),//video_reg_data_out),
				   .en(video_reg_w_enable&~mem_we));
   tristate #(8) gating_video_vram(.out(data_ext),
				   .in(do_video),//video_vram_data_out),
				   .en(video_vram_w_enable&~mem_we));
   tristate #(8) gating_video_oam(.out(data_ext),
				  .in(do_video),//video_oam_data_out),
				  .en(video_oam_w_enable&~mem_we));
   tristate #(8) gating_boostrap_reg(.out(data_ext),
                                     .in(bootstrap_reg_data),
                                     .en(addr_in_bootstrap_reg & ~mem_we));
   tristate #(8) gating_cart(.out(data_ext),
                             .in(cart_data),
                             .en(addr_in_cart & ~mem_we));
   tristate #(8) gating_cont_reg(.out(data_ext),
                                 .in(8'hff),
                                 .en(addr_in_controller & ~mem_we));
   tristate #(8) gating_IE(.out(data_ext),
                           .in({3'd0, IE_data}),
                           .en(addr_in_IE & mem_re));
   tristate #(8) gating_IF(.out(data_ext),
                           .in({3'd0, IF_data}),
                           .en(addr_in_IF & mem_re));
                           
   wire        flash_tri_en, wram_tri_en, junk_tri_en, sound_tri_en;
   wire        video_tri_en, vram_tri_en, oam_tri_en, bootstrap_tri_en;
   wire        cart_tri_en;
   
   assign flash_tri_en = addr_in_flash & ~mem_we;
   assign wram_tri_en = (addr_in_wram | addr_in_echo) & ~mem_we &
			(mem_re | dma_mem_re);
   assign junk_tri_en = addr_in_junk & ~mem_we;
   assign sound_tri_en = reg_w_enable&~mem_we;
   assign video_tri_en = video_reg_w_enable&~mem_we;
   assign vram_tri_en = video_vram_w_enable&~mem_we;
   assign oam_tri_en = video_oam_w_enable&~mem_we;
   assign bootstrap_tri_en = addr_in_bootstrap_reg & ~mem_we;
   assign cart_tri_en = addr_in_cart & ~mem_we;

   // Want to see: IF[3:0], IE[3:0], addr_in_bootstrap, addr_in_cart,
   // bootstrap_reg_data
//   assign print_data = {A_data, instruction, regs_data[79:48], regs_data[15:0]};
   assign print_data = {A_data,
                        instruction,
                        IF_data[3:0], IE_data[3:0],
                        bootstrap_reg_data[7:0], 
                        bp_addr[15:0],
                        regs_data[15:0]};

   wire [31:0] cycle_count;
   register #(32) cyc_reg(.q(cycle_count),
                          .d(cycle_count + 32'd1),
                          .load(~debug_halt & (bootstrap_reg_data[0])),
                          .reset(reset),
                          .clock(cpu_clock));
   
   wire [35 : 0] CONTROL;
   
   wire [15 : 0] TRIG0;
   wire [79 : 0] TRIG1;
   wire [7 : 0]  TRIG2;
   wire [15 : 0] TRIG3;
   wire [7 : 0]  TRIG4;
   wire [8 : 0]  TRIG5;
   wire [7 : 0]  TRIG6;
   wire [7 : 0]  TRIG7;
   wire [1 : 0]  TRIG8;
   wire [31 : 0] TRIG9;
   wire [31 : 0] TRIG10;
   wire [31 : 0] TRIG11;
   
   assign TRIG0 = regs_data[15:0];
   assign TRIG1 = {A_data, F_data, regs_data[79:16]};
   assign TRIG2 = instruction;
   assign TRIG3 = addr_ext;
   assign TRIG4 = data_ext;
   assign TRIG5 = {flash_tri_en,
                   wram_tri_en,
                   junk_tri_en,
                   sound_tri_en,
                   video_tri_en,
                   vram_tri_en,
                   oam_tri_en,
                   bootstrap_tri_en,
                   cart_tri_en};
   assign TRIG6 = {addr_in_wram,
                   addr_in_junk,
                   addr_in_dma, 
                   addr_in_tima,
                   addr_in_flash,
                   addr_in_bootstrap_reg,
                   addr_in_cart,
                   addr_in_echo};
   assign TRIG7 = {IF_data[3:0], IE_data[3:0]};
   assign TRIG8 = {mem_re, mem_we};
   assign TRIG9 = cycle_count;
   assign TRIG10 = {16'h0, high_mem_addr[15:0]};
   assign TRIG11 = {24'h0, high_mem_data[7:0]};

/*   assign wram_data_in = data_ext;
   assign wram_we = addr_in_wram & mem_we;
   assign wram_addr_long = (addr_in_echo) ? 
                           addr_ext - `MEM_ECHO_START : 
                           addr_ext - `MEM_WRAM_START;
   assign wram_addr = wram_addr_long[12:0]; // 8192 elts

   blockram8192
     br_wram(.clka(cpu_clock),
             .wea(wram_we),
             .addra(wram_addr),
             .dina(wram_data_in),
             .douta(wram_data_out));*/
   
   wire [35:0]   CONTROL0;
   
   chipscope_ila 
     cila(.CONTROL(CONTROL0),
          .CLK(cpu_clock),
          .TRIG0(TRIG0),
          .TRIG1(TRIG1),
          .TRIG2(TRIG2),
          .TRIG3(TRIG3),
          .TRIG4(TRIG4),
          .TRIG5(TRIG5),
          .TRIG6(TRIG6),
          .TRIG7(TRIG7),
          .TRIG8(TRIG8),
          .TRIG9(TRIG9),
          .TRIG10(TRIG10),
          .TRIG11(TRIG11));

   chipscope_icon
     cicon(.CONTROL0(CONTROL0));
   
endmodule
// Local Variables:
// verilog-library-directories:("." "../../fpgaboy_files/" "../..")
// verilog-library-files:("./cpu.v" "../../cartridge_interface.v")
// End:
