`include "cpu.vh"

module cpu_auto_testbench();

   // Buses
   wire [15:0] addr_ext;
   wire [7:0] data_ext;

   // Outputs
   wire       halt;
   wire       mem_we, mem_re;
   wire [7:0] A_data, instruction;
   wire [4:0] IF_data, IE_data;
   wire [79:0] regs_data;

   wire        dma_mem_re, dma_mem_we;
   wire        cpu_mem_disable;   

   // Inputs
   reg       clock, reset;
   reg [4:0] IE_in;
   reg       IE_load;
   wire [4:0] IF_in;
   wire       IF_load;

   parameter
     I_HILO = 4, I_SERIAL = 3, I_TIMA = 2, I_LCDC = 1, I_VBLANK = 0;
   
   
   // Testbench variables
   reg        ce;

   integer    count;

   wire       timer_reg_addr; // addr_ext == timer MMIO address
   
   cpu dut(/*AUTOINST*/
           // Outputs
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
           .reset                       (reset));

   mem #(65536) mmod(
                     // Inouts
                     .data_ext          (data_ext[7:0]),
                     // Inputs
                     .addr_ext          (addr_ext[15:0]),
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
   
   timers tima_module(/*AUTOINST*/
                      // Outputs
                      .timer_interrupt  (timer_interrupt),
                      // Inouts
                      .addr_ext         (addr_ext[15:0]),
                      .data_ext         (data_ext[7:0]),
                      // Inputs
                      .mem_re           (mem_re),
                      .mem_we           (mem_we),
                      .clock            (clock),
                      .reset            (reset));

   initial ce = 0;
   initial clock = 0;
   always #5 clock = ~clock;
   always @(posedge clock) ce = ~ce;

`define MODE_WAIT 2'b10
`define MODE_RENDER 2'b00

`define RENDER_CYCLES 50 // 440
   
   reg [1:0]  mode;
   integer    mode_count;

   wire [7:0]  NR10, NR11, NR12, NR14, NR21, NR22, NR24, NR30, NR31, NR32, NR33;
   wire [7:0]  NR41, NR42, NR43, NR302, NR50, NR51, NR13;

   assign NR10 = mmod.data[16'hff10];
   assign NR11 = mmod.data[16'hff11];
   assign NR12 = mmod.data[16'hff12];
   assign NR13 = mmod.data[16'hff13];
   assign NR14 = mmod.data[16'hff14];
   assign NR21 = mmod.data[16'hff16];
   assign NR22 = mmod.data[16'hff17];
   assign NR24 = mmod.data[16'hff19];
   assign NR30 = mmod.data[16'hff1a];
   assign NR31 = mmod.data[16'hff1b];
   assign NR32 = mmod.data[16'hff1c];
   assign NR33 = mmod.data[16'hff1e];
   assign NR41 = mmod.data[16'hff20];
   assign NR42 = mmod.data[16'hff21];
   assign NR43 = mmod.data[16'hff22];
   assign NR302 = mmod.data[16'hff23];
   assign NR50 = mmod.data[16'hff24];
   assign NR51 = mmod.data[16'hff25];
   
   initial begin
      count = 0;
      mode_count = 0;
      mode = `MODE_WAIT;
      reset <= 1'b1;
      IE_load <= 1'b0;
      IE_in <= 5'd0;
      
      @(posedge clock);

      reset <= 1'b0;
      
      while (~halt && count < 2000000) begin
         mode_count = mode_count + 1;
         count = count + 1;

         if (mode == `MODE_RENDER && mode_count >= `RENDER_CYCLES && 
             ~mem_we && ~mem_re) begin
            if (mmod.data[16'hff44] >= 8'd153) begin
               // Speed up the damn process
               mmod.data[16'hff44] = 8'd140;
            end else begin
               mmod.data[16'hff44] = mmod.data[16'hff44] + 8'd1;
            end
            mode_count = 0;
         end

         if (mode == `MODE_WAIT && mmod.data[16'hff40] == 8'h91) begin
            mode = `MODE_RENDER;
         end
         
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
