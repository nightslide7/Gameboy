`default_nettype none

module audio_top (input              square_wave_enable, 
		  input              sample_no,
		  input              ac97_bitclk,
		  input              ac97_sdata_in,
		  input              rotary_inc_a,
		  input              rotary_inc_b,
		  input [15:0]       reg_addr,
		  input [7:0]        reg_data,
		  input              reg_w_enable,
		  input              reset,
		  output wire        ac97_sdata_out,
		  output wire        ac97_sync,
		  output wire        ac97_reset_b,
/*		  input wire         flash_wait,
		  input wire [15:0]  flash_d,
		  output wire [23:0] flash_a,
		  output wire        flash_adv_n,
		  output wire        flash_ce_n,
		  output wire        flash_clk,
		  output wire        flash_oe_n,
		  output wire        flash_we_n,*/
		  output wire        strobe,
                  output wire [247:0] chipscope_signals,
                  output wire [23:0] control_regs
		  );
   wire [3:0] 		     ch1_level;
   wire [3:0] 		     ch2_level;
   wire [3:0] 		     ch3_level;
   
   
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
   wire 			     master_sound_enable;
   wire 			     ch4_on_flag;
   wire 			     ch3_on_flag;
   wire 			     ch2_on_flag;
   wire 			     ch1_on_flag;
   
   AC97 gen(/*AUTOINST*/
	    // Outputs
	    .ac97_sdata_out		(ac97_sdata_out),
	    .ac97_sync			(ac97_sync),
	    .ac97_reset_b		(ac97_reset_b),
	    .strobe			(strobe),
	    // Inputs
	    .square_wave_enable		(square_wave_enable),
	    .sample_no			(sample_no),
	    .ac97_bitclk		(ac97_bitclk),
	    .ac97_sdata_in		(ac97_sdata_in),
	    .rotary_inc_a		(rotary_inc_a),
	    .rotary_inc_b		(rotary_inc_b),
	    .SO1_ch1_enable		(SO1_ch1_enable),
	    .SO1_ch2_enable		(SO1_ch2_enable),
	    .SO1_ch3_enable		(SO1_ch3_enable),
	    .SO1_ch4_enable		(SO1_ch4_enable),
	    .SO2_ch1_enable		(SO2_ch1_enable),
	    .SO2_ch2_enable		(SO2_ch2_enable),
	    .SO2_ch3_enable		(SO2_ch3_enable),
	    .SO2_ch4_enable		(SO2_ch4_enable),
	    .master_sound_enable        (master_sound_enable),
	    .ch1_level			(ch1_level[3:0]),
	    .ch2_level			(ch2_level[3:0]),
	    .ch3_level			(ch3_level[3:0]));

   // The frame sequencer is a 512Hz clock from which other timing clocks
   // are derived
   wire 			     frame_sequencer_clk;
   
   my_clock_divider #(.DIV_SIZE(15), .DIV_OVER_TWO(12000)) 
                    framediv(.clock_out (frame_sequencer_clk),
			  .clock_in (ac97_bitclk)
			  );

   // The frequency sweep clock is a 128Hz clock. The frequency is swept
   // in multiples of 128Hz
   wire 			     square_sweep_cntrl_clk;

   my_clock_divider #(.DIV_SIZE(3), .DIV_OVER_TWO(2))
                    sweepdiv(.clock_out (square_sweep_cntrl_clk),
			     .clock_in (frame_sequencer_clk)
			     );

   // The volume envelope clock is a 64Hz clock. The volume is stepped
   // in multiples of 64Hz
   wire 			     square_envelope_cntrl_clk;

   my_clock_divider #(.DIV_SIZE(4), .DIV_OVER_TWO(4))
                    envdiv(.clock_out (square_envelope_cntrl_clk),
			   .clock_in (frame_sequencer_clk)
			   );
   
   // The length control clock is a 256Hz clock. Audio is played in multiples
   // of 256Hz
   wire 			     length_cntrl_clk;

   my_clock_divider #(.DIV_SIZE(2), .DIV_OVER_TWO(1)) 
                    lendiv(.clock_out (length_cntrl_clk),
			   .clock_in (frame_sequencer_clk)
			   );

   // Channels 1 and 2 have a specific frequency of 131072Hz for their
   // frequency control clock
   wire 			     ch1_2_freq_cntrl_clk;

   /* NOT PERFECT - try to fix. Is 130723.404Hz, should be 131072Hz */
   my_clock_divider #(.DIV_SIZE(6), .DIV_OVER_TWO(47))
                    freq12div(.clock_out (ch1_2_freq_cntrl_clk),
			      .clock_in (ac97_bitclk)
			      );
   
   // Channel 3 has a specific frequency of 65536Hz for its frequency 
   // control clock
   wire 			     ch3_freq_cntrl_clk;

   /* NOT PERFECT - try to fix. Is 65361.702Hz, should be 65536Hz */
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
			.master_sound_enable(master_sound_enable),
			.ch4_on_flag	(ch4_on_flag),
			.ch3_on_flag	(ch3_on_flag),
			.ch2_on_flag	(ch2_on_flag),
			.ch1_on_flag	(ch1_on_flag),
                        .chipscope_signals(chipscope_signals),
                        .control_regs(control_regs),
			// Inputs
			.ac97_bitclk	(ac97_bitclk),
			.reset		(reset),
			.reg_addr	(reg_addr[15:0]),
			.reg_data	(reg_data[7:0]),
			.reg_w_enable	(reg_w_enable));
   
   SquareWave ch1(// Outputs
		  .level		(ch1_level[3:0]),
		  // Inputs
		  .length_cntrl_clk     (length_cntrl_clk),
		  .sweep_cntrl_clk	(square_sweep_cntrl_clk),
		  .env_cntrl_clk	(square_envelope_cntrl_clk),
		  .freq_cntrl_clk       (ch1_2_freq_cntrl_clk),
		  .sweep_time		(ch1_sweep_time[2:0]),
		  .sweep_decreasing	(ch1_sweep_decreasing),
		  .num_sweep_shifts	(ch1_num_sweep_shifts[2:0]),
		  .wave_duty		(ch1_wave_duty[1:0]),
		  .length_data		(ch1_length_data[5:0]),
		  .initial_volume	(ch1_initial_volume[3:0]),
		  .envelope_increasing	(ch1_envelope_increasing),
		  .num_envelope_sweeps	(ch1_num_envelope_sweeps[2:0]),
		  .initialize		(ch1_reset),
		  .dont_loop		(ch1_dont_loop),
		  .frequency_data	(ch1_frequency_data[10:0]));
   
   SquareWave ch2(// Outputs
		  .level		(ch2_level[3:0]),
		  // Inputs
		  .length_cntrl_clk     (length_cntrl_clk),
		  .sweep_cntrl_clk	(square_sweep_cntrl_clk),
		  .env_cntrl_clk	(square_envelope_cntrl_clk),
		  .freq_cntrl_clk       (ch1_2_freq_cntrl_clk),
		  .sweep_time		(3'd0),
		  .sweep_decreasing	(1'd0),
		  .num_sweep_shifts	(3'd0),
		  .wave_duty		(ch2_wave_duty[1:0]),
		  .length_data		(ch2_length_data[5:0]),
		  .initial_volume	(ch2_initial_volume[3:0]),
		  .envelope_increasing	(ch2_envelope_increasing),
		  .num_envelope_sweeps	(ch2_num_envelope_sweeps[2:0]),
		  .initialize		(ch2_reset),
		  .dont_loop		(ch2_dont_loop),
		  .frequency_data	(ch2_frequency_data[10:0]));
   
   WaveformPlayer wp(.clk(ac97_bitclk),
		     .level(ch3_level),
		     .ch3_enable	(ch3_enable),
		     .ch3_length_data(ch3_length_data[7:0]),
		     .ch3_output_level(ch3_output_level[1:0]),
		     .ch3_reset	(ch3_reset),
		     .ch3_dont_loop	(ch3_dont_loop),
		     .ch3_frequency_data(ch3_frequency_data[10:0]),
		     .ch3_samples	(ch3_samples[127:0]),
		     .length_cntrl_clk(length_cntrl_clk),
		     .ch3_freq_cntrl_clk(ch3_freq_cntrl_clk));
endmodule // audio_top

// Local Variables:
// verilog-library-directories:("." "./AC97_work/" "./sound_functions/")
// verilog-library-files:("./sound_functions/sound_functions.v")
// End:
