/* AC97 support
 *
 * Specifications:
 *   http://download.intel.com/support/motherboards/desktop/sb/ac97_r23.pdf
 *   http://www.xilinx.com/products/boards/ml505/datasheets/87560554AD1981B_c.pdf
 */

module AC97(
            input              square_wave_enable, 
	    input              sample_no,
	    input              ac97_bitclk,
	    input              ac97_sdata_in,
            input              rotary_inc_a,
            input              rotary_inc_b,
	    output wire        ac97_sdata_out,
	    output wire        ac97_sync,
	    output wire        ac97_reset_b,
	    input wire         flash_wait,
	    input wire [15:0]  flash_d,
	    output wire [23:0] flash_a,
	    output wire        flash_adv_n,
	    output wire        flash_ce_n,
	    output wire        flash_clk,
	    output wire        flash_oe_n,
	    output wire        flash_we_n,
            output wire        strobe,
	    input wire [3:0]   ch1_level,
	    input wire [3:0]   ch2_level,
	    input wire [3:0]   ch3_level
	);
   
	/*AUTOWIRE*/
	// Beginning of automatic wires (for undeclared instantiated-module outputs)
	wire [19:0]	ac97_out_slot1;		// From conf of AC97Conf.v
	wire		ac97_out_slot1_valid;	// From conf of AC97Conf.v
	wire [19:0]	ac97_out_slot2;		// From conf of AC97Conf.v
	wire		ac97_out_slot2_valid;	// From conf of AC97Conf.v
	wire [19:0]	ac97_out_slot3;		// From source of AudioGen.v
	wire [19:0]	ac97_out_slot4;		// From source of AudioGen.v
	wire		ac97_strobe;		// From link of ACLink.v
	// End of automatics
   assign strobe = ac97_strobe;
   
	wire        ac97_out_slot3_valid = 1;
	wire        ac97_out_slot4_valid = 1;

	wire        ac97_out_slot5_valid = 0;
	wire [19:0] ac97_out_slot5;
	wire        ac97_out_slot6_valid = 0;
	wire [19:0] ac97_out_slot6;
	wire        ac97_out_slot7_valid = 0;
	wire [19:0] ac97_out_slot7 = 'h0;
	wire        ac97_out_slot8_valid = 0;
	wire [19:0] ac97_out_slot8 = 'h0;
	wire        ac97_out_slot9_valid = 0;
	wire [19:0] ac97_out_slot9 = 'h0;
	wire        ac97_out_slot10_valid = 0;
	wire [19:0] ac97_out_slot10 = 'h0;
	wire        ac97_out_slot11_valid = 0;
	wire [19:0] ac97_out_slot11 = 'h0;
	wire        ac97_out_slot12_valid = 0;
	wire [19:0] ac97_out_slot12 = 'h0;

   wire [3:0]       level;

   rotary_controller rot (
                          .clk (ac97_bitclk),
                          .rotary_inc_a (rotary_inc_a),
                          .rotary_inc_b (rotary_inc_b),
                          .level (level)
                          );
   
	AudioGen source(
		/*AUTOINST*/
			// Outputs
			.ac97_out_slot3	(ac97_out_slot3[19:0] ),
			.ac97_out_slot4	(ac97_out_slot4[19:0]),
			.flash_a	(flash_a[23:0]),
			.flash_adv_n	(flash_adv_n),
			.flash_ce_n	(flash_ce_n),
			.flash_clk	(flash_clk),
			.flash_oe_n	(flash_oe_n),
			.flash_we_n	(flash_we_n),
			// Inputs
			.ac97_bitclk	(ac97_bitclk),
			.ac97_strobe	(ac97_strobe),
			.flash_wait	(flash_wait),
			.flash_d	(flash_d[15:0]),
			.sample_no      (sample_no),
                        .square_wave_enable (square_wave_enable),
                        .level (level[3:0]),
			.ch1_level(ch1_level[3:0]),
			.ch2_level(ch2_level[3:0]),
			.ch3_level(ch3_level[3:0]));
        
	ACLink link(
		/*AUTOINST*/
		    // Outputs
		    .ac97_sdata_out	(ac97_sdata_out),
		    .ac97_sync		(ac97_sync),
		    .ac97_reset_b	(ac97_reset_b),
		    .ac97_strobe	(ac97_strobe),
		    // Inputs
		    .ac97_bitclk	(ac97_bitclk),
		    .ac97_sdata_in	(ac97_sdata_in),
		    .ac97_out_slot1	(ac97_out_slot1[19:0]),
		    .ac97_out_slot1_valid(ac97_out_slot1_valid),
		    .ac97_out_slot2	(ac97_out_slot2[19:0]),
		    .ac97_out_slot2_valid(ac97_out_slot2_valid),
		    .ac97_out_slot3	(ac97_out_slot3[19:0]),
		    .ac97_out_slot3_valid(ac97_out_slot3_valid),
		    .ac97_out_slot4	(ac97_out_slot4[19:0]),
		    .ac97_out_slot4_valid(ac97_out_slot4_valid),
		    .ac97_out_slot5	(ac97_out_slot5[19:0]),
		    .ac97_out_slot5_valid(ac97_out_slot5_valid),
		    .ac97_out_slot6	(ac97_out_slot6[19:0]),
		    .ac97_out_slot6_valid(ac97_out_slot6_valid),
		    .ac97_out_slot7	(ac97_out_slot7[19:0]),
		    .ac97_out_slot7_valid(ac97_out_slot7_valid),
		    .ac97_out_slot8	(ac97_out_slot8[19:0]),
		    .ac97_out_slot8_valid(ac97_out_slot8_valid),
		    .ac97_out_slot9	(ac97_out_slot9[19:0]),
		    .ac97_out_slot9_valid(ac97_out_slot9_valid),
		    .ac97_out_slot10	(ac97_out_slot10[19:0]),
		    .ac97_out_slot10_valid(ac97_out_slot10_valid),
		    .ac97_out_slot11	(ac97_out_slot11[19:0]),
		    .ac97_out_slot11_valid(ac97_out_slot11_valid),
		    .ac97_out_slot12	(ac97_out_slot12[19:0]),
		    .ac97_out_slot12_valid(ac97_out_slot12_valid));

	AC97Conf conf(/*AUTOINST*/
		      // Outputs
		      .ac97_out_slot1	(ac97_out_slot1[19:0]),
		      .ac97_out_slot1_valid(ac97_out_slot1_valid),
		      .ac97_out_slot2	(ac97_out_slot2[19:0]),
		      .ac97_out_slot2_valid(ac97_out_slot2_valid),
		      // Inputs
		      .ac97_bitclk	(ac97_bitclk),
		      .ac97_strobe	(ac97_strobe));
