`include "cpu.vh"

module cpu_auto_testbench();

   // Buses
   wire [15:0] addr_ext;
   wire [7:0] data_ext;

   // Outputs
   wire       halt;
   wire       mem_we, mem_re;
   wire [7:0] A_data, instruction;
   
   // Inputs
   reg       clock, reset;

   // Testbench variables
   reg        ce;

   integer    count;

   cpu dut(/*AUTOINST*/
           // Outputs
           .A_data                      (A_data[7:0]),
           .instruction                 (instruction[7:0]),
           .mem_we                      (mem_we),
           .mem_re                      (mem_re),
           .halt                        (halt),
           // Inouts
           .addr_ext                    (addr_ext[15:0]),
           .data_ext                    (data_ext[7:0]),
           // Inputs
           .clock                       (clock),
           .reset                       (reset));

   mem #(512) mmod(/*AUTOINST*/
                   // Inouts
                   .data_ext            (data_ext[7:0]),
                   // Inputs
                   .addr_ext            (addr_ext[15:0]),
                   .mem_we              (mem_we),
                   .mem_re              (mem_re),
                   .reset               (reset),
                   .clock               (clock));
   
   initial ce = 0;
   initial clock = 0;
   always #5 clock = ~clock;
   always @(posedge clock) ce = ~ce;

   initial begin
      count = 0;
      reset <= 1'b1;
      
      @(posedge clock);

      reset <= 1'b0;

      while (~halt && count < 100000) begin
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
