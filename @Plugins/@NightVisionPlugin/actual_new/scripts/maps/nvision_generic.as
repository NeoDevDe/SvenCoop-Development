/*
* |======================================================================================|
* | O P P O S I N G  F O R C E   N I G H T  V I S I O N   [standalone version]           |
* | Author:  Neo (Discord: NEO) Version: V1.81 / © 2020                                  |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC          |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)                 |
* |======================================================================================|
* |This map script enables the Opposing Force style NightVision view mode                |
* |======================================================================================|
* |Map script install instructions:                                                      |
* |--------------------------------------------------------------------------------------|
* |1. Extract the map script    'scripts/maps/nvision_generic.as'                        |
* |                       to    'svencoop_addon/scripts/maps'                            |
* |                     - and - 'scripts/maps/neo/nvision.as'                            |
* |                       to    'svencoop_addon/scripts/maps/neo'.                       |
* |--------------------------------------------------------------------------------------|
* |2. Use this script as the main map script file for your maps and                      |
* |   add to your map config (maps/<your-map>.cfg) the following lines:                  |
* |                                                                                      |
* |   map_script nvision_generic                                                         |
* |======================================================================================|
* |Usage of NightVision:                                                                 |
* |--------------------------------------------------------------------------------------|
* |Simply use standard flash light key to switch the NightVision view mode on and off    |
* |======================================================================================|
* | Additional notes:                                                                    |
* |--------------------------------------------------------------------------------------|
* | Initialization of night vision:  NightVision::g_NightVision.OnMapInit();             |
* | Init. of nv with chat commands:  NightVision::g_NightVision.OnMapInit(true, true);   |
* | Change night vision color: NightVision::g_NightVision.NVsetColor( Vector(0,255,0) ); |
* |                 - or -  NightVision::g_NightVision.NVsetColor( NightVision::GREEN ); |
* |======================================================================================|
* | NightVision say chat commands: (if say chat commands are activated)                  |
* |--------------------------------------------------------------------------------------|
* | => To show activation status enter:  /nvis                                           |
* | => To enable NightVision enter:   /nvis on    or   /nvison   (admin only)            |
* | => To disable NightVision enter:  /nvis off   or   /nvisoff  (admin only)            |
* |======================================================================================|
*/

#include "neo/nvision"

void MapInit()
{	// Init NightVision
	NightVision::g_NightVision.OnMapInit();  // => NVision and chat commands activated.
}
