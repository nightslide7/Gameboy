/*
 This file is part of DMGBoy.
 
 DMGBoy is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 DMGBoy is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with DMGBoy.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <iostream>
#include <assert.h>
#include "GBException.h"
#include "Registers.h"
#include "Memory.h"
#include "Instructions.h"

using namespace std;

#define _8bitsInmValue (mem->MemR(reg->Get_PC() + 1))
#define _16bitsInmValue ((mem->MemR(reg->Get_PC() + 2)) << 8) | mem->MemR(reg->Get_PC() + 1)

Instructions::Instructions(Registers* reg, Memory* mem)
{
	this->reg = reg;
	this->mem = mem;
}

Instructions::~Instructions(void)
{
}

void Instructions::NOP(){reg->Add_PC(1);}

void Instructions::LD_r1_r2(e_registers e_reg1, e_registers e_reg2)
{
	BYTE length = 1;

	if (e_reg1 == c_HL)
	{
		if (e_reg2 == $)
		{
			mem->MemW(reg->Get_HL(), _8bitsInmValue);
			length = 2;
		}
		else
			mem->MemW(reg->Get_HL(), (BYTE)reg->Get_Reg(e_reg2));
	}
	else
	{
		if (e_reg2 == c_HL)
		{
			reg->Set_Reg(e_reg1, mem->MemR(reg->Get_HL()));
		}
		else
		{
			reg->Set_Reg(e_reg1, reg->Get_Reg(e_reg2));
		}
	}

	reg->Add_PC(length);
}


void Instructions::LD_A_n(e_registers place)
{
    int address, value, length = 1;

	switch(place)
	{
		case $:
			value = _8bitsInmValue;
			length = 2;
			break;
		case c_$$:
			address = _16bitsInmValue;
			value = mem->MemR(address);
			length = 3;
			break;
		case c_BC:
			value = mem->MemR(reg->Get_BC());
			break;
		case c_DE:
			value = mem->MemR(reg->Get_DE());
			break;
		case c_HL:
			value = mem->MemR(reg->Get_HL());
			break;
		default:
			value = reg->Get_Reg(place);
	}

	reg->Set_A(value);

    reg->Add_PC(length);
}


void Instructions::LD_n_A(e_registers place)
{
    int address, length = 1;

	switch (place)
	{
		case c_$$:
			address = _16bitsInmValue;
			mem->MemW(address, reg->Get_A());
			length = 3;
			break;
		case c_BC:
			mem->MemW(reg->Get_BC(), reg->Get_A());
			break;
		case c_DE:
			mem->MemW(reg->Get_DE(), reg->Get_A());
			break;
		case c_HL:
			mem->MemW(reg->Get_HL(), reg->Get_A());
			break;
		default:
			reg->Set_Reg(place, reg->Get_A());
	}

	reg->Add_PC(length);
}

void Instructions::JP_nn()
{
	reg->Set_PC(_16bitsInmValue);
}

void Instructions::LDH_A_n()
{
	reg->Set_A(mem->MemR(0xFF00 + _8bitsInmValue));
	reg->Add_PC(2);
}

void Instructions::LDH_c$_A()
{
	mem->MemW(0xFF00 + _8bitsInmValue, reg->Get_A());
	reg->Add_PC(2);
}

void Instructions::CCF()
{
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(!reg->Get_flagC());
	reg->Add_PC(1);
}

void Instructions::CP_n(e_registers place)
{
	BYTE value;
	BYTE length = 1;

	switch (place)
	{
		case $:
			value = _8bitsInmValue;
			length = 2;
			break;
		case c_HL:
			value = mem->MemR(reg->Get_HL());
			break;
		default:
			value = (BYTE)reg->Get_Reg(place);
	}

	reg->Set_flagZ((reg->Get_A() == value) ? 1 : 0);
	reg->Set_flagN(1);
	reg->Set_flagH(((reg->Get_A() & 0x0F) < (value & 0x0F)) ? 1 : 0);
	reg->Set_flagC((reg->Get_A() < value) ? 1 : 0);

	reg->Add_PC(length);
}

void Instructions::CPL()
{
	reg->Set_A(~reg->Get_A());

	reg->Set_flagN(1);
	reg->Set_flagH(1);

	reg->Add_PC(1);
}

void Instructions::LD_n_nn(e_registers place)
{
	assert((place == BC) || (place == DE) || (place == HL) || (place == SP));
	reg->Set_Reg(place, _16bitsInmValue);
    reg->Add_PC(3);
}

void Instructions::LD_nn_SP()
{
	WORD destAddress = _16bitsInmValue;
	mem->MemW(destAddress, reg->Get_SP() & 0x00FF);
	mem->MemW(destAddress + 1, reg->Get_SP() >> 8);
    reg->Add_PC(3);
}

void Instructions::JR()
{
    char address;	//Con signo

	address = _8bitsInmValue;

	//El "2 +" es porque antes de saltar ha tenido que ver cuales eran los dos opcodes de la instruccion
	//y tiene importancia al ser un salto relativo con respecto al actual PC.
    reg->Add_PC(2 + address);
}

void Instructions::JR_CC_n(e_registers flag, BYTE value2check)
{
	if (reg->Get_Flag(flag) == value2check)
    {
		JR();
        reg->Set_ConditionalTaken(true);
    }
	else
		reg->Add_PC(2);
}

void Instructions::CALL_nn()
{
	reg->Add_SP(-1);
	mem->MemW(reg->Get_SP(),((reg->Get_PC() + 3) & 0xFF00) >> 8);
	reg->Add_SP(-1);
	mem->MemW(reg->Get_SP(),(reg->Get_PC() + 3) & 0x00FF);
	reg->Set_PC(_16bitsInmValue);
}

void Instructions::CALL_cc_nn(e_registers flag, BYTE value2check)
{
	if (reg->Get_Flag(flag) == value2check)
    {
		CALL_nn();
        reg->Set_ConditionalTaken(true);
    }
	else
		reg->Add_PC(3);
}

void Instructions::LDI_A_cHL()
{
	reg->Set_A(mem->MemR(reg->Get_HL()));
	reg->Set_HL(reg->Get_HL() + 1);
	reg->Add_PC(1);
}

void Instructions::LDI_cHL_A()
{
	mem->MemW(reg->Get_HL(), reg->Get_A());
	reg->Set_HL(reg->Get_HL() + 1);
	reg->Add_PC(1);
}

void Instructions::LDD_A_cHL()
{
	reg->Set_A(mem->MemR(reg->Get_HL()));
	reg->Set_HL(reg->Get_HL() - 1);
	reg->Add_PC(1);
}

void Instructions::LDD_cHL_A()
{
	mem->MemW(reg->Get_HL(), reg->Get_A());
	reg->Set_HL(reg->Get_HL() - 1);
	reg->Add_PC(1);
}

void Instructions::LD_SP_HL()
{
	reg->Set_SP(reg->Get_HL());

	reg->Add_PC(1);
}

void Instructions::SUB_n(e_registers place)
{
	int value, length = 1;

	if (place == c_HL)
		value = mem->MemR(reg->Get_HL());
	else if (place == $)
	{
		value = _8bitsInmValue;
		length = 2;
	}
	else
		value = reg->Get_Reg(place);

	reg->Set_flagZ((reg->Get_A() - value) ? 0 : 1);
	reg->Set_flagN(1);
	reg->Set_flagH(((reg->Get_A() & 0x0F) < (value & 0x0F)) ? 1 : 0);
	reg->Set_flagC((reg->Get_A() < value) ? 1 : 0);

	reg->Set_A(reg->Get_A() - value);

	reg->Add_PC(length);
}

void Instructions::ADD_A_n(e_registers place)
{
	int value, length = 1;
	BYTE valueReg;

	switch (place)
	{
		case $:		valueReg = _8bitsInmValue; length = 2; break;
		case c_HL:	valueReg = mem->MemR(reg->Get_HL()); break;
		default:	valueReg = (BYTE)reg->Get_Reg(place); break;
	}

	value = reg->Get_A() + valueReg;

	reg->Set_flagZ(!(value & 0xFF) ? 1 : 0);
	if (((reg->Get_A() & 0x0F) + (valueReg & 0x0F)) > 0x0F) reg->Set_flagH(1); else reg->Set_flagH(0);
	reg->Set_flagN(0);
	reg->Set_flagC((value > 0xFF) ? 1 : 0);

	reg->Set_A(value & 0xFF);

	reg->Add_PC(length);
}

void Instructions::ADC_A_n(e_registers lugar)
{
	int value, length = 1;
	BYTE valueReg;

	switch (lugar)
	{
		case $:		valueReg = _8bitsInmValue; length = 2; break;
		case c_HL:	valueReg = mem->MemR(reg->Get_HL()); break;
		default:	valueReg = (BYTE)reg->Get_Reg(lugar); break;
	}

	value = reg->Get_flagC() + valueReg + reg->Get_A();

	reg->Set_flagZ(!(value & 0xFF) ? 1 : 0);
	reg->Set_flagN(0);
	if ((reg->Get_flagC() + (valueReg & 0x0F) + (reg->Get_A() & 0x0F)) > 0x0F)
		reg->Set_flagH(1);
	else
		reg->Set_flagH(0);
	reg->Set_flagC((value > 0xFF) ? 1 : 0);

	reg->Set_A(value & 0xFF);

	reg->Add_PC(length);
}

void Instructions::INC_n(e_registers place)
{
	BYTE value;

	if (place == c_HL)
	{
		value = mem->MemR(reg->Get_HL()) + 1;
		mem->MemW(reg->Get_HL(), value);
	}
	else
	{
		value = reg->Get_Reg(place) + 1;
		reg->Set_Reg(place, value);
	}
	reg->Set_flagZ(value ? 0 : 1);
	reg->Set_flagN(0);
	reg->Set_flagH((value & 0x0F) ? 0 : 1);

	reg->Add_PC(1);
}

void Instructions::ADD_HL_n(e_registers place)
{
	WORD value, hl;
	
	value = reg->Get_Reg(place);
	hl = reg->Get_HL();
	
	reg->Set_flagN(0);
	reg->Set_flagH((((hl & 0x0FFF) + (value & 0x0FFF)) > 0x0FFF) ? 1 : 0);
	reg->Set_flagC(((hl + value) > 0xFFFF) ? 1 : 0);
	
	reg->Set_HL(hl + value);
	
	reg->Add_PC(1);
}

void Instructions::RLC_n(e_registers place)
{
	BYTE bit7, value;

	if (place == c_HL)
	{
		value = mem->MemR(reg->Get_HL());
		bit7 = BIT7(value) >> 7;
		value = (value << 1) | bit7;
		mem->MemW(reg->Get_HL(), value);
	}
	else
	{
		value = (BYTE)reg->Get_Reg(place);
		bit7 = BIT7(value) >> 7;
		value = (value << 1) | bit7;
		reg->Set_Reg(place, value);
	}

	reg->Set_flagZ(0);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(bit7);

    if (mem->MemR(reg->Get_PC()) == 0xCB)
    {
        reg->Set_flagZ(value ? 0 : 1);
		reg->Add_PC(2);
    }
	else
		reg->Add_PC(1);
}

void Instructions::INC_nn(e_registers lugar)
{
	reg->Set_Reg(lugar, reg->Get_Reg(lugar) + 1);
	reg->Add_PC(1);
}

void Instructions::DAA()
{
	/*
	 http://www.emutalk.net/showthread.php?t=41525&page=108
	 
	 Detailed info DAA
	 Instruction Format:
	 OPCODE                    CYCLES
	 --------------------------------
	 27h                       4
	 
	 
	 Description:
	 This instruction conditionally adjusts the accumulator for BCD addition
	 and subtraction operations. For addition (ADD, ADC, INC) or subtraction
	 (SUB, SBC, DEC, NEC), the following table indicates the operation performed:
	 
	 --------------------------------------------------------------------------------
	 |           | C Flag  | HEX value in | H Flag | HEX value in | Number  | C flag|
	 | Operation | Before  | upper digit  | Before | lower digit  | added   | After |
	 |           | DAA     | (bit 7-4)    | DAA    | (bit 3-0)    | to byte | DAA   |
	 |------------------------------------------------------------------------------|
	 |           |    0    |     0-9      |   0    |     0-9      |   00    |   0   |
	 |   ADD     |    0    |     0-8      |   0    |     A-F      |   06    |   0   |
	 |           |    0    |     0-9      |   1    |     0-3      |   06    |   0   |
	 |   ADC     |    0    |     A-F      |   0    |     0-9      |   60    |   1   |
	 |           |    0    |     9-F      |   0    |     A-F      |   66    |   1   |
	 |   INC     |    0    |     A-F      |   1    |     0-3      |   66    |   1   |
	 |           |    1    |     0-2      |   0    |     0-9      |   60    |   1   |
	 |           |    1    |     0-2      |   0    |     A-F      |   66    |   1   |
	 |           |    1    |     0-3      |   1    |     0-3      |   66    |   1   |
	 |------------------------------------------------------------------------------|
	 |   SUB     |    0    |     0-9      |   0    |     0-9      |   00    |   0   |
	 |   SBC     |    0    |     0-8      |   1    |     6-F      |   FA    |   0   |
	 |   DEC     |    1    |     7-F      |   0    |     0-9      |   A0    |   1   |
	 |   NEG     |    1    |     6-F      |   1    |     6-F      |   9A    |   1   |
	 |------------------------------------------------------------------------------|
	 
	 
	 Flags:
	 C:   See instruction.
	 N:   Unaffected.
	 P/V: Set if Acc. is even parity after operation, reset otherwise.
	 H:   See instruction.
	 Z:   Set if Acc. is Zero after operation, reset otherwise.
	 S:   Set if most significant bit of Acc. is 1 after operation, reset otherwise.
	 
	 Example:
	 
	 If an addition operation is performed between 15 (BCD) and 27 (BCD), simple decimal
	 arithmetic gives this result:
	 
	 15
	 +27
	 ----
	 42
	 
	 But when the binary representations are added in the Accumulator according to
	 standard binary arithmetic:
	 
	 0001 0101  15
	 +0010 0111  27
	 ---------------
	 0011 1100  3C
	 
	 The sum is ambiguous. The DAA instruction adjusts this result so that correct
	 BCD representation is obtained:
	 
	 0011 1100  3C result
	 +0000 0110  06 +error
	 ---------------
	 0100 0010  42 Correct BCD!
	*/
    
    int a = reg->Get_A();
    
    if (reg->Get_flagN() == 0)
    {
        if (reg->Get_flagH() || ((a & 0xF) > 9))
            a += 0x06;
        
        if (reg->Get_flagC() || (a > 0x9F))
            a += 0x60;
    }
    else
    {
        if (reg->Get_flagH())
            a = (a - 6) & 0xFF;
        
        if (reg->Get_flagC())
            a -= 0x60;
    }
    
    reg->Set_flagH(0);
    reg->Set_flagZ(0);
    
    if ((a & 0x100) == 0x100)
        reg->Set_flagC(1);
    
    a &= 0xFF;
    
    if (a == 0)
        reg->Set_flagZ(1);
    
    reg->Set_A(a);
    
    reg->Add_PC(1);
}

void Instructions::DEC_n(e_registers place)
{
	BYTE value;

	if (place == c_HL)
	{
		value = mem->MemR(reg->Get_HL()) - 1;
		mem->MemW(reg->Get_HL(), value);
	}
	else
	{
		value = reg->Get_Reg(place) - 1;
		reg->Set_Reg(place, value);
	}
	
	reg->Set_flagZ(!value ? 1 : 0);
	reg->Set_flagN(1);
	reg->Set_flagH(((value & 0x0F) == 0x0F) ? 1 : 0);

	reg->Add_PC(1);
}

void Instructions::DEC_nn(e_registers lugar)
{
	reg->Set_Reg(lugar, reg->Get_Reg(lugar) - 1);
	reg->Add_PC(1);
}

void Instructions::OR_n(e_registers lugar)
{
	BYTE longitud = 1;
    BYTE value;

	switch (lugar)
	{
		case $:
			value = reg->Get_A() | _8bitsInmValue;
			longitud = 2;
			break;
		case c_HL:
			value = reg->Get_A() | mem->MemR(reg->Get_HL());
			break;
		default:
			value = reg->Get_A() | reg->Get_Reg(lugar);
	}

    reg->Set_A(value);

	reg->Set_flagZ(value ? 0 : 1);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(0);

	reg->Add_PC(longitud);
}

