/**
 * Definition of useful constants for the GB80 CPU.
 * 
 * @author Joseph Carlos (jcarlos)
 */

/**
 * ALU operations
 */
`define ALU_ADD 5'd0
`define ALU_ADC 5'd1
`define ALU_SUB 5'd2
`define ALU_SBC 5'd3
`define ALU_AND 5'd4
`define ALU_OR 5'd5
`define ALU_XOR 5'd6
`define ALU_DEC 5'd7
`define ALU_INC 5'd8
`define ALU_DAA 5'd9
`define ALU_NOT 5'd10
`define ALU_CCF 5'd11
`define ALU_SCF 5'd12
`define ALU_RLC 5'd13
`define ALU_RL 5'd14
`define ALU_RRC 5'd15
`define ALU_RR 5'd16
`define ALU_SL 5'd17
`define ALU_SRA 5'd18
`define ALU_SRL 5'd19
`define ALU_PASS0 5'd20

/**
 * ALU size select
 */
`define ALU_SIZE_8 1'd0
`define ALU_SIZE_16 1'd1

/**
 * ALU flag indices
 */
`define F_Z 3
`define F_N 2
`define F_H 1
`define F_C 0

/**
 * Regfile select
 */
`define RGF_B 5'b01_000
`define RGF_C 5'b00_000
`define RGF_D 5'b01_001
`define RGF_E 5'b00_001
`define RGF_H 5'b01_010
`define RGF_L 5'b00_010
`define RGF_SPH 5'b01_011
`define RGF_SPL 5'b00_011
`define RGF_PCH 5'b01_100
`define RGF_PCL 5'b00_100
`define RGF_BC 5'b10_000
`define RGF_DE 5'b10_001
`define RGF_HL 5'b10_010
`define RGF_SP 5'b10_011
`define RGF_PC 5'b10_100
`define RGF_NONE 5'b11_111

/**
 * Nintendo register numbers - used in opcodes
 */
`define NIN_A 3'b111
`define NIN_B 3'b000
`define NIN_C 3'b001
`define NIN_D 3'b010
`define NIN_E 3'b011
`define NIN_H 3'b100
`define NIN_L 3'b101
`define NIN_BC 3'b000
`define NIN_DE 3'b001
`define NIN_HL 3'b010
`define NIN_SP 3'b011

