Sven Co-op - AMBIENT SOUND - MAP SCRIPT
=======================================

General Information:
--------------------
Date:	 October, 6th, 2019
Author:	 Neo (Dicord: 'Sven Co-op' Server - Neo)
Title:	 Ambient Sound Script for Sven Co-op V5.20
Version: V1.11 / © 2019
License: This code is protected and licensed with Creative Commons 3.0 - NC
	 (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)


Ambient Sound Map Script Information
------------------------------------
The Ambient Sound Map-Scripts enable the playing of ambient sound global.

The Scripts are developed and available in 2 different versions:
 (1.) Standalone map script version of Ambient Sound.
 (2.) #include map script version of Ambient Sound, which can be used from other scripts.


Ambient Sound - installing and usage instructions
-------------------------------------------------
=> [#include script version 'ambient_sound.as'] 
   1. Extract the map script 'scripts/maps/neo/ambient_sound.as'
                          to 'svencoop_addon/neo/scripts/maps'.

   2. Add to your main map script the following code:
     (a) #include "neo/ambient_sound"
     (b) For instant play of an ambient generic sound add in function 'MapInit()':

             AmbientGeneric("<your sound name >", true);
         or  AmbientGeneric("<your sound name>", <volume 1-10>, true);   [with volume]

         For instant play of an ambient music add in function 'MapInit()':
             AmbientMusic("<your music>", true);
         or  AmbientMusic("<your music>", <volume 1-10>, true);     [with volume]

        If you want to play the ambient generic sound or music later,
        you can use the following code:

        initializtion with:
            AmbientMusic@ g_ambient_sound = @AmbientGeneric("<your sound>");
        or
            AmbientMusic@ g_ambient_sound = @AmbientMusic("<your music>");

        To play the sound use:
          g_ambient_sound.On();

        To stop playing the sound use:
          g_ambient_sound.Off();

=> [standalone script version 'ambient_sound_generic.as'] 
   1. Extract the map script 'scripts/maps/ambient_sound_generic.as'
                         and 'scripts/maps/neo/ambient_sound.as'
                         to 'svencoop_addon/neo/scripts/maps'.

   2. Rename the file to another name to avoid filename conflicts:
      (i.e. from "ambient_music_generic.as" to "computalk1.as")

   3. In code enter your custom sound settings in the following code lines:
        const string ambient_sound_name   = "<your music>";// <== sound name:   i.e. "ambience/computalk1.wav"
        const bool   ambient_sound_type   = false;	   // <== sound type:   false = 'ambient_generic' / true = 'ambient_music'
        const uint   ambient_sound_volume = 10;		   // <== sound volume: 0 = silent / 10 = max. volume

   4. Use this script as the main map script file for your maps and
      add to your map config (maps/<your-map>.cfg) the following line:

        map_script "<your ambient sound script>"
        (i.e.    map_script computalk1)


Note: "<your sound name>" must include the complete filename of music
      (i.e. "ambience/computalk1.wav" without "svencoop/sound/")
