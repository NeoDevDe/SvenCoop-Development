Sven Co-op - Opposing Force NIGHT VISION - Plugin/Map Scripts
=============================================================

General Information:
--------------------
Date:	 October, 6th, 2019
Author:	 Neo (Dicord: 'Sven Co-op' Server - Neo)
	 NERO (Night Vision initial basic plugin script version)
Title:	 Opposing Force Night Vision plugin/map Script for Sven Co-op V5.20
Version: V1.41 © 2019
License: This code is protected and licensed with Creative Commons 3.0 - NC
	 (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)


Opposing Force Night Vision  Plugin/Map Script Information
----------------------------------------------------------
The Opposing Force Night Vision plugin/map script enables
the Opposing Force style NightVision view mode.

The Scripts are developed and available in 3 different versions:
 (1.) Plugin script version of Opposing Force Night Vision.
 (2.) Standalone map script version of Opposing Force Night Vision.
 (3.) #include map script version of Opposing Force Night Vision,
      which can be used from other scripts.


Opposing Force Night Vision - installing and usage instructions
---------------------------------------------------------------
=> [#include script version 'ofnvision.as'] 
   1. Extract the map script 'scripts/maps/neo/ofnvision.as'
                          to 'svencoop_addon/scripts/maps/neo'

   2. Add to main map script the following code:
      (a) #include "neo/ofnvision"
      (b) In function 'MapInit()':
            g_NightVision.OnMapInit();

=> [standalone script version 'ofnvision_generic.as'] 
   1. Extract the map script 'scripts/maps/ofnvision_generic.as'
                         and 'scripts/maps/neo/ofnvision.as'
                         to  'svencoop_addon/scripts/maps/...'.

   2. Use this script as the main map script file for your maps and
      add to your map config (maps/<your-map>.cfg) the following lines:
        map_script ofnvision_generic

=> [plugin script version 'ofnvision.as'] 
   1. Extract the map script 'scripts/plugin/ofnvision.as'
                         and 'scripts/maps/neo/ofnvision.as'
                         to  'svencoop_addon/scripts/...'.

   2. Add to configuration file at 'svencoop/default_plugins.txt'
      the following lines:

      "plugin"
      {
         "name" "OFnvision"
         "script" "ofnvision"
         "concommandns" "ofnv"
      }

   3. Add optional to you server configuration file at 'svencoop/server/server.cfg'
      additional lines to enable/disable the Night Vision functionality:
        => To enable  add:  as_command ofnv.nvision 1
        => To disable add:  as_command ofnv.nvision 0
   

Opposing Force Night Vision - Usage of OF NightVision
-----------------------------------------------------
Simply use standard flash light key to switch
the OF NightVision view mode on and off                                          


Note to additional usable NightVision functions
-----------------------------------------------
 - For NightVision with say chat commands use:
           'g_NightVision.OnMapInit(true, true);'
     [NV enable (true=on/false=off )--^] [^-- say chat cmd's (true=on/false=off)]

 - To enable call the function:    g_CrouchSpawn.Enable();
 - To disable call the function:   g_CrouchSpawn.Disable();
 - To check the status use:        if(g_CrouchSpawn.IsEnabled()) {}


OF NightVision say chat commands: (if say chat commands are activated)
----------------------------------------------------------------------
 => To show activation status enter:  /nvis
 => To enable OF NightVision enter:   /nvis on    or   /nvison
 => To disable OF NightVision enter:  /nvis off   or   /nvisoff
