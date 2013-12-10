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

#include <fstream>
#include <iostream>
#include <string>
#include <string.h>
#include <iomanip>
#include <assert.h>
#include "Cartridge.h"
#include "Def.h"
#include "GBException.h"
#include "MBC.h"

using namespace std;

Cartridge::Cartridge(string fileName, string batteriesPath, int checkCartridge) {
	_memCartridge = NULL;
	ifstream::pos_type size;
	ifstream file (fileName.c_str(), ios::in|ios::binary|ios::ate);
	if (file.is_open())
	{
		size = file.tellg();
		this->_romSize = (unsigned long)size;
		_memCartridge = new BYTE [size];
		file.seekg (0, ios::beg);
		file.read((char *)_memCartridge, (streamsize)size);
		file.close();

		cout << fileName << ":\nFile loaded in memory correctly" << endl;
		
		if (checkCartridge) CheckCartridge(batteriesPath);
		
		_isLoaded = true;
	}
	else
	{
		cerr << fileName << ": Error trying to open the file" << endl;
		_isLoaded = false;
	}
}

/*
 * Constructor que recibe un fichero, lo carga en memoria y lo procesa
 */
Cartridge::Cartridge(string fileName, string batteriesPath)
{
	_memCartridge = NULL;
	ifstream::pos_type size;
	ifstream file (fileName.c_str(), ios::in|ios::binary|ios::ate);
	if (file.is_open())
	{
		size = file.tellg();
		this->_romSize = (unsigned long)size;
		_memCartridge = new BYTE [size];
		file.seekg (0, ios::beg);
		file.read((char *)_memCartridge, (streamsize)size);
		file.close();

		cout << fileName << ":\nFile loaded in memory correctly" << endl;
		
		CheckCartridge(batteriesPath);
		
		_isLoaded = true;
	}
	else
	{
		cerr << fileName << ": Error trying to open the file" << endl;
		_isLoaded = false;
	}
}

/*
 * Constructor que recibe un buffer y su tamaño y lo procesa
 */
Cartridge::Cartridge(BYTE * cartridgeBuffer, unsigned long size, string batteriesPath)
{
	_romSize = size;
	_memCartridge = cartridgeBuffer;
	
	CheckCartridge(batteriesPath);
	
	_isLoaded = true;
}

Cartridge::~Cartridge(void)
{
	DestroyMBC();
	if (_memCartridge)
		delete [] _memCartridge;
}

/*
 * Comprueba el buffer de la rom, extrae el nombre, compara el tamaño e inicializa el MBC
 */
void Cartridge::CheckCartridge(string batteriesPath)
{
	MBCPathBatteries(batteriesPath);
	
	_name = string((char *)&_memCartridge[CART_NAME], 16);
	
	CheckRomSize((int)_memCartridge[CART_ROM_SIZE], _romSize);
	
	BYTE t = _memCartridge[CART_TYPE];

	switch(_memCartridge[CART_TYPE])
	{
		case 0x00:						//ROM ONLY
		case 0x08:						//ROM+RAM
		case 0x09:						//ROM+RAM+BATTERY
			ptrRead = &NoneRead;
			ptrWrite = &NoneWrite;
			InitMBCNone(_name, _memCartridge, _romSize);
			break;
		case 0x01:						//ROM+MBC1 
		case 0x02:						//ROM+MBC1+RAM 
		case 0x03:						//ROM+MBC1+RAM+BATT
			ptrRead = &MBC1Read;
			ptrWrite = &MBC1Write;
			InitMBC1(_name, _memCartridge, _romSize, _memCartridge[CART_RAM_SIZE]);
			break;
		case 0x05:						//ROM+MBC2 
		case 0x06:						//ROM+MBC2+BATTERY
			ptrRead = &MBC2Read;
			ptrWrite = &MBC2Write;
			InitMBC2(_name, _memCartridge, _romSize);
			break;
			/*
			 case 0x0B:						//ROM+MMM01
			 case 0x0C:						//ROM+MMM01+SRAM
			 case 0x0D: mbc = MMM01; break;	//ROM+MMM01+SRAM+BATT*/
		case 0x0F:						//ROM+MBC3+TIMER+BATT
		case 0x10:						//ROM+MBC3+TIMER+RAM+BATT
		case 0x11:						//ROM+MBC3
		case 0x12:						//ROM+MBC3+RAM
		case 0x13:						//ROM+MBC3+RAM+BATT
			ptrRead = &MBC3Read;
			ptrWrite = &MBC3Write;
			InitMBC3(_name, _memCartridge, _romSize, _memCartridge[CART_RAM_SIZE]);
			break;
		case 0x19:						//ROM+MBC5
		case 0x1A:						//ROM+MBC5+RAM
		case 0x1B:						//ROM+MBC5+RAM+BATT
		case 0x1C:						//ROM+MBC5+RUMBLE
		case 0x1D:						//ROM+MBC5+RUMBLE+SRAM
		case 0x1E:						//ROM+MBC5+RUMBLE+SRAM+BATT
			ptrRead = &MBC5Read;
			ptrWrite = &MBC5Write;
			InitMBC5(_name, _memCartridge, _romSize, _memCartridge[CART_RAM_SIZE]);
			break;
			/*case 0x1F:						//Pocket Camera
			 case 0xFD:						//Bandai TAMA5
			 case 0xFE: mbc = Other; break;	//Hudson HuC-3
			 case 0xFF: mbc = HuC1; break;	//Hudson HuC-1*/
		default: throw GBException("MBC not implemented yet");
	}
}

/*
 * Compara el tamaño de la rom con el valor de la cabecera
 */
int Cartridge::CheckRomSize(int numHeaderSize, int fileSize)
{
	int headerSize = 32768 << (numHeaderSize & 0x0F);
	if (numHeaderSize & 0xF0)
		headerSize += (32768 << ((numHeaderSize & 0xF0) >> 0x04));
	assert(headerSize == fileSize);
	if (headerSize != fileSize)
	{
		cout << "The header does not match with the file size" << endl;
		return 0;
	}
	else
		return 1;
}

BYTE *Cartridge::GetData()
{
	return _memCartridge;
}

unsigned int Cartridge::GetSize()
{
	return _romSize;
}

string Cartridge::GetName()
{
	return _name;
}

bool Cartridge::IsLoaded()
{
	return _isLoaded;
}

void Cartridge::SaveMBC(ofstream * file)
{
	MBCSaveState(file);
}

void Cartridge::LoadMBC(ifstream * file)
{
	MBCLoadState(file);
}
