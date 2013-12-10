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

#include "GBException.h"

using namespace std;

GBException::GBException(): exception()
{
	newException("", GBUnknown);
}

GBException::GBException(string description): exception()
{
	newException(description, GBUnknown);
}

GBException::GBException(string description, ExceptionType type): exception()
{
	newException(description, type);
}

GBException::~GBException() throw()
{

}

ExceptionType GBException::GetType()
{
	return type;
}

void GBException::newException(string description, ExceptionType type)
{
	this->description = description;
	this->type = type;
}

const char * GBException::what() const throw()
{
	return description.c_str();
}