endmodule

module AudioGen(
		input             ac97_bitclk,
		input             ac97_strobe,
		input             sample_no,
                input             square_wave_enable,
                input [3:0]       level,
		input [3:0]       ch1_level,
		input [3:0]       ch2_level,
		input [3:0]       ch3_level,
		output [19:0]     ac97_out_slot3,
		output [19:0]     ac97_out_slot4,
		input wire        flash_wait,
		input wire [15:0] flash_d,
		output reg [23:0] flash_a,
		output reg        flash_adv_n,
		output wire       flash_ce_n,
		output wire       flash_clk,
		output wire       flash_oe_n,
		output wire       flash_we_n
		);

   assign flash_ce_n = 'h0;
   assign flash_oe_n = 'h0;
   assign flash_we_n = 'h1;

   reg [23:0] 			  count = 'h0;

   reg [15:0] 			  curr_sample = 'h0;
   reg [15:0] 			  next_sample = 'h0;
   wire [19:0]                    square_sample;

   // NYAN: 481488 / 2 = 240744
   // Technologic: 439858 - 240744 = 199114
   // Both: 879716 / 2 = 439858
   
   always @(posedge ac97_bitclk) begin
      if (ac97_strobe) begin
	 //			if (count == 'd247968)
	 if ((~sample_no) & ((count == 'd240744) | (count >= 'd439858))) begin
	    count <= 'h0;
	 end else if (sample_no & (count >= 'd439858)) begin
	    count <= 'd240745;
	 end else begin
	    count <= count + 1;
	 end
	 
	 flash_a     <= count;
	 curr_sample <= next_sample;
	 flash_adv_n <= 'h0;
         
      end else if (!flash_wait) begin
	 flash_adv_n <= 'h1;
	 next_sample <= flash_d;
      end
   end // always @ (posedge ac97_bitclk)
   
   // Left Audio Channel
   assign ac97_out_slot3 = square_wave_enable ? ((ch1_level+ch2_level+ch3_level)<<(level)) : 
                           {curr_sample[15:8],curr_sample[7:0],4'h0};
   // Right Audio Channel
   assign ac97_out_slot4 = ac97_out_slot3;
   
endmodule



/* Timing diagrams for ACLink:
 *   http://nyus.joshuawise.com/ac97-clocking.scale.jpg
 */
module ACLink(
	input        ac97_bitclk,
	input        ac97_sdata_in,
	output wire  ac97_sdata_out,
	output wire  ac97_sync,
	output wire  ac97_reset_b,
	
	output wire  ac97_strobe,
	
	input [19:0] ac97_out_slot1,
	input        ac97_out_slot1_valid,
	input [19:0] ac97_out_slot2,
	input        ac97_out_slot2_valid,
	input [19:0] ac97_out_slot3,
	input        ac97_out_slot3_valid,
	input [19:0] ac97_out_slot4,
	input        ac97_out_slot4_valid,
	input [19:0] ac97_out_slot5,
	input        ac97_out_slot5_valid,
	input [19:0] ac97_out_slot6,
	input        ac97_out_slot6_valid,
	input [19:0] ac97_out_slot7,
	input        ac97_out_slot7_valid,
	input [19:0] ac97_out_slot8,
	input        ac97_out_slot8_valid,
	input [19:0] ac97_out_slot9,
	input        ac97_out_slot9_valid,
	input [19:0] ac97_out_slot10,
	input        ac97_out_slot10_valid,
	input [19:0] ac97_out_slot11,
	input        ac97_out_slot11_valid,
	input [19:0] ac97_out_slot12,
	input        ac97_out_slot12_valid
	);
	
	assign ac97_reset_b = 1;
	
	// We may want to make this into a state machine eventually.
	reg [7:0] curbit = 8'h0;	// Contains the bit currently on the bus.
	
	reg [255:0] inbits = 256'h0;
	reg [255:0] latched_inbits;
	
	/* Spec sez: rising edge should be in the middle of the final bit of
	 * the last slot, and the falling edge should be in the middle of
	 * the final bit of the TAG slot.
	 */
	assign ac97_sync = (curbit == 255) || (curbit < 15); 
	
	/* The outside world is permitted to read our latched data on the
	 * rising edge after bit 0 is transmitted.  Bit FF will have been
	 * latched on its falling edge, which means that on the rising edge
	 * that still contains bit FF, the "us to outside world" flipflops
	 * will have been triggered.  Given that, by the rising edge that
	 * contains bit 0, those flip-flops will have data.  So, the outside
	 * world strobe will be high on the rising edge that contains bit 0.
	 *
	 * Additionally, this strobe controls when the outside world will
	 * strobe new data into us.  The rising edge will latch new data
	 * into our inputs.  This data, in theory, will show up in time for
	 * the falling edge of the bit clock for big 01.
	 *
	 * NOTE: We need UCF timing constraints with setup times to make
	 * sure this happens!
	 */	 
	assign ac97_strobe = (curbit == 8'h00);
	
	/* The internal strobe for the output flip-flops needs to happen on
	 * the rising edge that still contains bit FF.
	 */
	always @(posedge ac97_bitclk) begin
		if (curbit == 8'hFF) begin
			latched_inbits <= inbits;
		end
		curbit <= curbit + 1;
	end
	
	always @(negedge ac97_bitclk)
		inbits[curbit] <= ac97_sdata_in;
	
	/* Bit order is reversed; msb of tag sent first. */
	wire [0:255] outbits = { /* TAG */
	                         1'b1,
	                         ac97_out_slot1_valid,
	                         ac97_out_slot2_valid,
	                         ac97_out_slot3_valid,
	                         ac97_out_slot4_valid,
	                         ac97_out_slot5_valid,
	                         ac97_out_slot6_valid,
	                         ac97_out_slot7_valid,
	                         ac97_out_slot8_valid,
	                         ac97_out_slot9_valid,
	                         ac97_out_slot10_valid,
	                         ac97_out_slot11_valid,
	                         ac97_out_slot12_valid,
	                         3'b000,
	                         /* and then time slots */
	                         ac97_out_slot1_valid ? ac97_out_slot1 : 20'h0,
	                         ac97_out_slot2_valid ? ac97_out_slot2 : 20'h0,
	                         ac97_out_slot3_valid ? ac97_out_slot3 : 20'h0,
	                         ac97_out_slot4_valid ? ac97_out_slot4 : 20'h0,
	                         ac97_out_slot5_valid ? ac97_out_slot5 : 20'h0,
	                         ac97_out_slot6_valid ? ac97_out_slot6 : 20'h0,
	                         ac97_out_slot7_valid ? ac97_out_slot7 : 20'h0,
	                         ac97_out_slot8_valid ? ac97_out_slot8 : 20'h0,
	                         ac97_out_slot9_valid ? ac97_out_slot9 : 20'h0,
	                         ac97_out_slot10_valid ? ac97_out_slot10 : 20'h0,
	                         ac97_out_slot11_valid ? ac97_out_slot11 : 20'h0,
	                         ac97_out_slot12_valid ? ac97_out_slot12 : 20'h0
	                         };
	
	/* Spec sez: should transition shortly after the rising edge.  In
	 * the end, we probably want to flop this to guarantee that (or set
	 * up UCF constraints as mentioned above).
	 */
	assign ac97_sdata_out = outbits[curbit];
/*
	wire [35:0] cs_control0;

	chipscope_icon icon0(
		.CONTROL0(cs_control0) // INOUT BUS [35:0]
	);
	
	chipscope_ila ila0 (
		.CONTROL(cs_control0), // INOUT BUS [35:0]
		.CLK(ac97_bitclk), // IN
		.TRIG0({'b0, ac97_sdata_out, inbits[curbit], ac97_sync, curbit[7:0]}) // IN BUS [255:0]
	);*/
endmodule

module AC97Conf(
	input              ac97_bitclk,
	input              ac97_strobe,
	output wire [19:0] ac97_out_slot1,
	output wire        ac97_out_slot1_valid,
	output wire [19:0] ac97_out_slot2,
	output wire        ac97_out_slot2_valid
	);
	
	reg        ac97_out_slot1_valid_r;
	reg [19:0] ac97_out_slot1_r;
	reg        ac97_out_slot2_valid_r;
	reg [19:0] ac97_out_slot2_r;
	
	assign ac97_out_slot1 = ac97_out_slot1_r;
	assign ac97_out_slot1_valid = ac97_out_slot1_valid_r;
	assign ac97_out_slot2 = ac97_out_slot2_r;
	assign ac97_out_slot2_valid = ac97_out_slot2_valid_r;

	reg [3:0] state = 4'h0;
	reg [3:0] nextstate = 4'h0;
	always @(*) begin
		ac97_out_slot1_valid_r = 0;
		ac97_out_slot1_r = 20'hxxxxx;
		ac97_out_slot2_valid_r = 0;
		ac97_out_slot2_r = 20'hxxxxx;
		nextstate = state;
		case (state)
		4'h0: begin
			ac97_out_slot1_valid_r = 1;
			ac97_out_slot1_r = {1'b0 /* write */, 7'h00 /* reset */, 12'b0 /* reserved */};
			ac97_out_slot2_valid_r = 1;
			ac97_out_slot2_r = {16'h0, 4'h0};
			nextstate = 4'h1;
		end
		4'h1: begin
			ac97_out_slot1_valid_r = 1;
			ac97_out_slot1_r = {1'b0 /* write */, 7'h02 /* master volume */, 12'b0 /* reserved */};
			ac97_out_slot2_valid_r = 1;
			ac97_out_slot2_r = {16'h0 /* unmuted, full volume */, 4'h0};
			nextstate = 4'h2;
		end
		4'h2: begin
			ac97_out_slot1_valid_r = 1;
			ac97_out_slot1_r = {1'b0 /* write */, 7'h18 /* pcm volume */, 12'b0 /* reserved */};
			ac97_out_slot2_valid_r = 1;
			ac97_out_slot2_r = {16'h0808 /* unmuted, 0dB */, 4'h0};
			nextstate = 4'h3;
		end
		4'h3: begin
			ac97_out_slot1_valid_r = 1;
			ac97_out_slot1_r = {1'b1 /* read */, 7'h26 /* power status */, 12'b0 /* reserved */};
			ac97_out_slot2_valid_r = 1;
			ac97_out_slot2_r = {20'h00000};
			nextstate = 4'h4;
		end
		4'h4: begin
			ac97_out_slot1_valid_r = 1;
			ac97_out_slot1_r = {1'b1 /* read */, 7'h7c /* vid0 */, 12'b0 /* reserved */};
			ac97_out_slot2_valid_r = 1;
			ac97_out_slot2_r = {20'h00000};
			nextstate = 4'h5;
		end
		4'h5: begin
			ac97_out_slot1_valid_r = 1;
			ac97_out_slot1_r = {1'b1 /* read */, 7'h7e /* vid1 */, 12'b0 /* reserved */};
			ac97_out_slot2_valid_r = 1;
			ac97_out_slot2_r = {20'h00000};
			nextstate = 4'h3;
		end
		endcase
	end
	
	always @(posedge ac97_bitclk)
		if (ac97_strobe)
			state <= nextstate;
endmodule
