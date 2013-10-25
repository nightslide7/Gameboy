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
		       input ch3_freq_cntrl_clk,
		       output reg [3:0] level
		       );
   reg [7:0] 	       index_hi = 3; //MSB of current sample
   wire [8:0] 	       true_len; //# of length_cntrl_clk edges before reset
   reg [8:0] 	       len_counter = 0;
   wire [11:0] 	       true_freq; //# of freq clks before next sample
   reg [11:0] 	       freq_counter = 0;
   reg [3:0] 	       reg_level; //synchronous level

   // The following numbers are specific to the Gameboy CH 3
   assign true_len = 9'd256 - ch3_length_data;
   assign true_freq = 12'd2048 - ch3_frequency_data;

   always@(posedge length_cntrl_clk) begin //play for specified length
      if (ch3_reset) begin
	 len_counter <= 0;
      end
      else if (len_counter <= true_len+1) begin //just past true_len
	 len_counter <= len_counter + 1;
      end
   end

   /* THIS IS WRONG, DOES NOT PLAY CORRECT FREQUENCY */
   always@(posedge ch3_freq_cntrl_clk) begin
      if (ch3_reset || ~ch3_enable) begin
	 reg_level <= 0;
	 index_hi <= 3;
	 freq_counter <= 0;
      end
      else begin
	 // Change samples at specified frequency
	 if (freq_counter == true_freq) begin
	    index_hi <= index_hi + 8'd4; //play next sample
	    freq_counter <= 12'b1; //true_freq always >= 1
	 end
	 else begin
	    freq_counter <= freq_counter + 12'b1;
	 end
	 // Play only for specified length
	 if ((ch3_dont_loop && (len_counter <= true_len)) ||
	     ~ch3_dont_loop) begin
	       if (index_hi <= 8'd127) begin
		  reg_level <= ch3_samples[index_hi -: 3]; //4 bits at a time
	       end
	    else begin
	       index_hi <= 3; //back to first sample
	    end
	 end
	 else if (len_counter > true_len) begin //stop output
	    reg_level <= 0;
	 end
      end // else: !if(ch3_reset)
   end // always@ (posedge clk)

   always@(*) begin
      //adjust volume
      if (ch3_output_level != 2'b0) begin
	 level = (reg_level >> (ch3_output_level - 1));
      end
      else begin
	 level = 0;
      end
   end
endmodule // WaveformPlayer
