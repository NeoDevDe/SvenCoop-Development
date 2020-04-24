/*
* |====================================================================================|
* | G L O B A L   S T A T E   M A N A G E R   T E S T     [plugin version]             |
* | Author:  Neo (Discord: NEO) Version: V1.20 / © 2020                                |
* | License: This code is protected and licensed with Creative Commons 4.0			   |
* | CC BY-NC-ND 4.0 / refer to https://creativecommons.org/licenses/by-nc-nd/4.0/)	   |
* |====================================================================================|
* | This script enables the testing of Global State Manager from plugin and map-script |          |
* |====================================================================================|
* | Plugin script install instructions:                                                |
* |------------------------------------------------------------------------------------|
* | 1. Extract the plugin/map script file 'scripts/plugin/globaltest.as'               |
* |                                 to    'svencoop_addon/plugin/...'.                 |
* |                               - and - 'scripts/maps/neo/globaltest.as'             |
* |                                 to    'svencoop_addon/scripts/maps/neo/...'.       |
* |------------------------------------------------------------------------------------|
* | 2. add to configuration file at 'svencoop/default_plugins.txt'                     |
* |    the following lines:                                                            |
* |                                                                                    |
* | {                                                                                  |
* |     "name" "GlobalTest"                                                            |
* |     "script" "globaltest"                                                          |
* |     "concommandns" "gt"                                                            |
* | }                                                                                  |
* |====================================================================================|
* | Global State Manager Test - say chat commands in 'server plugin' mode:             |
* |------------------------------------------------------------------------------------|
* | get a global state:  /global get [global state name]                               |
* | set a global state:  /global set [global state name] [on¦off¦dead]                 |
* |                      /global set [global state name] [map name] [on¦off¦dead]      |
* |====================================================================================|
*/

#include "../maps/neo/globaltest"


void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "Neo" );
	g_Module.ScriptInfo.SetContactInfo( "Neo (Discord: NEO)" );
	GlobalTest::g_GlobalTest.OnPluginInit(); // Plugin base init
}


void MapInit()
{
	GlobalTest::g_GlobalTest.OnMapInit(); // Plugin map init
}

