`default_nettype none

module audio_top (input              square_wave_enable, 
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
		  output wire [3:0] 			     ch3_out,
		  input wire ch3_reset_test
		  );
   reg [15:0] 			     reg_addr=16'hffff;
   reg [7:0] 			     reg_data=8'hff;
   reg 				     reg_w_enable=0;
   wire [2:0] 			     ch1_sweep_time;
   wire 			     ch1_sweep_decreasing;
   wire [2:0] 			     ch1_num_sweep_shifts;
   wire [1:0] 			     ch1_wave_duty;
   wire [5:0] 			     ch1_length_data;
   wire [3:0] 			     ch1_initial_volume;
   wire 			     ch1_envelope_increasing;
   wire [2:0] 			     ch1_num_envelope_sweeps;
   wire 			     ch1_reset;
   wire 			     ch1_dont_loop;
   wire [10:0] 			     ch1_frequency_data;
   wire [1:0] 			     ch2_wave_duty;
   wire [5:0] 			     ch2_length_data;
   wire [3:0] 			     ch2_initial_volume;
   wire 			     ch2_envelope_increasing;
   wire [2:0] 			     ch2_num_envelope_sweeps;
   wire 			     ch2_reset;
   wire 			     ch2_dont_loop;
   wire [10:0] 			     ch2_frequency_data;
   wire 			     ch3_enable;
   wire [7:0] 			     ch3_length_data;
   wire [1:0] 			     ch3_output_level;
   wire 			     ch3_reset;
   wire 			     ch3_dont_loop;
   wire [10:0] 			     ch3_frequency_data;
   wire [127:0] 		     ch3_samples;
   wire [5:0] 			     ch4_length_data;
   wire [3:0] 			     ch4_initial_volume;
   wire 			     ch4_envelope_increasing;
   wire [2:0] 			     ch4_num_envelope_sweeps;
   wire [3:0] 			     ch4_shift_clock_freq_data;
   wire 			     ch4_counter_width;
   wire [2:0] 			     ch4_freq_dividing_ratio;
   wire 			     ch4_reset;
   wire 			     ch4_dont_loop;
   wire 			     SO2_Vin;
   wire [2:0] 			     SO2_output_level;
   wire 			     SO1_Vin;
   wire [2:0] 			     SO1_output_level;
   wire 			     SO2_ch4_enable;
   wire 			     SO2_ch3_enable;
   wire 			     SO2_ch2_enable;
   wire 			     SO2_ch1_enable;
   wire 			     SO1_ch4_enable;
   wire 			     SO1_ch3_enable;
   wire 			     SO1_ch2_enable;
   wire 			     SO1_ch1_enable;
   wire 			     sound_master_enable;
   wire 			     ch4_on_flag;
   wire 			     ch3_on_flag;
   wire 			     ch2_on_flag;
   wire 			     ch1_on_flag;
   
   AC97 gen(/*AUTOINST*/
	    // Outputs
	    .ac97_sdata_out		(ac97_sdata_out),
	    .ac97_sync			(ac97_sync),
	    .ac97_reset_b		(ac97_reset_b),
	    .flash_a			(flash_a[23:0]),
	    .flash_adv_n		(flash_adv_n),
	    .flash_ce_n			(flash_ce_n),
	    .flash_clk			(flash_clk),
	    .flash_oe_n			(flash_oe_n),
	    .flash_we_n			(flash_we_n),
	    .strobe			(strobe),
	    // Inputs
	    .square_wave_enable		(square_wave_enable),
	    .sample_no			(sample_no),
	    .ac97_bitclk		(ac97_bitclk),
	    .ac97_sdata_in		(ac97_sdata_in),
	    .rotary_inc_a		(rotary_inc_a),
	    .rotary_inc_b		(rotary_inc_b),
	    .flash_wait			(flash_wait),
	    .flash_d			(flash_d[15:0]),
	    .ch3_vol			(ch3_out[3:0]));/*square_wave_enable, sample_no, ac97_bitclk, ac97_sdata_in,
	    rotary_inc_a, rotary_inc_b, ac97_sdata_out, ac97_sync,
	    ac97_reset_b, flash_wait, flash_d, flash_a, flash_adv_n,
	    flash_ce_n, flash_clk, flash_oe_n, flash_we_n, strobe,
	    ch3_out
	    );*/

   // The frame sequencer is a 512Hz clock from which other timing clocks
   // are derived
   wire 			     frame_sequencer_clk;
   
   my_clock_divider #(.DIV_SIZE(15), .DIV_OVER_TWO(12000)) 
                    framediv(.clock_out (frame_sequencer_clk),
			  .clock_in (ac97_bitclk)
			  );

   // The length control clock is a 256Hz clock. Audio is played in multiples
   // of 256Hz
   wire 			     length_cntrl_clk;

   my_clock_divider #(.DIV_SIZE(2), .DIV_OVER_TWO(1)) 
                    lendiv(.clock_out (length_cntrl_clk),
			   .clock_in (frame_sequencer_clk)
			   );

   // Channel 3 has a specific frequency for its frequency control clock
   wire 			     ch3_freq_cntrl_clk;

   /* NOT PERFECT - try to fix. Is 65361.702Hz, should be 65536Hz*/
   my_clock_divider #(.DIV_SIZE(7), .DIV_OVER_TWO(94))
                    freq3div(.clock_out (ch3_freq_cntrl_clk),
			     .clock_in (ac97_bitclk)
			     );

   sound_registers regs(/*AUTOINST*/
			// Outputs
			.ch1_sweep_time	(ch1_sweep_time[2:0]),
			.ch1_sweep_decreasing(ch1_sweep_decreasing),
			.ch1_num_sweep_shifts(ch1_num_sweep_shifts[2:0]),
			.ch1_wave_duty	(ch1_wave_duty[1:0]),
			.ch1_length_data(ch1_length_data[5:0]),
			.ch1_initial_volume(ch1_initial_volume[3:0]),
			.ch1_envelope_increasing(ch1_envelope_increasing),
			.ch1_num_envelope_sweeps(ch1_num_envelope_sweeps[2:0]),
			.ch1_reset	(ch1_reset),
			.ch1_dont_loop	(ch1_dont_loop),
			.ch1_frequency_data(ch1_frequency_data[10:0]),
			.ch2_wave_duty	(ch2_wave_duty[1:0]),
			.ch2_length_data(ch2_length_data[5:0]),
			.ch2_initial_volume(ch2_initial_volume[3:0]),
			.ch2_envelope_increasing(ch2_envelope_increasing),
			.ch2_num_envelope_sweeps(ch2_num_envelope_sweeps[2:0]),
			.ch2_reset	(ch2_reset),
			.ch2_dont_loop	(ch2_dont_loop),
			.ch2_frequency_data(ch2_frequency_data[10:0]),
			.ch3_enable	(ch3_enable),
			.ch3_length_data(ch3_length_data[7:0]),
			.ch3_output_level(ch3_output_level[1:0]),
			.ch3_reset	(ch3_reset),
			.ch3_dont_loop	(ch3_dont_loop),
			.ch3_frequency_data(ch3_frequency_data[10:0]),
			.ch3_samples	(ch3_samples[127:0]),
			.ch4_length_data(ch4_length_data[5:0]),
			.ch4_initial_volume(ch4_initial_volume[3:0]),
			.ch4_envelope_increasing(ch4_envelope_increasing),
			.ch4_num_envelope_sweeps(ch4_num_envelope_sweeps[2:0]),
			.ch4_shift_clock_freq_data(ch4_shift_clock_freq_data[3:0]),
			.ch4_counter_width(ch4_counter_width),
			.ch4_freq_dividing_ratio(ch4_freq_dividing_ratio[2:0]),
			.ch4_reset	(ch4_reset),
			.ch4_dont_loop	(ch4_dont_loop),
			.SO2_Vin	(SO2_Vin),
			.SO2_output_level(SO2_output_level[2:0]),
			.SO1_Vin	(SO1_Vin),
			.SO1_output_level(SO1_output_level[2:0]),
			.SO2_ch4_enable	(SO2_ch4_enable),
			.SO2_ch3_enable	(SO2_ch3_enable),
			.SO2_ch2_enable	(SO2_ch2_enable),
			.SO2_ch1_enable	(SO2_ch1_enable),
			.SO1_ch4_enable	(SO1_ch4_enable),
			.SO1_ch3_enable	(SO1_ch3_enable),
			.SO1_ch2_enable	(SO1_ch2_enable),
			.SO1_ch1_enable	(SO1_ch1_enable),
			.sound_master_enable(sound_master_enable),
			.ch4_on_flag	(ch4_on_flag),
			.ch3_on_flag	(ch3_on_flag),
			.ch2_on_flag	(ch2_on_flag),
			.ch1_on_flag	(ch1_on_flag),
			// Inputs
			.addr		(reg_addr[15:0]),
			.data		(reg_data[7:0]),
			.w_enable	(reg_w_enable));/*reg_addr, reg_data, reg_w_enable, ch1_sweep_time,
			ch1_sweep_decreasing, ch1_num_sweep_shifts,
			ch1_wave_duty, ch1_length_data, ch1_initial_volume,
			ch1_envelope_increasing, ch1_num_envelope_sweeps,
			ch1_reset, ch1_dont_loop, ch1_frequency_data,
			ch2_wave_duty, ch2_length_data, ch2_initial_volume,
			ch2_envelope_increasing, ch2_num_envelope_sweeps,
			ch2_reset, ch2_dont_loop, ch2_frequency_data,
			ch3_enable, ch3_length_data, ch3_output_level,
			ch3_reset, ch3_dont_loop, ch3_frequency_data,
			ch3_samples, ch4_length_data, ch4_initial_volume,
			ch4_envelope_increasing, ch4_num_envelope_sweeps,
			ch4_shift_clock_freq_data, ch4_counter_width,
			ch4_freq_dividing_ratio, ch4_reset, ch4_dont_loop,
			SO2_Vin, SO2_output_level, SO1_Vin, SO1_output_level,
			SO2_ch4_enable, SO2_ch3_enable, SO2_ch2_enable,
			SO2_ch1_enable, SO1_ch4_enable, SO1_ch3_enable,
			SO1_ch2_enable, SO1_ch1_enable, sound_master_enable,
			ch4_on_flag, ch3_on_flag, ch2_on_flag, ch1_on_flag
			);*/

   WaveformPlayer wp(.clk(ac97_bitclk),
		     .level(ch3_out),
		     .ch3_enable	(ch3_enable),
		     .ch3_length_data(ch3_length_data[7:0]),
		     .ch3_output_level(ch3_output_level[1:0]),
		     .ch3_reset	(ch3_reset_test),
		     .ch3_dont_loop	(ch3_dont_loop),
		     .ch3_frequency_data(ch3_frequency_data[10:0]),
		     .ch3_samples	(ch3_samples[127:0]),
		     .length_cntrl_clk(length_cntrl_clk),
		     .ch3_freq_cntrl_clk(ch3_freq_cntrl_clk));
endmodule // audio_top

// Local Variables:
// verilog-library-directories:("." "./AC97_work" "./sound_functions")
// End:
