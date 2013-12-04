// A module to rename busses
module professor_farnsworth(argh, argh);
  parameter
    width = 8;

   inout [width-1:0] argh;
   wire [width-1:0]  argh;
   
endmodule

module cartridge (output wire HDR1_2, HDR1_6, HDR1_8, HDR1_10, HDR1_60, HDR1_64,
                  output wire  HDR1_12, HDR1_14, HDR1_16, HDR1_18,
                  output wire  HDR1_20, HDR1_22, HDR1_24, HDR1_26,
                  output wire  HDR1_28, HDR1_30, HDR1_32, HDR1_34,
                  output wire  HDR1_36, HDR1_38, HDR1_40, HDR1_42,
                  inout        HDR1_44, HDR1_46, HDR1_48, HDR1_50,
                  inout        HDR1_52, HDR1_54, HDR1_56, HDR1_58,
                  input [15:0] cart_address,
                  inout [7:0]  cart_data,
                  input        clock,
                  input        cart_w_enable_l,
		  input        cart_r_enable_l,
		  input        cart_reset_l,
		  input        cart_cs_sram_l
                  );
                  

/*module cartridge (output wire      HDR1_2, HDR1_6, HDR1_8, HDR1_10,
                  output wire      HDR1_12, HDR1_14, HDR1_16, HDR1_18,
                  output wire      HDR1_20, HDR1_22, HDR1_24, HDR1_26,
                  output wire      HDR1_28, HDR1_30, HDR1_32, HDR1_34,
                  output wire      HDR1_36, HDR1_38, HDR1_40, HDR1_42,
                  input            HDR1_44, HDR1_46, HDR1_48, HDR1_50,
                  input            HDR1_52, HDR1_54, HDR1_56, HDR1_58,
                  output wire      HDR1_60, HDR1_64,
		  input [15:0]     cart_address,
		  output [7:0]     cart_data,
		  input            clock,
		  input            cart_w_enable_l,
		  input            cart_r_enable_l,
		  input            cart_reset_l,
		  input            cart_cs_sram_l);*/

   wire                      vdd;
   wire                      gnd;

   assign HDR1_2 = vdd;
   assign HDR1_6 = cart_w_enable_l;
   assign HDR1_8 = cart_r_enable_l;
   assign HDR1_10 = cart_cs_sram_l;
   assign HDR1_60 = cart_reset_l;
   assign HDR1_64 = gnd;
                  
   assign HDR1_12 = cart_address[0];
   assign HDR1_14 = cart_address[1];
   assign HDR1_16 = cart_address[2];
   assign HDR1_18 = cart_address[3];
   assign HDR1_20 = cart_address[4];
   assign HDR1_22 = cart_address[5];
   assign HDR1_24 = cart_address[6];
   assign HDR1_26 = cart_address[7];
   assign HDR1_28 = cart_address[8];
   assign HDR1_30 = cart_address[9];
   assign HDR1_32 = cart_address[10];
   assign HDR1_34 = cart_address[11];
   assign HDR1_36 = cart_address[12];
   assign HDR1_38 = cart_address[13];
   assign HDR1_40 = cart_address[14];
   assign HDR1_42 = cart_address[15];


/*   
   professor_farnsworth #(8)
   yes_that_one ({HDR1_58, HDR1_56, HDR1_54, HDR1_52, HDR1_50, HDR1_48,
                HDR1_46, HDR1_44},
            cart_data[7:0]);*/
   
/*   assign cart_data[0] = HDR1_44;
   assign cart_data[1] = HDR1_46;
   assign cart_data[2] = HDR1_48;
   assign cart_data[3] = HDR1_50;
   assign cart_data[4] = HDR1_52;
   assign cart_data[5] = HDR1_54;
   assign cart_data[6] = HDR1_56;
   assign cart_data[7] = HDR1_58;*/

   assign vdd = 1;
   assign gnd = 0;

/*   always@ (posedge clock) begin
      cart_data[7:0] <= cart_data[7:0];
   end*/
endmodule


