Sven Co-op - Opposing Force NIGHT VISION - Plugin/Map Scripts
=============================================================

General Information:
--------------------
Date:	 April, 6th, 2020
Author:	 Neo (Dicord: 'Sven Co-op' Server - Neo)
	 NERO (Night Vision initial basic plugin script version)
Title:	 Opposing Force Night Vision plugin/map Script for Sven Co-op V5.22
Version: V1.90 © 2020
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
=> [#include script version 'nvision.as'] 
   1. Extract the map script 'scripts/maps/neo/nvision.as'
                          to 'svencoop_addon/scripts/maps/neo'

   2. Add to main map script the following code:
      (a) #include "neo/nvision"
      (b) In function 'MapInit()':
           NightVision::g_NightVision.OnMapInit();

=> [standalone script version   'nvision_generic.as'] 
   1. Extract the map script    'scripts/maps/nvision_generic.as'
                          to    'svencoop_addon/scripts/maps/...'
                       - and -  'scripts/maps/neo/nvision.as'
                          to    'svencoop_addon/scripts/maps/neo/...'.

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
         "name" "NVision"
         "script" "nvision"
         "concommandns" "nvis"
      }

   3. Add optional to you server configuration file at 'svencoop/server/server.cfg'
      additional lines to enable/disable the Night Vision functionality:
        => To enable  add:  as_command nvis.nvisionp 1
        => To disable add:  as_command nvis.nvisionp 0
   

Usage of NightVision
----------------------------------------------
Simply use standard flash light key to switch
the NightVision view mode on and off                                          


Note to additional usable NightVision functions
-----------------------------------------------
 - For NightVision with say chat commands use:
    NightVision::g_NightVision.OnMapInit(true, true);
            [NV enable (true=on/false=off )--^]  [^-- say chat cmd's (true=on/false=off)]

 - To enable call the function:      NightVision::g_NightVision.Enable();
 - To disable call the function:     NightVision::g_NightVision.Disable();
 - To check the status use:          if(NightVision::g_NightVision.IsEnabled()) {}
 - To change the night vision color: NightVision::g_NightVision.NVsetColor( Vector(0,255,0) );
|                            - or -  NightVision::g_NightVision.NVsetColor( NightVision::GREEN );

NightVision say chat commands: (if say chat commands are activated)
-------------------------------------------------------------------
 => To show activation status enter:  /nvis
 => To enable  NightVision enter:     /nvis on    or   /nvison   (admin only)
 => To disable NightVision enter:     /nvis off   or   /nvisoff  (admin only)
