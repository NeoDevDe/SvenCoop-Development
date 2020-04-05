/*
* |==============================================================================|
* | O P P O S I N G  F O R C E   N I G H T  V I S I O N   [plugin version]       |
* | Author:  Neo (Discord: NEO) Version: V1.80 / © 2020                          |
* | Credits: NERO (Night Vision initial basic plugin script version)             |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC  |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)         |
* |==============================================================================|
* | This map script enables the Opposing Force style NightVision view mode       |
* |==============================================================================|
* | 1. Extract the plugin/map script file 'scripts/plugin/ofnvision.as'         |
* |                                 to    'svencoop_addon/plugin/...'.          |
* |                               - and - 'scripts/maps/neo/ofnvision.as'        |
* |                                 to    'svencoop_addon/scripts/maps/neo/...'.          |
* |------------------------------------------------------------------------------|
* | 2. add to configuration file at 'svencoop/default_plugins.txt'               |
* |    the following lines:                                                      |
* |                                                                              |
* | "plugin"                                                                     |
* | {                                                                            |
* |     "name" "nvision"                                                         |
* |     "script" "nvision"                                                       |
* |     "concommandns" "nvis"                                                    |
* | }                                                                            |
* |==============================================================================|
* | NightVision activation from server cfg file ('server.cfg'):                  |
* |------------------------------------------------------------------------------|
* | => To enable  NightVision add:  as_command nvis.nvision 1                    |
* | => To disable NightVision add:  as_command nvis.nvision 0                    |
* |==============================================================================|
* | NightVision chat commands: (if say chat commands are activated)              |
* |------------------------------------------------------------------------------|
* | => To show activation status enter:  /nvis                                   |
* | => To enable NightVision enter:   /nvis on    or   /nvison  (admin only)     |
* | => To disable NightVision enter:  /nvis off   or   /nvisoff (admin only)     |
* |==============================================================================|
* | Usage of NightVision:                                                        |
* |------------------------------------------------------------------------------|
* | If enabled, simply use standard flash light key                              |
* | to switch the NightVision view mode on and off                               |
* |==============================================================================|
*/


#include "../maps/neo/nvision"


void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "Neo" );
	g_Module.ScriptInfo.SetContactInfo( "Neo (Discord: NEO)" );
}


void MapInit()
{
	NightVision::g_NightVision.OnMapInit(false, true); // Init with NV=disabled and HookSay=enabled
}