void Instructions::XOR_n(e_registers lugar)
{
    BYTE longitud = 1;
    BYTE value;

	switch (lugar)
	{
		case $:
			value = reg->Get_A() ^ _8bitsInmValue;
			longitud = 2;
			break;
		case c_HL:
			value = reg->Get_A() ^ mem->MemR(reg->Get_HL());
			break;
		default:
			value = reg->Get_A() ^ reg->Get_Reg(lugar);
	}
    
    reg->Set_A(value);

	reg->Set_flagZ(value ? 0 : 1);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(0);

	reg->Add_PC(longitud);
}

void Instructions::RET()
{
	reg->Set_PC((mem->MemR(reg->Get_SP() + 1) << 8) | mem->MemR(reg->Get_SP()));
	reg->Add_SP(2);
}

void Instructions::RETI()
{
	EI();
	RET();
}

void Instructions::RET_cc(e_registers flag, BYTE value2check)
{
	reg->Add_PC(1);
	if (reg->Get_Flag(flag) == value2check)
    {
		RET();
        reg->Set_ConditionalTaken(true);
    }
}

void Instructions::LD_nn_n(e_registers lugar)
{
	reg->Set_Reg(lugar, _8bitsInmValue);
	reg->Add_PC(2);
}

void Instructions::LD_A_cC()
{
	reg->Set_A(mem->MemR(0xFF00 + reg->Get_C()));
	reg->Add_PC(1);
}

