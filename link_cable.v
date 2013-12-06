`default_nettype none
/**
 * Gameboy link cable module
 * 
 * Serial data transfer in and out of FF01
 * FF02 is control register
 */

module link_cable (/*AUTOARG*/
   // Outputs
   HDR2_40_SM_6_P, link_cable_interrupt,
   // Inouts
   HDR2_46_SM_12_N, data_ext, addr_ext,
   // Inputs
   cpu_clock, reset, HDR2_42_SM_14_N, addr_in_SB,
   addr_in_SC, mem_we, mem_re
   );

   input cpu_clock;
   input reset;
   output wire HDR2_40_SM_6_P; //pin 2
   input      HDR2_42_SM_14_N; //pin 3
   inout      HDR2_46_SM_12_N; //pin 5 (clock in)
   inout [7:0] data_ext;
   inout [15:0] addr_ext;
   input 	addr_in_SB;
   input 	addr_in_SC;
   input 	mem_we;
   input 	mem_re;
   output reg 	link_cable_interrupt;

   wire internal_clock;
   wire data_in;
   reg data_out;
   wire using_external_clock;
   reg 	sck_state, next_sck_state, send_clock;
   reg [4:0] counter;
   reg [7:0] SB, SC;
   
   assign data_in = HDR2_42_SM_14_N;
   assign HDR2_40_SM_6_P = data_out;
   assign using_external_clock = ~SC[0];


   tristate #(8) sb (.in(SB), .out(data_ext), .en(mem_re&addr_in_SB));
   tristate #(8) sc (.in(SC), .out(data_ext), .en(mem_re&addr_in_SC));
   tristate #(1) clk (.in(internal_clock), .out(HDR2_46_SM_12_N),
		     .en(send_clock));
   
//   register #(8) sc_reg (.d(data_ext), .q(SC), .load(mem_we&addr_in_SC),
//			 .reset(reset), .clock(cpu_clock));
   
   my_clock_divider #(.DIV_SIZE(10), .DIV_OVER_TWO(252)) //~8184.52 Hz
   int_clock(.clock_out(internal_clock),
		  .clock_in(cpu_clock));

   always@(posedge cpu_clock or posedge reset) begin
      if (reset) begin
	 sck_state <= 1;
	 SB <= 8'd0;
	 data_out <= 1;
	 SC <= 8'h01;
	 counter <= 0;
	 link_cable_interrupt <= 0;
      end
      else begin
	 link_cable_interrupt <= 0;
	 sck_state <= next_sck_state;
	 if (counter <= 4'd7) begin
	    case (sck_state)
	      0: begin
		 if (next_sck_state) begin
		    SB <= {SB[6:0],data_in};
		    counter <= counter + 1;
		 end
	      end
	      1: begin
		 if (~next_sck_state) begin
		    data_out <= SB[7];
		 end
	      end
	    endcase // case (sck_state)
	 end // if (counter <= 7)
	 else if (counter == 4'd8) begin
	    counter <= 0;
	    link_cable_interrupt <= 1;
	    SC[7] <= 0;
	 end
	 if (mem_we & addr_in_SC) begin
	    SC <= data_ext;
	 end
	 if (mem_we & addr_in_SB) begin
	    SB <= data_ext;
	 end
      end
   end // always@ (posedge cpu_clock or posedge reset)
   
   always@(*) begin
      if (SC[7]) begin
	 if (using_external_clock) begin
	    next_sck_state = HDR2_46_SM_12_N;
	    send_clock = 0;
	 end
	 else begin
	    next_sck_state = internal_clock;
	    send_clock = 1;
	 end
      end // if (SC[7])
      else begin
	 send_clock = 0;
	 next_sck_state = 1'b1;
      end
   end // always@ (*)
endmodule