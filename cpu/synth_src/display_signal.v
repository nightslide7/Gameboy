module display_signal(/*AUTOARG*/
   // Outputs
   display_hex_data_in, display_hex_start, display_signal_done,
   clearAll,
   // Inputs
   display_signal_data, display_hex_done, display_signal_start, clock,
   reset
   );
   parameter
     channels = 4, // # of bytes
     // Generated
     width = channels << 2; // channels * 4

   output wire [3:0] display_hex_data_in;
   output reg       display_hex_start;
   output reg       display_signal_done;
   output reg       clearAll;

   input [width-1:0] display_signal_data;
   input             display_hex_done;
   input             display_signal_start;
   input             clock, reset;

   reg [log2(channels)-1:0] count, next_count;

`define cdisp 1'd0
`define cwait 1'd1

   reg                      cstate, next_cstate;

   mux #(.width(4),
         .channels(channels)) signal_mux(.out(display_hex_data_in),
                                         .in(display_signal_data),
                                         .sel(count));
   always @(*) begin
      display_hex_start = 1'b0;
      next_cstate = `cdisp;
      next_count = count;
      clearAll = 1'b0;
      display_signal_done = 1'b0;
      case (cstate)
        `cdisp: begin
           if (~display_hex_done) begin
              display_hex_start = 1'b1;
              next_cstate = `cdisp;
           end else if (count == 0) begin
              next_cstate = `cwait;
              display_signal_done = 1;
              next_count = (channels - 1);
           end else begin
              display_hex_start = 1'b1;
              next_cstate = `cdisp;
              next_count = count - 1;
           end
        end
        `cwait: begin
           if (display_signal_start) begin
              next_cstate = `cdisp;
              clearAll = 1'b1;
           end else begin
              next_cstate = `cwait;
           end
        end
      endcase
   end
   
   always @(posedge clock or posedge reset) begin
      if (reset) begin
         cstate <= `cdisp;
         count <= (channels - 1);
      end else begin
         cstate <= next_cstate;
         count <= next_count;
      end
   end

   function integer log2;
      input integer value;
      begin
         value = value-1;
         for (log2 = 0; value > 0; log2 = log2 + 1) begin
           value = value >> 1;
         end
      end
   endfunction
   
endmodule // display_signal

