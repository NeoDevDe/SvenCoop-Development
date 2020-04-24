/*
* |====================================================================================|
* | G L O B A L   S T A T E   M A N A G E R   T E S T     [#include version]           |
* | Author:  Neo (Discord: NEO) Version: V1.20 / © 2020                                |
* | License: This code is protected and licensed with Creative Commons 4.0			   |
* | CC BY-NC-ND 4.0 / refer to https://creativecommons.org/licenses/by-nc-nd/4.0/)	   |
* |====================================================================================|
* | This script enables the testing of Global State Manager from plugin and map-script |          |
* |====================================================================================|
* | Map script install instructions:                                                   |
* |------------------------------------------------------------------------------------|
* | 1. Extract the map script 'scripts/maps/neo/globaltest.as'                         |
* |                       to 'svencoop_addon/scripts/maps/neo'.                        |
* |------------------------------------------------------------------------------------|
* | 2. Add to main map script the following code:                                      |
* |                                                                                    |
* |   (a) #include "neo/globaltest"                                                    |
* |                                                                                    |
* |   (b) In function 'MapInit()':                                                     |
* |       GlobalTest::g_GlobalTest.OnMapInit();                                        |
* |====================================================================================|
* | Global State Manager Test - say chat commands in 'server plugin' mode:             |
* |------------------------------------------------------------------------------------|
* | get a global state:  /global get [global state name]                               |
* | set a global state:  /global set [global state name] [on¦off¦dead]                 |
* |                      /global set [global state name] [map name] [on¦off¦dead]      |
* |====================================================================================|
* | Global State Manager Test - say chat commands in 'map script' mode:                |
* |------------------------------------------------------------------------------------|
* | get a global state:  .global get [global state name]                               |
* | set a global state:  .global set [global state name] [on¦off¦dead]                 |
* |                      .global set [global state name] [map name] [on¦off¦dead]      |
* |====================================================================================|
*/

namespace GlobalState /* global_state.as */
{
// GetGlobal return values:
//	const uint GLOBAL_OFF	= 0;
//	const uint GLOBAL_ON	= 1;
//	const uint GLOBAL_DEAD	= 2;
const uint GLOBAL_MAX		= 2;
const uint GLOBAL_UNDEFINED	= 0xFFFF;

const array<string> GLOBAL_STATE_VALUE_NAMES = // array for global state value names 
{
	"GLOBAL_OFF", "GLOBAL_ON", "GLOBAL_DEAD"
};

const bool IsValidGlobalStateValue(uint uState)
{
	return (uState <= GLOBAL_MAX);
}

const string GetGlobalStateValueNameFromUint(uint uState)
{
	return (IsValidGlobalStateValue(uState) ? GLOBAL_STATE_VALUE_NAMES[uState] : "INVALID STATE");
}

const uint GetGlobalStateValueFromString(const string szName)
{
	if(!szName.IsEmpty())
		for(uint u=0; u <= GLOBAL_MAX; u++)
			if(szName == GLOBAL_STATE_VALUE_NAMES[u])
				return u;

	return GLOBAL_ERR_NAME_UNDEF;
}

const string GetGlobalStateValueName(const string szName)
{
	return GetGlobalStateValueNameFromUint(GetGlobalState(szName));
}

const uint GetGlobalState(const string szName)
{
	if(szName.IsEmpty() or !g_GlobalState.EntityInTable(szName))
		return GLOBAL_UNDEFINED;					 // global state does not exists
	else
		return g_GlobalState.EntityGetState(szName); // return global state
}

// SetGlobal return values:
const uint GLOBAL_SUCCESS_NEW		= 0; // no error - new global state added
const uint GLOBAL_SUCCESS_EXISTING	= 1; // no error - existing global state updated
const uint GLOBAL_ERR_NAME_UNDEF	= 2; // global name undefined
const uint GLOBAL_ERR_MAPNAME_UNDEF	= 3; // map name undefined (only map name update function)
const uint GLOBAL_ERR_STATE_UNDEF	= 4; // global state does not exists (only map name update function)
const uint GLOBAL_ERR_CREATE		= 5; // global state creation failed (after global state creation)
const uint GLOBAL_ERR_STATE_DIFF	= 6; // get global state != set global state (actual state != setted state)

const uint SetGlobalState(const string szName, GLOBALESTATE gsState)	// create/update global state
{
	return SetGlobalState(szName, "", gsState);
}

const uint SetGlobalState(const string szName, const string szMapName)	// update map name on existing global state
{
	if(szName.IsEmpty())
		return GLOBAL_ERR_NAME_UNDEF; // global name empty

	if(szMapName.IsEmpty())
		return GLOBAL_ERR_MAPNAME_UNDEF; // map name empty

	if(!g_GlobalState.EntityInTable(szName))
		return GLOBAL_ERR_STATE_UNDEF; // global state does not exists for update

	g_GlobalState.EntityUpdate(szName, szMapName);

	return GLOBAL_SUCCESS_EXISTING; // finished without errors
}

const uint SetGlobalState(const string szName, const string szMapName, GLOBALESTATE gsState)
{
	if(szName.IsEmpty())
		return GLOBAL_ERR_NAME_UNDEF; // global name empty

	if(!g_GlobalState.EntityInTable(szName)) // new global state ?
	{
		g_GlobalState.EntityAdd(szName, szMapName, gsState);
		if(g_GlobalState.EntityGetState(szName) != gsState)
			return GLOBAL_ERR_STATE_DIFF; // get global state != set global state

		return GLOBAL_SUCCESS_NEW;
	}
	else{
		g_GlobalState.EntitySetState(szName, gsState);
		if(g_GlobalState.EntityGetState(szName) != gsState)
			return GLOBAL_ERR_STATE_DIFF;  // get global state != set global state

		if(!szMapName.IsEmpty())
			return SetGlobalState(szName, szMapName); // change map name

		return GLOBAL_SUCCESS_EXISTING;
	}
}
}