void Instructions::LD_cC_A()
{
	mem->MemW(0xFF00 + reg->Get_C(), reg->Get_A());
	reg->Add_PC(1);
}

void Instructions::SET_b_r(BYTE bit, e_registers place)
{
	if (place == c_HL)
		mem->MemW(reg->Get_HL(), mem->MemR(reg->Get_HL()) | (1 << bit));
	else
		reg->Set_Reg(place, reg->Get_Reg(place) | (1 << bit));

	reg->Add_PC(2);
}

void Instructions::BIT_b_r(BYTE bit, e_registers lugar)
{
	BYTE value;

	if (lugar == c_HL)
		value = mem->MemR(reg->Get_HL());
	else
		value = (BYTE)reg->Get_Reg(lugar);

	if (!(value & (1 << bit)))
		reg->Set_flagZ(1);
	else
		reg->Set_flagZ(0);

	reg->Set_flagN(0);
	reg->Set_flagH(1);

	reg->Add_PC(2);
}

void Instructions::RES_b_r(BYTE bit, e_registers lugar)
{
    if (lugar == c_HL)
		mem->MemW(reg->Get_HL(), mem->MemR(reg->Get_HL()) & ~(1 << bit));
	else
		reg->Set_Reg(lugar, reg->Get_Reg(lugar) & ~(1 << bit));

	reg->Add_PC(2);
}

