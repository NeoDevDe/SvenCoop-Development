/*
* |===============================================================================|
* | A M B I E N T   S O U N D - M A P   S C R I P T   [#include version]          |
* | Author: Neo (Discord: NEO) Version: V1.11 / © 2019                            |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC   |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)          |
* |===============================================================================|
* |This map script enables playing of ambient sound global.                       |
* |===============================================================================|
* |Map script install instructions:                                               |
* |-------------------------------------------------------------------------------|
* |1. Extract the map script 'scripts/maps/neo/ambient_sound.as'                  |
* |                       to 'svencoop_addon/scripts/maps/neo'                    |
* |-------------------------------------------------------------------------------|
* |2. Add to your main map script the following code:                             |
* |                                                                               |
* | (a) #include "neo/ambient_sound"                                              |
* |                                                                               |
* | (b) For instant play of an ambient generic sound add in function 'MapInit()': |
* |         AmbientGeneric("<your sound>", true);                                 |
* |     or  AmbientGeneric("<your sound>", <volume 1-10>, true);   [with volume]  |
* |                                                                               |
* |     For instant play of an ambient music add in function 'MapInit()':         |
* |         AmbientMusic("<your music>", true);                                   |
* |     or  AmbientMusic("<your music>", <volume 1-10>, true);     [with volume]  |
* |                                                                               |
* |     If you want to play the ambient generic sound or music later              |
* |     you can use the following code:                                           |
* |                                                                               |
* |     initializtion with:                                                       |
* |         AmbientMusic@ g_ambient_sound = @AmbientGeneric("<your sound>");      |
* |     or                                                                        |
* |         AmbientMusic@ g_ambient_sound = @AmbientMusic("<your music>");        |
* |                                                                               |
* |     To play the sound use:                                                    |
* |       g_ambient_sound.On();                                                   |
* |                                                                               |
* |     To stop playing the sound use:                                            |
* |       g_ambient_sound.Off();                                                  |
* |===============================================================================|
* | Note: "<your sound>" must include the complete filename of music              |
* |       (i.e. "ambience/computalk1.wav" without "svencoop/sound/")              |
* |===============================================================================|
*/


const uint MAX_SOUND_VOLUME      = 10;


AmbientSound@ AmbientGeneric(string sound_name, bool start=false)
{
	return @AmbientSound(sound_name, false, MAX_SOUND_VOLUME, start);
}

AmbientSound@ AmbientGeneric(string sound_name, uint sound_volume, bool start=false)
{
	return @AmbientSound(sound_name, false, sound_volume, start);
}

AmbientSound@ AmbientMusic(string sound_name, bool start=false)
{
	return @AmbientSound(sound_name, true, MAX_SOUND_VOLUME, start);
}

AmbientSound@ AmbientMusic(string sound_name, uint sound_volume, bool start=false)
{
	return @AmbientSound(sound_name, false, sound_volume, start);
}


uint ambient_sound_count = 0;

class AmbientSound
{
	private string  AMBIENT_SOUND_GENERIC = "ambient_generic";
	private string  AMBIENT_SOUND_MUSIC   = "ambient_music";
	private string  target  = "";
	private string  name    = "";
	private bool    type    = false;
	private uint    volume  = MAX_SOUND_VOLUME;
	private bool    playing = false;
	private EHandle h_sound = null;

	AmbientSound() {}

	AmbientSound(string sound_name, bool sound_type, uint sound_volume=MAX_SOUND_VOLUME, bool start=false)
	{
		target = "ambient_sound_" + (++ambient_sound_count);
		name   = sound_name;
		type   = sound_type;
		volume = ((sound_volume <= MAX_SOUND_VOLUME) ? sound_volume : MAX_SOUND_VOLUME);
		g_SoundSystem.PrecacheSound(name);
		if(start)
			On(); // start playing sound
	}

	const string GetTargetName()	{ return name;    }
	const string GetSoundName()		{ return name;    }
	bool         GetSoundType()		{ return type;    }
	bool         IsPlaying()		{ return playing; }

	bool On()
	{
		if(target.IsEmpty() or name.IsEmpty())
			return false;

		if(!playing)
		{
			dictionary keys;
			keys["origin"]	   = "0 0 0";
			keys["targetname"] = target;
			keys["message"]	   = name;

			if(!type)
			{
				keys["health"]	   = "" + volume;
				keys["playmode"]   = "2";
				keys["spawnflags"] = "1";
				keys["classname"]  = AMBIENT_SOUND_GENERIC;
				h_sound = EHandle(g_EntityFuncs.CreateEntity(AMBIENT_SOUND_GENERIC, keys, true));
			}
			else
			{
				keys["volume"]	   = "" + volume;
				keys["spawnflags"] = "2";
				keys["classname"]  = AMBIENT_SOUND_MUSIC;
				h_sound = EHandle(g_EntityFuncs.CreateEntity(AMBIENT_SOUND_MUSIC, keys, true));
			}

			playing = true;
		}
		return true;
	}

	void Off()
	{
		if(playing)
			g_EntityFuncs.Remove(h_sound.GetEntity());
		h_sound = null;
		playing = false;
	}
	
	void Destroy()
	{
		Off();
		type = false;
		name = "";
	}
}

