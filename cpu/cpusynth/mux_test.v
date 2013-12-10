module mux_test();

   wire [3:0] out;

   reg [15:0] in;
   reg [1:0]  sel;

   mux #(.width(4),
         .channels(4)) dut(.out(out),
                           .in(in),
                           .sel(sel));

   reg        clock;
   initial clock = 0;
   always #5 clock = ~clock;

   initial begin
      $display("in, sel || out");
      $monitor(,"%16h, %3b || %4h",
               in, sel, out);

      in <= 16'h1234;
      sel <= 2'd0;

      @(posedge clock);

      sel <= 2'd1;

      @(posedge clock);

      sel <= 2'd2;

      @(posedge clock);

      sel <= 2'd3;

      @(posedge clock);

      #1 $finish;
      
   end

endmodule // mux_test
