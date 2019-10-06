/*
* |==================================================================================|
* | C R O U C H   S P A W N  -  MAP SCRIPT   [standalone/#include version]           |
* | Author:   Neo (Discord: NEO) Version: V1.41 / © 2019                             |
* | Credits:  H2                 Version: V1.00 (initial implementation script)      |                                                  |
* | License:  This code is protected and licensed with Creative Commons 3.0 - NC     |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)             |
* |==================================================================================|
* | The Crouch Spawn map script addition allows players to spawn inside areas, where |
* | you must be crouched where they would otherwise be stuck clipping the walls.     |
* |                                                                                  |
* | The script is enabled by default and forces the player to                        |
* | crouch when spawned inside the area and prevents being stuck.                    |
* |==================================================================================|
* | Map script install instructions:                                                 |
* |----------------------------------------------------------------------------------|
* | 1. Extract the map script 'scripts/maps/neo/crouch_spawn.as' to                  |
* |                           'svencoop_addon/scripts/maps/neo'.                     |
* |----------------------------------------------------------------------------------|
* | 2. Add to main map script the following code:                                    |
* |                                                                                  |
* |      #include "neo/crouch_spawn"                                                 |
* |----------------------------------------------------------------------------------|
* | Note: - The Couch Spawn function is enabled by default (no init code needed)     |
* |                                                                                  |
* | Additional usable functions:                                                     |
* |   - To enable call the function:    g_CrouchSpawn.Enable();                      |
* |   - To disable call the function:   g_CrouchSpawn.Disable();                     |
* |   - To check the status use:        if(g_CrouchSpawn.IsEnabled()) {}             |
* |==================================================================================|
* | Usage of CROUCH SPAWN addition in your map                                       |
* |----------------------------------------------------------------------------------|
* | 1st: Locate your spawn area and measure the origin.                              |
* | 2nd: Then, subtract 16 units from the z-axis measurement.                        |
* | 3rd: Save the origin keyvalue.                                                   |
* |==================================================================================|
*/


CrouchSpawn@ g_CrouchSpawn = @CrouchSpawn();


final class CrouchSpawn
{
	private float m_flPlayerZoffset = 36.0f;
	private float m_fPlayerZheight  = 72.0f;
	private bool  m_fbEnabled       = true;

	bool IsEnabled()
	{ 
		return m_fbEnabled;
	}

	void Enable()
	{
		if(!m_fbEnabled)
		{
			g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn, PlayerSpawnHook(this.OnPlayerSpawn));
			m_fbEnabled = true;
		}
	}

	void Disable()
	{
		if(m_fbEnabled)
		{
			g_Hooks.RemoveHook(Hooks::Player::PlayerSpawn, PlayerSpawnHook(this.OnPlayerSpawn));
			m_fbEnabled = false;
		}
	}

    HookReturnCode OnPlayerSpawn(CBasePlayer@ pPlayer)
    {
        if(pPlayer !is null)
		{	// Start from the player's feet and trace 72 units upwards. Ugly as hell but it's good 'nuff.
			Vector vecOrigin    = pPlayer.pev.origin;
				   vecOrigin.z -= m_flPlayerZoffset;
			Vector vecEnd       = vecOrigin;
				   vecEnd.z    += m_fPlayerZheight;

			// Perform the trace and check the trace fraction, we need to crouch if it's below 1.
			TraceResult trPlayer;
			g_Utility.TraceLine(vecOrigin, vecEnd, ignore_monsters, pPlayer.edict(), trPlayer);
			if(trPlayer.flFraction < 1.0f)
			{	// Do the magic trick!
				pPlayer.pev.flags     |= FL_DUCKING;
				pPlayer.pev.view_ofs.z -= 15;
			}
		}
        return HOOK_CONTINUE;
    }
}