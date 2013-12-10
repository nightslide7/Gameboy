/**
 * A simple breakpoints module for the GB80 CPU.
 * 
 * Author: Joseph Carlos (jdcarlos1@gmail.com)
 */

module breakpoints(/*AUTOARG*/
   // Outputs
   bp_addr, bp_addr_disp, hi_lo_disp,
   // Inputs
   bp_addr_part_in, bp_hi_lo_sel_in, bp_hi_lo_disp_in, reset, clock
   );
   parameter
     reset_addr = 16'hffff;
   
   output reg [15:0] bp_addr = reset_addr;
   output reg [7:0]  bp_addr_disp;
   output reg        hi_lo_disp;
   
   input [7:0]       bp_addr_part_in;
   input             bp_hi_lo_sel_in, bp_hi_lo_disp_in;
   input             reset, clock;

   always @(posedge clock or posedge reset) begin
      if (reset) begin
         bp_addr <= reset_addr;
         hi_lo_disp <= 1'b0;
      end else begin
         if (bp_hi_lo_disp_in) begin
            hi_lo_disp <= ~hi_lo_disp;
         end else begin
            hi_lo_disp <= hi_lo_disp;
         end
         if (bp_hi_lo_sel_in & hi_lo_disp) begin
            bp_addr <= {bp_addr_part_in, bp_addr[7:0]};
         end else if (bp_hi_lo_sel_in) begin
            bp_addr <= {bp_addr[15:8], bp_addr_part_in};
         end
      end
   end

   always @(*) begin
      if (hi_lo_disp) begin
         bp_addr_disp = bp_addr[15:8];
      end else begin
         bp_addr_disp = bp_addr[7:0];
      end
   end
   
endmodule

