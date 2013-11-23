`include "cpu.vh"

module cpu_auto_testbench();

   // Buses
   wire [15:0] addr_ext;
   wire [7:0] data_ext;

   // Outputs
   wire [79:0] regs_data;
   wire        halt;
   wire        mem_we, mem_re;
   wire [7:0]  A_data, instruction, F_data;
   wire [4:0]  IF_data, IE_data;

   wire        dma_mem_re, dma_mem_we;
   wire        cpu_mem_disable;

   wire [15:0] bp_addr;
   wire [7:0]  bp_addr_disp;
   
   // Inputs
   reg         clock, reset;
   reg [4:0]   IE_in;
   reg         IE_load;
   wire [4:0]  IF_in;
   wire        IF_load;
   wire        bp_step, bp_continue;

   /*wire [7:0]  bp_addr_part_in;
   wire        bp_hi_lo_sel_in, bp_hi_lo_disp_in;*/
   
   parameter
     I_HILO = 4, I_SERIAL = 3, I_TIMA = 2, I_LCDC = 1, I_VBLANK = 0;
   
   // Testbench variables
   reg        ce;

   wire       timer_reg_addr; // addr_ext == timer MMIO address
   
   integer    count;

   /*assign bp_addr_part_in = 8'hff;
   assign bp_hi_lo_sel_in = 1'b1;
   assign bp_hi_lo_disp_in = 1'b1;*/

   assign bp_addr = 16'hffff;
   assign bp_step = 1'b0;
   assign bp_continue = 1'b0;
   
   cpu dut(/*AUTOINST*/
           // Outputs
           .F_data                      (F_data[7:0]),
           .A_data                      (A_data[7:0]),
           .instruction                 (instruction[7:0]),
           .IF_data                     (IF_data[4:0]),
           .IE_data                     (IE_data[4:0]),
           .regs_data                   (regs_data[79:0]),
           .mem_we                      (mem_we),
           .mem_re                      (mem_re),
           .halt                        (halt),
           // Inouts
           .addr_ext                    (addr_ext[15:0]),
           .data_ext                    (data_ext[7:0]),
           // Inputs
           .IF_in                       (IF_in[4:0]),
           .IE_in                       (IE_in[4:0]),
           .IF_load                     (IF_load),
           .IE_load                     (IE_load),
           .cpu_mem_disable             (cpu_mem_disable),
           .clock                       (clock),
           .reset                       (reset),
           .bp_addr                     (bp_addr[15:0]),
           .bp_step                     (bp_step),
           .bp_continue                 (bp_continue));

   mem #(65536) mmod(
                     // Inouts
                     .data_ext(data_ext[7:0]),
                     // Inputs
                     .addr_ext(addr_ext[15:0]),
                     .mem_we((mem_we | dma_mem_we)),
                     .mem_re((mem_re | dma_mem_re) & ~timer_reg_addr),
                     .reset             (reset),
                     .clock             (clock));

   dma gb80_dma(.dma_mem_re(dma_mem_re),
                .dma_mem_we(dma_mem_we),
                .addr_ext(addr_ext),
                .data_ext(data_ext),
                .mem_we(mem_we),
                .mem_re(mem_re),
                .cpu_mem_disable(cpu_mem_disable),
                .clock(clock),
                .reset(reset));

   assign timer_reg_addr = (addr_ext == `MMIO_DIV) |
                           (addr_ext == `MMIO_TMA) |
                           (addr_ext == `MMIO_TIMA) |
                           (addr_ext == `MMIO_TAC);

   wire       timer_interrupt;

   assign IF_in[I_TIMA] = timer_interrupt;
   assign IF_in[I_VBLANK] = 1'b0;
   assign IF_in[I_LCDC] = 1'b0;
   assign IF_in[I_HILO] = 1'b0;
   assign IF_in[I_SERIAL] = 1'b0;

   assign IF_load = timer_interrupt;
   
   timers
     tima_module(/*AUTOINST*/
                 // Outputs
                 .timer_interrupt       (timer_interrupt),
                 // Inouts
                 .addr_ext              (addr_ext[15:0]),
                 .data_ext              (data_ext[7:0]),
                 // Inputs
                 .mem_re                (mem_re),
                 .mem_we                (mem_we),
                 .clock                 (clock),
                 .reset                 (reset));

/*   breakpoints #(16'hffff)
   bp_module(/AUTOINST/
             // Outputs
             .bp_addr               (bp_addr[15:0]),
             .bp_addr_disp          (bp_addr_disp[7:0]),
             // Inputs
             .bp_addr_part_in       (bp_addr_part_in[7:0]),
             .bp_hi_lo_sel_in       (bp_hi_lo_sel_in),
             .bp_hi_lo_disp_in      (bp_hi_lo_disp_in),
             .reset                 (reset),
             .clock                 (clock));*/
   
   initial ce = 0;
   initial clock = 0;
   always #5 clock = ~clock;
   always @(posedge clock) ce = ~ce;
   
   initial begin
      count = 0;
      reset <= 1'b1;
      IE_load <= 1'b0;
      IE_in <= 5'd0;
      
      @(posedge clock);

      reset <= 1'b0;
      
      while (~halt && count < 1000000) begin
         count = count + 1;
         @(posedge clock);
      end

      @(posedge clock);
      
      #1 $finish;
   end
   
endmodule // cpu_test

// Local Variables:
// verilog-library-directories:(".")
// verilog-library-files:("./cpu.v")
// End:
