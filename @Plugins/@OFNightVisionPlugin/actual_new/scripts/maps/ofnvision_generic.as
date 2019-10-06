/*
* |==============================================================================|
* | O P P O S I N G  F O R C E   N I G H T  V I S I O N   [standalone version]   |
* | Author:  Neo (Discord: NEO) Version: V1.41 / © 2019                          |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC  |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)         |
* |==============================================================================|
* |This map script enables the Opposing Force style NightVision view mode        |
* |==============================================================================|
* |Map script install instructions:                                              |
* |------------------------------------------------------------------------------|
* |1. Extract the map scripts 'scripts/maps/ofnvision_generic.as'                |
* |                       and 'scripts/maps/neo/ofnvision.as'                    |
* |                       to  'svencoop_addon/scripts/maps'.                     |
* |------------------------------------------------------------------------------|
* |2. Use this script as the main map script file for your maps and              |
* |   add to your map config (maps/<your-map>.cfg) the following lines:          |
* |                                                                              |
* |   map_script ofnvision_generic                                               |
* |==============================================================================|
* |Usage of OF NightVision:                                                      |
* |----------------------------------------------------------------------------  |
* |Simply use standard flash light key to switch the                             |
* |OF NightVision view mode on and off                                           |
* |==============================================================================|
* | Additional notes:                                                            |
* |------------------------------------------------------------------------------|
* | For NightVision with say chat commands replace 'g_NightVision.OnMapInit();'  |
* | with 'g_NightVision.OnMapInit(true, true);'                                  |
* | [NV enable (true=on/false=off )--^] [^-- say chat cmd's (true=on/false=off)] |
* |==============================================================================|
* | OF NightVision say chat commands: (if say chat commands are activated)       |
* |------------------------------------------------------------------------------|
* | => To show activation status enter:  /nvis                                   |
* | => To enable OF NightVision enter:   /nvis on    or   /nvison                |
* | => To disable OF NightVision enter:  /nvis off   or   /nvisoff               |
* |==============================================================================|
*/

#include "neo/ofnvision"

void MapInit()
{	// Init NightVision
	g_NightVision.OnMapInit();  // with 'say chat commands' use '.OnMapInit(true, true);'
}
