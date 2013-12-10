module tristate(/*AUTOARG*/
   // Outputs
   out,
   // Inputs
   in, en
   );
   parameter
     width = 1;
   output wire [width-1:0] out;
   input [width-1:0]       in;
   input                   en;

   assign out = (en) ? in : {width{1'bz}};
   
endmodule // tristate
