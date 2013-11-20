module rotary_controller(
		         input            clk,
                         input            rotary_inc_a,
                         input            rotary_inc_b,
			 input            reset,
		         output reg [3:0] level = 4'hE
                   );

   reg [3:0] 			      state = 4'd0;
   reg [3:0] 			      next_state = 4'd0;
   reg 				      inc;
   reg 				      dec;
   
   always@(posedge clk or posedge reset) begin
      if (reset) begin
	 level <= 4'hE;
	 state <= 4'd0;
      end
      else begin
	 state <= next_state;
	 if (inc && (level != 4'hf)) level <= level + 1;
	 else if (dec && (level != 0)) level <= level - 1;
      end
   end

   always@( * ) begin
      case (state)
	4'd0: begin
	   if (rotary_inc_a) begin
	      next_state = 4'd1;
	   end
	   else if (rotary_inc_b) begin
	      next_state = 4'd4;
	   end
	   else begin
	      next_state = 4'd0;
	   end
           inc = 0;
           dec = 0;
	end // case: 4'd0
	4'd1: begin
	   if (~rotary_inc_a & ~rotary_inc_b) begin
	      next_state = 4'd0;
	   end
	   else if (rotary_inc_a & ~rotary_inc_b) begin
	      next_state = 4'd1;
	   end
	   else begin
	      next_state = 4'd2;
	   end
           inc = 0;
           dec = 0;
	end // case: 4'd1
	4'd2: begin
           inc = 0;
           dec = 0;
	   if (~rotary_inc_b & rotary_inc_a) begin
	      next_state = 4'd1;
	   end
	   else if (rotary_inc_b & ~rotary_inc_a) begin
	      next_state = 4'd3;
	   end
	   else if (rotary_inc_a & rotary_inc_b) begin
	      next_state = 4'd2;
	   end
	   else begin
	      next_state = 4'd0;
              dec = 1;
	   end
	end // case: 4'd2
	4'd3: begin
           inc = 0;
           dec = 0;
	   if (rotary_inc_a) begin
	      next_state = 4'd2;
	   end
	   else if (~rotary_inc_a & ~rotary_inc_b) begin
	      next_state = 4'd0;
              dec = 1;
	   end
	   else begin
	      next_state = 4'd3;
	   end
	end // case: 4'd3
	4'd4: begin
           inc = 0;
           dec = 0;
	   if (~rotary_inc_b & ~rotary_inc_a) begin
	      next_state = 4'd0;
	   end
	   else if (rotary_inc_b & ~rotary_inc_a) begin
	      next_state = 4'd4;
	   end
	   else begin
	      next_state = 4'd5;
	   end
	end // case: 4'd4
	4'd5: begin
           inc = 0;
           dec = 0;
	   if (~rotary_inc_a & rotary_inc_b) begin
	      next_state = 4'd4;
	   end
	   else if (rotary_inc_a & ~rotary_inc_b) begin
	      next_state = 4'd6;
	   end
	   else if (rotary_inc_b & rotary_inc_a) begin
	      next_state = 4'd5;
	   end
	   else begin
	      next_state = 4'd0;
              inc = 1;
	   end
	end // case: 4'd5
	4'd6: begin
           inc = 0;
           dec = 0;
	   if (rotary_inc_b) begin
	      next_state = 4'd5;
	   end
	   else if (~rotary_inc_b & ~rotary_inc_a) begin
	      next_state = 4'd0;
              inc = 1;
	   end
	   else begin
	      next_state = 4'd6;
	   end
	end // case: 4'd6
        default: begin
           next_state = 4'd0;
           inc = 0;
           dec = 0;
        end
      endcase // case (state)
   end // always@ ( * )
endmodule