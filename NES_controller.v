module NES (input clk_in, //Audio clk (12.288MHz)
	    input data,
	    output reg clk_out=0,
	    output reg strobe=0,
	    output reg ctrl_a,//all controller signals asserted LOW
	    output reg ctrl_b,
	    output reg ctrl_sel,
	    output reg ctrl_start,
	    output reg ctrl_up,
	    output reg ctrl_dn,
	    output reg ctrl_l,
	    output reg ctrl_r
	    );

   parameter A = 5'd0, WAIT_A = 5'd1, B = 5'd2, WAIT_B = 5'd3, SEL = 5'd4,
	       WAIT_SEL = 5'd5, START = 5'd6, WAIT_START = 5'd7, UP = 5'd8,
	       WAIT_UP = 5'd9, DN = 5'd10, WAIT_DN = 5'd11, LEFT = 5'd12,
	       WAIT_LEFT = 5'd13, RIGHT = 5'd14, STROBED = 5'd15, WAIT = 5'd16;
   reg [4:0] 	       state=WAIT;
   reg [4:0] 	       n_state=WAIT;

   reg [17:0] 	   clock_counter; //for dividing the clock
   parameter DIV_CNT = 204800; //Gameboy polls controller at 60Hz

   wire 	   state_clk;
   my_clock_divider #(.DIV_SIZE(4), .DIV_OVER_TWO(1))
                    statediv (.clock_out (state_clk),
			      .clock_in (clk_in)
			      );
   
   always @(posedge clk_in) begin
      if (clock_counter == DIV_CNT) begin
	 strobe <= 1'd1;
	 state <= STROBED;
	 clock_counter <= 0;
      end
      else begin
	 strobe <= 0;
	 state <= n_state;
	 clock_counter <= clock_counter + 18'd1;
      end
   end // always @ (posedge clk_in)

   always @(posedge state_clk) begin
      case (state)
	WAIT: begin
	   clk_out <= 0;
	   n_state <= WAIT;
	end
	STROBED: begin
	   clk_out <= 0;
	   n_state <= A;
	end
	A: begin
	   ctrl_a <= data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_A;
	end
	WAIT_A: begin
	   clk_out <= ~clk_out;
	   n_state <= B;
	end
	B: begin
	   ctrl_b <= data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_B;
	end
	WAIT_B: begin
	   clk_out <= ~clk_out;
	   n_state <= SEL;
	end
	SEL: begin
	   ctrl_sel <= data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_SEL;
	end
	WAIT_SEL: begin
	   clk_out <= ~clk_out;
	   n_state <= START;
	end
	START: begin
	   ctrl_start <= data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_START;
	end
	WAIT_START: begin
	   clk_out <= ~clk_out;
	   n_state <= UP;
	end
	UP: begin
	   ctrl_up <= data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_UP;
	end
	WAIT_UP: begin
	   clk_out <= ~clk_out;
	   n_state <= DN;
	end
	DN: begin
	   ctrl_dn <= data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_DN;
	end
	WAIT_DN: begin
	   clk_out <= ~clk_out;
	   n_state <= LEFT;
	end
	LEFT: begin
	   ctrl_l <= data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_LEFT;
	end
	WAIT_LEFT: begin
	   clk_out <= ~clk_out;
	   n_state <= RIGHT;
	end
	RIGHT: begin
	   ctrl_r <= data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT;
	end
      endcase // case state
   end // always @ (posedge clk_in)
endmodule