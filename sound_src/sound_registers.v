/* Gameboy Sound Registers
 * 18-545 eob
 * 
 * Register names and specifiations are taken from:
 * meatfighter.com/gameboy/TheNintendoGameboy.pdf
 * Sound registers may be set at all times while producing sound.
 * 
 */

module sound_registers
  (input               ac97_bitclk,
   input               reset,
   input [15:0]        reg_addr,
   input [7:0]         reg_data,
   input               reg_w_enable,
   output wire [2:0]   ch1_sweep_time,
   output wire         ch1_sweep_decreasing,
   output wire [2:0]   ch1_num_sweep_shifts,
   output wire [1:0]   ch1_wave_duty,
   output wire [5:0]   ch1_length_data,
   output wire [3:0]   ch1_initial_volume,
   output wire         ch1_envelope_increasing,
   output wire [2:0]   ch1_num_envelope_sweeps,
   output wire         ch1_reset,
   output wire         ch1_dont_loop,
   output wire [10:0]  ch1_frequency_data,
   output wire [1:0]   ch2_wave_duty,
   output wire [5:0]   ch2_length_data,
   output wire [3:0]   ch2_initial_volume,
   output wire         ch2_envelope_increasing,
   output wire [2:0]   ch2_num_envelope_sweeps,
   output wire         ch2_reset,
   output wire         ch2_dont_loop,
   output wire [10:0]  ch2_frequency_data,
   output wire         ch3_enable,
   output wire [7:0]   ch3_length_data,
   output wire [1:0]   ch3_output_level,
   output wire         ch3_reset,
   output wire         ch3_dont_loop,
   output wire [10:0]  ch3_frequency_data,
   output wire [127:0] ch3_samples,
   output wire [5:0]   ch4_length_data,
   output wire [3:0]   ch4_initial_volume,
   output wire         ch4_envelope_increasing,
   output wire [2:0]   ch4_num_envelope_sweeps,
   output wire [3:0]   ch4_shift_clock_freq_data,
   output wire         ch4_counter_width,
   output wire [2:0]   ch4_freq_dividing_ratio,
   output wire         ch4_reset,
   output wire         ch4_dont_loop,
   output wire         SO2_Vin,
   output wire [2:0]   SO2_output_level,
   output wire         SO1_Vin,
   output wire [2:0]   SO1_output_level,
   output wire         SO2_ch4_enable,
   output wire         SO2_ch3_enable,
   output wire         SO2_ch2_enable,
   output wire         SO2_ch1_enable,
   output wire         SO1_ch4_enable,
   output wire         SO1_ch3_enable,
   output wire         SO1_ch2_enable,
   output wire         SO1_ch1_enable,
   output wire         master_sound_enable,
   output wire         ch4_on_flag,
   output wire         ch3_on_flag,
   output wire         ch2_on_flag,
   output wire         ch1_on_flag,
   output wire [247:0] chipscope_signals,
   output wire [23:0] control_regs
   );

   /* Channel 1 - Tone & Sweep */
   /** NR10 - Sweep register (R/W)
    *         bit 7: Not Used
    *         bit 6-4: Sweep Time
    *         bit 3: Sweep Increase/Decrease (0: increase, 1: decrease)
    *         bit 2-0: Number of Sweep Shift (n: 0-7)
    * 
    *         Sweep Time:
    *                    000: sweep off - no freq change
    *                    001: 7.8 ms (1/128Hz)
    *                    010: 15.6 ms (2/128Hz)
    *                    011: 23.4 ms (3/128Hz)
    *                    100: 31.3 ms (4/128Hz)
    *                    101: 39.1 ms (5/128Hz)
    *                    110: 46.9 ms (6/128Hz)
    *                    111: 54.7 ms (7/128Hz)
    *         Frequency at each shift is X(t) = X(t-1) +/- X(t-1)/2^n
    */
   reg [7:0] NR10;
   assign ch1_sweep_time = NR10[6:4];
   assign ch1_sweep_decreasing = NR10[3];
   assign ch1_num_sweep_shifts = NR10[2:0];

   /** NR11 - Sound Length/Wave Pattern Duty register (R/W)
    *         bit 7-6: Wave Pattern Duty (Read/Write)
    *         bit 5-0: Sound Length Data (Write Only) (t1: 0-63)
    * 
    *         Wave Duty:
    *                   00: 12.5% ( _-------_-------_------- )
    *                   01: 25%   ( __------__------__------ )
    *                   10: 50%   ( ____----____----____---- ) (normal)
    *                   11: 75%   ( ______--______--______-- )
    *         Sound Length = (64-t1)*(1/256) seconds
    *         The Length value is only used if Bit 6 in NR14 is set.
    */
   reg [7:0]   NR11;
   assign ch1_wave_duty = NR11[7:6];
   assign ch1_length_data = NR11[5:0];

   /** NR12 - Volume Envelope register (R/W)
    *         bit 7-4: Initial Volume of Envelope (0-0Fh) (0=No Sound)
    *         bit 3: Envelope Direction (0=Decrease, 1=Increase)
    *         bit 2-0: Number of Envelope Sweeps (n: 0-7)
    *                  (if zero, stop current envelope operation)
    * 
    *         Length of 1 Step = n*(1/64) seconds
    */
   reg [7:0]   NR12;
   assign ch1_initial_volume = NR12[7:4];
   assign ch1_envelope_increasing = NR12[3];
   assign ch1_num_envelope_sweeps = NR12[2:0];

   /** NR13 - Frequency lo (Write Only)
    *         Lower 8 Bits of 11-bit Frequency (x)
    */
   reg [7:0]  NR13;

   /** NR14 - Frequency hi (R/W)
    *         bit 7: Initial (1=Restart Sound) (Write Only)
    *         bit 6: Counter / Consecutive Selection (R/W)
    *                (1 = stop input when length in NR11 expires)
    *         bit 5-3: Not Used
    *         bit 2-0: Frequency's Higher 3 Bits (x) (Write Only)
    * 
    *         Frequency = 131072/(2048-x) Hz
    */
   reg [7:0]  NR14;
   assign ch1_reset = NR14[7];
   assign ch1_dont_loop = NR14[6];
   assign ch1_frequency_data = (NR14[2:0]<<8)|(NR13[7:0]);


   /* Channel 2 - Tone */
   /** NR21 - Length/Wave Pattern Duty (R/W)
    *         bit 7-6: Wave Pattern Duty (R/W)
    *         bit 5-0: Sound Length Data (Write Only) (t1: 0-63)
    * 
    *         Wave Duty:
    *                   00: 12.5% ( _-------_-------_------- )
    *                   01: 25%   ( __------__------__------ )
    *                   10: 50%   ( ____----____----____---- ) (normal)
    *                   11: 75%   ( ______--______--______-- )
    *         Sound Length = (64-t1)*(1/256) seconds
    *         The Length value is only used if Bit 6 in NR24 is set.
    */
   reg [7:0]  NR21;
   assign ch2_wave_duty = NR21[7:6];
   assign ch2_length_data = NR21[5:0];

   /** NR22 - Volume Envelope register (R/W)
    *         bit 7-4: Initial Volume of Envelope (0-0Fh) (0=No Sound)
    *         bit 3: Envelope Direction (0=Decrease, 1=Increase)
    *         bit 2-0: Number of Envelope Sweeps (n: 0-7)
    *                  (if zero, stop current envelope operation)
    * 
    *         Length of 1 Step = n*(1/64) seconds
    */
   reg [7:0]  NR22;
   assign ch2_initial_volume = NR22[7:4];
   assign ch2_envelope_increasing = NR22[3];
   assign ch2_num_envelope_sweeps = NR22[2:0];

   /** NR23 - Frequency lo (Write Only)
    *         Lower 8 Bits of 11-bit Frequency (x)
    */
   reg [7:0]  NR23;

   /** NR24 - Frequency hi (R/W)
    *         bit 7: Initial (1=Restart Sound) (Write Only)
    *         bit 6: Counter / Consecutive Selection (R/W)
    *                (1 = stop input when length in NR21 expires)
    *         bit 5-3: Not Used
    *         bit 2-0: Frequency's Higher 3 Bits (x) (Write Only)
    * 
    *         Frequency = 131072/(2048-x) Hz
    */
   reg [7:0]  NR24;
   assign ch2_reset = NR24[7];
   assign ch2_dont_loop = NR24[6];
   assign ch2_frequency_data = (NR24[2:0]<<8)|(NR23[7:0]);


   /* Channel 3 - Wave Output */
   /** NR30 - Sound On/Off (R/W)
    *         bit 7: Sound Channel 3 Off (0=Stop, 1=Playback)
    *         bit 6-0: Not Used
    */
   reg [7:0]  NR30;
   assign ch3_enable = NR30[7];

   /** NR31 - Sound Length (Write Only (presumably))
    *         bit 7-0: Sound Length (t1: 0-255)
    * 
    *         Sound Length = (256-t1)*(1/256) seconds
    *         This value is used only if Bit 6 in NR34 is set.
    */
   reg [7:0]  NR31;
   assign ch3_length_data = NR31[7:0];

   /** NR32 - Select Output Level (R/W)
    *         bit 7: Not Used
    *         bit 6-5: Select Output Level
    *         bit 4-0: Not Used
    * 
    *         Possible Output Levels are:
    *                0: Mute (No sound)
    *                1: 100% Volume (Produce Wave Pattern RAM Data as it is)
    *                2: 50% Volume (Produce Wave Pattern RAM Data shifted 
    *                               once to the right)
    *                3: 25% Volume (Produce Wave Pattern RAM Data shifted 
    *                               twice to the right)
    */
   reg [7:0]  NR32;
   assign ch3_output_level = NR32[6:5];

   /** NR33 - Frequency's Lower Data (Write Only)
    *         Lower 8 bits of an 11 bit frequency (x).
    */
   reg [7:0]  NR33;

   /** NR34 - Frequency's Higher Data and Control (R/W)
    *         bit 7: Initial (1=Restart Sound) (Write Only)
    *         bit 6: Counter/consecutive Selection (R/W)
    *                (1=Stop output when length in NR31 expires)
    *         bit 5-3: Not Used
    *         bit 2-0: Frequency's higher 3 bits (x) (Write Only)
    * 
    *         Frequency = 4194304/(64*(2048-x)) Hz = 65536/(2048-x) Hz
    */
   reg [7:0]  NR34;
   assign ch3_reset = NR34[7];
   assign ch3_dont_loop = NR34[6];
   assign ch3_frequency_data = (NR34[2:0]<<8)|(NR33[7:0]);

   /* Wave Pattern RAM (FF30-FF3F)
    *
    * Contains arbitrary waveform data.
    * Holds 32 4-bit samples that are played back upper 4 bits first.
    */
   reg [7:0]  WR3F, WR3E, WR3D, WR3C, WR3B, WR3A, WR39, WR38, WR37, WR36;
   reg [7:0]  WR35, WR34, WR33, WR32, WR31, WR30;
   // Samples are played zero index first
   assign ch3_samples = 128'h0123456789ABCDEFFEDCBA9876543210;//{WR30, WR31, WR32, WR33, WR34, WR35, WR36,