void Instructions::DI()
{
	reg->Set_IME(0);
	reg->Add_PC(1);
}

void Instructions::EI()
{
	reg->Set_IME(1);
	reg->Add_PC(1);
}

void Instructions::SBC_A(e_registers place)
{
	WORD value;
    BYTE result;
    int sum;
	int length = 1;

	switch(place)
	{
		case c_HL:
            value = mem->MemR(reg->Get_HL());
            sum = value + reg->Get_flagC();
			break;
		case $:
            value = _8bitsInmValue;
            sum = value + reg->Get_flagC();
			length = 2;
			break;
		default:
            value = reg->Get_Reg(place);
			sum = value + reg->Get_flagC();
	}
    result = reg->Get_A() - sum;
    
	reg->Set_flagZ(!result);
	reg->Set_flagN(1);
    
    if ((reg->Get_A() & 0x0F) < (value & 0x0F))
        reg->Set_flagH(true);
    else if ((reg->Get_A() & 0x0F) < (sum & 0x0F))
        reg->Set_flagH(true);
    else if (((reg->Get_A() & 0x0F)==(value & 0x0F)) && ((value & 0x0F)==0x0F) && (reg->Get_flagC()))
        reg->Set_flagH(true);
    else
        reg->Set_flagH(false);
    
    reg->Set_flagC(reg->Get_A() < sum);

	reg->Set_A(result);

	reg->Add_PC(length);
}

void Instructions::AND(e_registers lugar)
{
	BYTE longitud = 1;

	switch (lugar)
	{
		case $:
			reg->Set_A(reg->Get_A() & _8bitsInmValue);
			longitud = 2;
			break;
		case c_HL:
			reg->Set_A(reg->Get_A() & mem->MemR(reg->Get_HL()));
			break;
		default:
			reg->Set_A(reg->Get_A() & reg->Get_Reg(lugar));
	}

	reg->Set_flagZ(reg->Get_A() ? 0 : 1);
	reg->Set_flagN(0);
	reg->Set_flagH(1);
	reg->Set_flagC(0);

	reg->Add_PC(longitud);
}


void Instructions::SLA_n(e_registers place)
{
	BYTE bit7, value;

	if (place == c_HL)
	{
		bit7 = BIT7(mem->MemR(reg->Get_HL())) >> 7;
		value = mem->MemR(reg->Get_HL()) << 1;
		mem->MemW(reg->Get_HL(), value);
	}
	else
	{
		bit7 = BIT7(reg->Get_Reg(place)) >> 7;
		value = reg->Get_Reg(place) << 1;
		reg->Set_Reg(place, value);
	}

	reg->Set_flagZ(!value ? 1 : 0);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(bit7);

	reg->Add_PC(2);
}

void Instructions::SRA_n(e_registers lugar)
{
    BYTE bit0, bit7, value;

	if (lugar == c_HL)
	{
		bit0 = BIT0(mem->MemR(reg->Get_HL()));
		bit7 = BIT7(mem->MemR(reg->Get_HL()));
		mem->MemW(reg->Get_HL(), bit7 | (mem->MemR(reg->Get_HL()) >> 1));
		value = mem->MemR(reg->Get_HL());
	}
	else
	{
		bit0 = BIT0(reg->Get_Reg(lugar));
		bit7 = BIT7(reg->Get_Reg(lugar));
		reg->Set_Reg(lugar, bit7 | (reg->Get_Reg(lugar) >> 1));
		value = (BYTE)reg->Get_Reg(lugar);
	}

	reg->Set_flagZ(!value ? 1 : 0);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(bit0);

	reg->Add_PC(2);
}

void Instructions::SRL_n(e_registers place)
{
    BYTE bit0, value;

	if (place == c_HL)
	{
		bit0 = BIT0(mem->MemR(reg->Get_HL()));
		value = mem->MemR(reg->Get_HL()) >> 1;
		mem->MemW(reg->Get_HL(), value);
	}
	else
	{
		bit0 = BIT0(reg->Get_Reg(place));
		value = reg->Get_Reg(place) >> 1;
		reg->Set_Reg(place, value);
	}

	reg->Set_flagZ(!value ? 1 : 0);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(bit0);

	reg->Add_PC(2);
}

void Instructions::ADD_SP_n()
{
	char n = _8bitsInmValue;

	reg->Set_flagZ(0);
	reg->Set_flagN(0);

    reg->Set_flagH(((reg->Get_SP() & 0x0F) + (n & 0x0F)) > 0x0F);
    reg->Set_flagC(((reg->Get_SP() & 0xFF) + (n & 0xFF)) > 0xFF);

	reg->Add_SP(n);

	reg->Add_PC(2);
}

void Instructions::JP_HL()
{
	reg->Set_PC(reg->Get_HL());
}

void Instructions::SCF()
{
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(1);

	reg->Add_PC(1);
}

void Instructions::HALT()
{
	reg->Set_Halt(true);
	
	reg->Add_PC(1);

}

void Instructions::STOP()
{
    // En una gameboy real apagaria la pantalla si ha
    // transcurrido demasiado tiempo sin pulsar ningun
    // boton. Aqui no se va simular ese comportamiento
	//reg->Set_Stop(true);

	reg->Add_PC(2);
}

void Instructions::SWAP(e_registers place)
{
	BYTE value;

	if (place == c_HL)
	{
		value = mem->MemR(reg->Get_HL());
		value = ((value & 0x0F) << 4) | ((value & 0xF0) >> 4);
		mem->MemW(reg->Get_HL(), value);
	}
	else
	{
		value = (BYTE)reg->Get_Reg(place);
		value = ((value & 0x0F) << 4) | ((value & 0xF0) >> 4);
		reg->Set_Reg(place, value);
	}

	reg->Set_flagZ(value ? 0 : 1);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(0);

	reg->Add_PC(2);
}

void Instructions::PUSH_nn(e_registers lugar)
{
	reg->Add_SP(-1);
	mem->MemW(reg->Get_SP(), (reg->Get_Reg(lugar) & 0xFF00) >> 8);
	reg->Add_SP(-1);
	mem->MemW(reg->Get_SP(), reg->Get_Reg(lugar) & 0x00FF);

	reg->Add_PC(1);
}

