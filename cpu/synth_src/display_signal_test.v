module display_signal_test();
   parameter width = 16;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 clearAll;               // From dut of display_signal.v
   wire [3:0]           display_hex_data_in;    // From dut of display_signal.v
   wire                 display_hex_start;      // From dut of display_signal.v
   wire                 display_signal_done;    // From dut of display_signal.v
   // End of automatics

   reg [width-1:0]      display_signal_data;
   reg                  display_hex_done, display_signal_start;
   reg                  clock, reset;
   
   display_signal #(.width(width))
   dut(/*AUTOINST*/
       // Outputs
       .display_hex_data_in             (display_hex_data_in[3:0]),
       .display_hex_start               (display_hex_start),
       .display_signal_done             (display_signal_done),
       .clearAll                        (clearAll),
       // Inputs
       .display_signal_data             (display_signal_data[width-1:0]),
       .display_hex_done                (display_hex_done),
       .display_signal_start            (display_signal_start),
       .clock                           (clock),
       .reset                           (reset));

   initial clock = 0;
   always #5 clock = ~clock;

   initial begin
      display_signal_data <= 16'h1234;
      display_hex_done <= 1'd1;
      display_signal_start <= 1'd0;
      reset <= 1'd1;

      @(posedge clock);

      reset <= 1'd0;

      repeat (5) @(posedge clock);

      display_signal_start <= 1'd1;

      @(posedge clock);

      display_signal_start <= 1'd0;
      
      repeat (6) begin
         display_hex_done <= 1'd0;

         repeat (2) @(posedge clock);

         display_hex_done <= 1'd1;
         
         @(posedge clock);
      end

      repeat (2) @(posedge clock);

      #1 $finish;
      
   end
   
endmodule // display_signal_test
