// The Flash memory stores bytes from the hex -> mcs file as follows:
// Little Endian
// Intellllll!!!!
// Notice that the Flash clock should be 1 for asynchronous read mode, which is
// the default mode.

// The CPU's clock is 4194304 Hz, or 2^22 Hz.

module lcd_top(CLK_33MHZ_FPGA,
	       GPIO_SW_C,
	       GPIO_SW_E,
	       GPIO_SW_S,
	       GPIO_SW_W,
/*               GPIO_LED_7, GPIO_LED_6, GPIO_LED_5, GPIO_LED_4, GPIO_LED_3,
               GPIO_LED_2, GPIO_LED_1, GPIO_LED_0,
               GPIO_DIP_SW8, GPIO_DIP_SW7, GPIO_DIP_SW6, GPIO_DIP_SW5,
               GPIO_DIP_SW4, GPIO_DIP_SW3, GPIO_DIP_SW2, GPIO_DIP_SW1,*/
	       LCD_FPGA_RS, LCD_FPGA_RW, LCD_FPGA_E,
	       LCD_FPGA_DB7, LCD_FPGA_DB6, LCD_FPGA_DB5, LCD_FPGA_DB4,
               flash_wait, flash_d, flash_a, flash_adv_n, flash_ce_n, 
               flash_oe_n, flash_we_n, flash_clk,
	       strobe, ac97_sync, ac97_reset_b,
	       ac97_bitclk, ac97_sdata_in, ac97_sdata_out,
	       rotary_inc_a, rotary_inc_b
);
  
   input CLK_33MHZ_FPGA;
//   input USER_CLK;
   /* switch C is reset, E is clear, S is resetFSM, W is nextString */
   input GPIO_SW_C, GPIO_SW_E, GPIO_SW_S, GPIO_SW_W;	
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

/*   output wire GPIO_LED_7, GPIO_LED_6, GPIO_LED_5, GPIO_LED_4, GPIO_LED_3;
   output wire GPIO_LED_2, GPIO_LED_1, GPIO_LED_0;

   input wire GPIO_DIP_SW8, GPIO_DIP_SW7, GPIO_DIP_SW6, GPIO_DIP_SW5;
   input wire GPIO_DIP_SW4, GPIO_DIP_SW3, GPIO_DIP_SW2, GPIO_DIP_SW1;*/

   wire       bram_we;
   wire [15:0] bram_addr;
   wire [7:0]  bram_data_in;
   wire [7:0]  bram_data_out;
   
/*   assign {GPIO_LED_7, GPIO_LED_6, GPIO_LED_5, GPIO_LED_4, GPIO_LED_3,
           GPIO_LED_2, GPIO_LED_1, GPIO_LED_0} = bram_data_out;

   assign bram_addr = {12'hff0, GPIO_DIP_SW5, GPIO_DIP_SW6, 
                       GPIO_DIP_SW7, GPIO_DIP_SW8};

   assign bram_data_in = {5'd0, GPIO_DIP_SW2, GPIO_DIP_SW3, GPIO_DIP_SW4};
   assign bram_we = GPIO_DIP_SW1;*/
   
   blockram br(.clka(clock),
               .wea(bram_we),
               .addra(bram_addr),
               .dina(bram_data_in),
               .douta(bram_data_out));
   
   
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
   assign print_data = {A_data, instruction, regs_data[79:48], regs_data[15:0]};
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
   
