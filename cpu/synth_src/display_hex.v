module display_hex(/*AUTOARG*/
   // Outputs
   lcd_dataIn, lcd_writeStart, display_hex_done,
   // Inputs
   display_hex_data_in, display_hex_start, clock, reset, lcd_initDone,
   lcd_writeDone
   );
   // LCD controller outputs
   output reg [7:0] lcd_dataIn; // ASCII value going to the LCD controller
   output reg       lcd_writeStart; // Assert to write to the LCD controller

   // User output
   output reg       display_hex_done; // Asserted when this module finishes

   // User input
   input [3:0]      display_hex_data_in; // Number input
   input            display_hex_start; // Start when asserted
   input            clock, reset;
   
   // LCD controller input
   input            lcd_initDone; // Asserted when the LCD controller is started
   input            lcd_writeDone; // Asserted when the LCD controller writes
   
   wire [7:0]       data_ascii;

   // Get the ascii value for the LCD controller
   decode_ascii_hex ascii_decode(.ascii(data_ascii),
                                 .n(display_hex_data_in));

`define idle 2'd0
`define data0 2'd1
`define wait0 2'd2

   reg [1:0]        state, next_state;

   always @(*) begin
      lcd_dataIn = 8'd0;
      lcd_writeStart = 1'b0;
      display_hex_done = 1'b0;
      case (state)
        `idle: begin
           if (~lcd_initDone || ~display_hex_start) begin
              next_state = `idle;
           end else begin
              next_state = `data0;
           end
        end
        `data0: begin
           lcd_dataIn = data_ascii;
           lcd_writeStart = 1'b1;
           next_state = `wait0;
        end
        `wait0: begin
           lcd_dataIn = data_ascii;
           if (~lcd_writeDone) begin
              next_state = `wait0;              
           end else begin
              next_state = `idle;
              display_hex_done = 1'b1;
           end
        end
        default: begin
           next_state = `idle;
        end
      endcase
   end
   
   always @(posedge clock, posedge reset) begin
      if (reset) begin
         state <= `idle;
      end else begin
         state <= next_state;
      end
   end
   
endmodule // simple_display

module decode_ascii_hex(/*AUTOARG*/
   // Outputs
   ascii,
   // Inputs
   n
   );
   output reg [7:0] ascii;
   input [3:0]      n;

   always @(*) begin
      case (n)
        4'h0: ascii = 8'h30;
        4'h1: ascii = 8'h31;
        4'h2: ascii = 8'h32;
        4'h3: ascii = 8'h33;
        4'h4: ascii = 8'h34;
        4'h5: ascii = 8'h35;
        4'h6: ascii = 8'h36;
        4'h7: ascii = 8'h37;
        4'h8: ascii = 8'h38;
        4'h9: ascii = 8'h39;
        4'ha: ascii = 8'h61;
        4'hb: ascii = 8'h62;
        4'hc: ascii = 8'h63;
        4'hd: ascii = 8'h64;
        4'he: ascii = 8'h65;
        4'hf: ascii = 8'h66;
        default: ascii = 8'h26; // &
      endcase
   end
endmodule // decode_hex
