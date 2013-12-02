/**
 * Gameboy NES controller
 * Sets register FF00 with button statuses as per Gameboy spec
 *
 */

module NES (input ac97_bitclk, //Audio clk (12.288MHz)
	    input clock,
	    input HDR2_2_SM_8_N,
	    input [7:0] FF00_data_in,
	    input FF00_load_in,
	    output reg [7:0] FF00_data_out,
	    output wire HDR2_6_SM_7_N,
	    output wire HDR2_4_SM_8_P,
	    output reg joypad_interrupt
	    );

   wire 	       controller_data;
   reg 		       strobe=0;
   reg 		       clk_out=0;
   
   assign controller_data = HDR2_2_SM_8_N;
   assign HDR2_4_SM_8_P = strobe;
   assign HDR2_6_SM_7_N = clk_out;

   reg 	       ctrl_a;//all controller signals asserted low
   reg 	       ctrl_b;
   reg 	       ctrl_sel;
   reg 	       ctrl_start;
   reg 	       ctrl_up;
   reg 	       ctrl_dn;
   reg 	       ctrl_l;
   reg 	       ctrl_r;

   reg        cpu_a_b_sel_start_b;
   reg        cpu_r_l_up_dn_b;
   wire        cpu_clock;

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
			      .clock_in (ac97_bitclk)
			      );

   my_clock_divider #(.DIV_SIZE(7), .DIV_OVER_TWO(40)) //~4.125MHz
   cdiv(.clock_out(cpu_clock),
        .clock_in(clock));
   
   always @(posedge ac97_bitclk) begin
      if (FF00_load_in) begin
	 cpu_a_b_sel_start_b <= FF00_data_in[5];
	 cpu_r_l_up_dn_b <= FF00_data_in[4];
      end
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
      // Input and output to CPU
      if (~cpu_a_b_sel_start_b) begin
	 FF00_data_out[3:0] <= {ctrl_start, ctrl_sel, ctrl_b, ctrl_a};
      end
      else if (~cpu_r_l_up_dn_b) begin
	 FF00_data_out[3:0] <= {ctrl_dn, ctrl_up, ctrl_l, ctrl_r};
      end
   end // always @ (posedge ac97_bitclk)

   always @(posedge cpu_clock) begin
      if (~cpu_a_b_sel_start_b) begin
	 if (FF00_data_out[3:0] != {ctrl_start, ctrl_sel, ctrl_b, ctrl_a}) begin
	    joypad_interrupt <= 1;
	 end
 	 else begin
	    joypad_interrupt <= 0;
	 end
      end
      else if (~cpu_r_l_up_dn_b) begin
	 if (FF00_data_out[3:0] != {ctrl_dn, ctrl_up, ctrl_l, ctrl_r}) begin
	    joypad_interrupt <= 1;
	 end
 	 else begin
	    joypad_interrupt <= 0;
	 end	 
      end
      else begin
	 joypad_interrupt <= 0;
      end // else: !if(~cpu_r_l_up_dn_b)
   end // always @ (posedge cpu_clock)
      
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
	   ctrl_a <= controller_data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_A;
	end
	WAIT_A: begin
	   clk_out <= ~clk_out;
	   n_state <= B;
	end
	B: begin
	   ctrl_b <= controller_data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_B;
	end
	WAIT_B: begin
	   clk_out <= ~clk_out;
	   n_state <= SEL;
	end
	SEL: begin
	   ctrl_sel <= controller_data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_SEL;
	end
	WAIT_SEL: begin
	   clk_out <= ~clk_out;
	   n_state <= START;
	end
	START: begin
	   ctrl_start <= controller_data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_START;
	end
	WAIT_START: begin
	   clk_out <= ~clk_out;
	   n_state <= UP;
	end
	UP: begin
	   ctrl_up <= controller_data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_UP;
	end
	WAIT_UP: begin
	   clk_out <= ~clk_out;
	   n_state <= DN;
	end
	DN: begin
	   ctrl_dn <= controller_data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_DN;
	end
	WAIT_DN: begin
	   clk_out <= ~clk_out;
	   n_state <= LEFT;
	end
	LEFT: begin
	   ctrl_l <= controller_data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT_LEFT;
	end
	WAIT_LEFT: begin
	   clk_out <= ~clk_out;
	   n_state <= RIGHT;
	end
	RIGHT: begin
	   ctrl_r <= controller_data;
	   clk_out <= ~clk_out;
	   n_state <= WAIT;
	end
      endcase // case state
   end // always @ (posedge state_clk)
endmodule