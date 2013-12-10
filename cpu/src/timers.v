`include "cpu.vh"

/**
 * The timer module for the GB80 CPU.
 * 
 * Author: Joseph Carlos (jdcarlos1@gmail.com)
 */

module timers(/*AUTOARG*/
   // Outputs
   timer_interrupt,
   // Inouts
   addr_ext, data_ext,
   // Inputs
   mem_re, mem_we, clock, reset
   );

   inout [15:0] addr_ext;
   inout [7:0]  data_ext;

   output wire  timer_interrupt;
   
   input        mem_re, mem_we;
   input        clock, reset;
   
   // 00: 4.096 kHz (CPU / 1024) 4096 = 2**10
   // 01: 262.144 kHz (CPU / 16) 16 = 2**4
   // 10: 65.536 kHz (CPU / 64) 64 = 2**6
   // 11: 16.384 kHz (CPU / 256) 256 = 2**8
   wire [9:0]   counter_data;
   wire [7:0]   TMA_data, TIMA_data, DIV_data, DIV_LO_data;
   wire [2:0]   TAC_data;
   reg          TIMA_inc, TIMA_ce;
   
   // Writing, reading to the registers from the bus
   wire          DIV_write, DIV_read, TIMA_write, TIMA_read;
   wire          TAC_write, TAC_read, TMA_write, TMA_read;

   assign DIV_write = (mem_we) ? (addr_ext == `MMIO_DIV) : 1'b0;
   assign TIMA_write = (mem_we) ? (addr_ext == `MMIO_TIMA) : 1'b0;
   assign TAC_write = (mem_we) ? (addr_ext == `MMIO_TAC) : 1'b0;
   assign TMA_write = (mem_we) ? (addr_ext == `MMIO_TMA) : 1'b0;

   assign DIV_read = (mem_re) ? (addr_ext == `MMIO_DIV) : 1'b0;
   assign TIMA_read = (mem_re) ? (addr_ext == `MMIO_TIMA) : 1'b0;
   assign TAC_read = (mem_re) ? (addr_ext == `MMIO_TAC) : 1'b0;
   assign TMA_read = (mem_re) ? (addr_ext == `MMIO_TMA) : 1'b0;

   tristate #(8) DIV_tri(.out(data_ext[7:0]),
                         .in(DIV_data[7:0]),
                         .en(DIV_read));
   tristate #(8) TIMA_tri(.out(data_ext[7:0]),
                          .in(TIMA_data[7:0]),
                          .en(TIMA_read));
   tristate #(8) TAC_tri(.out(data_ext[7:0]),
                         .in({5'd0, TAC_data}),
                         .en(TAC_read));
   tristate #(8) TMA_tri(.out(data_ext[7:0]),
                         .in(TMA_data[7:0]),
                         .en(TMA_read));

   always @(*) begin
      case (TAC_data[1:0])
        2'b00: TIMA_ce = counter_data[9];
        2'b01: TIMA_ce = counter_data[3];
        2'b10: TIMA_ce = counter_data[5];
        2'b11: TIMA_ce = counter_data[7];
      endcase
   end
   
   reg           timas, next_timas;

`define TIMA_CE_0 1'b0
`define TIMA_CE_1 1'b1

   always @(*) begin
      next_timas = timas;
      TIMA_inc = 1'b0;
      case (timas)
        `TIMA_CE_0: begin
           if (TIMA_ce) begin
              next_timas = `TIMA_CE_1;
              TIMA_inc = 1'b1;
           end
        end
        `TIMA_CE_1: begin
           if (~TIMA_ce) begin
              next_timas = `TIMA_CE_0;
           end
        end
      endcase
   end

   always @(posedge clock or posedge reset) begin
      if (reset) begin
         timas <= `TIMA_CE_0;
      end else begin
         timas <= next_timas;
      end
   end
   
   register #(10, 0) TIMA_counter(.q(counter_data),
                                  .d(counter_data + 10'd1),
                                  .load(TAC_data[2]),
                                  .reset(reset),
                                  .clock(clock));

   wire [8:0] DIV_LO_sum;
   assign DIV_LO_sum = {1'b0, DIV_LO_data} + 9'b1;
   
   register #(8, 0) DIV_LO(.q(DIV_LO_data),
                           .d(DIV_LO_sum[7:0]),
                           .load(1'b1),
                           .reset(reset),
                           .clock(clock));
   
   register #(8, 0) DIV(.q(DIV_data),
                        .d(DIV_data + {7'b0, DIV_LO_sum[8]}),
                        .load(1'b1),
                        .reset(reset | DIV_write),
                        .clock(clock));

   register #(3, 0) TAC(.q(TAC_data),
                        .d(data_ext[2:0]),
                        .load(TAC_write),
                        .reset(reset),
                        .clock(clock));

   register #(8) TMA(.q(TMA_data),
                     .d(data_ext),
                     .load(TMA_write),
                     .clock(clock),
                     .reset(reset));
                     
   register #(8) TIMA(.q(TIMA_data),
                      .d((TIMA_write) ? data_ext :
                         (TIMA_data == 8'hff) ? 
                         ((TMA_write) ? data_ext : TMA_data) :
                         TIMA_data + 8'd1),
                      .load(TIMA_write | (TIMA_inc & TAC_data[2])),
                      .reset(reset),
                      .clock(clock));

   assign timer_interrupt = (TIMA_data == 8'hff) & TIMA_inc;
   
endmodule // timers

// Local Variables:
// verilog-library-directories:(".")
// verilog-library-files:("./cpu.v")
// End:
