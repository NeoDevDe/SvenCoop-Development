/*
* |==============================================================================|
* | A M B I E N T   S O U N D - M A P   S C R I P T   [standalone version]       |
* | Author: Neo (Discord: NEO) Version: V1.11 / © 2019                           |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC  |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)         |
* |==============================================================================|
* |This map script enables instant playing of ambient sound global.              |
* |==============================================================================|
* |Map script install instructions:                                              |
* |------------------------------------------------------------------------------|
* |1. Extract the map scripts 'scripts/maps/ambient_sound_generic.as'            |
* |                       and 'scripts/maps/neo/ambient_sound.as'                |
* |                       to  'svencoop_addon/scripts/maps'                      |
* |------------------------------------------------------------------------------|
* |2. Rename the file to another name to avoid filename conflicts:               |
* |   (i.e. from "ambient_music_generic.as" to "computalk1.as")                  |
* |------------------------------------------------------------------------------|
* |3. In code enter your custom sound settings in the following code lines:      |
* |     const string ambient_sound_name   = "<your music>";                      |
* |     const bool   ambient_sound_type   = false;                               |
* |     const uint   ambient_sound_volume = 10;                                  |
* |------------------------------------------------------------------------------|
* |4. Use this script as the main map script file for your maps and              |
* |   add to your map config (maps/<your-map>.cfg) the following line:           |
* |                                                                              |
* |     map_script "<your ambient sound script>"                                 |
* |     (i.e.    map_script computalk1)                                          |
* |==============================================================================|
* | Note: "<your music>" must include the complete filename of music             |
* |       (i.e. "ambience/computalk1.wav" without "svencoop/sound/")             |
* |==============================================================================|
*/

#include "neo/ambient_sound"


// Enter your custom sound settings here:
const string ambient_sound_name   = "<your music>";	// <== enter your sound name here   [i.e.  "ambience/computalk1.wav"]
const bool   ambient_sound_type   = false;			// <== enter your sound type here   [false = 'ambient_generic' / true = 'ambient_music']
const uint   ambient_sound_volume = 10;				// <== enter your sound volume here [0 = silent / 10 = max. volume]


// Code section: Don't change anything here !!!

void MapInit()
{
	AmbientSound(ambient_sound_name, ambient_sound_type, ambient_sound_volume, true);
}
