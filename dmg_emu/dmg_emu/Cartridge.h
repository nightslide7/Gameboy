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

#pragma once

#ifndef __CARTRIDGE_H__
#define __CARTRIDGE_H__

#include <string>
#include "Def.h"

#define CART_NAME		0x0134
#define CART_COLOR		0x0143
#define CART_TYPE		0x0147
#define CART_ROM_SIZE	0x0148
#define CART_RAM_SIZE	0x0149

class Cartridge
{
private:
	unsigned long _romSize;
	std::string _name;
	bool _isLoaded;
	BYTE * _memCartridge;

	BYTE (*ptrRead)(WORD);
	void (*ptrWrite)(WORD, BYTE);
	void CheckCartridge(std::string batteriesPath="");
	int CheckRomSize(int numHeaderSize, int fileSize);
public:
	Cartridge(std::string fileName, std::string batteriesPath="");
	Cartridge(std::string fileName, std::string batteriesPath="", int checkCartridge=1);
	Cartridge(BYTE * cartridgeBuffer, unsigned long size, std::string batteriesPath="");
	~Cartridge();
	
	BYTE *GetData();
	unsigned int GetSize();
	std::string GetName();
	bool IsLoaded();

	inline BYTE Read(WORD direction) { return ptrRead(direction); };
	inline void Write(WORD direction, BYTE value) { ptrWrite(direction, value); };
	
	void Print(int beg, int end);
	
	void SaveMBC(std::ofstream * file);
	void LoadMBC(std::ifstream * file);
};

#endif
