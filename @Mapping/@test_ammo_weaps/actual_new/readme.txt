Sven Co-op - TEST AMMO & WEAPONS - Map and map Script
=====================================================

General Information:
--------------------
Date:	 October, 10th, 2019
Author:	 Neo (Dicord: 'Sven Co-op' Server - Neo)
Title:	 Test Ammo & Weapons map Script for Sven Co-op V5.20
Version: V1.10 © 2019
License: This code is protected and licensed with Creative Commons 3.0 - NC
	 (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)


Test Ammo & Weapons Map and map Script Information
----------------------------------------------------------
This Map and map script is for testing and analysis of weapon ammo indexes.

The Map and map Script are developed as a ready-to-run version.


Test Ammo & Weapons - installing and usage instructions
---------------------------------------------------------------
1. Extract the folders 'maps' and 'scripts'
                    to 'svencoop_addon/...'.

2. Start Sven Co-op Client and enter in console for start one of the maps:

   (a)  map test_ammo_weaps		[<= for sstandard weapons]
   (b)  map test_ammo_weaps_th		[<= for sstandard & they hunger weapons]

Test Ammo & Weapons - Usage of test map
----------------------------------------
Start map, equip weapons/ammo in map and
enter say chat commands for analysis.


Test Ammo & Weapons - say chat commands:
-----------------------------------------------------------------------------
 /help         : help with available say chat commands
 /giveall      : give all weapons
 /dropall      : remove all weapons
 /equip        : 
 /equipedweaps : show data of equiped weapons
 /extraweaps   : equip weapon_clock, weapon_mp5, weapon_python and weapon_saw
 /ammodefs     : show generic known ammo definitions in SC
 /customweap 'weapon_???' : show data of equiped custom weapon (equip 1st !)
 /customammo '?????'  : show custom ammo definition (need weeapon/ammo addon)


Test Ammo & Weapons - usage of custom TH weapons in map editor:
-----------------------------------------------------------------------------
Use 'hunger.fgd' in your favorite map editor to add TH weapons in a map.


Identified SC server AS function Bugs which happens with registered TH weapons:
-------------------------------------------------------------------------------
NOTE: function 'g_PlayerFuncs.GetAmmoIndex('<ammo name>') is bugged !
It works correctly, if no custom entites are registered. After registering
of TH weapons, this function does not return for all valid ammo type a valid index.
But with command '/giveall' and '/equipedweaps' all ammo types with indexes will be displayed.
