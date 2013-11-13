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
   
   // Inputs
   reg       clock, reset;
   wire [4:0] IF_in;
   reg [4:0] IE_in;
   reg       IE_load;
   wire      IF_load;

   parameter
     I_HILO = 4, I_SERIAL = 3, I_TIMA = 2, I_LCDC = 1, I_VBLANK = 0;
   
   
   // Testbench variables
   reg        ce;

   integer    count;

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
           .clock                       (clock),
           .reset                       (reset));

   wire timer_reg_addr = 
        (addr_ext == `MMIO_DIV) |
        (addr_ext == `MMIO_TMA) |
        (addr_ext == `MMIO_TIMA) |
        (addr_ext == `MMIO_TAC);
   
   mem #(65536) mmod(
                     // Inouts
                     .data_ext          (data_ext[7:0]),
                     // Inputs
                     .addr_ext          (addr_ext[15:0]),
                     .mem_we            (mem_we),
                     .mem_re            ((mem_re) ? ~timer_reg_addr : 1'b0),
                     .reset             (reset),
                     .clock             (clock));

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
   
   initial begin
      count = 0;
      reset <= 1'b1;
      IE_load <= 1'b0;
      IE_in <= 5'd0;
      
      @(posedge clock);

      reset <= 1'b0;

      @(posedge clock);

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
