/*
* |==============================================================================|
* | A N I M A T E D   W E L C O M E   [#include version]                         |
* | Author: Neo (Discord: NEO) Version: V1.11 / © 2019                           |
* |         Makaber (base script for dynamic_mapvote)                            |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC  |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)         |
* |==============================================================================|
* |This map script enables an dancing Gordon model as a wepon, whis is only      |
* |visible for the player in 1st person mode, if the weapon is active selected.  |
* |==============================================================================|
* |Map script install instructions:                                              |
* |------------------------------------------------------------------------------|
* |1. Extract the map script 'scripts/maps/neo/anim_welcome.as'                  |
* |                       to 'svencoop_addon/scripts/maps/neo'                   |
* |------------------------------------------------------------------------------|
* |2. Extract the welcome model 'models/v_welcome.mdl'                           |
* |                          to 'svencoop_addon/models'                          |
* |------------------------------------------------------------------------------|
* |3. Add to your main map script the following code:                            |
* |                                                                              |
* | (a) #include "neo/anim_welcome"                                              |
* |                                                                              |
* | (b) in function 'MapInit()':                                                 |
* |     RegisterWelcomeAnimation();                                              |
* |------------------------------------------------------------------------------|
* |4. Add to your map config (maps/<your-map>.cfg) the following line:           |
* |                                                                              |
* |   weapon_welcome 1                                                           |
* |==============================================================================|
*/

enum WelcomeAnimation
{
    // Put your animations here. The names on here don't need to match the ones from the model, they just go in the same order as they are on the model
	WELCOME_IDLE = 0
};

class weapon_welcome : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	
	void Spawn()
	{
		self.PrecacheCustomModels();
		g_EntityFuncs.SetModel(self, self.GetW_Model("models/keyT.mdl"));
		self.m_iClip			= -1;
		self.m_flCustomDmg		= self.pev.dmg;
		self.FallInit();// get ready to fall down.
	}

	bool GetItemInfo(ItemInfo& out info)
	{
		info.iMaxAmmo1		= -1;
		info.iMaxAmmo2		= -1;
		info.iMaxClip		= WEAPON_NOCLIP;
		info.iSlot			= 0;
		info.iPosition		= 5;
		info.iWeight		= 0;

		return true;
	}
	
	bool AddToPlayer(CBasePlayer@ pPlayer)
	{
		if(!BaseClass.AddToPlayer(pPlayer))
			return false;

		@m_pPlayer = pPlayer;
		return true;
	}

	float WeaponTimeBase()
	{
		return g_Engine.time; //g_WeaponFuncs.WeaponTimeBase();
	}

	void Holster(int skiplocal /* = 0 */)
	{
		self.m_fInReload = false;// cancel any reload in progress.
		m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase(); 
		m_pPlayer.pev.viewmodel = 0;
	}
	
    void WeaponIdle()
	{
		self.ResetEmptySound();
		if(self.m_flTimeWeaponIdle > WeaponTimeBase())
			return;

		self.SendWeaponAnim(WELCOME_IDLE , 0, 0);
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 18.8; // Change the second Value to the time the animation needs to play

	}

	bool Deploy()
	{
		bool bResult = self.DefaultDeploy(self.GetV_Model("models/v_welcome.mdl"), self.GetP_Model("models/keyT.mdl"), WELCOME_IDLE, "welcome");
		float deployTime = 18.8;
		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + deployTime;
		return bResult;
	}
}

void RegisterWelcomeAnimation()
{
	g_Game.PrecacheModel("models/keyT.mdl");
	g_Game.PrecacheModel("models/v_welcome.mdl");
	g_CustomEntityFuncs.RegisterCustomEntity("weapon_welcome", "weapon_welcome");
	g_ItemRegistry.RegisterWeapon("weapon_welcome", "hl_weapons");
}

void UnRegisterWelcomeAnimation()
{
//	no function for unregister from g_ItemRegistry available
	g_CustomEntityFuncs.UnRegisterCustomEntity("weapon_welcome");
}


