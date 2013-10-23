/**
 * sound_functions.v
 * 18-545
 * eob
 * 
 * Creates modules for dealing with the various sound functions
 * e.g. frequency sweep, volume envelope, waveforms and white noise
 * 
 */


/**
 * WaveformPlayer
 * 
 * Plays 32 4-bit samples stored in "memory"
 * Calculates length of sound from 256Hz timer "length_cntrl_clk"
 * 
 */
module WaveformPlayer (input clk,
		       input ch3_enable,
		       input [7:0] ch3_length_data,
		       input [1:0] ch3_output_level,
		       input ch3_reset,
		       input ch3_dont_loop,
		       input [10:0] ch3_frequency_data,
		       input [127:0] ch3_samples,
		       input length_cntrl_clk,
		       output reg [3:0] level
		       );
   reg [7:0] 	       index_hi = 3; //MSB of current sample
   wire [8:0] 	       true_len; //# of length_cntrl_clk edges before reset
   reg [8:0] 	       len_counter = 0;
   
   assign true_len = 9'd256 - ch3_length_data;

   always@(posedge length_cntrl_clk) begin
      if (ch3_reset) begin
	 len_counter <= 0;
      end
      else if (len_counter <= true_len+1) begin //just pass true_len
	 len_counter <= len_counter + 1;
      end
   end
   
   always@(posedge clk) begin
      if (ch3_reset) begin
	 level <= 0;
	 index_hi <= 3;
      end
      else begin
	 if ((ch3_dont_loop && (len_counter <= true_len)) ||
	     ~ch3_dont_loop) begin
	    if (index_hi <= 8'd127) begin
	       level <= ch3_samples[index_hi -: 3]; //4 bits at a time
	       index_hi <= index_hi + 8'd4;
	    end
	    else begin
	       index_hi <= 3; //back to first sample
	    end
	 end
	 else if (len_counter > true_len) begin //stop output
	    level <= 0;
	 end
      end // else: !if(ch3_reset)
   end // always@ (posedge clk)
endmodule // WaveformPlayer
