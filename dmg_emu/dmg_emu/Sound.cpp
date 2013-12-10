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
// Definir la siguiente linea para que en Visual Studio no haya conflicto
// entre SDL y GB_Snd_Emu al definir tipos basicos
#define BLARGG_COMPILER_HAS_NAMESPACE 1
/*
#include "Basic_Gb_Apu.h"
#ifdef __WXMSW__
#include "SoundSDL.h"
#else
#include "SoundPortaudio.h"
#endif
#include "Sound.h"

using namespace std;

BYTE soundMask[] = {
    0x80, 0x3F, 0x00, 0xFF, 0xBF, // NR10-NR14 (0xFF10-0xFF14)
    0xFF, 0x3F, 0x00, 0xFF, 0xBF, // NR20-NR24 (0xFF15-0xFF19)
    0x7F, 0xFF, 0x9F, 0xFF, 0xBF, // NR30-NR34 (0xFF1A-0xFF1E)
    0xFF, 0xFF, 0x00, 0x00, 0xBF, // NR40-NR44 (0xFF1F-0xFF23)
    0x00, 0x00, 0x70, 0xFF, 0xFF, // NR50-NR54 (0xFF24-0xFF28)
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, // --------- (0xFF29-0xFF2D)
    0xFF, 0xFF,                   // --------- (0xFF2E-0xFF2F)
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // WaveRAM (0xFF30-0xFF37)
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // WaveRAM (0xFF38-0xFF3F)
};

enum SoundError { ERROR, NO_ERROR };

int Sound::HandleError( const char* str )
{
	if ( str )
	{
		cerr << "Error: " << str << endl;
		return ERROR;
	}
	else
		return NO_ERROR;
}

Sound::Sound()
{
	enabled = false;
	initialized = true;
	sampleRate = 44100;//22050;

#ifdef __WXMSW__
	sound = new SoundSDL();
#else
    sound = new SoundPortaudio();
#endif
    
    apu = new Basic_Gb_Apu();
	
	if (ChangeSampleRate(sampleRate) == ERROR)
	{
		initialized = false;
		return;
	}
	
	if (Start() == ERROR)
	{
		initialized = false;
		return;
	}
}

Sound::~Sound()
{
    delete sound;
    delete apu;
}

int Sound::ChangeSampleRate(long newSampleRate)
{
	if (!initialized)
		return NO_ERROR;
	
	sampleRate = newSampleRate;
	bool wasEnabled = enabled;
	
	if (wasEnabled)
		Stop();
	
	// Set sample rate and check for out of memory error
	if (HandleError( apu->set_sample_rate(sampleRate) ) == ERROR)
		return ERROR;
	
	if (wasEnabled)
	{
		if (Start() == ERROR)
			return ERROR;
	}
	
	return NO_ERROR;
}

int Sound::Start()
{
	if (!initialized)
		return NO_ERROR;
	
	if (!enabled)
	{
		// Generate a few seconds of sound and play using SDL
		if (sound->Start(sampleRate, 2) == false)
			return ERROR;
	}
	enabled = true;
	
	return NO_ERROR;
}

int Sound::Stop()
{
	if (!initialized)
		return NO_ERROR;
	
	if (enabled)
		sound->Stop();
	
	enabled = false;
	
	return NO_ERROR;
}

bool Sound::GetEnabled()
{
	return enabled;
}

void Sound::SetEnabled(bool enabled)
{
	if (enabled)
		Start();
	else
		Stop();
}

void Sound::EndFrame()
{
	if ((!initialized) || (!enabled))
		return;
	
	apu->end_frame();
	
	int const bufSize = apu->samples_avail();
	blip_sample_t * buf = new blip_sample_t[bufSize];
	
    // Play whatever samples are available
    long count = apu->read_samples(buf, bufSize);
    
    sound->Write(buf, count);

	delete[] buf;
}
void Sound::WriteRegister(WORD address, BYTE value)
{
    if (enabled)
    {
        if ((address == NR52) && ((value & 0x80) == 0))
        {
            for (int i=0xFF10; i<=0xFF26; i++)
                apu->write_register(i, 0);
        }
        else
        {
            // Si no esta habilitado el sonido se ignora la escribitura a los registros
            if ((address >= 0xFF30) || (address == NR52) || (apu->read_register(NR52)&0x80))
                apu->write_register(address, value);
        }
    }
}

BYTE Sound::ReadRegister(WORD address)
{
    BYTE value = 0;
    if(enabled)
        value = apu->read_register(address);
    
    // Los registros de sonido no devuelven directamente su valor.
    // Hay bits que no son legibles. soundMask lo resuelve.
    return value|soundMask[address-NR10];
}
*/

// Unimplemented for CPU simulation
#include "Sound.h"

using namespace std;

BYTE soundMask[] = {
    0x80, 0x3F, 0x00, 0xFF, 0xBF, // NR10-NR14 (0xFF10-0xFF14)
    0xFF, 0x3F, 0x00, 0xFF, 0xBF, // NR20-NR24 (0xFF15-0xFF19)
    0x7F, 0xFF, 0x9F, 0xFF, 0xBF, // NR30-NR34 (0xFF1A-0xFF1E)
    0xFF, 0xFF, 0x00, 0x00, 0xBF, // NR40-NR44 (0xFF1F-0xFF23)
    0x00, 0x00, 0x70, 0xFF, 0xFF, // NR50-NR54 (0xFF24-0xFF28)
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, // --------- (0xFF29-0xFF2D)
    0xFF, 0xFF,                   // --------- (0xFF2E-0xFF2F)
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // WaveRAM (0xFF30-0xFF37)
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // WaveRAM (0xFF38-0xFF3F)
};

enum SoundError { ERROR, NO_ERROR };

int Sound::HandleError( const char* str )
{
	if ( str )
	{
		cerr << "Error: " << str << endl;
		return ERROR;
	}
	else
		return NO_ERROR;
}

Sound::Sound()
{
	enabled = false;
	initialized = true;
	sampleRate = 44100;//22050;
	
	if (ChangeSampleRate(sampleRate) == ERROR)
	{
		initialized = false;
		return;
	}
	
	if (Start() == ERROR)
	{
		initialized = false;
		return;
	}
}

Sound::~Sound()
{
}

int Sound::ChangeSampleRate(long newSampleRate)
{
	return NO_ERROR;
}

int Sound::Start()
{
	
	return NO_ERROR;
}

int Sound::Stop()
{
	return NO_ERROR;
}

bool Sound::GetEnabled()
{
	return enabled;
}

void Sound::SetEnabled(bool enabled)
{
	if (enabled)
		Start();
	else
		Stop();
}

void Sound::EndFrame()
{

}
void Sound::WriteRegister(WORD address, BYTE value)
{

}

BYTE Sound::ReadRegister(WORD address)
{
    BYTE value = 0;
    
    // Los registros de sonido no devuelven directamente su valor.
    // Hay bits que no son legibles. soundMask lo resuelve.
    return value|soundMask[address-NR10];
}
