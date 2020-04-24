Sven Co-op - Global State Manager Test - Plugin/Map Scripts
===========================================================

General Information:
--------------------
Date:	 April, 25h, 2020
Author:	 Neo (Dicord: 'Sven Co-op' Server - Neo)
Title:	 Global State Manager Test plugin/map Script for Sven Co-op V5.22
Version: V1.20 © 2020
License: This code is protected and licensed with Creative Commons 4.0 - CC BY-NC-ND 4.0
	 (refer to https://creativecommons.org/licenses/by-nc-nd/4.0/)


Global State Manager Test  Plugin/Map Script Information
----------------------------------------------------------
This script enables the testing of Global State Manager from plugin and map-script

The Scripts are developed and available in 3 different versions:
 (1.) Plugin script version of Global State Manager Test.
 (2.) Standalone map script version of Global State Manager Test.
 (3.) #include map script version of Global State Manager Test,
      which can be used from other scripts.


Global State Manager Test - installing and usage instructions
---------------------------------------------------------------
=> [#include script version 'globaltest.as'] 
   1. Extract the map script 'scripts/maps/neo/globaltest.as'
                          to 'svencoop_addon/scripts/maps/neo'

   2. Add to main map script the following code:
      (a) #include "neo/globaltest"
      (b) In function 'MapInit()':
           GlobalTest::g_GlobalTest.OnMapInit();

=> [standalone script version   'globaltest_generic.as'] 
   1. Extract the map script   'scripts/maps/globaltest_generic.as'
                          to    'svencoop_addon/scripts/maps'
                       - and - 'scripts/maps/neo/globaltest.as'
                          to    'svencoop_addon/scripts/maps/neo'


   2. Use this script as the main map script file for your maps and
      add to your map config (maps/<your-map>.cfg) the following lines:
        map_script globaltest_generic

=> [plugin script version 'globaltest.as'] 
   1. Extract the map script 'scripts/plugin/globaltest.as'
                         and 'scripts/maps/neo/globaltest.as'
                         to  'svencoop_addon/scripts/...'.

   2. Add to configuration file at 'svencoop/default_plugins.txt'
      the following lines:

      "plugin"
      {
         "name" "GlobalTest"
         "script" "globaltest"
         "concommandns" "gt"
      }


Global State Manager Test - say chat commands in 'server plugin' mode:
-----------------------------------------------------------------------------
 get a global state: /global get [global state name]
 set a global state: /global set [global state name] [on¦off¦dead]
                     /global set [global state name] [map name] [on¦off¦dead]

Global State Manager Test - say chat commands in 'map script' mode:
-----------------------------------------------------------------------------
 get a global state: .global get [global state name]
 set a global state: .global set [global state name] [on¦off¦dead]
                     .global set [global state name] [map name] [on¦off¦dead]
