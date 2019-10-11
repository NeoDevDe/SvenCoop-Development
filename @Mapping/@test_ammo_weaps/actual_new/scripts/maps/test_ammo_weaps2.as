/*
* |==============================================================================|
* | T E S T   A M M O   &   W E A P O N S   [standalone version]                 |
* | Author: Neo (Discord: NEO) Version: V1.00                                    |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC  |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)         |
* |==============================================================================|
* | This map script is for testing and analysis of weapon ammo indexes           |
* |==============================================================================|
* | Map script install instructions:                                             |
* |------------------------------------------------------------------------------|
* | 1. Extract the files 'maps/test_ammo_weaps.bsp'                              |
* |                  and 'scripts/maps/test_ammo_weaps.as.as'                    |
* |                   to 'svencoop_addon/...'.                                   |
* |------------------------------------------------------------------------------|
* | 2. Start Sven Co-op Client and enter in console for start:                   |
* |                                                                              |
* |   map test_ammo_weaps                                                        |
* |==============================================================================|
* | Included are the following say chat commands                                 |
* |------------------------------------------------------------------------------|
* | /help         : help with available say chat commands                        |
* | /equipedweaps : show data of equiped weapons                                 |
* | /extraweaps   : equip weapon_clock, weapon_mp5, weapon_python and weapon_saw |
* | /ammodefs     : show generic known ammo definitions in SC                    |
* | /customweap 'weapon_???' : show data of equiped custom weapon (equip 1st !)  |
* | /customammo '?????'  : show custom ammo definition (need weeapon/ammo addon) |
* |==============================================================================|
*/

#include "test_ammo_weaps"
#include "hunger/th_weapons"


void MapInit()
{
	THWeaponSawedoff::Register();
	THWeaponM16A1::Register();
	THWeaponM1911::Register();
	THWeaponThompson::Register();
	THWeaponM14::Register();
	THWeaponTeslagun::Register();
	THWeaponGreasegun::Register();
	THWeaponSpanner::Register();
}