//			 WR37, WR38, WR39, WR3A, WR3B, WR3C, WR3D,
//			 WR3E, WR3F};
   /* DEPRECATED
   reg [3:0]  ch3_sample0 = MEMORY[FF3F][7:4];
   reg [3:0]  ch3_sample1 = MEMORY[FF3F][4:0];
   reg [3:0]  ch3_sample2 = MEMORY[FF3E][7:4];
   reg [3:0]  ch3_sample3 = MEMORY[FF3E][4:0];
   reg [3:0]  ch3_sample4 = MEMORY[FF3D][7:4];
   reg [3:0]  ch3_sample5 = MEMORY[FF3D][4:0];
   reg [3:0]  ch3_sample6 = MEMORY[FF3C][7:4];
   reg [3:0]  ch3_sample7 = MEMORY[FF3C][4:0];
   reg [3:0]  ch3_sample8 = MEMORY[FF3B][7:4];
   reg [3:0]  ch3_sample9 = MEMORY[FF3B][4:0];
   reg [3:0]  ch3_sample10 = MEMORY[FF3A][7:4];
   reg [3:0]  ch3_sample11 = MEMORY[FF3A][4:0];
   reg [3:0]  ch3_sample12 = MEMORY[FF39][7:4];
   reg [3:0]  ch3_sample13 = MEMORY[FF39][4:0];
   reg [3:0]  ch3_sample14 = MEMORY[FF38][7:4];
   reg [3:0]  ch3_sample15 = MEMORY[FF38][4:0];
   reg [3:0]  ch3_sample16 = MEMORY[FF37][7:4];
   reg [3:0]  ch3_sample17 = MEMORY[FF37][4:0];
   reg [3:0]  ch3_sample18 = MEMORY[FF36][7:4];
   reg [3:0]  ch3_sample19 = MEMORY[FF36][4:0];
   reg [3:0]  ch3_sample20 = MEMORY[FF35][7:4];
   reg [3:0]  ch3_sample21 = MEMORY[FF35][4:0];
   reg [3:0]  ch3_sample22 = MEMORY[FF34][7:4];
   reg [3:0]  ch3_sample23 = MEMORY[FF34][4:0];
   reg [3:0]  ch3_sample24 = MEMORY[FF33][7:4];
   reg [3:0]  ch3_sample25 = MEMORY[FF33][4:0];
   reg [3:0]  ch3_sample26 = MEMORY[FF32][7:4];
   reg [3:0]  ch3_sample27 = MEMORY[FF32][4:0];
   reg [3:0]  ch3_sample28 = MEMORY[FF31][7:4];
   reg [3:0]  ch3_sample29 = MEMORY[FF31][4:0];
   reg [3:0]  ch3_sample30 = MEMORY[FF30][7:4];
   reg [3:0]  ch3_sample31 = MEMORY[FF30][4:0];
   */


   /* Channel 4 - Noise */
   /** NR41 - Sound Length (R/W)
    *         bit 7-6: Not Used
    *         bit 5-0: Sound Length Data (t1: 0-63)
    * 
    *         Sound Length = (64-t1)*(1/256) seconds
    *         This value is only used if Bit 6 in NR44 is set
    */
   reg [7:0]  NR41;
   assign ch4_length_data = NR41[5:0];

   /** NR42 - Volume Envelope (R/W)
    *         bit 7-4: Initial Volume of Envelope (0-0Fh) (0=No Sound)
    *         bit 3: Envelope Direction (0=Decrease, 1=Increase)
    *         bit 2-0: Number of Envelope Sweeps (n: 0-7)
    *                  (If zero, stop envelope operation)
    * 
    *         Length of 1 step = n*(1/64) seconds
    */
   reg [7:0]  NR42;
   assign ch4_initial_volume = NR42[7:4];
   assign ch4_envelope_increasing = NR42[3];
   assign ch4_num_envelope_sweeps = NR42[2:0];

   /** NR43 - Polynomial Counter (R/W)
    *         bit 7-4: Shift Clock Frequency (s)
    *         bit 3: Counter Step/Width (0=15 bits, 1=7 bits)
    *         bit 2-0: Dividing Ratio of Frequencies (r)
    * 
    *         Frequency = 524288Hz/r/2^(s+1)
    *            for r=0 assume r=0.5 instead
    * 
    *         The amplitude is randomly switched between high and low at 
    *         the given frequency. A higher frequency will make the noise
    *         to appear 'softer'. When Bit 3 is set, the output will become
    *         more regular, and some frequencies will sound more like Tone
    *         than Noise.
    */
   reg [7:0]  NR43;
   assign ch4_shift_clock_freq_data = NR43[7:4];
   assign ch4_counter_width = NR43[3];
   assign ch4_freq_dividing_ratio = NR43[2:0];

   /** NR44 - Control (R/W)
    *         bit 7: Initial (1=Restart Sound) (Write Only)
    *         bit 6: Counter/consecutive Selection (R/W)
    *                (1=Stop output when length in NR41 expires)
    */
   reg [7:0]  NR44;
   assign ch4_reset = NR44[7];
   assign ch4_dont_loop = NR44[6];


   /* Sound Control Registers */
   /** NR50 - Channel Control / On-Off / Volume (R/W)
    *         bit 7: Output Vin to SO2 Terminal (1=Enable)
    *         bit 6-4: SO2 Output Level (Master Volume) (0-7)
    *         bit 3: Output Vin to SO1 Terminal (1=Enable)
    *         bit 2-0: SO1 Output Level (Master Volume (0-7)
    * 
    *         The Vin signal is received from the game cartridge bus,
    *         allowing external hardware in the cartridge to supply a 
    *         fifth sound channel, additionally to the gameboys internal 
    *         four channels. As far as I know this feature isn't used by 
    *         any existing games.
    */
   reg [7:0]  NR50;
   assign SO2_Vin = NR50[7];
   assign SO2_output_level = NR50[6:4];
   assign SO1_Vin = NR50[3];
   assign SO1_output_level = NR50[2:0];

   /** NR51 - Selection of Sound Output Terminal (R/W)
    *         bit 7: Output Sound 4 to SO2 Terminal
    *         bit 6: Output Sound 3 to SO2 Terminal
    *         bit 5: Output Sound 2 to SO2 Terminal
    *         bit 4: Output Sound 1 to SO2 Terminal
    *         bit 3: Output Sound 4 to SO1 Terminal
    *         bit 2: Output Sound 3 to SO1 Terminal
    *         bit 1: Output Sound 2 to SO1 Terminal
    *         bit 0: Output Sound 1 to SO1 Terminal
    */
   reg [7:0]  NR51;
   assign SO2_ch4_enable = NR51[7];
   assign SO2_ch3_enable = NR51[6];
   assign SO2_ch2_enable = NR51[5];
   assign SO2_ch1_enable = NR51[4];
   assign SO1_ch4_enable = NR51[3];
   assign SO1_ch3_enable = NR51[2];
   assign SO1_ch2_enable = NR51[1];
   assign SO1_ch1_enable = NR51[0];

   /** NR52 - Sound On/Off
    *         bit 7: All Sound On/Off (0: stop all sound circuits) (R/W)
    *         bit 6-4: Not Used
    *         bit 3: Sound 4 ON Flag (Read Only)
    *         bit 2: Sound 3 ON Flag (Read Only)
    *         bit 1: Sound 2 ON Flag (Read Only)
    *         bit 0: Sound 1 ON Flag (Read Only)
    * 
    *         If your GB programs don't use sound then write 00h to this 
    *         register to save 16% or more on GB power consumption. 
    *         Disabeling the sound controller by clearing Bit 7 destroys 
    *         the contents of all sound registers. 
    *         Also, it is not possible to access any sound registers
    *         (except FF26) while the sound controller is disabled.
    * 
    *         Bits 0-3 of this register are read only status bits, 
    *         writing to these bits does NOT enable/disable sound. 
    *         The flags get set when sound output is restarted by 
    *         setting the Initial flag (Bit 7 in NR14-NR44), the flag 
    *         remains set until the sound length has expired (if enabled). 
    *         A volume envelope which has decreased to zero volume will 
    *         NOT cause the sound flag to go off.
    */
   reg [7:0]  NR52;
   assign master_sound_enable = NR52[7];
   assign ch4_on_flag = NR52[3];
   assign ch3_on_flag = NR52[2];
   assign ch2_on_flag = NR52[1];
   assign ch1_on_flag = NR52[0];
   

