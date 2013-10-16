module clock_divider(/*AUTOARG*/
   // Outputs
   clock_out,
   // Inputs
   clock_in, reset
   );

   parameter
     BITS = 3;

   output wire clock_out;

   input wire  clock_in, reset;
   
   reg [BITS-1:0]           counter;

   assign clock_out = counter[BITS-1];

   always @(posedge clock_in) begin
      if (reset) begin
         counter <= {BITS{1'd0}};
      end
      else begin
         counter <= counter + {{BITS-1{1'd0}}, 1'd1};
      end
   end

endmodule
