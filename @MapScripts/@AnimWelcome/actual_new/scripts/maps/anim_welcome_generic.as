/*
* |==============================================================================|
* | A N I M A T E D   W E L C O M E   [standalone version]                       |
* | Author: Neo (Discord: NEO) Version: V1.11 / © 2019                           |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC  |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)         |
* |==============================================================================|
* |This map script enables an dancing Gordon model as a wepon, which is only     |
* |visible for the player in 1st person mode, if the weapon is active selected.  |
* |==============================================================================|
* |Map script install instructions:                                              |
* |------------------------------------------------------------------------------|
* |1. Extract the map script 'scripts/maps/anim_welcome_generic.as'              |
* |                      and 'scripts/maps/anim_welcome.as'                      |
* |                       to 'svencoop_addon/scripts/maps'                       |
* |------------------------------------------------------------------------------|
* |2. Extract the welcome model 'models/v_welcome.mdl'                           |
* |                          to 'svencoop_addon/models'                          |
* |------------------------------------------------------------------------------|
* |3. Use this script as the main map script file for your maps and              |
* |   add to your map config (maps/<your-map>.cfg) the following lines:          |
* |                                                                              |
* |   weapon_welcome 1                                                           |
* |   map_script anim_welcome_generic                                            |
* |==============================================================================|
*/


#include "neo/anim_welcome"


void MapInit(){
	RegisterWelcomeAnimation();
}
