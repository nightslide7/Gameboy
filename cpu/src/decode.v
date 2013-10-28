`include "cpu.vh"

/**
 * Giant ridiculous combinational circuit. Works by continuously fetching
 * instructions and then going through the states (microcode) that makes up
 * each instruction. Actually using microcode is a problem because there are
 * far too many control signals to fit it into the flash memory on the ML505.
 * Perhaps later I'll write a module to run the flash at 4x the processor speed
 * and shift microcode over to drastically reduce area and synthesis time.
 */
module decode(/*AUTOARG*/
   // Outputs
   regfile_rn_in, regfile_rn_out, regfile_we, regfile_change16,
   regfile_inc, regfile_jp_hl, addr_buf_load, addr_buf_write,
   data_buf_load, data_buf_write, addr_buf_load_ext,
   addr_buf_write_ext, data_buf_load_ext, data_buf_write_ext,
   inst_reg_load, A_load, F_load, temp1_load, temp0_load,
   regfile_data_gate, A_data_gate, F_data_gate, alu_data_gate,
   regfile_addr_gate, alu_data1_in_sel, alu_data0_in_sel,
   addr_ff00_sel, alu_op, alu_size, halt,
   // Inputs
   instruction, taken, clock, reset
   );
   // Constant Parameters //////////////////////////////////////////////////////
   parameter
     F_Z = 3, F_N = 2, F_H = 1, F_C = 0;
   
   // Outputs //////////////////////////////////////////////////////////////////
   
   // Regfile
   output wire [4:0]  regfile_rn_in, regfile_rn_out;
   output wire        regfile_we;
   output wire        regfile_change16, regfile_inc;
   output reg         regfile_jp_hl;
   
   
   // Buffers
   // To/from internal bus
   output reg         addr_buf_load, addr_buf_write;
   output reg         data_buf_load, data_buf_write;
   // To/from external bus
   output reg         addr_buf_load_ext, addr_buf_write_ext;
   output reg         data_buf_load_ext, data_buf_write_ext;

   // Registers
   output reg         inst_reg_load, A_load, F_load, temp1_load, temp0_load;

   // Tristate buffer enables
   output reg         regfile_data_gate, A_data_gate, F_data_gate;
   output reg         alu_data_gate;
   output reg         regfile_addr_gate;

   // Mux selects
   output reg [1:0]   alu_data1_in_sel, alu_data0_in_sel;
   output reg         addr_ff00_sel;

   // ALU
   output reg [4:0]   alu_op;
   output reg         alu_size;

   // External
   output reg         halt;
   
   // Inputs ///////////////////////////////////////////////////////////////////
   
   input [7:0]        instruction;
   input              taken;
   
   input              clock, reset;

   // Internal Signals /////////////////////////////////////////////////////////

   // Multibyte instructions
   reg                cb, next_cb;

   // Counter
   // Top 3 bits are machine cycle, lower 2 are T cycle
   reg [4:0]          cycle, next_cycle;

   // Number of machine cycles in the current instruction
   reg [3:0]          m_cycles;
   
   wire [2:0]         m_cycle;
   wire [1:0]         t_cycle;

   // Halted register
   reg                halted;
   
   assign m_cycle = cycle[4:2];
   assign t_cycle = cycle[1:0];

   // Register number decoding
   reg [4:0]          rn_in, rn_out;
   reg [2:0]          nin_rn_in, nin_rn_out;
   reg                rn16_in, rn16_out, rn16_in_lo, rn16_in_hi, rn16_out_lo;
   reg                rn16_out_hi;
   wire [4:0]         rn_in_inter;
   
   rn_decode rgf_in_decoder(.rgf_rn_out(regfile_rn_in),
                            .rgf_rn_in(rn_in_inter),
                            .rn(nin_rn_in),
                            .rn16(rn16_in),
                            .hi(rn16_in_hi),
                            .lo(rn16_in_lo));
   rn_decode rgf_out_decoder(.rgf_rn_out(regfile_rn_out),
                             .rgf_rn_in(rn_out),
                             .rn(nin_rn_out),
                             .rn16(rn16_out),
                             .hi(rn16_in_hi),
                             .lo(rn16_in_lo));

   // To make PC++ easier
   reg                regfile_change16_l, regfile_inc_l, regfile_inc_pc;
   reg                regfile_we_l;

   assign rn_in_inter = (regfile_inc_pc) ? `RGF_PC : rn_in;
   assign regfile_we = regfile_inc_pc | regfile_we_l;
   assign regfile_change16 = regfile_inc_pc | regfile_change16_l;
   assign regfile_inc = regfile_inc_pc | regfile_inc_l;
   
   // State Machine ////////////////////////////////////////////////////////////

   wire [5:0]         next_cycle_high;
   assign next_cycle_high = {1'b0, cycle} + 6'b1;
   
   always @(posedge clock or posedge reset) begin
      if (reset) begin
         cycle <= 5'd0;
         cb <= 1'b0;
         halted <= 1'd0;
      end else begin
         cycle <= next_cycle;
         cb <= next_cb;
         if (halt) begin
            halted <= 1'd1;
         end
      end
   end

   always @(*) begin
      
      // Defaults //////////////////////////////////////////////////////////////
      
      // Regfile
      //{regfile_we, regfile_change16, regfile_inc} = 3'd0;
      {regfile_we_l, regfile_change16_l, regfile_inc_l, regfile_inc_pc} = 4'd0;
      regfile_jp_hl = 1'd0;
      
      // Buffers
      // To/from internal bus
      {addr_buf_load, addr_buf_write} = 2'd0;
      {data_buf_load, data_buf_write} = 2'd0;
      // To/from external bus
      {addr_buf_load_ext, addr_buf_write_ext} = 2'd0;
      {data_buf_load_ext, data_buf_write_ext} = 2'd0;

      // Registers
      {inst_reg_load, A_load, F_load, temp1_load, temp0_load} = 5'd0;

      // Tristate buffer enables
      {regfile_data_gate, A_data_gate, F_data_gate, alu_data_gate} = 4'd0;
      regfile_addr_gate = 1'd0;

      // Mux selects
      alu_data1_in_sel = 2'd0;
      {alu_data0_in_sel, addr_ff00_sel} = 2'd0;

      // ALU
      alu_op = 5'd0;
      alu_size = 1'd0;

      // CB, cycle
      next_cb = cb;
      m_cycles = 4'd1;

      // Register number decoding
      rn_in = `RGF_NONE;
      rn_out = `RGF_NONE;
      nin_rn_in = 3'd0;
      nin_rn_out = 3'd0;
      {rn16_in, rn16_out} = 2'd0;
      {rn16_in_hi, rn16_in_lo, rn16_out_hi, rn16_out_lo} = 4'd0;

      // Special
      halt = 1'b0;
      
      // Fetch/Decode //////////////////////////////////////////////////////////

      if (halted) begin
         // Do nothing
         m_cycles = 4'd1;
      end else if (cycle == 5'd0) begin
         // Fetch 0: Load ADRBUF
         m_cycles = 4'd1;
         
         rn_out = `RGF_PC;
         regfile_addr_gate = 1'b1;
         addr_buf_load = 1'b1;
      end else if (cycle == 5'd1) begin
         // Fetch 1: PC++; Load DBUF
         m_cycles = 4'd1;
         
         regfile_inc_pc = 1'b1;
         addr_buf_write_ext = 1'b1;
         data_buf_load_ext = 1'b1;
      end else if (cycle == 5'd2) begin
         // Fetch 2: Load IR; Load the next PC into ABUF in case of CB
         m_cycles = 4'd1;
         
         data_buf_write = 1'b1;
         inst_reg_load = 1'b1;
         
         rn_out = `RGF_PC;
         regfile_addr_gate = 1'b1;
         addr_buf_load = 1'b1;
      end else if ((cycle == 5'd3) && (instruction == 8'hCB)) begin
         // Fetch 3 (CB): Remember CB; PC++; load DBUF
         m_cycles = 4'd2;
         
         next_cb = 1'b1;
         regfile_inc_pc = 1'b1;
         addr_buf_write_ext = 1'b1;
         data_buf_load_ext = 1'b1;
      end else if ((cycle == 5'd4) && (cb)) begin
         // Fetch 4 (CB): Load IR
         m_cycles = 4'd2;
         
         data_buf_write = 1'b1;
         inst_reg_load = 1'b1;
      end

      // Regular Instructions //////////////////////////////////////////////////

      else if (~cb) begin

         casex (instruction)

           // NOP //
           8'b0: begin
              // Do nothing for 1 machine cycle
              m_cycles = 4'd1;
           end

           // HALT //
           // MUST BE AT TOP TO CATCH 8-BIT LOADS: DO NOT MOVE
           8'b01_110_110: begin
              // HALT: Stop execution
              halt = 1'b1;
           end

           // 8-Bit Transfer/Input-Output Instructions /////////////////////////
           
           // LD r, (HL); LD (HL), r; LD r1, r2 //
           8'b01_xxx_xxx: begin
              if (instruction[2:0] == 3'b110) begin
                 // LD r1, (HL)
                 m_cycles = 4'd2;
                 case (cycle)
                   5'd3: begin
                      // Load ABUF
                      rn_out = `RGF_HL;
                      regfile_addr_gate = 1'b1;
                      addr_buf_load = 1'b1;
                   end
                   5'd4: begin
                      // Write ABUF; load DBUF
                      addr_buf_write_ext = 1'b1;
                      data_buf_load_ext = 1'b1;
                   end
                   5'd5: begin
                      // Write DBUF to r1
                      data_buf_write = 1'b1;
                      nin_rn_in = instruction[5:3];
                      if (nin_rn_in == `NIN_A) begin
                         A_load = 1'b1;
                         alu_op = `ALU_PASS0;
                      end else begin
                         regfile_we_l = 1'b1;
                      end
                   end
                 endcase

                 // LD (HL), r2 //
              end else if (instruction[5:3] == 3'b110) begin
                 m_cycles = 4'd2;
                 case (cycle)
                   5'd3: begin
                      // Load ABUF with HL
                      rn_out = `RGF_HL;
                      regfile_addr_gate = 1'b1;
                      addr_buf_load = 1'b1;
                   end
                   5'd4: begin
                      // Load DBUF with r2
                      nin_rn_out = instruction[2:0];
                      if (nin_rn_out == `NIN_A) begin
                         A_data_gate = 1'b1;
                      end else begin
                         regfile_data_gate = 1'b1;
                      end
                      data_buf_load = 1'b1;
                   end
                   5'd5: begin
                      // Write DBUF to mem
                      addr_buf_write_ext = 1'b1;
                      data_buf_write_ext = 1'b1;
                   end
                 endcase

                 // LD r1, r2 //
              end else begin
                 m_cycles = 4'd1;
                 if (cycle == 5'd3) begin
                    nin_rn_in = instruction[5:3];
                    nin_rn_out = instruction[2:0];
                    if (nin_rn_in == `NIN_A) begin
                       A_load = 1'b1;
                       alu_op = `ALU_PASS0;
                    end else begin
                       regfile_we_l = 1'b1;
                    end
                    if (nin_rn_out == `NIN_A) begin
                       A_data_gate = 1'b1;
                    end else begin
                       regfile_data_gate = 1'b1;
                    end
                 end
              end
           end // case: 8'b01xxxxxx

           // LD r, n; LD (HL), n //
           8'b00_xxx_110: begin
              if (instruction[5:3] == 3'b110) begin
                 // LD (HL), n //
                 m_cycles = 4'd3;
                 case (cycle)
                   5'd3: begin
                      // PC ++; Load DBUF with n; Load ABUF with HL
                      regfile_inc_pc = 1'b1;
                      
                      addr_buf_write_ext = 1'b1;
                      data_buf_load_ext = 1'b1;

                      regfile_addr_gate = 1'b1;
                      rn_out = `RGF_HL;
                      addr_buf_load = 1'b1;
                   end
                   5'd4: begin
                      // Write DBUF to memory
                      addr_buf_write_ext = 1'b1;
                      data_buf_write_ext = 1'b1;
                   end
                 endcase
              end else begin
                 // LD r1, n //
                 m_cycles = 4'd2;
                 case (cycle)
                   5'd3: begin
                      // Load ABUF with PC
                      rn_out = `RGF_PC;
                      regfile_addr_gate = 1'b1;
                      addr_buf_load = 1'b1;
                   end
                   5'd4: begin
                      // Get n: PC++; Load DBUF
                      regfile_inc_pc = 1'b1;
                      addr_buf_write_ext = 1'b1;
                      data_buf_load_ext = 1'b1;
                   end
                   5'd5: begin
                      // Write DBUF into regfile
                      data_buf_write = 1'b1;
                      nin_rn_in = instruction[5:3];
                      if (nin_rn_in == `NIN_A) begin
                         A_load = 1'b1;
                         alu_op = `ALU_PASS0;
                      end else begin
                         regfile_we_l = 1'b1;
                      end
                   end
                 endcase
              end
           end // case: 8'b00xxx110

           // LD A, (BC) //
           8'b00_001_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // Output BC to ABUF
                   regfile_addr_gate = 1'b1;
                   rn_out = `RGF_BC;
                   addr_buf_load = 1'b1;
                end
                5'd4: begin
                   // Read mem to DBUF
                   data_buf_load_ext = 1'b1;
                end
                5'd5: begin
                   // Load DBUF into A
                   A_load = 1'b1;
                   alu_op = `ALU_PASS0;
                end
              endcase
           end

           // LD A, (DE) //
           8'b00_011_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // Output DE to ABUF
                   regfile_addr_gate = 1'b1;
                   rn_out = `RGF_DE;
                   addr_buf_load = 1'b1;
                end
                5'd4: begin
                   // Read mem to DBUF
                   data_buf_load_ext = 1'b1;
                end
                5'd5: begin
                   // Load DBUF into A
                   A_load = 1'b1;
                   alu_op = `ALU_PASS0;
                end
              endcase
           end

           // LD A, ({ff, C}) //
           8'b11_110_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // ABUF = {ff, C}
                   rn_out = `RGF_C;
                   addr_ff00_sel = 1'b1;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;
                end
                5'd4: begin
                   // DBUF = ({ff, C})
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;
                end
                5'd5: begin
                   // A = DBUF
                   data_buf_write = 1'b1;
                   A_load = 1'b1;
                end
              endcase
           end

           // LD ({ff, C}), A //
           8'b11_100_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // ABUF = {ff, C}, DBUF = A
                   rn_out = `RGF_C;
                   addr_ff00_sel = 1'b1;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;

                   A_data_gate = 1'b1;
                   data_buf_load = 1'b1;
                end
                5'd4: begin
                   // ({ff, C}) = A
                   addr_buf_write_ext = 1'b1;
                   data_buf_write_ext = 1'b1;
                end
              endcase
           end

           // LD A, (n) (LD A, (n + 0xFF00)) //
           8'b11_110_000: begin
              m_cycles = 4'd3;
              case (cycle)
                5'd3: begin
                   // DBUF = n, temp0 = old C
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;

                   rn_out = `RGF_C;
                   regfile_data_gate = 1'b1;
                   temp0_load = 1'b1;
                end
                5'd4: begin
                   // C = n
                   rn_in = `RGF_C;
                   regfile_we_l = 1'b1;
                   data_buf_write = 1'b1;
                end
                5'd5: begin
                   // ABUF = (C + 0xFF00), C = old C
                   rn_out = `RGF_C;
                   regfile_addr_gate = 1'b1;
                   addr_buf_write = 1'b1;
                   addr_ff00_sel = 1'b1;

                   rn_in = `RGF_C;
                   regfile_we_l = 1'b1;
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   alu_op = `ALU_PASS0;
                   alu_data_gate = 1'b1;
                end // case: 5'd5
                5'd6: begin
                   // DBUF = (n), PC++
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;

                   regfile_inc_pc = 1'b1;
                end
                5'd7: begin
                   // A = (n)
                   data_buf_write = 1'b1;
                   alu_op = `ALU_PASS0;
                   A_load = 1'b1;
                end
              endcase
           end

           // LD (n), A (also LD (n + 0xff00), A) //
           8'b11_100_000: begin
              m_cycles = 4'd3;
              case (cycle)
                5'd3: begin
                   // DBUF = n, temp0 = old C
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;

                   rn_out = `RGF_C;
                   regfile_data_gate = 1'b1;
                   temp0_load = 1'b1;
                end
                5'd4: begin
                   // C = n
                   rn_in = `RGF_C;
                   regfile_we_l = 1'b1;
                   data_buf_write = 1'b1;
                end
                5'd5: begin
                   // ABUF = (C + 0xff00), C = old C
                   rn_out = `RGF_C;
                   regfile_addr_gate = 1'b1;
                   addr_buf_write = 1'b1;
                   addr_ff00_sel = 1'b1;

                   rn_in = `RGF_C;
                   regfile_we_l = 1'b1;
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   alu_op = `ALU_PASS0;
                   alu_data_gate = 1'b1;
                end
                5'd6: begin
                   // DBUF = A, PC++
                   A_data_gate = 1'b1;
                   data_buf_load = 1'b1;

                   regfile_inc_pc = 1'b1;
                end
                5'd7: begin
                   // (n) = A
                   addr_buf_write_ext = 1'b1;
                   data_buf_write_ext = 1'b1;
                end
              endcase
           end

           // LD A, (nn) //
           8'b11_111_010: begin
              m_cycles = 4'd4;
              case (cycle)
                5'd3: begin
                   // DBUF = nnL, PC++
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;

                   regfile_inc_pc = 1'b1;
                end
                5'd4: begin
                   // ABUF = PC, temp0 = nnL
                   rn_out = `RGF_PC;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;

                   data_buf_write = 1'b1;
                   temp0_load = 1'b1;
                end
                5'd5: begin
                   // DBUF = nnH, PC++
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;

                   regfile_inc_pc = 1'b1;
                end
                5'd6: begin
                   // temp1 = nnH
                   data_buf_write = 1'b1;
                   temp1_load = 1'b1;
                end
                5'd7: begin
                   // DBUF = old C
                   rn_out = `RGF_C;
                   regfile_data_gate = 1'b1;
                   data_buf_load = 1'b1;
                end
                5'd8: begin
                   // C = nnL
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   alu_op = `ALU_PASS0;
                   alu_data_gate = 1'b1;
                   rn_in = `RGF_C;
                   regfile_we_l = 1'b1;
                end
                5'd9: begin
                   // temp0 = old B
                   rn_out = `RGF_B;
                   temp0_load = 1'b1;
                end
                5'd10: begin
                   // B = nnH
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   alu_op = `ALU_PASS1;
                   alu_data_gate = 1'd1;
                   rn_in = `RGF_B;
                   regfile_we_l = 1'b1;
                end
                5'd11: begin
                   // ABUF = nn, C = old C
                   rn_out = `RGF_BC;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;

                   data_buf_write = 1'b1;
                   rn_in = `RGF_C;
                   regfile_we_l = 1'b1;
                end
                5'd12: begin
                   // B = old B, DBUF = (nn)
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   alu_op = `ALU_PASS0;
                   alu_data_gate = 1'b1;
                   rn_in = `RGF_B;
                   regfile_we_l = 1'b1;

                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;
                end
                5'd13: begin
                   // A = DBUF
                   data_buf_write = 1'b1;
                   alu_op = `ALU_PASS0;
                   A_load = 1'b1;
                end
                // woohoo!
              endcase
           end

           // LD (nn), A //
           8'b11_101_010: begin
              // INVOLVES COPYPASTA FROM ABOVE
           end
           
           // LD A, (HLI) (i.e. LD A, (HL); HL++) //
           8'b00_111_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // Load ABUF with HL
                   regfile_addr_gate = 1'b1;
                   rn_out = `RGF_HL;
                   addr_buf_load = 1'b1;
                end
                5'd4: begin
                   // Load DBUF, HL++
                   data_buf_load_ext = 1'b1;
                   
                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   regfile_inc_l = 1'b1;
                   rn_in = `RGF_HL;
                end
                5'd5: begin
                   // Load A from DBUF
                   A_load = 1'b1;
                   alu_op = `ALU_PASS0;
                   data_buf_write = 1'b1;
                end
              endcase
           end

           // LD A, (HLD) (i.e. LD A, (HL); HL--) //
           8'b00_111_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // Load ABUF with HL
                   regfile_addr_gate = 1'b1;
                   rn_out = `RGF_HL;
                   addr_buf_load = 1'b1;
                end
                5'd4: begin
                   // Load DBUF, HL--
                   data_buf_load_ext = 1'b1;
                   
                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   rn_in = `RGF_HL;
                end
                5'd5: begin
                   // Load A from DBUF
                   A_load = 1'b1;
                   alu_op = `ALU_PASS0;
                   data_buf_write = 1'b1;
                end
              endcase
           end // case: 8'b00_111_010

           // LD (BC), A //
           8'b00_000_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // Load BC into ABUF
                   rn_out = `RGF_BC;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;
                end
                5'd4: begin
                   // Read (BC) into DBUF
                   data_buf_load_ext = 1'b1;
                   addr_buf_write_ext = 1'b1;
                end
                5'd5: begin
                   // Save DBUF into A
                   A_load = 1'b1;
                   alu_op = `ALU_PASS0;
                   data_buf_write = 1'b1;
                end
              endcase
           end

           // LD (DE), A //
           8'b00_010_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // Load DE into ABUF
                   rn_out = `RGF_DE;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;
                end
                5'd4: begin
                   // Read (DE) into DBUF
                   data_buf_load_ext = 1'b1;
                   addr_buf_write_ext = 1'b1;
                end
                5'd5: begin
                   // Save DBUF into A
                   A_load = 1'b1;
                   alu_op = `ALU_PASS0;
                   data_buf_write = 1'b1;
                end
              endcase
           end // case: 8'b00_010_010

           // LD (HLI), A //
           8'b00_101_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // Load HL into ABUF, load A into DBUF
                   rn_out = `RGF_HL;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;

                   A_data_gate = 1'b1;
                   data_buf_load = 1'b1;
                end
                5'd4: begin
                   // Write DBUF into (HL), HL++
                   data_buf_write_ext = 1'b1;
                   addr_buf_write_ext = 1'b1;

                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   regfile_inc_l = 1'b1;
                   rn_in = `RGF_HL;
                end
              endcase
           end

           // LD (HLD), A //
           8'b00_110_010: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // Load HL into ABUF, load A into DBUF
                   rn_out = `RGF_HL;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;

                   A_data_gate = 1'b1;
                   data_buf_load = 1'b1;
                end
                5'd4: begin
                   // Write DBUF into (HL), HL--
                   data_buf_write_ext = 1'b1;
                   addr_buf_write_ext = 1'b1;

                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   rn_in = `RGF_HL;
                end
              endcase
           end // case: 8'b00_110_010

           // 16-Bit Transfer Instructions /////////////////////////////////////
           
           // LD r1, nn //
           8'b00_xx0_001: begin
              m_cycles = 4'd3;
              case (cycle)
                5'd3: begin
                   // ABUF already contains the next PC from fetch 2
                   // Get LSB of nn, PC++
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;

                   regfile_inc_pc = 1'b1;
                end
                5'd4: begin
                   // Load DBUF into LSB of r1, load ABUF, PC++
                   regfile_we_l = 1'b1;
                   nin_rn_in = instruction[5:4];
                   rn16_in_lo = 1'b1;
                   data_buf_write = 1'b1;

                   regfile_addr_gate = 1'b1;
                   rn_out = `RGF_PC;
                   addr_buf_write = 1'b1;
                end
                5'd5: begin
                   // Load DBUF with MSB of nn
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;
                end
                5'd6: begin
                   // Load MSB of r1 with DBUF
                   data_buf_write = 1'b1;
                   regfile_we_l = 1'b1;
                   nin_rn_in = instruction[5:4];
                   rn16_in_hi = 1'b1;
                end
              endcase
           end

           // LD SP, HL //
           8'b11_111_001: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // SP[15:8] = HL[15:8]
                   regfile_data_gate = 1'b1;
                   regfile_we_l = 1'b1;
                   rn_in = `RGF_SPH;
                   rn_out = `RGF_H;
                end
                5'd4: begin
                   // SP[7:0] = HL[7:0]
                   regfile_data_gate = 1'b1;
                   regfile_we_l = 1'b1;
                   rn_in = `RGF_SPL;
                   rn_out = `RGF_L;
                end
              endcase
           end

           // PUSH qq //
           8'b11_xx0_101: begin
              m_cycles = 4'd4;
              case (cycle)
                5'd3: begin
                   // Decrement SP, load DBUF with qq[15:8]
                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   rn_in = `RGF_SP;

                   if (instruction[5:4] == 2'b11) begin
                      A_data_gate = 1'b1;
                   end else begin
                      regfile_data_gate = 1'b1;
                      nin_rn_out = instruction[5:4];
                      rn16_out = 1'b1;
                      rn16_out_hi = 1'b1;
                   end
                   data_buf_load = 1'b1;
                end
                5'd4: begin
                   // Load ABUF with SP-1, SP--
                   rn_out = `RGF_SP;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;

                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   rn_in = `RGF_SP;
                end
                5'd5: begin
                   // Write qq[15:8] to (SP-1), load ABUF with SP-2
                   addr_buf_write_ext = 1'b1;
                   data_buf_write_ext = 1'b1;

                   addr_buf_load = 1'b1;
                   rn_out = `RGF_SP;
                   regfile_addr_gate = 1'b1;
                end
                5'd6: begin
                   // Load DBUF with qq[7:0]
                   if (instruction[5:4] == 2'b11) begin
                      F_data_gate = 1'b1;
                   end else begin
                      regfile_data_gate = 1'b1;
                      nin_rn_out = instruction[5:4];
                      rn16_out = 1'b1;
                      rn16_out_lo = 1'b1;
                   end
                   data_buf_load = 1'b1;
                end
                5'd7: begin
                   // Write qq[7:0] to (SP-2)
                   addr_buf_write_ext = 1'b1;
                   data_buf_write_ext = 1'b1;
                end
              endcase
           end

           // POP qq //
           8'b11_xx0_001: begin
              m_cycles = 4'd3;
              case (cycle)
                5'd3: begin
                   // Load SP into ABUF, SP++
                   rn_out = `RGF_SP;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;

                   rn_in = `RGF_SP;
                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   regfile_inc_l = 1'b1;
                end
                5'd4: begin
                   // Load qqL into DBUF, load SP+1 into ABUF, SP++
                   data_buf_load_ext = 1'b1;
                   addr_buf_write_ext = 1'b1;

                   rn_out = `RGF_SP;
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;

                   rn_in = `RGF_SP;
                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   regfile_inc_l = 1'b1;
                end // case: 5'd4
                5'd5: begin
                   // Load DBUF into qqL regfile, load qqH into DBUF
                   if (instruction[5:4] == 2'b11) begin
                      alu_op = `ALU_PASSF;
                      F_load = 1'b1;
                   end else begin
                      nin_rn_in = instruction[5:4];
                      rn16_in = 1'b1;
                      rn16_in_lo = 1'b1;
                      regfile_we_l = 1'b1;
                   end
                   
                   data_buf_load_ext = 1'b1;
                   addr_buf_write_ext = 1'b1;
                end
                5'd6: begin
                   // Load DBUF into qqH regfile
                   if (instruction[5:4] == 2'b11) begin
                      alu_op = `ALU_PASS0;
                      A_load = 1'b1;
                   end else begin
                      nin_rn_in = instruction[5:4];
                      rn16_in = 1'b1;
                      rn16_in_hi = 1'b1;
                      regfile_we_l = 1'b1;
                   end
                end
              endcase
           end // case: 8'b11_xx0_001

           // LD HL, SP+e //
           8'b00_001_000: begin
              m_cycles = 4'd3;
              case (cycle)
                5'd3: begin
                   // DBUF = e, PC++
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;

                   regfile_inc_pc = 1'b1;
                end
                5'd4: begin
                   // temp0 = DBUF (== e);
                   data_buf_write = 1'b1;
                   temp0_load = 1'b1;
                end
                5'd5: begin
                   // temp1 = SPL
                   rn_out = `RGF_SPL;
                   regfile_data_gate = 1'b1;
                   temp1_load = 1'b1;
                end
                5'd6: begin
                   // L = SPL + e
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   alu_op = `ALU_ADD;
                   alu_data_gate = 1'b1;
                   rn_in = `RGF_L;
                   regfile_we_l = 1'b1;
                end
                5'd7: begin
                   // temp1 = SPH
                   rn_out = `RGF_SPH;
                   regfile_data_gate = 1'b1;
                   temp1_load = 1'b1;
                end
                5'd8: begin
                   // H = SPH + ff/00 + carry
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   alu_data0_in_sel = `ALU_0_SEL_FF;
                   alu_op = `ALU_ADC;
                   alu_data_gate = 1'b1;
                   rn_in = `RGF_L;
                   regfile_we_l = 1'b1;
                end
              endcase
           end
           
           // LD (nn), SP //
           8'b00_001_000: begin
              m_cycles = 4'd5;
              case (cycle)
                5'd3: begin
                   // Load C into temp0, load low address byte into DBUF, PC++
                   regfile_data_gate = 1'b1;
                   temp0_load = 1'b1;
                   rn_out = `RGF_C;

                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;

                   regfile_inc_pc = 1'b1;
                end
                5'd4: begin
                   // Load B into temp1, load DBUF into C
                   regfile_data_gate = 1'b1;
                   temp1_load = 1'b1;
                   rn_out = `RGF_B;

                   regfile_we_l = 1'b1;
                   rn_in = `RGF_C;
                   data_buf_write = 1'b1;
                end
                5'd5: begin
                   // Load ABUF with PC+1, PC++
                   addr_buf_load = 1'b1;
                   regfile_addr_gate = 1'b1;
                   rn_out = `RGF_PC;

                   regfile_inc_pc = 1'b1;
                end
                5'd6: begin
                   // Load DBUF with high address byte
                   addr_buf_write_ext = 1'b1;
                   data_buf_write_ext = 1'b1;
                end
                5'd7: begin
                   // Load B with DBUF
                   data_buf_write = 1'b1;
                   regfile_we_l = 1'b1;
                   rn_in = `RGF_B;
                end
                5'd8: begin
                   // Load ABUF with BC
                   regfile_addr_gate = 1'b1;
                   addr_buf_load = 1'b1;
                   rn_out = `RGF_BC;
                end
                5'd9: begin
                   // Load DBUF with SPL, increment BC
                   regfile_data_gate = 1'b1;
                   data_buf_load = 1'b1;
                   rn_out = `RGF_SPL;

                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   regfile_inc_l = 1'b1;
                   rn_in = `RGF_BC;
                end // case: 5'd9
                5'd10: begin
                   // Write SPL to (BC), load ABUF with BC+1
                   data_buf_write_ext = 1'b1;
                   addr_buf_write_ext = 1'b1;

                   addr_buf_load = 1'b1;
                   regfile_addr_gate = 1'b1;
                   rn_out = `RGF_BC;
                end
                5'd11: begin
                   // Load DBUF with SPH
                   regfile_data_gate = 1'b1;
                   data_buf_load = 1'b1;
                   rn_out = `RGF_SPH;
                end
                5'd12: begin
                   // Write SPH to (BC+1), load B with temp1
                   data_buf_write_ext = 1'b1;
                   addr_buf_write_ext = 1'b1;

                   alu_data_gate = 1'b1;
                   alu_op = `ALU_PASS1;
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   regfile_we_l = 1'b1;
                   rn_in = `RGF_B;
                end
                5'd13: begin
                   // load C with temp0
                   alu_data_gate = 1'b1;
                   alu_op = `ALU_PASS0;
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   regfile_we_l = 1'b1;
                   rn_in = `RGF_C;
                end
                // Jesus Christ what a mess that was
              endcase
           end
           
           // 8 Bit Arithmetic and Logical Operation Instructions //////////////

           8'b10_xxx_xxx: begin
              if (instruction[2:0] == 3'b110) begin
                 // A, (HL) group
                 m_cycles = 4'd2;
                 case (cycle)
                   5'd3: begin
                      // Load HL into ABUF
                      rn_out = `RGF_HL;
                      regfile_addr_gate = 1'b1;
                      addr_buf_load = 1'b1;
                   end
                   5'd4: begin
                      // Load (HL) into DBUF
                      addr_buf_write_ext = 1'b1;
                      data_buf_load_ext = 1'b1;
                   end
                   5'd5: begin
                      if (instruction[5:3] != 3'b111) begin
                         // Don't change A on a compare
                         A_load = 1'b1;
                      end
                      F_load = 1'b1;
                      case (instruction[5:3])
                        // ADD: 000, ADC: 001, SUB: 010, SBC: 011,
                        // AND: 100, OR: 110, XOR: 101, CP: 111
                        3'b000: alu_op = `ALU_ADD;
                        3'b001: alu_op = `ALU_ADC;
                        3'b010: alu_op = `ALU_SUB;
                        3'b011: alu_op = `ALU_SBC;
                        3'b100: alu_op = `ALU_AND;
                        3'b110: alu_op = `ALU_OR;
                        3'b101: alu_op = `ALU_XOR;
                        3'b111: alu_op = `ALU_SUB;
                      endcase // case (instruction[5:3])
                   end
                 endcase
              end else begin
                 // A, r group
                 m_cycles = 4'd1;
                 if (cycle == 5'd3) begin
                    nin_rn_out = instruction[2:0];
                    if (nin_rn_out == `NIN_A) begin
                       A_data_gate = 1'b1;
                    end else begin
                       regfile_data_gate = 1'b1;
                    end
                    if (instruction[5:3] != 3'b111) begin
                       // Don't change A on a compare
                       A_load = 1'b1;
                    end
                    F_load = 1'b1;
                    case (instruction[5:3])
                      // ADD: 000, ADC: 001, SUB: 010, SBC: 011,
                      // AND: 100, OR: 110, XOR: 101, CP: 111
                      3'b000: alu_op = `ALU_ADD;
                      3'b001: alu_op = `ALU_ADC;
                      3'b010: alu_op = `ALU_SUB;
                      3'b011: alu_op = `ALU_SBC;
                      3'b100: alu_op = `ALU_AND;
                      3'b110: alu_op = `ALU_OR;
                      3'b101: alu_op = `ALU_XOR;
                      3'b111: alu_op = `ALU_SUB;
                    endcase // case (instruction[5:3])
                 end
              end
           end

           // INC r //
           8'b00_xxx_10x: begin
              m_cycles = 4'd1;
              case (cycle)
                5'd3: begin
                   nin_rn_in = instruction[5:3];
                   nin_rn_out = instruction[5:3];
                   if (instruction[5:3] == 3'b111) begin
                      A_load = 1'b1;
                      alu_data1_in_sel = `ALU_1_SEL_A;
                   end else begin
                      regfile_we_l = 1'b1;
                      alu_data1_in_sel = `ALU_1_SEL_RGF;
                      alu_data_gate = 1'b1;
                   end
                   if (instruction[0]) begin
                      alu_op = `ALU_DEC;
                   end else begin
                      alu_op = `ALU_INC;
                   end
                   F_load = 1'b1;
                end
              endcase
           end

           // INC (HL), DEC (HL) //
           8'b00_110_10x: begin
              m_cycles = 4'd3;
              case (cycle)
                5'd3: begin
                   // ABUF = HL
                   rn_out = `RGF_HL;
                   regfile_addr_gate = 1'b1;
                end
                5'd4: begin
                   // DBUF = (HL)
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;
                end
                5'd5: begin
                   // temp1 = (HL)
                   data_buf_write = 1'b1;
                   temp1_load = 1'b1;
                end
                5'd6: begin
                   // DBUF = (HL) +/- 1
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   if (instruction[0]) begin
                      alu_op = `ALU_DEC;
                   end else begin
                      alu_op = `ALU_INC;
                   end
                   F_load = 1'b1;
                   alu_data_gate = 1'b1;
                   data_buf_load = 1'b1;
                end
                5'd7: begin
                   // (HL) = (HL) +/- 1
                   addr_buf_write_ext = 1'b1;
                   data_buf_write_ext = 1'b1;
                end
              endcase
           end
           
           // 16-Bit Arithmetic Operation Instructions /////////////////////////

           // ADD HL, ss //
           8'b00_xx1_001: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   // temp1 = ssL
                   nin_rn_out = instruction[5:4];
                   rn16_out = 1'b1;
                   rn16_out_lo = 1'b1;
                   regfile_data_gate = 1'b1;
                   temp1_load = 1'b1;
                end
                5'd4: begin
                   // temp0 = L
                   rn_out = `RGF_L;
                   regfile_data_gate = 1'b1;
                   temp0_load = 1'b1;
                end
                5'd5: begin
                   // L = L + ssL
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   alu_op = `ALU_ADD;
                   F_load = 1'b1;
                   alu_data_gate = 1'b1;
                   regfile_we_l = 1'b1;
                   rn_in = `RGF_L;
                end
                5'd6: begin
                   // temp0 = ssH
                   nin_rn_out = instruction[5:4];
                   rn16_out = 1'b1;
                   rn16_out_lo = 1'b1;
                   regfile_data_gate = 1'b1;
                   temp0_load = 1'b1;
                end
                5'd7: begin
                   // H = H + ssH
                   rn_out = `RGF_H;
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   alu_data1_in_sel = `ALU_1_SEL_RGF;
                   alu_op = `ALU_ADC;
                   F_load = 1'b1;
                   alu_data_gate = 1'b1;
                   regfile_we_l = 1'b1;
                   rn_in = `RGF_H;
                end
              endcase
           end

           // ADD SP, e //
           8'b11_101_000: begin
              m_cycles = 4'd4;
              case (cycle)
                5'd3: begin
                   // DBUF = e, PC++
                   addr_buf_write_ext = 1'b1;
                   data_buf_load_ext = 1'b1;

                   regfile_inc_pc = 1'b1;
                end
                5'd4: begin
                   // temp0 = e
                   data_buf_write = 1'b1;
                   temp0_load = 1'b1;
                end
                5'd5: begin
                   // temp1 = SPL
                   rn_out = `RGF_SPL;
                   regfile_data_gate = 1'b1;
                   temp1_load = 1'b1;
                end
                5'd6: begin
                   // SPL = SPL + e
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   alu_op = `ALU_ADD;
                   F_load = 1'b1;
                   alu_data_gate = 1'b1;
                   rn_in = `RGF_SPL;
                   regfile_we_l = 1'b1;
                end
                5'd7: begin
                   // temp1 = SPH
                   rn_out = `RGF_SPH;
                   regfile_data_gate = 1'b1;
                   temp1_load = 1'b1;
                end
                5'd8: begin
                   // SPH = SPH + 00/ff + carry
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   alu_data0_in_sel = `ALU_0_SEL_FF;
                   alu_op = `ALU_ADC;
                   F_load = 1'b1;
                   alu_data_gate = 1'b1;
                   rn_in = `RGF_SPH;
                   regfile_we_l = 1'b1;
                end
              endcase
           end

           // INC ss //
           8'b00_xx0_011: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   regfile_inc_l = 1'b1;
                   rn16_in = 1'b1;
                   nin_rn_in = instruction[5:4];
                end
              endcase
           end
           
           // DEC ss //
           8'b00_xx1_011: begin
              m_cycles = 4'd2;
              case (cycle)
                5'd3: begin
                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   regfile_inc_l = 1'b0;
                   rn16_in = 1'b1;
                   nin_rn_in = instruction[5:4];
                end
              endcase
           end
           
           // Jump Instructions ////////////////////////////////////////////////

           // JP nn, JP cc, nn //
           8'b11_000_011, 8'b11_0xx_010: begin
              if (instruction[0] | taken) begin
                 // JP nn, JP cc, nn: taken //
                 m_cycles = 4'd3;
                 case (cycle)
                   5'd3: begin
                      // PC++, DBUF = nnL
                      regfile_inc_pc = 1'b1;
                      addr_buf_write_ext = 1'b1;
                      
                      data_buf_load_ext = 1'b1;
                   end
                   5'd4: begin
                      // temp0 = nnL
                      // ABUF = PC
                      data_buf_write = 1'b1;
                      temp0_load = 1'b1;
                      
                      rn_out = `RGF_PC;
                      regfile_addr_gate = 1'b1;
                      addr_buf_load = 1'b1;
                   end
                   5'd5: begin
                      // DBUF = nnH
                      // temp1 = A
                      addr_buf_write_ext = 1'b1;
                      data_buf_load_ext = 1'b1;
                      
                      A_data_gate = 1'b1;
                      temp1_load = 1'b1;
                   end
                   5'd6: begin
                      // A = temp0 (nnL), PCH = nnH
                      A_load = 1'b1;
                      alu_op = `ALU_PASS0;
                      alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                      
                      data_buf_write = 1'b1;
                      regfile_we_l = 1'b1;
                      rn_in = `RGF_PCH;
                   end
                   5'd7: begin
                      // PCL = A (nnL), A = temp1 (old A)
                      A_data_gate = 1'b1;
                      regfile_we_l = 1'b1;
                      rn_in = `RGF_PCL;

                      A_load = 1'b1;
                      alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                      alu_op = `ALU_PASS1;
                   end
                 endcase // case (cycle)
              end else begin // if (instruction[0] | taken)
                 // JP cc, nn: not taken //
                 m_cycles = 4'd2;
                 case (cycle)
                   // Don't forget to increment the PC!
                   5'd3: begin
                      regfile_inc_pc = 1'b1;
                   end
                   5'd4: begin
                      regfile_inc_pc = 1'b1;
                   end
                 endcase
              end
           end

           // JR e //
//           8'b00_011_000, 8'b00_100_000, 8'b00_101_000, 8'b00_110_000, 8'b00_111_000: begin
           8'b00_011_000, 8'b00_1xx_000: begin
              if ((~instruction[5]) | taken) begin
                 // JR e, JR cc, e: taken //
                 m_cycles = 4'd3;
                 case (cycle)
                   5'd3: begin
                      // DBUF = e, PC = PC + 2
                      data_buf_load_ext = 1'b1;
                      addr_buf_write_ext = 1'b1;

                      regfile_inc_pc = 1'b1;
                   end
                   5'd4: begin
                      // TEMP0 = e
                      data_buf_write = 1'b1;
                      temp0_load = 1'b1;
                   end
                   5'd5: begin
                      // DBUF = flags
                      F_data_gate = 1'b1;
                      data_buf_load = 1'b1;
                   end
                   5'd6: begin
                      // TEMP1 = PCL
                      rn_out = `RGF_PCL;
                      regfile_data_gate = 1'b1;
                      temp1_load = 1'b1;                   
                   end
                   5'd7: begin
                      // PCL = PCL + e
                      alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                      alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                      alu_op = `ALU_ADD;
                      F_load = 1'b1;
                      alu_data_gate = 1'b1;
                      regfile_we_l = 1'b1;
                      rn_in = `RGF_PCL;
                   end
                   5'd8: begin
                      // TEMP1 = PCH
                      rn_out = `RGF_PCL;
                      regfile_data_gate = 1'b1;
                      temp1_load = 1'b1;
                   end
                   5'd9: begin
                      // PCH = PCH + ff/00 + carry
                      alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                      alu_data0_in_sel = `ALU_0_SEL_FF;
                      alu_op = `ALU_ADC;
                      rn_in = `RGF_PCH;
                   end
                   5'd10: begin
                      // F = DBUF (== flags)
                      alu_data0_in_sel = `ALU_0_SEL_DATA;
                      alu_op = `ALU_PASSF;
                      F_load = 1'b1;
                   end
                   // God damn it Intel
                 endcase // case (cycle)
              end else begin // if (~(instruction[5]) | taken)
                 // JR cc, e: not taken //
                 m_cycles = 4'd2;
                 case (cycle)
                   5'd3: begin
                      regfile_inc_pc = 1'b1;
                   end
                 endcase
              end
           end

           // JP (HL) //
           // MOTHERFUCKER
           8'b11_101_001: begin
              m_cycles = 4'd1;
              if (cycle == 5'd3) begin
                 regfile_jp_hl = 1'b1;
              end
           end

           // CALL nn, CALL cc, nn //
//           8'b11_001_101, 8'b11_000_100, 8'b11_001_100, 8'b11_010_100, 8'b11_011_100: begin
           8'b11_001_101, 8'b11_0xx_100: begin
              if (instruction[0] | taken) begin
                 // CALL nn, CALL cc, nn taken //
                 m_cycles = 4'd6;
                 case (cycle)
                   5'd3: begin
                      // SP = SP - 1, DBUF = nnL
                      regfile_we_l = 1'b1;
                      regfile_change16_l = 1'b1;
                      rn_in = `RGF_SP;

                      data_buf_load_ext = 1'b1;
                      addr_buf_write_ext = 1'b1;
                   end
                   5'd4: begin
                      // SP = SP - 2, ABUF = SP - 1, temp0 = nnL
                      regfile_we_l = 1'b1;
                      regfile_change16_l = 1'b1;
                      rn_in = `RGF_SP;

                      addr_buf_load = 1'b1;
                      regfile_addr_gate = 1'b1;
                      rn_out = `RGF_SP;

                      temp0_load = 1'b1;
                      data_buf_write = 1'b1;
                   end
                   5'd5: begin
                      // DBUF = PCH
                      data_buf_load = 1'b1;
                      regfile_data_gate = 1'b1;
                      rn_out = `RGF_PCH;
                   end
                   5'd6: begin
                      // (SP - 1) = PCH, ABUF = SP - 2
                      data_buf_write_ext = 1'b1;
                      addr_buf_write_ext = 1'b1;

                      addr_buf_load = 1'b1;
                      regfile_addr_gate = 1'b1;
                      rn_out = `RGF_SP;
                   end
                   5'd7: begin
                      // DBUF = PCL
                      data_buf_load = 1'b1;
                      regfile_data_gate = 1'b1;
                      rn_out = `RGF_PCL;
                   end
                   5'd8: begin
                      // (SP - 2) = PCL, PC = PC + 2
                      data_buf_write_ext = 1'b1;
                      addr_buf_write_ext = 1'b1;

                      regfile_inc_pc = 1'b1;
                   end
                   5'd9: begin
                      // ABUF = PC + 2, PCL = temp0 (== nnL)
                      addr_buf_load = 1'b1;
                      regfile_addr_gate = 1'b1;
                      rn_out = `RGF_PC;
                      
                      alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                      alu_op = `ALU_PASS0;
                      alu_data_gate = 1'b1;
                      regfile_we_l = 1'b1;
                      rn_in = `RGF_PCL;
                   end
                   5'd10: begin
                      // DBUF = nnH
                      data_buf_load_ext = 1'b1;
                      addr_buf_write_ext = 1'b1;
                   end
                   5'd11: begin
                      // PCH = DBUF (== nnH)
                      data_buf_write = 1'b1;
                      regfile_we_l = 1'b1;
                      rn_in = `RGF_PCH;
                   end
                 endcase // case (cycle)
              end else begin // if (instruction[0] | taken)
                 // CALL cc, nn: not taken //
                 m_cycles = 4'd3;
                 case (cycle)
                   // Increment the PC to skip the immediate value
                   5'd3: begin
                      regfile_inc_pc = 1'b1;
                   end
                   5'd4: begin
                      regfile_inc_pc = 1'b1;
                   end
                 endcase
              end
           end // case: 8'b11_001_101 CALL nn

           // RET, RETI, RET cc //
//           8'b11_001_001, 8'b11_011_001, 8'b11_000_000, 8'b11_001_000, 8'b11_010_000, 8'b11_011_000: begin
           8'b11_001_001, 8'b11_0xx_000: begin
              if (instruction[0] | taken) begin
                 // RET, RETI, RET cc taken //
                 m_cycles = 4'd4;
                 case (cycle)
                   5'd3: begin
                      // ABUF = SP, SP = SP + 1
                      rn_out = `RGF_SP;
                      regfile_addr_gate = 1'b1;
                      addr_buf_load = 1'b1;

                      rn_in = `RGF_SP;
                      regfile_change16_l = 1'b1;
                      regfile_inc_l = 1'b1;
                      regfile_we_l = 1'b1;
                   end
                   5'd4: begin
                      // DBUF = (SP), ABUF = SP + 1
                      addr_buf_write_ext = 1'b1;
                      data_buf_load_ext = 1'b1;

                      rn_out = `RGF_SP;
                      regfile_addr_gate = 1'b1;
                      addr_buf_load = 1'b1;
                   end
                   5'd5: begin
                      // PCL = DBUF, DBUF = (SP + 1)
                      data_buf_write = 1'b1;
                      regfile_we_l = 1'b1;
                      rn_in = `RGF_PCL;

                      addr_buf_write_ext = 1'b1;
                      data_buf_load_ext = 1'b1;
                   end
                   5'd6: begin
                      // PCH = DBUF
                      data_buf_write = 1'b1;
                      regfile_we_l = 1'b1;
                      rn_in = `RGF_PCH;
                   end
                   5'd7: begin
                      // SP = SP + 2
                      rn_in = `RGF_SP;
                      regfile_change16_l = 1'b1;
                      regfile_inc_l = 1'b1;
                      regfile_we_l = 1'b1;
                   end
                 endcase // case (cycle)
              end else begin
                 // RET cc, not taken //
                 m_cycles = 4'd2;
              end
           end

           // RST n //
           /*
            000 00 0000 0000
            001 08 0000 1000
            010 10 0001 0000
            011 18 0001 1000
            100 20 0010 0000
            101 28 0010 1000
            110 30 0011 0000
            111 38 0011 1000
            The reset value is ((instruction << 2) >> 5) << 3
            */
           8'b11_xxx_111: begin
              m_cycles = 4'd4;
              case (cycle)
                5'd3: begin
                   // Decrement SP, load instruction into temp register
                   regfile_we_l = 1'b1;
                   regfile_change16_l = 1'b1;
                   rn_in = `RGF_SP;

                   data_buf_write = 1'b1;
                   temp1_load = 1'b1;
                end
                5'd4: begin
                   // Load SP-1 into ABUF, SP = SP - 2, temp1 = p
                   regfile_addr_gate = 1'b1;
                   rn_out = `RGF_SP;
                   addr_buf_load = 1'b1;

                   regfile_we_l = 1'b1;
                   rn_in = `RGF_SP;
                   regfile_change16_l = 1'b1;

                   alu_data0_in_sel = `ALU_0_SEL_RSTP;
                   alu_op = `ALU_PASS0;
                   alu_data_gate = 1'b1;
                   temp1_load = 1'b1;
                end
                5'd5: begin
                   // Output PCH to data buffer
                   data_buf_load = 1'b1;
                   rn_out = `RGF_PCH;
                   regfile_data_gate = 1'b1;
                end
                5'd6: begin
                   // Write PCH to (SP - 1), load data buf with PCL
                   data_buf_write_ext = 1'b1;
                   addr_buf_write_ext = 1'b1;

                   data_buf_load = 1'b1;
                   rn_out = `RGF_PCL;
                   regfile_data_gate = 1'b1;
                end
                5'd7: begin
                   // ABUF = SP - 2, PCL = P
                   addr_buf_load = 1'b1;
                   regfile_addr_gate = 1'b1;
                   rn_out = `RGF_SP;

                   rn_in = `RGF_PCL;
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   alu_op = `ALU_PASS1;
                   alu_data_gate = 1'b1;
                   regfile_we_l = 1'b1;
                end
                5'd8: begin
                   // temp0 = temp1
                   alu_data_gate = 1'b1;
                   alu_op = `ALU_PASS1;
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   temp0_load = 1'b1;
                end
                5'd9: begin
                   // temp1 = temp0 ^ temp1 (== temp1 ^ temp1 == 0)
                   alu_data_gate = 1'b1;
                   alu_op = `ALU_XOR;
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                   temp1_load = 1'b1;
                end
                5'd10: begin
                   // PCH = temp1 (== 0)
                   regfile_we_l = 1'b1;
                   rn_in = `RGF_PCH;
                   alu_op = `ALU_PASS1;
                   alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                   alu_data_gate = 1'b1;
                end
              endcase
           end // case: 8'b11_xxx_111
           


      // General-Purpose Arithmetic/CPU Control Instructions ///////////////////

           // DAA //
           8'b00_100_111: begin
              m_cycles = 4'd1;
              case(cycle)
                5'd3: begin
                   alu_data1_in_sel = `ALU_1_SEL_A;
                   alu_op = `ALU_DAA;
                   A_load = 1'b1;
                   F_load = 1'b1;
                end
              endcase
           end

           // CPL //
           8'b00_101_111: begin
              m_cycles = 4'd1;
              case(cycle)
                5'd3: begin
                   alu_data1_in_sel = `ALU_1_SEL_A;
                   alu_op = `ALU_NOT;
                   A_load = 1'b1;
                   F_load = 1'b1;
                end
              endcase
           end

           // CCF //
           8'b00_111_111: begin
              m_cycles = 4'd1;
              case(cycle)
                5'd3: begin
                   alu_op = `ALU_CCF;
                   F_load = 1'b1;
                end
              endcase
           end

           // SCF //
           8'b00_110_111: begin
              m_cycles = 4'd1;
              case(cycle)
                5'd3: begin
                   alu_op = `ALU_SCF;
                   F_load = 1'b1;
                end
              endcase
           end
           
         endcase // casex (instruction)
      
      // CB Instructions ///////////////////////////////////////////////////////
      
      end else begin
         casex (instruction)

           // Rotate Shift Instructions ////////////////////////////////////////
           
           8'b00_xxx_xxx: begin
              case (instruction[5:3])
                3'b000: alu_op = `ALU_RLC;
                3'b001: alu_op = `ALU_RRC;
                3'b010: alu_op = `ALU_RL;
                3'b011: alu_op = `ALU_RR;
                3'b100: alu_op = `ALU_SL;
                3'b101: alu_op = `ALU_SRA;
                3'b110: alu_op = `ALU_SWAP;
                3'b111: alu_op = `ALU_SRL;
              endcase
              if (instruction[2:0] == 3'b110) begin
                 // (HL)
                 m_cycles = 4'd4;
                 case (cycle)
                   5'd5: begin
                      // ABUF = HL
                      rn_out = `RGF_HL;
                      regfile_addr_gate = 1'b1;
                      addr_buf_load = 1'b1;
                   end
                   5'd6: begin
                      // DBUF = (HL)
                      addr_buf_write_ext = 1'b1;
                      data_buf_load_ext = 1'b1;
                   end
                   5'd7: begin
                      // temp1 = (HL)
                      data_buf_write = 1'b1;
                      temp1_load = 1'b1;
                   end
                   5'd8: begin
                      // DBUF = op((HL))
                      alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                      alu_data_gate = 1'b1;
                      data_buf_load = 1'b1;
                      F_load = 1'b1;
                   end
                   5'd9: begin
                      // (HL) = op((HL))
                      addr_buf_write_ext = 1'b1;
                      data_buf_write_ext = 1'b1;
                   end
                 endcase
              end else begin
                 // r
                 m_cycles = 4'd2;
                 case (cycle)
                   5'd5: begin
                      // temp1 = r
                      if (instruction[2:0] == 3'b111) begin
                         A_data_gate = 1'b1;
                      end else begin
                         nin_rn_out = instruction[2:0];
                         regfile_data_gate = 1'b1;
                      end
                      temp1_load = 1'b1;
                   end
                   5'd6: begin
                      // r = op(r)
                      alu_data1_in_sel = `ALU_1_SEL_TEMP1;
                      if (instruction[2:0] == 3'b111) begin
                         A_load = 1'b1;
                      end else begin
                         alu_data_gate = 1'b1;
                         nin_rn_in = instruction[2:0];
                         regfile_we_l = 1'b1;
                      end
                      F_load = 1'b1;
                   end
                 endcase
              end

           end
           
           // Bit Operations ///////////////////////////////////////////////////

           // BIT //
           8'b01_xxx_xxx: begin
             if (instruction[2:0] == 3'b110) begin
                // BIT b, (HL)
                m_cycles = 4'd3;
                case (cycle)
                  5'd5: begin
                     // ABUF = HL
                     rn_out = `RGF_HL;
                     regfile_addr_gate = 1'b1;
                     addr_buf_load = 1'b1;
                  end
                  5'd6: begin
                     // DBUF = (HL)
                     addr_buf_write_ext = 1'b1;
                     data_buf_load_ext = 1'b1;
                  end
                  5'd7: begin
                     // Set the fucking flags
                     alu_data1_in_sel = `ALU_1_SEL_DATA;
                     alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                     alu_op = `ALU_BIT;
                     F_load = 1'b1;
                  end
                endcase
             end else begin
                // BIT b, r
                m_cycles = 4'd2;
                case (cycle)
                  5'd5: begin
                     nin_rn_out = instruction[2:0];
                     if (nin_rn_out == 3'b111) begin
                        alu_data1_in_sel = `ALU_1_SEL_A;
                     end else begin
                        regfile_data_gate = 1'b1;
                        alu_data1_in_sel = `ALU_1_SEL_DATA;
                     end
                     alu_data0_in_sel = `ALU_0_SEL_TEMP0;
                     alu_op = `ALU_BIT;
                     F_load = 1'b1;
                  end
                endcase
             end // else: !if(instruction[2:0] == 3'b110)
           end // case: 8'b01_xxx_xxx

         endcase // case (instruction)
      end // else: !if(~cb)
      
      
      // Next cycle calculation ////////////////////////////////////////////////

      // If we've reached 1 cycle before our alloted machine cycles end, then
      // set the next cycle to 0. Otherwise, continue counting cycles.
      // Additionally, reset the multibyte instruction flag.
      if (next_cycle_high[5:2] == m_cycles) begin
         next_cycle = 5'b0;
         next_cb = 1'b0;
      end else begin
         next_cycle = next_cycle_high[4:0];
      end
      
   end
   
endmodule // decode
