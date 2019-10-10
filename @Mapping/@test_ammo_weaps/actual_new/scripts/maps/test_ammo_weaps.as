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


const array<string> TEST_AMMO_WEAPON_NAMES = {
	"weapon_medkit",	"weapon_9mmhandgun", "weapon_9mmAR", "weapon_uzi", "weapon_glock", "weapon_mp5",
	"weapon_357", "weapon_eagle", "weapon_python",
	"weapon_shotgun",
	"weapon_crossbow",
	"weapon_m16", "weapon_m249", "weapon_minigun", "weapon_saw",
	"weapon_rpg",
	"weapon_displacer", "weapon_egon", "weapon_gauss",
	"weapon_hornetgun",
	"weapon_handgrenade",
	"weapon_satchel",
	"weapon_tripmine",
	"weapon_snark",
	"weapon_sniperrifle",
	"weapon_sporelauncher",
	"weapon_shockrifle"
};


const array<string> TEST_AMMO_TYPE_NAMES = {
	"health"
	"9mm",
	"357",
	"buckshot",
	"bolts",
	"556",
	"ARgrenades",
	"rockets",
	"uranium",
	"Hornets",
	"Hand Grenade",
	"Satchel Charge",
	"Trip Mine",
	"Snarks",
	"m40a1",
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
			g_PlayerFuncs.SayText(plr, "/equipedweaps : show data of equiped weapons\n");
			g_PlayerFuncs.SayText(plr, "/extraweaps   : equip weapon_clock, weapon_mp5, weapon_python and weapon_saw\n");
			g_PlayerFuncs.SayText(plr, "/ammodefs     : show generic known ammo definitions in SC\n");
			g_PlayerFuncs.SayText(plr, "/customweap 'weapon_???' : show data of equiped custom weapon (equip 1st !)\n");
			g_PlayerFuncs.SayText(plr, "/customammo '?????'  : show custom ammo definition (need weeapon/ammo addon)\n");

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
											 ("' Primary ammo ['" + weapon.pszAmmo2() + "', idx=" + weapon.SecondaryAmmoIndex() + ", max=" + weapon.iMaxAmmo2() + "]" + "\n")));
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
											 ("' Primary ammo ['" + weapon.pszAmmo2() + "', idx=" + weapon.SecondaryAmmoIndex() + ", max=" + weapon.iMaxAmmo2() + "]" + "\n")));
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
