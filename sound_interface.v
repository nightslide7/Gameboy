/* Gameboy Sound Interface Module
 * 18-545 eob
 * 
 * Register names and specifiations are taken from:
 * meatfighter.com/gameboy/TheNintendoGameboy.pdf
 * Sound registers may be set at all times while producing sound.
 * 
 * Read and Write directions in comments are coming from cartridge.
 */

module sound_interface
  (input register,
   output wire sound_out1, sound_out2);

   /* Channel 1 - Tone & Sweep */
   parameter NR10 = 16'hFF10, NR11 = 16'hFF11, NR12 = 16'hFF12,
     NR13 = 16'hFF13, NR14 = 16'hFF14;
   /* NR10 - Sweep register (R/W)
    *        bit 7: Not Used
    *        bit 6-4: Sweep Time
    *        bit 3: Sweep Increase/Decrease (0: increase, 1: decrease)
    *        bit 2-0: Number of Sweep Shift (n: 0-7)
    *        Sweep Time:
    *                   000: sweep off - no freq change
    *                   001: 7.8 ms (1/128Hz)
    *                   010: 15.6 ms (2/128Hz)
    *                   011: 23.4 ms (3/128Hz)
    *                   100: 31.3 ms (4/128Hz)
    *                   101: 39.1 ms (5/128Hz)
    *                   110: 46.9 ms (6/128Hz)
    *                   111: 54.7 ms (7/128Hz)
    *        Frequency at each shift is X(t) = X(t-1) +/- X(t-1)/2^n
    */
   reg [2:0]   ch1_sweep_time = MEMORY[NR10][6:4];
   reg 	       ch1_sweep_decreasing = MEMORY[NR10][3];
   reg [2:0]   ch1_num_sweep_shifts = MEMORY[NR10][2:0];
   /* NR11 - Sound Length/Wave Pattern Duty register (R/W)
    *        bit 7-6: Wave Pattern Duty (Read/Write)
    *        bit 5-0: Sound Length Data (Write Only) (t1: 0-63)
    *        Wave Duty:
    *                  00: 12.5% ( _-------_-------_------- )
    *                  01: 25%   ( __------__------__------ )
    *                  10: 50%   ( ____----____----____---- ) (normal)
    *                  11: 75%   ( ______--______--______-- )
    *        Sound Length = (64-t1)*(1/256) seconds
    *        The Length value is only used if Bit 6 in NR14 is set.
    */
   reg [1:0]   ch1_wave_duty = MEMORY[NR11][7:6];
   reg [5:0]   ch1_length_data = MEMORY[NR11][5:0];
   /* NR12 - Volume Envelope register (R/W)
    *        bit 7-4: Initial Volume of Envelope (0-0Fh) (0=No Sound)
    *        bit 3: Envelope Direction (0=Decrease, 1=Increase)
    *        bit 2-0: Number of Envelope Sweeps (n: 0-7)
    *                 (if zero, stop current envelope operation)
    *        Length of 1 Step = n*(1/64) seconds
    */
   reg [3:0]   ch1_initial_volume = MEMORY[NR12][7:4];
   reg 	       ch1_envelope_increasing = MEMORY[NR12][3];
   reg [2:0]   ch1_num_envelope_sweeps = MEMORY[NR12][2:0];
   /* NR13 - Frequency lo (Write Only)
    *        Lower 8 Bits of 11-bit Frequency (x)
    */
   /* NR14 - Frequency hi (R/W)
    *        bit 7: Initial (1=Restart Sound) (Write Only)
    *        bit 6: Counter / Consecutive Selection (R/W)
    *               (1 = stop input when length in NR11 expires)
    *        bit 5-3: Not Used
    *        bit 2-0: Frequency's Higher 3 Bits (x) (Write Only)
    *        Frequency = 131072/(2048-x) Hz
    */
   reg 	       ch1_initialize = MEMORY[NR14][7];
   reg 	       ch1_dont_loop = MEMORY[NR14][6];
   reg [10:0]  ch1_frequency = (MEMORY[NR14][2:0]<<8)|(MEMORY[NR14]);

   /* Channel 2 - Tone */
   parameter NR21 = 16'hFF16, NR22 = 16'hFF17, NR23 = 16'hFF18,
     NR24 = 16'hFF19;
   /* NR21 - 