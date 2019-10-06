Sven Co-op - CROUCH SPAWN - MAP SCRIPT
======================================

General Information:
--------------------
Date:	 October, 6th, 2019
Author:	 Neo (Dicord: 'Sven Co-op' Server - Neo)
Credits: H2  (initial implementation V1.00)
Title:	 Crouch Spawn map Script for Sven Co-op V5.20
Version: V1.41 © 2019
License: This code is protected and licensed with Creative Commons 3.0 - NC
	 (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)


Crouch Spawn Map Script Information
---------------------------------------
The Crouch Spawn map script addition allows players to spawn inside areas
where you must be crouched where they would otherwise be stuck clipping the walls.

The script is enabled by default and forces the player to                        |
crouch when spawned inside the area and prevents being stuck. 

The Scripts are developed and available in 1 combined version:
  #include map/Standalone script version of Crouch Spawn, which
   - can be used from other scripts
   - can be used as the main map script for a map.


Crouch Spawn - installing and usage instructions
------------------------------------------------
=> [#include script usage 'crouch_spawn.as'] 
   1. Extract the map script 'scripts/maps/neo/crouch_spawn.as'
                          to 'svencoop_addon/scripts/maps/neo'

   2. Add to main map script the following code:
      #include "neo/crouch_spawn"

=> [standalone script usage 'crouch_spawn.as'] 
   1. Extract the map script 'scripts/maps/neo/crouch_spawn.as'
                          to 'svencoop_addon/scripts/maps/neo'

   2. Use this script as the main map script file for your maps and
      add to your map config (maps/<your-map>.cfg) the following lines:
         map_script neo/crouch_spawn


Crouch Spawn - additional notes
-------------------------------
General: The Couch Spawn function is enabled by default (no init code needed)

Additional usable functions:
  - To enable call the function:    g_CrouchSpawn.Enable();
  - To disable call the function:   g_CrouchSpawn.Disable();
  - To check the status use:        if(g_CrouchSpawn.IsEnabled()) {}

Additional notes to the Usage of CROUCH SPAWN addition in your map
   1st: Locate your spawn area and measure the origin.
   2nd: Then, subtract 16 units from the z-axis measurement.
   3rd: Save the origin keyvalue.