/*   
   always @(*) begin
//      next_count = count;
      display_hex_start = 1'b0;
      next_cstate = `cdisp0;
      clearAll = 1'b0;
      display_hex_data_in = print_data[15:12];
      case (cstate)
        `cdisp0: begin
           if (~display_hex_done) begin
              display_hex_start = 1'b1;
              display_hex_data_in = print_data[15:12];
              next_cstate = `cdisp0;
           end else begin
              next_cstate = `cdisp1;
           end
        end
        `cdisp1: begin
           if (~display_hex_done) begin
              display_hex_start = 1'b1;
              display_hex_data_in = print_data[11:8];
              next_cstate = `cdisp1;
           end else begin
              next_cstate = `cdisp2;
           end
        end
        `cdisp2: begin
           if (~display_hex_done) begin
              display_hex_start = 1'b1;
              display_hex_data_in = print_data[7:4];
              next_cstate = `cdisp2;
           end else begin
              next_cstate = `cdisp3;
           end
        end
        `cdisp3: begin
           if (~display_hex_done) begin
              display_hex_start = 1'b1;
              display_hex_data_in = print_data[3:0];
              next_cstate = `cdisp3;
           end else begin
              next_cstate = `cwait;
           end
        end
        `cwait: begin
           if (cpu_clock || button_down) begin //button_down) begin
              next_cstate = `cdisp0;
//              next_count = count + 16'h1;
              clearAll = 1'b1;
           end else begin
              next_cstate = `cwait;
           end
        end
      endcase
   end
  */ 
   always @(posedge clock or posedge reset) begin
      if (reset) begin
         cstate <= `cdisp0;
      end else begin
         cstate <= next_cstate;
      end
   end
   
//   assign display_hex_data_in = count;

   button #(.delay_cycles(6000000)) inc_button(.pressed(button_down),
                                                .button_input(GPIO_SW_S),
                                                .clock(clock),
                                                .reset(reset));
   
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
   wire [15:0] addr_ext;
   wire [7:0]  data_ext;

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
   assign FF44_read = (addr_ext == 16'hff44) & mem_re;
   
   wire        addr_in_flash;

   assign addr_in_flash = addr_ext <= 16'h140;
   
//   assign data_ext = (mem_we) ? 8'bzzzzzzzz : flash_d[7:0];
//   assign data_ext = (mem_we) ? 8'bzzzzzzzz : (addr_in_flash ? 
//                                               flash_d[7:0] :
//                                               bram_data_out[7:0]);
   

   
   assign bram_data_in = data_ext;
   assign bram_we = ~addr_in_flash & mem_we;
   assign bram_addr = addr_ext;
   assign flash_a = {8'd0, addr_ext};
   assign flash_adv_n = ~mem_re;

   wire [4:0]  IF_data, IE_data, IF_load, IE_load, IF_in, IE_in;
   assign IF_in = 5'b0;
   assign IE_in = 5'b0;
   assign IF_load = 1'b0;
   assign IE_load = 1'b0;
   
   cpu gb80_cpu(.mem_we(mem_we),
                .mem_re(mem_re),
                .halt(halt),
                .addr_ext(addr_ext),
                .data_ext(data_ext),
                .clock(cpu_clock),
                .reset(reset),
                .A_data(A_data),
                .instruction(instruction),
                .regs_data(regs_data),
                .IF_data(IF_data),
                .IE_data(IE_data),
                .IF_in(IF_in),
                .IE_in(IE_in),
                .IF_load(IF_load),
                .IE_load(IE_load));

   my_clock_divider #(.DIV_SIZE(2), .DIV_OVER_TWO(4)) //~4.125MHz
   cdiv(.clock_out(cpu_clock),
        .clock_in(clock));

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
   
   wire        reg_w_enable;
   wire [7:0]  reg_data_in;
   wire [7:0]  reg_data_out;
   wire [15:0] reg_addr;

   assign reg_w_enable = ((addr_ext >= 16'hFF10 && addr_ext <= 16'hFF1E) ||
			  (addr_ext >= 16'hFF30 && addr_ext <= 16'hFF3F) ||
			  (addr_ext >= 16'hFF20 && addr_ext <= 16'hFF26));
   assign reg_data_in = bram_data_in;
   assign reg_addr = bram_addr;

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
		   .reg_data(reg_data),
		   .reg_w_enable(reg_w_enable)
		  );

   tristate #(8) gating_ff44(.out(data_ext),
			     .in(FF44_data),
			     .en(FF44_read&~mem_we));
   tristate #(8) gating_flash(.out(data_ext),
			      .in(flash_d),
			      .en(addr_in_flash&~mem_we));
   tristate #(8) gating_bram(.out(data_ext),
			     .in(bram_data_out),
			     .en(~addr_in_flash&~FF44_read&~reg_w_enable&~mem_we));
   tristate #(8) gating_sound_regs(.out(data_ext),
				   .in(reg_data), //FIX THIS: regs need output
				   .en(reg_w_enable&~mem_we));
   tristate #(8) gating_video_regs(.out(data_ext),
				   .in(video_reg_data_out),
				   .en(video_reg_w_enable&~mem_we));
   tristate #(8) gating_video_vram(.out(data_ext),
				   .in(video_vram_data_out),
				   .en(video_vram_w_enable&~mem_we));
   tristate #(8) gating_video_oam(.out(data_ext),
				  .in(video_oam_data_out),
				  .en(video_oam_w_enable&~mem_we));

endmodule
// Local Variables:
// verilog-library-directories:(".")
// verilog-library-files:("./cpu.v")
// End:
