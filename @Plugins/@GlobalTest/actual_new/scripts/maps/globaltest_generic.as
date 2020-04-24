/*
* |====================================================================================|
* | G L O B A L   S T A T E   M A N A G E R   T E S T     [standalone version]         |
* | Author:  Neo (Discord: NEO) Version: V1.20 / © 2020                                |
* | License: This code is protected and licensed with Creative Commons 4.0			   |
* | CC BY-NC-ND 4.0 / refer to https://creativecommons.org/licenses/by-nc-nd/4.0/)	   |
* |====================================================================================|
* | This script enables the testing of Global State Manager from plugin and map-script |          |
* |====================================================================================|
* | Map script install instructions:                                                   |
* |------------------------------------------------------------------------------------|
* | 1. Extract the map script   'scripts/maps/globaltest_generic.as'                   |
* |                       to    'svencoop_addon/scripts/maps'                          |
* |                     - and - 'scripts/maps/neo/globaltest.as'                       |
* |                       to    'svencoop_addon/scripts/maps/neo'.                     |
* |------------------------------------------------------------------------------------|
* | 2. Use this script as the main map script file for your maps and                   |
* |    add to your map config (maps/<your-map>.cfg) the following lines:               |
* |                                                                                    |
* |   map_script globaltest_generic                                                    |
* |====================================================================================|
* | Global State Manager Test - say chat commands in 'map script' mode:                |
* |------------------------------------------------------------------------------------|
* | get a global state:  .global get [global state name]                               |
* | set a global state:  .global set [global state name] [on¦off¦dead]                 |
* |                      .global set [global state name] [map name] [on¦off¦dead]      |
* |====================================================================================|
*/

#include "neo/globaltest"

void MapInit()
{
	GlobalTest::g_GlobalTest.OnMapInit();
}
