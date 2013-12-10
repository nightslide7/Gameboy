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

#ifndef __GBEXCEPTION_H__
#define __GBEXCEPTION_H__

#include <string>

enum ExceptionType { GBUnknown, GBError, GBExit };

class GBException: public std::exception
{
private:
	std::string description;
	ExceptionType type;
	void newException(std::string desc, ExceptionType type);

public:
	GBException();
	GBException(std::string desc);
	GBException(std::string desc, ExceptionType type);
	const char* what() const throw();
	ExceptionType GetType();
	~GBException() throw();
};

#endif