namespace GlobalTest
{
// static GlobalTest class instance
GlobalTest@ g_GlobalTest = @GlobalTest();

// GlobalTest class
final class GlobalTest
{
	private bool m_bPlugin			= false;		// flag for map-script / plugin run mode
	private string	szGlobalCmd		= ".global";	// say commands for "global states": map-script with '.' / plugin with '/'
	private string	szCVarCmd		= ".cvar";		// say commands for "cvar's":		 map-script with '.' / plugin with '/'
	private CCVar@	ccvarPlugin		= null;			// call back function for cvars
	private dictionary dGlobalStates;				// dictionary for global states (string to GLOBALESTATE)
	private array<string> aGlobalStates = { "GLOBAL_OFF", "GLOBAL_ON", "GLOBAL_DEAD"}; // array for global states 


	// GlobalTest class constructor
	GlobalTest()
	{
		dGlobalStates["on"]			=  GLOBAL_ON;
		dGlobalStates["off"]		=  GLOBAL_OFF;
		dGlobalStates["dead"]		=  GLOBAL_DEAD;
	}

	void OnPluginInit()
	{
		m_bPlugin	= false;
		szGlobalCmd	=  "/global";
		szCVarCmd	=  "/cvar";
	}

	void OnMapInit()
	{
		g_Hooks.RegisterHook(Hooks::Player::ClientSay, ClientSayHook(this.OnClientSay));
		@ccvarPlugin = CCVar("global_test", "on", "global test plugin run status", ConCommandFlag::None, null);
	}

