Sven Co-op - ENV_SNOW ENTITY - MAP SCRIPT
=========================================

General Information:
--------------------
Date:	 October, 3th, 2019
Author:	 Neo (Dicord: 'Sven Co-op' Server - Neo)
Credits: y00tguy (V1.00 / techical protype with test map) 
Title:	 env_snow entity for Sven Co-op V5.20
Version: V1.41 / © 2019
License: This code is protected and licensed with Creative Commons 3.0 - NC
	 (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)


env_snow Entity - Map Script Information
----------------------------------------
The env_snow entity map script enables winter snow weather effects.

The Scripts are developed and available in 2 different versions:
 (1.) Standalone map script version of env_snow Entity.
 (2.) #include map script version of env_snow Entity, which can be used from other scripts.


env_snow Entity - Installing and initialization
-----------------------------------------------
=> [#include script version 'env_snow.as'] 
   1. Extract the map script 'scripts/maps/neo/env_snow.as'
                          to 'svencoop_addon/scripts/maps/neo'

   2. Add to your main map script the following code:
      (a) #include "neo/env_snow"
      (b) in function 'MapInit()':
            RegisterEnvSnow();

=> [standalone script version 'env_snow_generic.as'] 
   1. Extract the map script 'scripts/maps/env_snow_generic.as'
                         and 'scripts/maps/neo/env_snow.as'
                         to 'svencoop_addon/scripts/maps'.

   2. Use this script as the main map script file for your maps and
      add to your map config (maps/<your-map>.cfg) the following lines:
        weapon_welcome 1
        map_script env_snow_generic


env_snow Entity - Addition to map editor
----------------------------------------
Add the file 'env_snow.fgd' to your favorite map editor
to be able to add the new entity 'env_snow' to your map.  


env_snow Entity - Keyvaluse overview
------------------------------------
"Snow particle size", [snow_size]: (0 - 4)
  Size of snow particle from 4/large - 1/small for included snow sprites - or -
  0 for custon snow paricle sprite (=> needs to be defined with keyvalue 'particle_spr').

"Snow intensity", [intensity]: (1 - 20)
  Defines the intensity of snow.

"Snow radius", [radius]:
  Defines the size of the round circle snow effect zone in units. Higher values makes the
  snow effect slower and less visible/effectiv. Instead of large radius,better use mutiple
  snow entities with small radius.

"Speed multiplicator", [speed_mult]:
  Defines the speed of snow falling speed (0,1 - 10,0)

"Min. random snow fall height offset", [z_rand_min]: (0 - 60)
"Max. random snow fall height offset", [z_rand_max]: (70 - 650)
  Min. and max. snow fall height offset for randomization of snow fall start point
  (=> Start point is calculated with: 'entity.origin.z' + randomized z from [z_rand_min <=> z_rand_max])

"Dynamic snow mode", [dynamic]: (0 / 1)"
  Allows to switch the snow effect between the static mode [=0/static fixed/multiple snow entities]
  - and - dynamic player oriented mode [snow effect origin = player origin/only one snow entity]

"Min. snow fall activation zone", [zone_min]: (min. x, y, z)
"Max. snow fall activation zone", [zone_max]: (max. x, y, z)
  Min. and max. vector of snow effect activation zone which triggers the snow fall effect, if the player
  is inside. This should br general used to reduce cpu/network load with activated snow entities.
  Note: The this option is only working, of dynamic snow mode is off ([dynamic] = 0).

"Custom snow particle Sprite", [particle_spr]:
  Name of a custom snow particle sprite (If used, set [snow_size] = 0).

"Snow angles", [angles]:
  Defines the angle for snow fall. For vertical snow fall use "90 0 0".

"Flags", [spawnflags]:
   1: "Start on": Starts snow effect after entity creation.


env_snow Entity - Sample definitions
------------------------------------

{
"origin" "256 512 -384"
"spawnflags" "1"
"z_rand_min" "600"
"z_rand_max" "600"
"snow_size" "3"
"speed_mult" "2.0"
"radius" "2048"
"intensity" "5"
"angles" "90 0 0"
"targetname" "best_weather"
"classname" "env_snow"
}


{
"origin" "3481 -1599 400"
"spawnflags" "1"
"z_rand_min" "20"
"z_rand_max" "250"
"snow_size" "2"
"speed_mult" "1.0"
"radius" "1000"
"intensity" "3"
"zone_min" "600 -2440 0"
"zone_max" "3920 -1130 200"
"angles" "90 0 0"
"targetname" "snow_area_1"
"classname" "env_snow"
}

