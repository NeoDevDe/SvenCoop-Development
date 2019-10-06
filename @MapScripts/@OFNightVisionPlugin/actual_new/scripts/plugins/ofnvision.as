/*
* |=============================================================================|
* | O P P O S I N G  F O R C E   N I G H T  V I S I O N   [plugin version]      |
* | Author:  Neo (Discord: NEO) Version: V1.41 / © 2019                         |
* | Credits: NERO (Night Vision initial basic plugin script version)            |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)        |
* |=============================================================================|
* | This map script enables the Opposing Force style NightVision view mode      |
* |=============================================================================|
* | 1. Extract the plugin/map script files 'scripts/plugin/ofnvision.as'        |
* |                                 and   'scripts/maps/neo/ofnvision.as'       |
* |                                 to    'svencoop_addon/scripts/...'.         |
* |-----------------------------------------------------------------------------|
* | 2. add to configuration file at 'svencoop/default_plugins.txt'              |
* |    the following lines:                                                     |
* |                                                                             |
* | "plugin"                                                                    |
* | {                                                                           |
* |     "name" "OFnvision"                                                      |
* |     "script" "ofnvision"                                                    |
* |     "concommandns" "ofnv"                                                   |
* | }                                                                           |
* |=============================================================================|
* | OF NightVision activation from server cfg file ('server.cfg'):              |
* |-----------------------------------------------------------------------------|
* | => To enable OF NightVision add:   as_command ofnv.nvision 1                |
* | => To disable OF NightVision add:  as_command ofnv.nvision 0                |
* |=============================================================================|
* | OF NightVision chat commands: (if say chat commands are activated)          |
* |-----------------------------------------------------------------------------|
* | => To show activation status enter:  /nvis                                  |
* | => To enable OF NightVision enter:   /nvis on    or   /nvison               |
* | => To disable OF NightVision enter:  /nvis off   or   /nvisoff              |
* |=============================================================================|
* | Usage of OF NightVision:                                                    |
* |-----------------------------------------------------------------------------|
* | If enabled, simply use standard flash light key                             |
* | to switch the OF NightVision view mode on and off                           |
* |=============================================================================|
*/


#include "../maps/neo/ofnvision"


void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "Neo" );
	g_Module.ScriptInfo.SetContactInfo( "Neo (Discord: NEO)" );
}


void MapInit()
{
	g_NightVision.OnMapInit(false, true); // Init with NV=disabled and HookSay=enabled
}

