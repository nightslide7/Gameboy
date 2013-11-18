module mux(/*AUTOARG*/
   // Outputs
   out,
   // Inputs
   in, sel
   );
   parameter
     width = 8,
     channels = 4;
   
   output [width-1:0] out;
   input [(channels * width) - 1:0] in;
   input [log2(channels) - 1:0]     sel;

   genvar                       i;

   wire [width-1:-0]            in_array [0:channels-1];

   assign out = in_array[sel];

   generate
      for (i = 0; i < channels; i = i + 1) begin: genloop1
         assign in_array[i] = in[((i + 1) * width) - 1:(i * width)];
      end
   endgenerate
   
   function integer log2;
      input integer value;
      begin
         value = value-1;
         for (log2 = 0; value > 0; log2 = log2 + 1) begin
           value = value >> 1;
         end
      end
   endfunction
   
endmodule // mux

  
