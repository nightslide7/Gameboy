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

#include <sstream>
#include <fstream>
#include <iomanip>
#include "Registers.h"
#include "GBException.h"

using namespace std;

Registers::Registers() {ResetRegs();}

Registers::~Registers()
{
}

Registers *Registers::GetPtrRegisters() {return this;}

WORD Registers::Get_Reg(e_registers reg)
{
	switch (reg){
		case A: return this->Get_A(); break;
		case B: return this->Get_B(); break;
		case C: return this->Get_C(); break;
		case D: return this->Get_D(); break;
		case E: return this->Get_E(); break;
		case F: return this->Get_F(); break;
		case H: return this->Get_H(); break;
		case L: return this->Get_L(); break;
		case AF: return this->Get_AF(); break;
		case BC: return this->Get_BC(); break;
		case DE: return this->Get_DE(); break;
		case HL: return this->Get_HL(); break;
		case PC: return this->Get_PC(); break;
		case SP: return this->Get_SP(); break;
		default:
			stringstream out;
			out << "Get_Reg - Error, incorrect register: " << reg << endl;
			throw GBException(out.str().data());
	}
}

void Registers::Set_Reg(e_registers reg, WORD value)
{
	switch (reg){
		case A: this->Set_A((BYTE)value); break;
		case B: this->Set_B((BYTE)value); break;
		case C: this->Set_C((BYTE)value); break;
		case D: this->Set_D((BYTE)value); break;
		case E: this->Set_E((BYTE)value); break;
		case F: this->Set_F((BYTE)value); break;
		case H: this->Set_H((BYTE)value); break;
		case L: this->Set_L((BYTE)value); break;
		case AF: this->Set_AF(value); break;
		case BC: this->Set_BC(value); break;
		case DE: this->Set_DE(value); break;
		case HL: this->Set_HL(value); break;
		case PC: this->Set_PC(value); break;
		case SP: this->Set_SP(value); break;
		default:
			stringstream out;
			out << "Set_Reg - Error, incorrect register: " << reg << endl;
			throw GBException(out.str().data());
	}
}

BYTE Registers::Get_Flag(e_registers flag)
{
	switch (flag){
		case f_C: return this->Get_flagC();
		case f_H: return this->Get_flagH();
		case f_N: return this->Get_flagN();
		case f_Z: return this->Get_flagZ();
		default:
			stringstream out;
			out << "Error, incorrect flag (Get): " << flag << endl;
			throw GBException(out.str().data());
	}
}

void Registers::Set_Flag(e_registers flag, BYTE value)
{
	switch (flag){
		case f_C: this->Set_flagC(value);
		case f_H: this->Set_flagH(value);
		case f_N: this->Set_flagN(value);
		case f_Z: this->Set_flagZ(value);
		default:
			stringstream out;
			out << "Error, incorrect flag (Set): " << flag << endl;
			throw GBException(out.str().data());
	}
}

void Registers::ResetRegs()
{
	this->Set_AF(0x11B0);
	this->Set_BC(0x0013);
	this->Set_DE(0x00D8);
	this->Set_HL(0x014D);
	this->Set_PC(0x0100);
	this->Set_SP(0xFFFE);
	this->Set_Halt(false);
	this->Set_Stop(false);
	this->Set_IME(false);
}

void Registers::ResetRegsDebug() {
	this->Set_AF(0x0000);
	this->Set_BC(0x0000);
	this->Set_DE(0x0000);
	this->Set_HL(0x0000);
	this->Set_PC(0x0000);
	this->Set_SP(0x0000);
	this->Set_Halt(false);
	this->Set_Stop(false);
	this->Set_IME(false);
}

string Registers::ToString()
{
	stringstream out;
	
	out << "PC: " << setfill('0') << setw(4) << uppercase << hex << (int)Get_PC()
		<< ", AF: " << setfill('0') << setw(4) << uppercase << hex << (int)Get_AF()
		<< ", BC: " << setfill('0') << setw(4) << uppercase << hex << (int)Get_BC()
		<< ", DE: " << setfill('0') << setw(4) << uppercase << hex << (int)Get_DE()
		<< ", HL: " << setfill('0') << setw(4) << uppercase << hex << (int)Get_HL()
		<< ", SP: " << setfill('0') << setw(4) << uppercase << hex << (int)Get_SP()
		<< ", H: " << Get_Halt() << ", I: " << Get_IME();
	/*
	out << "PC = " << hex << (int)Get_PC()
	<< " SP = " << hex << (int)Get_SP()
	<< " AF = " << hex << (int)Get_AF()
	<< " BC = " << hex << (int)Get_BC()
	<< " DE = " << hex << (int)Get_DE()
	<< " HL = " <<	hex << (int)Get_HL()
	<< " Interrupts = " << Get_IME();
	 */
	
	return out.str();
}


string Registers::RegDump() {
	stringstream out;
	out << "AF " << setfill('0') << setw(4) << hex << (int)Get_AF() << "\n"
		<< "BC " << setfill('0') << setw(4) << hex << (int)Get_BC() << "\n"
		<< "DE " << setfill('0') << setw(4) << hex << (int)Get_DE() << "\n"
		<< "HL " << setfill('0') << setw(4) << hex << (int)Get_HL() << "\n"
		<< "SP " << setfill('0') << setw(4) << hex << (int)Get_SP()  << "\n"
		<< "PC " << setfill('0') << setw(4) << hex << (int)Get_PC() << "\n";
//		<< "H: " << Get_Halt() << ", I: " << Get_IME();
	return out.str();
}

void Registers::SaveRegs(ofstream * file)
{
	//file->write((char *)this, sizeof(Registers));
	file->write((char *)&this->af.doble, sizeof(WORD));
	file->write((char *)&this->bc.doble, sizeof(WORD));
	file->write((char *)&this->de.doble, sizeof(WORD));
	file->write((char *)&this->hl.doble, sizeof(WORD));
	file->write((char *)&this->pc, sizeof(WORD));
	file->write((char *)&this->sp, sizeof(WORD));
	file->write((char *)&this->IME, sizeof(bool));
	file->write((char *)&this->pendingIME, sizeof(bool));
	file->write((char *)&this->pendingIMEvalue, sizeof(bool));
	file->write((char *)&this->halt, sizeof(bool));
	file->write((char *)&this->stop, sizeof(bool));
}

void Registers::LoadRegs(ifstream * file)
{
	file->read((char *)&this->af.doble, sizeof(WORD));
	file->read((char *)&this->bc.doble, sizeof(WORD));
	file->read((char *)&this->de.doble, sizeof(WORD));
	file->read((char *)&this->hl.doble, sizeof(WORD));
	file->read((char *)&this->pc, sizeof(WORD));
	file->read((char *)&this->sp, sizeof(WORD));
	file->read((char *)&this->IME, sizeof(bool));
	file->read((char *)&this->pendingIME, sizeof(bool));
	file->read((char *)&this->pendingIMEvalue, sizeof(bool));
	file->read((char *)&this->halt, sizeof(bool));
	file->read((char *)&this->stop, sizeof(bool));
}
