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

#ifndef __DEF_H__
#define __DEF_H__

//#define MAKEGBLOG

#define APP_NAME		"DMGBoy"
#define APP_VERSION		"1.0"
#define APP_MAINT		"Pablo Gascó"
#define APP_LICENCE		"GPL v3"
#define APP_COPYRIGTH	"(C) 2013 Pablo Gasco"
#define APP_WEBSITE		"http://code.google.com/p/dmgboy/"

#define SAVE_STATE_VERSION	0x02

typedef unsigned char BYTE;
typedef unsigned short WORD;

#define GB_SCREEN_W 160
#define GB_SCREEN_H 144

#define LCD_MODE_0 204    //201-207
#define LCD_MODE_1 456    //456 * 10 = 4560
#define LCD_MODE_2 80     //77-83
#define LCD_MODE_3 172    //169-175

#define HDMA_CYCLES 8

#define FRAME_CYCLES    70224

#define BIT0(value)	((value) & 0x01)
#define BIT1(value)	((value) & 0x02)
#define BIT2(value)	((value) & 0x04)
#define BIT3(value)	((value) & 0x08)
#define BIT4(value)	((value) & 0x10)
#define BIT5(value)	((value) & 0x20)
#define BIT6(value)	((value) & 0x40)
#define BIT7(value)	((value) & 0x80)

#define BITS01(value)	((value) & 0x03)
#define BITS23(value)	((value) & 0x0C)
#define BITS45(value)	((value) & 0x30)
#define BITS67(value)	((value) & 0xC0)

#define P1		0xFF00
#define SB		0xFF01
#define SC		0xFF02
#define DIV		0xFF04
#define TIMA	0xFF05
#define TMA		0xFF06
#define TAC		0xFF07
#define IF		0xFF0F
#define NR10	0xFF10
#define NR11	0xFF11
#define NR12	0xFF12
#define NR13	0xFF13
#define NR14	0xFF14
#define NR21	0xFF16
#define NR22	0xFF17
#define NR23	0xFF18
#define NR24	0xFF19
#define NR30	0xFF1A
#define NR31	0xFF1B
#define NR32	0xFF1C
#define NR33	0xFF1D
#define NR34	0xFF1E
#define NR41	0xFF20
#define NR42	0xFF21
#define NR43	0xFF22
#define NR44	0xFF23
#define NR50	0xFF24
#define NR51	0xFF25
#define NR52	0xFF26
#define LCDC	0xFF40
#define STAT	0xFF41
#define SCY		0xFF42
#define SCX		0xFF43
#define LY		0xFF44
#define LYC		0xFF45
#define DMA		0xFF46
#define BGP		0xFF47
#define OBP0	0xFF48
#define OBP1	0xFF49
#define WY		0xFF4A
#define WX		0xFF4B
#define KEY1    0xFF4D
#define VBK     0xFF4F
#define HDMA1   0xFF51
#define HDMA2   0xFF52
#define HDMA3   0xFF53
#define HDMA4   0xFF54
#define HDMA5   0xFF55
#define BGPI    0xFF68
#define BGPD    0xFF69
#define OBPI    0xFF6A
#define OBPD    0xFF6B
#define SVBK    0xFF70
#define IE		0xFFFF

#endif
