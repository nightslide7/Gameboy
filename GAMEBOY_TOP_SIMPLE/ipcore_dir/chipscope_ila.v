///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2013 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.3
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : chipscope_ila.v
// /___/   /\     Timestamp  : Tue Dec 03 15:19:27 Eastern Standard Time 2013
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module chipscope_ila(
    CONTROL,
    CLK,
    TRIG0,
    TRIG1,
    TRIG2,
    TRIG3,
    TRIG4,
    TRIG5,
    TRIG6,
    TRIG7,
    TRIG8,
    TRIG9,
    TRIG10,
    TRIG11,
    TRIG12,
    TRIG13,
    TRIG14,
    TRIG15) /* synthesis syn_black_box syn_noprune=1 */;


inout [35 : 0] CONTROL;
input CLK;
input [15 : 0] TRIG0;
input [79 : 0] TRIG1;
input [7 : 0] TRIG2;
input [15 : 0] TRIG3;
input [7 : 0] TRIG4;
input [8 : 0] TRIG5;
input [7 : 0] TRIG6;
input [7 : 0] TRIG7;
input [1 : 0] TRIG8;
input [31 : 0] TRIG9;
input [31 : 0] TRIG10;
input [31 : 0] TRIG11;
input [39 : 0] TRIG12;
input [39 : 0] TRIG13;
input [39 : 0] TRIG14;
input [127 : 0] TRIG15;

endmodule
