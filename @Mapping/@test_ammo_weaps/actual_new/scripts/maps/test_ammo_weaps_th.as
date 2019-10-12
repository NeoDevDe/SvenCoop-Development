/*
* |==================================================================================|
* | T E S T   A M M O   &   W E A P O N S  (with hunger weaps)  [standalone version] |
* | Author: Neo (Discord: NEO) Version: V1.10                                        |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC      |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)             |
* |==================================================================================|
* | This map script is for testing and analysis of weapon ammo indexes               |
* |==================================================================================|
* | Map script install instructions:                                                 |
* |----------------------------------------------------------------------------------|
* | 1. Extract the files 'maps/test_ammo_weaps.bsp'                                  |
* |                  and 'scripts/maps/test_ammo_weaps.as.as'                        |
* |                   to 'svencoop_addon/...'.                                       |
* |----------------------------------------------------------------------------------|
* | 2. Start Sven Co-op Client and enter in console for start:                       |
* |                                                                                  |
* |   map test_ammo_weaps                                                            |
* |==================================================================================|
* | Included are the following say chat commands                                     |
* |----------------------------------------------------------------------------------|
* | /help         : help with available say chat commands                            |
* | /giveall      : give all weapons\n");                                            |
* | /dropall      : remove all weapons\n");                                          |
* | /equip  ????? : Equip item                                                       |
* | /equipedweaps : show data of equiped weapons                                     |
* | /extraweaps   : equip weapon_clock, weapon_mp5, weapon_python and weapon_saw     |
* | /ammodefs     : show generic known ammo definitions in SC                        |
* | /customweap 'weapon_???' : show data of equiped custom weapon (equip 1st !)      |
* | /customammo '?????'  : show custom ammo definition (need weeapon/ammo addon)     |
* |==================================================================================|
*/


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


const array<string> TEST_AMMO_WEAPON_NAMES = {
	"weapon_sawedoff",    "weapon_shotgun",
	"weapon_m16",         "weapon_m16a1", "weapon_m249",     "weapon_minigun", "weapon_saw",
	"weapon_9mmhandgun",  "weapon_9mmAR", "weapon_colt1911", "weapon_glock",
	"weapon_greasegun",   "weapon_mp5",   "weapon_tommygun", "weapon_uzi",
	"weapon_sniperrifle", "weapon_m14",
	"weapon_displacer",   "weapon_egon",  "weapon_gauss",    "weapon_teslagun",
	"weapon_medkit",	"weapon_357",         "weapon_eagle", "weapon_python",
	"weapon_crossbow",
	"weapon_rpg",
	"weapon_hornetgun",
	"weapon_handgrenade",
	"weapon_satchel",
	"weapon_tripmine",
	"weapon_snark",
	"weapon_sporelauncher",
	"weapon_shockrifle"
};


const array<string> TEST_AMMO_TYPE_NAMES = {
	"buckshot",
	"556",
	"9mm",
	"m40a1",
	"uranium",
	"health"
	"357",
	"bolts",
	"ARgrenades",
	"rockets",
	"Hornets",
	"Hand Grenade",
	"Satchel Charge",
	"Trip Mine",
	"Snarks",
	"sporeclip",
	"shock charges"
};


TestAmmoWeaps@ g_NightVision = @TestAmmoWeaps();


final class TestAmmoWeaps
{
	TestAmmoWeaps()
	{
		g_Hooks.RegisterHook(Hooks::Player::ClientSay, ClientSayHook(this.OnClientSay));
	}

