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

#include "Def.h"

#ifndef __IGBSCREENDRAWABLE_H__
#define __IGBSCREENDRAWABLE_H__

class IGBScreenDrawable
{
public:
	virtual void OnPreDraw() = 0;
	virtual void OnPostDraw() = 0;
	virtual void OnDrawPixel(int idColor, int x, int y) = 0;
    virtual void OnDrawPixel(BYTE r, BYTE g, BYTE b, int x, int y) = 0;
	virtual void OnRefreshScreen() = 0;
	virtual void OnClear() = 0;
};

#endif