	HookReturnCode OnClientSay(SayParameters@ pParams)
	{
		CBasePlayer@ plr = pParams.GetPlayer();
		const CCommand@ args = pParams.GetArguments();
		if(args[0] == szGlobalCmd)
		{
			if (args.ArgC() < 2)
			{
				g_PlayerFuncs.SayText(plr, "Global State Manager Test - Command overview\n");
				g_PlayerFuncs.SayText(plr, "-----------------------------------------------------------------\n");
				g_PlayerFuncs.SayText(plr, " " + szGlobalCmd + " get [global state name]\n");
				g_PlayerFuncs.SayText(plr, " " + szGlobalCmd + " set [global state name] [on¦off¦dead]\n");
				g_PlayerFuncs.SayText(plr, " " + szGlobalCmd + " set [global state name] [map name] [on¦off¦dead]\n");
			}
			else 
			{
				if(args[1] == "get")
				{
					if (args.ArgC() < 3) // param global name ?!
					{
						g_PlayerFuncs.SayText(plr, "ERROR: *** Missing 'global state name' !\n");
						g_PlayerFuncs.SayText(plr, "[Help info: ==> Enter a 'string value' for 'global state name']\n");
					}
					else
					{
						const uint uState = GlobalState::GetGlobalState(args[2]);
						if(!GlobalState::IsValidGlobalStateValue(uState))
							g_PlayerFuncs.SayText(plr, "'Global state' with 'global state name' '" + args[2] + "' does not exists !\n");
						else
							g_PlayerFuncs.SayText(plr, "'Global state info's': global name = '" + args[2] +	"', state = '" +
																GlobalState::GetGlobalStateValueNameFromUint(uState) + "'.\n");
					}
				}
				else if(args[1] == "set")
				{
					if (args.ArgC() < 3) // param global name ?!
					{
						g_PlayerFuncs.SayText(plr, "ERROR: *** Missing 'global state name' !\n");
						g_PlayerFuncs.SayText(plr, "[Help info: ==> Enter a 'string value' for 'global state name']\n");
					}
					else if (args.ArgC() < 4) // param global state
					{
						g_PlayerFuncs.SayText(plr, "ERROR: *** Missing new 'global state value' !\n");
						g_PlayerFuncs.SayText(plr, "[Help info: ==> Defined 'global state values' are 'on', 'off' and 'dead']\n");
					}
					else if( (args.ArgC() < 5 and !dGlobalStates.exists(args[3])) or // check param global state value
							(args.ArgC() >= 5 and !dGlobalStates.exists(args[4])) )
					{
						g_PlayerFuncs.SayText(plr, "ERROR: *** Invalid new 'global state value' !\n");
						g_PlayerFuncs.SayText(plr, "[Help info: ==> Defined 'global state values' are 'on', 'off' and 'dead']\n");
					}
					else
					{
						uint result;
						if(args.ArgC() < 5) // map name defined ?
							result = GlobalState::SetGlobalState(args[2], GLOBALESTATE( dGlobalStates[args[3]] )); // no
						else
							result = GlobalState::SetGlobalState(args[2], args[3], GLOBALESTATE( dGlobalStates[args[4]] )); // yes
					
						switch(result) // show result
						{
							case GlobalState::GLOBAL_SUCCESS_NEW:
								g_PlayerFuncs.SayText(plr, "Added new global state with 'global state name' = '" + args[2] + "' " +
														((args.ArgC() < 5) ? "" : ("'map name' = '" + args[3] + "' ")) +
														"to 'global state' = '" + GlobalState::GetGlobalStateValueName(args[2]) + "'\n");
								break;
							case GlobalState::GLOBAL_SUCCESS_EXISTING:
								g_PlayerFuncs.SayText(plr, "Updated existing global state with 'global state name' = '" + args[2] + "' " +
															((args.ArgC() < 5) ? "" : ("'map name' = '" + args[3] + "' ")) +
															"to 'global state' = '" + GlobalState::GetGlobalStateValueName(args[2]) + "'\n");
								break;
							case GlobalState::GLOBAL_ERR_NAME_UNDEF:
								g_PlayerFuncs.SayText(plr, "ERROR: *** Param global 'global state name' is undefined !\n");
								g_PlayerFuncs.SayText(plr, "[Help info: ==> Check param 'global state name' on function call of 'SetGlobalState()'.");
								break;
							case GlobalState::GLOBAL_ERR_MAPNAME_UNDEF:
								g_PlayerFuncs.SayText(plr, "ERROR: *** Param 'global state map name' is undefined !\n");
								g_PlayerFuncs.SayText(plr, "[Help info: ==> Check param 'global state map name' on function call of 'SetGlobalState()'.");
								break;
							case GlobalState::GLOBAL_ERR_STATE_UNDEF:
								g_PlayerFuncs.SayText(plr, "ERROR: *** GLobal state with name = '" + args[2] + "' does not exists *** !\n");
								break;
							case GlobalState::GLOBAL_ERR_CREATE:
								g_PlayerFuncs.SayText(plr, "ERROR: *** Creation of gobal state with name = '" + args[2] + "' has failed *** !\n");
								break;
							case GlobalState::GLOBAL_ERR_STATE_DIFF:
								g_PlayerFuncs.SayText(plr, "ERROR: *** Gobal state Mismatch. Actual global state differs from setted global state *** !\n");
								break;
							default:
								g_PlayerFuncs.SayText(plr, "ERROR: *** Unknown error code " + result + " *** !\n");
								break;
						}
					}
				}
				else
					g_PlayerFuncs.SayText(plr, "ERROR: *** Invalid sub command !\n[Help info: ==>Defined sub commands are: 'get' and 'set']\n");

			}
			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		return HOOK_CONTINUE;
	}

	~GlobalTest() { g_Hooks.RemoveHook(Hooks::Player::ClientSay, ClientSayHook(this.OnClientSay)); }
}
}