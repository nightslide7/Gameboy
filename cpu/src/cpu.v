`include "cpu.vh"

/**
 * The GB80 CPU.
 * 
 * Consists of a microcode module, register file, and ALU connected to some 
 * extra control hardware and parallel data and address buses. The buses output
 * to the user of the CPU through some buffers.
 * 
 * @author Joseph Carlos (jcarlos)
 */

/**
 * The top module.
 */
module cpu(/*AUTOARG*/
   // Outputs
   mem_we, mem_re, halt,
   // Inouts
   addr_ext, data_ext,
   // Inputs
   clock, reset
   );
   inout [15:0] addr_ext;
   inout [7:0]  data_ext;

   output wire  mem_we, mem_re;
   output wire  halt;
   
   input        clock, reset;

   // Global wires /////////////////////////////////////////////////////////////

   // Buses
   wire [15:0]  addr_bus;
   wire [7:0]   data_bus;


   // Intermediate data signals ////////////////////////////////////////////////

   // Registers
   wire [7:0]   A_data, F_data, temp1_data, temp0_data, instruction;

   // ALU
   wire [7:0]   alu_data0_in, alu_data_out;
   reg [7:0]    alu_data1_in;
   wire [3:0]   alu_flags_in, alu_flags_out;
   assign alu_flags_in = F_data[7:4];
   
   // Regfile
   // regfile_data_addr is necessary for instructions that output 
   // 16'hff00 + regfile_data_out[7:0] to the address bus.
   wire [15:0]  regfile_data_out, regfile_data_addr;
   wire [7:0]   regfile_data_in;
   
   // Control signals //////////////////////////////////////////////////////////
   
   // Buffers
   // To/from internal bus
   wire        addr_buf_load, addr_buf_write;
   wire        data_buf_load, data_buf_write;
   // To/from external bus
   wire        addr_buf_load_ext, addr_buf_write_ext;
   wire        data_buf_load_ext, data_buf_write_ext;

   // Outputs
   assign mem_we = data_buf_write_ext;
   assign mem_re = data_buf_load_ext;
   
   // Registers
   wire        inst_reg_load, A_load, F_load, temp1_load, temp0_load;

   // Tristate buffer enables
   wire        regfile_data_gate, A_data_gate, F_data_gate, regfile_addr_gate;

   // Mux selects
   wire [1:0]  alu_data1_in_sel;
   wire        alu_data0_in_sel, addr_ff00_sel;

   // ALU
   wire [4:0]  alu_op;
   wire        alu_size;
   
   // Regfile
   wire [4:0]  regfile_rn_in, regfile_rn_out;
   wire        regfile_we, regfile_change_pc, regfile_inc_pc;

   // Multiplexers /////////////////////////////////////////////////////////////

   assign regfile_data_addr = (addr_ff00_sel) ? {8'hff, regfile_data_out[7:0]} :
                              regfile_data_out;

   assign alu_data0_in = (alu_data0_in_sel) ? temp0_data : data_bus;

   always @(/*AUTOSENSE*/A_data or alu_data1_in_sel or data_bus
            or temp1_data) begin
      case (alu_data1_in_sel)
        2'b00: alu_data1_in = A_data;
        2'b01: alu_data1_in = data_bus;
        2'b10: alu_data1_in = A_data;
        2'b11: alu_data1_in = temp1_data;
      endcase
   end

   assign regfile_data_in = data_bus;
   
   // Input/Output buffers /////////////////////////////////////////////////////
   
   buffer #(16, 0) addr_buf(.bus_in(addr_bus),
                            .bus_ext(addr_ext),
                            .bus_in_read(addr_buf_load),
                            .bus_in_write(addr_buf_write),
                            .bus_ext_read(addr_buf_load_ext),
                            .bus_ext_write(addr_buf_write_ext),
                            .clock(clock),
                            .reset(reset));
   buffer #(8, 0) data_buf(.bus_in(data_bus),
                           .bus_ext(data_ext),
                           .bus_in_read(data_buf_load),
                           .bus_in_write(data_buf_write),
                           .bus_ext_read(data_buf_load_ext),
                           .bus_ext_write(data_buf_write_ext),
                           .clock(clock),
                           .reset(reset));
   
   // Registers ////////////////////////////////////////////////////////////////

   // TODO: make into a single always block
   
   register #(8, 0) inst_reg(.q(instruction),
                             .d(data_bus),
                             .load(inst_reg_load),
                             .clock(clock),
                             .reset(reset));

   register #(8, 0) A_reg(.q(A_data),
                          .d(alu_data_out),
                          .load(A_load),
                          .clock(clock),
                          .reset(reset));

   register #(8, 0) F_reg(.q(F_data),
                          .d({alu_flags_out, 4'b0}),
                          .load(F_load),
                          .clock(clock),
                          .reset(reset));

   register #(8, 0) temp1_reg(.q(temp1_data),
                              .d(data_bus),
                              .load(temp1_load),
                              .clock(clock),
                              .reset(reset));

   register #(8, 0) temp0_reg(.q(temp0_data),
                              .d(data_bus),
                              .load(temp0_load),
                              .clock(clock),
                              .reset(reset));
   
   // Tristate buffers /////////////////////////////////////////////////////////
   
   tristate #(8) regfile_data_tri(.out(data_bus),
                                  .in(regfile_data_out[7:0]),
                                  .en(regfile_data_gate)),
     A_data_tri(.out(data_bus),
                .in(A_data),
                .en(A_data_gate)),
     F_data_tri(.out(data_bus),
                .in(F_data),
                .en(F_data_gate));

   tristate #(16) regfile_addr_tri(.out(addr_bus),
                                   .in(regfile_data_addr[15:0]),
                                   .en(regfile_addr_gate));

   // ALU //////////////////////////////////////////////////////////////////////

   alu gb80_alu(/*AUTOINST*/
                // Outputs
                .alu_data_out           (alu_data_out[7:0]),
                .alu_flags_out          (alu_flags_out[3:0]),
                // Inputs
                .alu_data0_in           (alu_data0_in[7:0]),
                .alu_data1_in           (alu_data1_in[7:0]),
                .alu_op                 (alu_op[4:0]),
                .alu_flags_in           (alu_flags_in[3:0]),
                .alu_size               (alu_size));

   // Regfile //////////////////////////////////////////////////////////////////

   regfile gb80_regfile(/*AUTOINST*/
                        // Outputs
                        .regfile_data_out(regfile_data_out[15:0]),
                        // Inputs
                        .regfile_data_in(regfile_data_in[7:0]),
                        .regfile_rn_in  (regfile_rn_in[4:0]),
                        .regfile_rn_out (regfile_rn_out[4:0]),
                        .regfile_we     (regfile_we),
                        .regfile_change_pc(regfile_change_pc),
                        .regfile_inc_pc (regfile_inc_pc),
                        .reset          (reset),
                        .clock          (clock),
                        .halt           (halt));

   // Decode module ////////////////////////////////////////////////////////////

   decode gb80_decode(/*AUTOINST*/
                      // Outputs
                      .regfile_rn_in    (regfile_rn_in[4:0]),
                      .regfile_rn_out   (regfile_rn_out[4:0]),
                      .regfile_we       (regfile_we),
                      .regfile_change_pc(regfile_change_pc),
                      .regfile_inc_pc   (regfile_inc_pc),
                      .addr_buf_load    (addr_buf_load),
                      .addr_buf_write   (addr_buf_write),
                      .data_buf_load    (data_buf_load),
                      .data_buf_write   (data_buf_write),
                      .addr_buf_load_ext(addr_buf_load_ext),
                      .addr_buf_write_ext(addr_buf_write_ext),
                      .data_buf_load_ext(data_buf_load_ext),
                      .data_buf_write_ext(data_buf_write_ext),
                      .inst_reg_load    (inst_reg_load),
                      .A_load           (A_load),
                      .F_load           (F_load),
                      .temp1_load       (temp1_load),
                      .temp0_load       (temp0_load),
                      .regfile_data_gate(regfile_data_gate),
                      .A_data_gate      (A_data_gate),
                      .F_data_gate      (F_data_gate),
                      .regfile_addr_gate(regfile_addr_gate),
                      .alu_data1_in_sel (alu_data1_in_sel[1:0]),
                      .alu_data0_in_sel (alu_data0_in_sel),
                      .addr_ff00_sel    (addr_ff00_sel),
                      .alu_op           (alu_op[4:0]),
                      .alu_size         (alu_size),
                      .halt             (halt),
                      // Inputs
                      .instruction      (instruction[7:0]),
                      .clock            (clock),
                      .reset            (reset));

   // synthesis translate_off
   integer fd;
   always @(posedge clock) begin
      if (~reset && halt) begin
         fd = $fopen("cpu_dump.txt");
         $fdisplay(fd, "AF %4h", {A_data, F_data});
         $fclose(fd);
      end
   end
   // synthesis translate_on
   
endmodule // cpu

/**
 * Decoder from Nintendo's register number values (don't know why I didn't
 * just use these values... oops).
 * 
 * @output rgf_rn_out The regfile index value.
 * @input rgf_rn_in A regfile index value. If it is not `RGF_NONE, then this
 *    value is passed through. Otherwise, {rn16, rn} is decoded.
 * @input rn A 3-bit register number as specified in the GB Programming Manual.
 * @input rn16 1 if using a 16-bit register code in rn, 0 if using an 8-bit
 *    register code.
 */
