module tb(); 


   reg cpu_clock;
   reg reset;
   wire HDR2_40_SM_6_P; //pin 2
   reg 	HDR2_42_SM_14_N; //pin 3
   wire HDR2_46_SM_12_N; //pin 5 (clock in) inout
   wire [7:0] data_ext; //inout
   wire [15:0] addr_ext; //inout
   wire        addr_in_SB;
   wire        addr_in_SC;
   reg 	       mem_we;
   reg 	       mem_re;
   wire        link_cable_interrupt;

   reg 	       clock_gate;
   reg 	       ext_clock;
   reg [7:0]   counter;
   reg [7:0]   data;
   reg [15:0]  addr;
   reg 	       data_en, addr_en;


   link_cable dut (/*AUTOINST*/
		   // Outputs
		   .HDR2_40_SM_6_P	(HDR2_40_SM_6_P),
		   .link_cable_interrupt(link_cable_interrupt),
		   // Inouts
		   .HDR2_46_SM_12_N	(HDR2_46_SM_12_N),
		   .data_ext		(data_ext[7:0]),
		   .addr_ext		(addr_ext[15:0]),
		   // Inputs
		   .cpu_clock		(cpu_clock),
		   .reset		(reset),
		   .HDR2_42_SM_14_N	(HDR2_42_SM_14_N),
		   .addr_in_SB		(addr_in_SB),
		   .addr_in_SC		(addr_in_SC),
		   .mem_we		(mem_we),
		   .mem_re		(mem_re));

   initial begin
      reset = 1;
      cpu_clock = 0;
      ext_clock = 0;
      clock_gate = 0;
      counter = 0;
      data_en = 0;
      addr_en = 0;
      data = 0;
      addr = 0;
      mem_we = 0;
      mem_re = 0;
      HDR2_42_SM_14_N = 1;
      #10 reset = 0;
   end

   always
     #1 cpu_clock = ~cpu_clock;

   always
     #10 ext_clock = ~ext_clock;

   tristate #(1) t (.in(ext_clock), .out(HDR2_46_SM_12_N), .en(clock_gate));
   tristate #(8) d (.in(data), .out(data_ext), .en(data_en));
   tristate #(16) a (.in(addr), .out(addr_ext), .en(addr_en));

   assign addr_in_SB = addr_ext == 16'hFF01;
   assign addr_in_SC = addr_ext == 16'hFF02;
   
   initial begin
      repeat(19) @(posedge cpu_clock);
      addr = 16'hFF01;
      data = 8'hAA;
      data_en = 1;
      addr_en = 1;
      mem_we <= 1;
      @(posedge cpu_clock);
      mem_we <= 0;

      @(posedge cpu_clock);
      mem_we <= 1;
      data = 8'h81;
      addr = 16'hFF02;

      @(posedge cpu_clock);
      mem_we <= 0;
      data_en = 0;
      addr_en = 0;
      repeat (8) @(negedge HDR2_46_SM_12_N);
      
      repeat (500) @(posedge cpu_clock);
      
      addr = 16'hFF02;
      data = 8'h80;
      data_en = 1;
      addr_en = 1;
      mem_re <= 0;
      mem_we <= 1;
      @(posedge cpu_clock);
      addr = 16'hFFFF;
      data = 8'h80;
      data_en = 1;
      addr_en = 1;
      mem_re <= 0;
      mem_we <= 0;
      @(posedge cpu_clock);
      data_en = 0;
      addr_en = 0;
      repeat(2) @(posedge cpu_clock);
      clock_gate <= 1;
      repeat(8) begin
	 counter <= counter + 1;
	 HDR2_42_SM_14_N <= ~counter[0];
	 @(negedge ext_clock);
      end
      HDR2_42_SM_14_N <= 1;
      clock_gate <= 0;
      repeat(20) @(posedge cpu_clock);
      #1 $finish;
   end // initial begin
endmodule // tb

// Local Variables:
// verilog-library-directories:("..")
// End:
