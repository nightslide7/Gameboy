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

#ifndef __REGISTERS_H__
#define __REGISTERS_H__

#include "Def.h"
#include <iostream>

enum e_registers {
	A = 0x00, B, C, D, E, F, H, L,	//registros simples
	AF = 0x10, BC, DE, HL,			//registros dobles
	f_Z = 0x20, f_N, f_H, f_C,		//flags
	PC = 0x30, SP, $, c_$$,
	c_BC = 0x40, c_DE, c_HL,		//memoria apuntada por el registro doble
};

union u_register{
	WORD doble;
	BYTE simple[2];
};

class Registers
{
private:
	u_register af, bc, de, hl;
	WORD pc; //Program Counter
	WORD sp; //Stack Pointer
	bool IME;
	bool pendingIME;
	bool pendingIMEvalue;
	bool halt;
	bool stop;
    bool conditionalTaken;
public:
	Registers();
	~Registers();

	Registers *GetPtrRegisters();

	inline BYTE Get_A()				{return this->af.simple[1];}
	inline void Set_A(BYTE value)	{this->af.simple[1] = value;}
	inline BYTE Get_B()				{return this->bc.simple[1];}
	inline void Set_B(BYTE value)	{this->bc.simple[1] = value;}
	inline BYTE Get_C()				{return this->bc.simple[0];}
	inline void Set_C(BYTE value)	{this->bc.simple[0] = value;}
	inline BYTE Get_D()				{return this->de.simple[1];}
	inline void Set_D(BYTE value)	{this->de.simple[1] = value;}
	inline BYTE Get_E()				{return this->de.simple[0];}
	inline void Set_E(BYTE value)	{this->de.simple[0] = value;}
	inline BYTE Get_F()				{return this->af.simple[0];}
	inline void Set_F(BYTE value)	{this->af.simple[0] = value & 0xF0;}
	inline BYTE Get_H()				{return this->hl.simple[1];}
	inline void Set_H(BYTE value)	{this->hl.simple[1] = value;}
	inline BYTE Get_L()				{return this->hl.simple[0];}
	inline void Set_L(BYTE value)	{this->hl.simple[0] = value;}

	inline WORD Get_AF()			{return this->af.doble;}
	inline void Set_AF(WORD value)	{this->af.doble = value & 0xFFF0;}
	inline WORD Get_BC()			{return this->bc.doble;}
	inline void Set_BC(WORD value)	{this->bc.doble = value;}
	inline WORD Get_DE()			{return this->de.doble;}
	inline void Set_DE(WORD value)	{this->de.doble = value;}
	inline WORD Get_HL()			{return this->hl.doble;}
	inline void Set_HL(WORD value)	{this->hl.doble = value;}

	inline WORD Get_PC()			{return this->pc;}
	inline void Set_PC(WORD value)  {this->pc = value;}
	inline void Add_PC(int value)   {this->pc += value;};
	inline WORD Get_SP()			{return this->sp;}
	inline void Set_SP(WORD value)  {this->sp = value;}
	inline void Add_SP(int value)   {this->sp += value;};

	inline bool Get_IME()			{return this->IME;}
	inline void Set_IME(bool value, bool immediately=true)
	{
		if (immediately)
		{
			this->IME = value;
			this->pendingIME = false;
		}
		else
		{
			this->pendingIME = true;
			this->pendingIMEvalue = value;
		}
	}
	
	inline void Set_PendingIME()
	{
		if (this->pendingIME)
		{
			this->IME = this->pendingIMEvalue;
			this->pendingIME = false;
		}
	}

	inline bool Get_Halt()				{return this->halt;}
	inline void Set_Halt(bool value)	{this->halt = value;}

	inline bool Get_Stop()				{return this->stop;}
	inline void Set_Stop(bool value)	{this->stop = value;}

	WORD Get_Reg(e_registers reg);
	void Set_Reg(e_registers reg, WORD value);

	inline BYTE Get_flagZ() {return (this->af.simple[0] >> 7);}
	inline void Set_flagZ(BYTE value) {this->af.simple[0] = (this->af.simple[0] & 0x7F) | (value << 7);}
	inline BYTE Get_flagN() {return ((this->af.simple[0] & 0x40) >> 6);}
	inline void Set_flagN(BYTE value) {this->af.simple[0] = (this->af.simple[0] & 0xBF) | (value << 6);}
	inline BYTE Get_flagH() {return ((this->af.simple[0] & 0x20) >> 5);}
	inline void Set_flagH(BYTE value) {this->af.simple[0] = (this->af.simple[0] & 0xDF) | (value << 5);}
	inline BYTE Get_flagC() {return ((this->af.simple[0] & 0x10) >> 4);}
	inline void Set_flagC(BYTE value) {this->af.simple[0] = (this->af.simple[0] & 0xEF) | (value << 4);}
	
	BYTE Get_Flag(e_registers flag);
	void Set_Flag(e_registers flag, BYTE value);
    
    void Set_ConditionalTaken(bool value) {conditionalTaken = value;}
    bool Get_ConditionalTaken() {return conditionalTaken;}

	void ResetRegs();
	void SaveRegs(std::ofstream * file);
	void LoadRegs(std::ifstream * file);
	
	//////////////// ADDED FOR CPU SIMULATION
	void ResetRegsDebug();
	std::string RegDump();

	std::string ToString();
};

#endif