void Instructions::POP_nn(e_registers lugar)
{
	reg->Set_Reg(lugar, (mem->MemR(reg->Get_SP() + 1) << 8) | mem->MemR(reg->Get_SP()));
	reg->Add_SP(2);

	reg->Add_PC(1);
}

void Instructions::JP_cc_nn(e_registers flag, BYTE value2check)
{
	WORD nn;

	nn = _16bitsInmValue;

	reg->Add_PC(3);

	if (reg->Get_Flag(flag) == value2check)
    {
		reg->Set_PC(nn);
        reg->Set_ConditionalTaken(true);
    }
}

void Instructions::RL_n(e_registers place)
{
	BYTE oldBit7, value;

	if (place == c_HL)
	{
		oldBit7 = BIT7(mem->MemR(reg->Get_HL())) >> 7;
		value = (mem->MemR(reg->Get_HL()) << 1) | reg->Get_flagC();
		mem->MemW(reg->Get_HL(), value);
	}
	else
	{
		oldBit7 = BIT7(reg->Get_Reg(place)) >> 7;
		value = (reg->Get_Reg(place) << 1) | reg->Get_flagC();
		reg->Set_Reg(place, value);
	}

	reg->Set_flagZ(0);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(oldBit7);

	if (mem->MemR(reg->Get_PC()) == 0xCB)
    {
        reg->Set_flagZ(value ? 0 : 1);
		reg->Add_PC(2);
    }
	else
		reg->Add_PC(1);
}

void Instructions::RR_n(e_registers place)
{
	BYTE bit0, value;

	if (place == c_HL)
	{
		value = mem->MemR(reg->Get_HL());
		bit0 = BIT0(value);
		value = (reg->Get_flagC() << 7) | (value >> 1);
		mem->MemW(reg->Get_HL(), value);
	}
	else
	{
		value = (BYTE)reg->Get_Reg(place);
		bit0 = BIT0(value);
		value = (reg->Get_flagC() << 7) | (value >> 1);
		reg->Set_Reg(place, value);
	}

	reg->Set_flagZ(0);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(bit0);

	if (mem->MemR(reg->Get_PC()) == 0xCB)
    {
        reg->Set_flagZ(value ? 0 : 1);
		reg->Add_PC(2);
    }
	else
		reg->Add_PC(1);
}

void Instructions::RRC_n(e_registers place)
{
	BYTE bit0, value;

	if (place == c_HL)
	{
		value = mem->MemR(reg->Get_HL());
		bit0 = BIT0(value);
		value = (bit0 << 7) | (value >> 1);
		mem->MemW(reg->Get_HL(), value);
	}
	else
	{
		value = (BYTE)reg->Get_Reg(place);
		bit0 = BIT0(value);
		value = (bit0 << 7) | (value >> 1);
		reg->Set_Reg(place, value);
	}

	reg->Set_flagZ(0);
	reg->Set_flagN(0);
	reg->Set_flagH(0);
	reg->Set_flagC(bit0);

	if (mem->MemR(reg->Get_PC()) == 0xCB)
    {
        reg->Set_flagZ(value ? 0 : 1);
		reg->Add_PC(2);
    }
	else
		reg->Add_PC(1);
}

void Instructions::PUSH_PC()
{
	reg->Add_SP(-1);
	mem->MemW(reg->Get_SP(), (reg->Get_PC() & 0xFF00) >> 8);
	reg->Add_SP(-1);
	mem->MemW(reg->Get_SP(), reg->Get_PC() & 0x00FF);
}

void Instructions::RST_n(BYTE desp)
{
	//Queremos que se guarde la siquiente instruccion a ejecutar
	reg->Add_PC(1);

	PUSH_PC();

	reg->Set_PC(0x0000 + desp);
}

void Instructions::LDHL_SP_n()
{
	char n = _8bitsInmValue;

	reg->Set_flagZ(0);
	reg->Set_flagN(0);
    reg->Set_flagH(((reg->Get_SP() & 0x0F) + (n & 0x0F)) > 0x0F);
    reg->Set_flagC(((reg->Get_SP() & 0xFF) + (n & 0xFF)) > 0xFF);

	reg->Set_HL(reg->Get_SP() + n);

	reg->Add_PC(2);
}
