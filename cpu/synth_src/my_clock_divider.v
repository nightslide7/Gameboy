module my_clock_divider(/*AUTOARG*/
   // Outputs
   clock_out,
   // Inputs
   clock_in
   );

   parameter
     DIV_SIZE = 15,
       DIV_OVER_TWO = 24000;
   

   output reg clock_out = 0;

   input wire  clock_in;
   
   reg [DIV_SIZE-1:0]           counter=0;

   always @(posedge clock_in) begin
      if (counter == DIV_OVER_TWO-1) begin
			clock_out = ~clock_out;
			counter <= 0;
      end
		else
			counter <= counter + 1;
   end

endmodule
