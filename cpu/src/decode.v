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
   regfile_rn_in, regfile_rn_out, regfile_we, regfile_change_pc,
   regfile_inc_pc, addr_buf_load, addr_buf_write, data_buf_load,
   data_buf_write, addr_buf_load_ext, addr_buf_write_ext,
   data_buf_load_ext, data_buf_write_ext, inst_reg_load, A_load,
   F_load, temp1_load, temp0_load, regfile_data_gate, A_data_gate,
   F_data_gate, regfile_addr_gate, alu_data1_in_sel, alu_data0_in_sel,
   addr_ff00_sel, alu_op, alu_size, halt,
   // Inputs
   instruction, clock, reset
   );
   // Outputs //////////////////////////////////////////////////////////////////
   
   // Regfile
   output wire [4:0]  regfile_rn_in, regfile_rn_out;
   output reg         regfile_we, regfile_change_pc, regfile_inc_pc;
   
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
   output reg         regfile_addr_gate;

   // Mux selects
   output reg [1:0]   alu_data1_in_sel;
   output reg         alu_data0_in_sel, addr_ff00_sel;

   // ALU
   output reg [4:0]   alu_op;
   output reg         alu_size;

   // External
   output reg         halt;
   
   // Inputs ///////////////////////////////////////////////////////////////////
   
   input [7:0]        instruction;

   input              clock, reset;

   // Internal Signals /////////////////////////////////////////////////////////

   // Whether we are on a CB prefix instruction
   reg                cb, next_cb;
   
   // Counter
   // Top 3 bits are machine cycle, lower 2 are T cycle
   reg [4:0]          cycle, next_cycle;

   // Number of machine cycles in the current instruction
   reg [3:0]          m_cycles;
   
   wire [2:0]         m_cycle;
   wire [1:0]         t_cycle;

   assign m_cycle = cycle[4:2];
   assign t_cycle = cycle[1:0];

   // Register number decoding
   reg [4:0]          rn_in, rn_out;
   reg [2:0]          nin_rn_in, nin_rn_out;
   reg                rn16_in, rn16_out;
   
   rn_decode rgf_in_decoder(.rgf_rn_out(regfile_rn_in),
                            .rgf_rn_in(rn_in),
                            .rn(nin_rn_in),
                            .rn16(rn16_in)),
     rgf_out_decoder(.rgf_rn_out(regfile_rn_out),
                     .rgf_rn_in(rn_out),
                     .rn(nin_rn_out),
                     .rn16(rn16_out));

   // State Machine ////////////////////////////////////////////////////////////

   wire [5:0]         next_cycle_high;
   assign next_cycle_high = {1'b0, cycle} + 6'b1;
   
   always @(posedge clock or posedge reset) begin
      if (reset) begin
         cycle <= 5'd0;
         cb <= 1'd0;
      end else begin
         cycle <= next_cycle;
         cb <= next_cb;
      end
   end

   always @(/*AUTOSENSE*/`ALU_ADD or `ALU_PASS0 or `NIN_A or `RGF_HL
            or `RGF_NONE or `RGF_PC or cb or cycle or instruction
            or next_cycle_high) begin
      
      // Defaults //////////////////////////////////////////////////////////////
      
      // Regfile
      {regfile_we, regfile_change_pc, regfile_inc_pc} = 3'd0;
      
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
      {regfile_data_gate, A_data_gate, F_data_gate} = 3'd0;
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

      halt = 1'b0;
      
      // Fetch/Decode //////////////////////////////////////////////////////////

      if (cycle == 5'd0) begin
         // Fetch 0: Load ADRBUF
         m_cycles = 4'd1;
         
         rn_out = `RGF_PC;
         regfile_addr_gate = 1'b1;
         addr_buf_load = 1'b1;
      end else if (cycle == 5'd1) begin
         // Fetch 1: PC++; Load DBUF
         m_cycles = 4'd1;
         
         regfile_we = 1'b1;
         regfile_change_pc = 1'b1;
         regfile_inc_pc = 1'b1;
         addr_buf_write_ext = 1'b1;
         data_buf_load_ext = 1'b1;
      end else if (cycle == 5'd2) begin
         // Fetch 2: Load IR; Load the next instruction in case of CB
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
         regfile_we = 1'b1;
         regfile_change_pc = 1'b1;
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
           
           // 8-bit loads //
           8'b01xxxxxx: begin
              if (instruction[5:0] == 6'b110110) begin
                 // HALT: For now, the testbench asserts reset and finishes
                 halt = 1'b1;
              end else if (instruction[2:0] == 3'b110) begin
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
                         regfile_we = 1'b1;
                      end
                   end
                 endcase
              end
           end // case: 8'b01xxxxxx

           // 8-bit immediate loads //
           8'b00xxx110: begin
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
                   regfile_we = 1'b1;
                   regfile_change_pc = 1'b1;
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
                      regfile_we = 1'b1;
                   end
                end
              endcase
           end

           // 8 Bit Adds //
           8'b10_000_xxx: begin
              if (instruction[2:0] == 3'b110) begin
                 // ADD A, (HL)
              end else begin
                 // ADD A, r
                 nin_rn_out = instruction[2:0];
                 if (nin_rn_out == `NIN_A) begin
                    A_data_gate = 1'b1;
                 end else begin
                    regfile_data_gate = 1'b1;
                 end
                 A_load = 1'b1;
                 F_load = 1'b1;
                 alu_op = `ALU_ADD;
              end
           end
           
         endcase
      end

      
      // CB Instructions ///////////////////////////////////////////////////////

      /*else begin
         case (instruction)
           
         endcase
      end*/

      // Next cycle calculation ////////////////////////////////////////////////

      // If we've reached 1 cycle before our alloted machine cycles end, then
      // set the next cycle to 0. Otherwise, continue counting cycles.      
      if (next_cycle_high[5:2] == m_cycles) begin
         next_cycle = 5'b0;
      end else begin
         next_cycle = next_cycle_high[4:0];
      end
      
   end
   
endmodule // decode
