Sven Co-op - ITEM_HEALTHCHARGER - MAP SCRIPT
============================================

General Information:
--------------------
Date:	 October, 11th, 2019
Author:	 Neo (Dicord: 'Sven Co-op' Server - Neo)
Credits: supadupaplex (V1.00 / techical HL protype included in decay maps)
Title:	 item_healthcharger Entity for Sven Co-op V5.20
Version: BETA (with bugs) / © 2019
License: This code is protected and licensed with Creative Commons 3.0 - NC
	 (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)


item_healthcharger Entity - Map Script Information
--------------------------------------------------
The item_healthcharger entity map script enables an alternative health charger station.

Included are an #include version of the item_healthcharger entity, a main map script for
the charger test map, the test map with .cfg file and several other needed runtime files.


item_healthcharger Entity - installing and usage instructions
-------------------------------------------------------------
1. Extract folders 'maps', 'models', 'scripts' and 'sound'
                to 'svencoop_addon/...'.

2. Start Sven Co-op Client and enter in console for start:

     map test_chargers


DEVELOPMENT on Hold, because of item_healthcharger function problems
--------------------------------------------------------------------
The development of this script is on HOLD, because entities of type
'item_healthcharger' are only working in DECAY maps ('dy_xxx.bsp')
but in test map 'test_chargers' is a render problem with healthcharger body.

Tried to get it running with folloowing useless additions:
 - modified entity placement std. for item_healthcharger equal to test map
 - copied all from decay map .cfg files into test map .cfg (incl. global sound setting).
 - copied all from decay main map scripts into main test map script.
 - copied all map settings from class 'worldspawn' into test map class 'worldspawn'.

Result: Bug gets not fixed ! => Developmeent on hold !


IF someone has an idea, how to fix the problem,
please contact me over SC forum in discord....
