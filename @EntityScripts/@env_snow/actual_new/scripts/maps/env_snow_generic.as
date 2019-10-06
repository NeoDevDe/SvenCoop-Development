/*
* |=============================================================================|
* | E N V _ S N O W   E N T I T Y  -  M A P  S C R I P T  [standalone version]  |
* | Author:  Neo (Discord: NEO) Version: V1.41 / © 2019                         |
* | Credits: y00tguy (V1.00 / techical protype with test map)                   |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)        |
* |=============================================================================|
* | This entity map script enables winter snow weather effects.                 |
* |=============================================================================|
* | Map script install instructions:                                            |
* |-----------------------------------------------------------------------------|
* | 1. Extract the map scripts 'scripts/maps/env_snow_generic.as'               |
* |                       and 'scripts/maps/neo/env_snow.as'                    |
* |                       to  'svencoop_addon/scripts/maps/...'.                |
* |-----------------------------------------------------------------------------|
* | 2. Use this script as the main map script file for your maps and            |
* |    add to your map config (maps/<your-map>.cfg) the following lines:        |
* |                                                                             |
* |      map_script env_snow_generic                                            |
* |-----------------------------------------------------------------------------|
* | Additional notes to the Usage of 'env_snow' entity in your map              |
* |-----------------------------------------------------------------------------|
* | Add the file 'env_snow.fgd' to your favorite map editor                     |
* | to add the new entity 'env_snow' to your map.                               |
* |=============================================================================|
*/

#include "neo/env_snow"

void MapInit()
{	
	RegisterEnvSnow();
}
