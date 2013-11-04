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
   
   // Inputs
   reg       clock, reset;
   reg [4:0] IF_in, IE_in;
   reg       IF_load, IE_load;

   
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

   mem #(65536) mmod(/*AUTOINST*/
                     // Inouts
                     .data_ext          (data_ext[7:0]),
                     // Inputs
                     .addr_ext          (addr_ext[15:0]),
                     .mem_we            (mem_we),
                     .mem_re            (mem_re),
                     .reset             (reset),
                     .clock             (clock));
   
   initial ce = 0;
   initial clock = 0;
   always #5 clock = ~clock;
   always @(posedge clock) ce = ~ce;

   initial begin
      count = 0;
      reset <= 1'b1;
      IF_load <= 1'b0;
      IE_load <= 1'b0;
      IF_in <= 5'd0;
      IE_in <= 5'd0;
      
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