/**
 * Combinational Register Assignment Logic
 */
always@(posedge ac97_bitclk or posedge reset) begin
   if (reset) begin
      // initial values taken from devrs.com/gb/files/hosted/GBSOUND.txt
      NR10 <= 0;//8'h80;
      NR11 <= 0;//8'hBF;
      NR12 <= 0;//8'hF3;
      NR13 <= 0;//8'hFF;
      NR14 <= 0;//8'hB0;
      NR21 <= 0;//8'h3F;
      NR22 <= 0;//8'h00;
      NR23 <= 0;//8'hFF;
      NR24 <= 0;//8'hBF;
      NR30 <= 0;//8'h7F;
      NR31 <= 0;//8'hFF;
      NR32 <= 0;//8'h9F;
      NR33 <= 0;//8'hFF;
      NR34 <= 0;//8'hBF;
      // The waveform ram values are basically arbitrary
      WR30 <= 0;//8'hAC;
      WR31 <= 0;//8'hDD;
      WR32 <= 0;
      WR33 <= 0;
      WR34 <= 0;
      WR35 <= 0;
      WR36 <= 0;
      WR37 <= 0;
      WR38 <= 0;
      WR39 <= 0;
      WR3A <= 0;
      WR3B <= 0;
      WR3C <= 0;
      WR3D <= 0;
      WR3E <= 0;
      WR3F <= 0;
      NR41 <= 0;//8'hFF;
      NR42 <= 0;//8'h00;
      NR43 <= 0;//8'h00;
      NR44 <= 0;//8'hBF;
      NR50 <= 0;//8'h77;
      NR51 <= 0;//8'hF3;
      NR52 <= 0;//8'hF1;
   end // if (~ac97_reset_b)
   else begin
      if (reg_w_enable) begin
	 case (reg_addr)
           16'hFF10: NR10 <= reg_data;
           16'hFF11: NR11 <= reg_data;
           16'hFF12: NR12 <= reg_data;
           16'hFF13: NR13 <= reg_data;
           16'hFF14: NR14 <= reg_data;      
           16'hFF16: NR21 <= reg_data;
           16'hFF17: NR22 <= reg_data;
           16'hFF18: NR23 <= reg_data;
           16'hFF19: NR24 <= reg_data;
           16'hFF1A: NR30 <= reg_data;
           16'hFF1B: NR31 <= reg_data;
           16'hFF1C: NR32 <= reg_data;
           16'hFF1D: NR33 <= reg_data;
           16'hFF1E: NR34 <= reg_data;
           16'hFF30: WR30 <= reg_data;
           16'hFF31: WR31 <= reg_data;
           16'hFF32: WR32 <= reg_data;
           16'hFF33: WR33 <= reg_data;
           16'hFF34: WR34 <= reg_data;
           16'hFF35: WR35 <= reg_data;
           16'hFF36: WR36 <= reg_data;
           16'hFF37: WR37 <= reg_data;
           16'hFF38: WR38 <= reg_data;
           16'hFF39: WR39 <= reg_data;
           16'hFF3A: WR3A <= reg_data;
           16'hFF3B: WR3B <= reg_data;
           16'hFF3C: WR3C <= reg_data;
           16'hFF3D: WR3D <= reg_data;
           16'hFF3E: WR3E <= reg_data;
           16'hFF3F: WR3F <= reg_data;
           16'hFF20: NR41 <= reg_data;
           16'hFF21: NR42 <= reg_data;
           16'hFF22: NR43 <= reg_data;
           16'hFF23: NR44 <= reg_data;
           16'hFF24: NR50 <= reg_data;
           16'hFF25: NR51 <= reg_data;
           16'hFF26: NR52 <= reg_data;
	 endcase
      end
   end // else: !if(~ac97_reset_b)
end // always@ (posedge ac97_bitclk or negedge ac97_reset_b)

   wire [39:0] sound1, sound2, sound3;
   wire [127:0] waveform;

   assign control_regs = {NR52, NR51, NR50};
   
   assign sound1 = {NR14, NR13, NR12, NR11, NR10};
   assign sound2 = {NR24, NR23, NR22, NR21, NR14};
   assign sound3 = {NR34, NR33, NR32, NR31, NR30};
   assign waveform = {WR3F, WR3E, WR3D, WR3C, WR3B, WR3A, WR39, WR38,
                      WR37, WR36, WR35, WR34, WR33, WR32, WR31, WR30};
   
   assign chipscope_signals = {waveform, sound3, sound2, sound1};
   
endmodule
