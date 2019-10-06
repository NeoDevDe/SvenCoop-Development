Sven Co-op - ANIMATED WELCOME - MAP SCRIPT
==========================================

General Information:
--------------------
Date:	 October, 6th, 2019
Author:	 Neo (Dicord: 'Sven Co-op' Server - Neo)
	 Makaber (initial base script for dynamic_mapvote)
Title:	 Animated Welcome Script with Gordon Model for Sven Co-op V5.20
Version: V1.11 / © 2019
License: This code is protected and licensed with Creative Commons 3.0 - NC
	 (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)


Animated Welcome Map Script Information
---------------------------------------
The Welcome Map Script enables an dancing Gordon model as a wepon, whis is
only visible for the player in 1st person mode, if the weapon is active selected.

The Scripts are developed and available in 2 different versions:
 (1.) Standalone map script version of Animated Welcome.
 (2.) #include map script version of Animated Welcome, which can be used from other scripts.


Animated Welcome - installing and usage instructions
----------------------------------------------------
=> [#include script version 'anim_welcome.as'] 
   1. Extract the map script 'scripts/maps/neo/anim_welcome.as'
                          to 'svencoop_addon/scripts/maps/neo'

   2. Extract the welcome model 'models/v_welcome.mdl'
                             to 'svencoop_addon/models'

   3. Add to your main map script the following code:
      (a) #include "neo/anim_welcome"
      (b) in function 'MapInit()':
            RegisterWelcomeAnimation();

   4. Add to your map config (maps/<your-map>.cfg) the following line:
        weapon_welcome 1                                                         |

=> [standalone script version 'anim_welcome_generic.as'] 
   1. Extract the map script 'scripts/maps/anim_welcome_generic.as'
                         and 'scripts/maps/neo/anim_welcome.as'
                         to 'svencoop_addon/scripts/maps'.

   2. Extract the welcome model 'models/v_welcome.mdl'
                             to 'svencoop_addon/models'

   3. Use this script as the main map script file for your maps and
      add to your map config (maps/<your-map>.cfg) the following lines:
        weapon_welcome 1
        map_script anim_welcome_generic