	HookReturnCode OnClientSay(SayParameters@ pParams)
	{
		CBasePlayer@ plr = pParams.GetPlayer();
		const CCommand@ args = pParams.GetArguments();
		if(args[0] == "/help")
		{
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "Command Help\n");
			g_PlayerFuncs.SayText(plr, "============\n");
			g_PlayerFuncs.SayText(plr, "/giveall      : give all weapons\n");
			g_PlayerFuncs.SayText(plr, "/dropall      : remove all weapons\n");
			g_PlayerFuncs.SayText(plr, "/equip  ????? : Equip item\n");
			g_PlayerFuncs.SayText(plr, "/equipedweaps : show data of equiped weapons\n");
			g_PlayerFuncs.SayText(plr, "/extraweaps   : equip weapon_clock, weapon_mp5, weapon_python and weapon_saw\n");
			g_PlayerFuncs.SayText(plr, "/ammodefs     : show generic known ammo definitions in SC\n");
			g_PlayerFuncs.SayText(plr, "/customweap  weapon_???  : show data of equiped custom weapon (equip 1st !)\n");
			g_PlayerFuncs.SayText(plr, "/customammo  ?????       : show custom ammo definition (need weeapon/ammo addon)\n");

			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/giveall")
		{
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "Give all Weapons\n");

			for(uint i = 0; i < TEST_AMMO_WEAPON_NAMES.length(); i++)
				plr.GiveNamedItem(TEST_AMMO_WEAPON_NAMES[i]);

			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/dropall")
		{
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "Remove all Weapons\n");

			plr.RemoveAllItems(false);

			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/equip")
		{
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "\n");
			if (args.ArgC() < 2)
				g_PlayerFuncs.SayText(plr, "*** No item name specified ***\n");
			else
			{
				plr.GiveNamedItem(args[1]);
				CBasePlayerWeapon@ weapon =  cast<CBasePlayerWeapon@>(@plr.HasNamedPlayerItem(args[1]));
				if(weapon is null)
					g_PlayerFuncs.SayText(plr, "*** item '" + args[1] + "' hasn't been equiped ***\n");
				else
				{
					g_PlayerFuncs.SayText(plr, "Custom Item Data\n");
					g_PlayerFuncs.SayText(plr, "==================\n");
					g_PlayerFuncs.SayText(plr,
											 "Item '" + args[1] +
											 "' => Primary ammo ['" + weapon.pszAmmo1() + "', idx=" + weapon.PrimaryAmmoIndex() + ", max=" + weapon.iMaxAmmo1() + "]" +
											((weapon.SecondaryAmmoIndex() < 0) ? "\n" :
											 ("' Secondary ammo ['" + weapon.pszAmmo2() + "', idx=" + weapon.SecondaryAmmoIndex() + ", max=" + weapon.iMaxAmmo2() + "]" + "\n")));
				}
			}

			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/equipedweaps")
		{
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "Show Weapon Ammo List\n");
			g_PlayerFuncs.SayText(plr, "=====================\n");

			for(uint i = 0; i < TEST_AMMO_WEAPON_NAMES.length(); i++)
			{
				CBasePlayerWeapon@ weapon =  cast<CBasePlayerWeapon@>(@plr.HasNamedPlayerItem(TEST_AMMO_WEAPON_NAMES[i]));
				if(weapon !is null)
				{
					g_PlayerFuncs.SayText(plr,
											 "weapon '" + TEST_AMMO_WEAPON_NAMES[i] +
											 "' => Primary ammo ['" + weapon.pszAmmo1() + "', idx=" + weapon.PrimaryAmmoIndex() + ", max=" + weapon.iMaxAmmo1() + "]" +
											((weapon.SecondaryAmmoIndex() < 0) ? "\n" :
											 ("' Secondary ammo ['" + weapon.pszAmmo2() + "', idx=" + weapon.SecondaryAmmoIndex() + ", max=" + weapon.iMaxAmmo2() + "]" + "\n")));
				}
			}

			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/extraweaps")
		{
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "Adding extra Weapons\n");

			plr.GiveNamedItem("weapon_glock");
			plr.GiveNamedItem("weapon_mp5");
			plr.GiveNamedItem("weapon_python");
			plr.GiveNamedItem("weapon_saw");

			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/ammodefs")
		{
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "Show Ammo Definition List\n");
			g_PlayerFuncs.SayText(plr, "=========================\n");

			// NOTE: function 'g_PlayerFuncs.GetAmmoIndex('<ammo name>') is bugged !
			// It works correctly, if no custom entites are registered. After registering
			// of TH weapons, this function does not return for all valid ammo type a valid index.
			// But with command '/giveall' and '/equipedweaps' all ammo types with indexes will be displayed.
			for(uint i = 0; i < TEST_AMMO_TYPE_NAMES.length(); i++)
				if(g_PlayerFuncs.GetAmmoIndex(TEST_AMMO_TYPE_NAMES[i]) >= 0)
					g_PlayerFuncs.SayText(plr,	"idx = " + g_PlayerFuncs.GetAmmoIndex(TEST_AMMO_TYPE_NAMES[i]) + " / Ammo name = '" + TEST_AMMO_TYPE_NAMES[i] + "'\n");
			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/customweap")
		{
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "\n");
			if (args.ArgC() < 2)
				g_PlayerFuncs.SayText(plr, "*** No custom weapon name specified ***\n");
			else
			{
				CBasePlayerWeapon@ weapon =  cast<CBasePlayerWeapon@>(@plr.HasNamedPlayerItem(args[1]));
				if(weapon is null)
					g_PlayerFuncs.SayText(plr, "*** custom weapon '" + args[1] + "' is not equiped ***\n");
				else
				{
					g_PlayerFuncs.SayText(plr, "Custom Weapon Data\n");
					g_PlayerFuncs.SayText(plr, "==================\n");
					g_PlayerFuncs.SayText(plr,
											 "weapon '" + args[1] +
											 "' => Primary ammo ['" + weapon.pszAmmo1() + "', idx=" + weapon.PrimaryAmmoIndex() + ", max=" + weapon.iMaxAmmo1() + "]" +
											((weapon.SecondaryAmmoIndex() < 0) ? "\n" :
											 ("' Secondary ammo ['" + weapon.pszAmmo2() + "', idx=" + weapon.SecondaryAmmoIndex() + ", max=" + weapon.iMaxAmmo2() + "]" + "\n")));
				}
			}

			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/customammo")
		{
			g_PlayerFuncs.SayText(plr, "\n");
			g_PlayerFuncs.SayText(plr, "\n");
			if (args.ArgC() < 2)
				g_PlayerFuncs.SayText(plr, "*** No custom ammo name specified ***\n");
			else
			{
				if(g_PlayerFuncs.GetAmmoIndex(args[1]) == -1)
					g_PlayerFuncs.SayText(plr, "*** custom ammo '" + args[1] + "' is undefined ***\n");
				else
				{
					g_PlayerFuncs.SayText(plr, "Custom Ammo Data\n");
					g_PlayerFuncs.SayText(plr, "================\n");
					g_PlayerFuncs.SayText(plr,	"idx = " + g_PlayerFuncs.GetAmmoIndex(args[1]) + " / Ammo name = '" + args[1] + "'\n");
				}
			}

			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		return HOOK_CONTINUE;
	}

	~TestAmmoWeaps()
	{
		g_Hooks.RemoveHook(Hooks::Player::ClientSay, ClientSayHook(this.OnClientSay));
	}
}