module rn_decode(/*AUTOARG*/
   // Outputs
   rgf_rn_out,
   // Inputs
   rgf_rn_in, rn, rn16
   );
   output reg [4:0]   rgf_rn_out;
   input [4:0]        rgf_rn_in;
   input [2:0]        rn;
   input              rn16;
   
   always @(*) begin
      if (rgf_rn_in == `RGF_NONE) begin
         if (~rn16) begin
            case (rn)
              `NIN_B: rgf_rn_out = `RGF_B;
              `NIN_C: rgf_rn_out = `RGF_C;
              `NIN_D: rgf_rn_out = `RGF_D;
              `NIN_E: rgf_rn_out = `RGF_E;
              `NIN_H: rgf_rn_out = `RGF_H;
              `NIN_L: rgf_rn_out = `RGF_L;
            endcase
         end else begin
            case(rn)
              `NIN_BC: rgf_rn_out = `RGF_BC;
              `NIN_DE: rgf_rn_out = `RGF_DE;
              `NIN_HL: rgf_rn_out = `RGF_HL;
              `NIN_SP: rgf_rn_out = `RGF_SP;
            endcase
         end
      end else begin
         rgf_rn_out = rgf_rn_in;
      end
   end
endmodule // rn_decode

/**
 * A tristate buffer (because you can't assign multiple times to a single bus).
 * 
 * @param width The width of the input and output.
 * @output out The bus to output to.
 * @input in The input signal.
 * @en out is driven to in if en == 1, z's otherwise.
 */
module tristate(/*AUTOARG*/
   // Outputs
   out,
   // Inputs
   in, en
   );
   parameter
     width = 1;
   output wire [width-1:0] out;
   input [width-1:0]       in;
   input                   en;

   assign out = (en) ? in : {width{1'bz}};
   
endmodule // tristate

/**
 * A simple register.
 * 
 * @parameter width The width of the register in bits.
 * @parameter reset_value The value to reset the register to.
 * @output q The data output.
 * @input d The data input.
 * @input load Loads the register with the value on d.
 * @input clock A clock.
 * @input reset A posedge reset.
 */
module register(/*AUTOARG*/
   // Outputs
   q,
   // Inputs
   d, load, clock, reset
   );
   parameter
     width = 8,
     reset_value = 0;
   
   output reg [(width - 1):0] q;
   input [(width - 1):0]      d;
   input                      load;
   input                      clock, reset;

   always @(posedge clock or posedge reset) begin
      if (reset) begin
         q <= reset_value;
      end
      else if (load) begin
         q <= d;
      end
   end
   
endmodule // register

/**
 * A buffer.
 * 
 * I'm pretty sure this doesn't actually do anything more efficient than a
 * register with a mux on the input and output plus some tristate buffers.
 * 
 * @parameter width The width of the buffer in bits.
 * @parameter reset_value The value to set the buffer to on reset.
 * @inout bus_in An internal bus.
 * @inout bus_ext An external bus.
 * @input bus_in_read Reads data from the internal bus to the buffer.
 * @input bus_in_write Writes the data from the buffer to the internal bus.
 * @input bus_ext_read Reads data from the external bus to the buffer.
 * @input bus_ext_write Writes data from the buffer to the external bus.
 * @input clock The clock.
 * @input reset A posedge reset.
 */
module buffer(/*AUTOARG*/
   // Inouts
   bus_in, bus_ext,
   // Inputs
   bus_in_read, bus_in_write, bus_ext_read, bus_ext_write, clock,
   reset
   );
   parameter
     width = 8,
     reset_value = 0;

   inout [(width - 1):0] bus_in;
   inout [(width - 1):0] bus_ext;
   input                 bus_in_read, bus_in_write, bus_ext_read, bus_ext_write;
   input                 clock, reset;
   
   reg [(width - 1):0]   q;

   assign bus_in = (bus_in_write) ? q : {width{1'bz}};
   assign bus_ext = (bus_ext_write) ? q : {width{1'bz}};

   always @(posedge clock or posedge reset) begin
      if (reset) begin
         q <= reset_value;
      end
      else if (bus_in_read) begin
         q <= bus_in;
      end
      else if (bus_ext_read) begin
         q <= bus_ext;
      end
   end
   
endmodule // buffer

// Local Variables:
// verilog-library-directories:(".")
// End:
