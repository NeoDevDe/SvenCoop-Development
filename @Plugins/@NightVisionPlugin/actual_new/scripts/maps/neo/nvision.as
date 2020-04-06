/*
* |====================================================================================|
* | O P P O S I N G  F O R C E   N I G H T  V I S I O N   [#include version]           |
* | Author:  Neo (Discord: NEO) Version: V1.81 / © 2020                                |
* | Credits: NERO (Night Vision initial basic plugin script version)                   |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC        |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)               |
* |====================================================================================|
* | This map script enables the Opposing Force style NightVision view mode             |
* |====================================================================================|
* | Map script install instructions:                                                   |
* |------------------------------------------------------------------------------------|
* | 1. Extract the map script 'scripts/maps/neo/nvision.as'                            |
* |                       to 'svencoop_addon/scripts/maps/neo'.                        |
* |------------------------------------------------------------------------------------|
* | 2. Add to main map script the following code:                                      |
* |                                                                                    |
* |   (a) #include "neo/nvision"                                                       |
* |                                                                                    |
* |   (b) In function 'MapInit()':                                                     |
* |       NightVision::g_NightVision.OnMapInit();                                      |
* |====================================================================================|
* | Usage NightVision:                                                                 |
* |------------------------------------------------------------------------------------|
* | Simply use standard flash light key to switch the                                  |
* | NightVision view mode on and off                                                   |
* |====================================================================================|
* | Note to additional usable NightVision functions:                                   |
* |------------------------------------------------------------------------------------|
* | - For NightVision with say chat commands use:                                      |
* |  NightVision::g_NightVision.OnMapInit(true, true);                                 |
* |       [NV enable (true=on/false=off )--^] [^-- say chat cmd's (true=on/false=off)] |
* |------------------------------------------------------------------------------------|
* | - To enable call the function:    NightVision::g_NightVision.Enable();             |
* | - To disable call the function:   NightVision::g_NightVision.Disable();            |
* | - To check the status use:        if(NightVision::g_NightVision.IsEnabled()) {}    |
* | - To change the night vision color:                                                |
* |                      NightVision::g_NightVision.NVsetColor( Vector(0,255,0) );     |
* |              - or -  NightVision::g_NightVision.NVsetColor( NightVision::GREEN );  |
* |====================================================================================|
* | NightVision say chat commands: (if say chat commands are activated)                |
* |------------------------------------------------------------------------------------|
* | => To show activation status enter:  /nvis                                         |
* | => To enable  NightVision enter:     /nvis on    or   /nvison   (admin only)       |
* | => To disable NightVision enter:     /nvis off   or   /nvisoff  (admin only)       |
* |====================================================================================|
* | NightVision activation from map cfg file ('<map-name>.cfg'):                       |
* |------------------------------------------------------------------------------------|
* | => To enable  NightVision add:  as_command nvision 1                               |
* | => To disable NightVision add:  as_command nvision 0                               |
* |====================================================================================|
*/


namespace NightVision
{
// Predefine Colors
Vector NV_DEFAULT	= Vector(  0,255,  0);
Vector RED    		= Vector(255,  0,  0);
Vector RED2    		= Vector(255, 64, 64);
Vector GREEN  		= Vector(  0,255,  0);
Vector GREEN2  		= Vector(128,255,  0);
Vector GREEN_DARK	= Vector( 64,255,  0);
Vector BLUE			= Vector(  0,  0,255);
Vector CYAN			= Vector(  0,160,192);
Vector YELLOW		= Vector(255,255,  0);
Vector YELLOW2		= Vector(255,216,  0);
Vector ORANGE		= Vector(255,127,  0);
Vector ORANGE2		= Vector(255,170,  0);
Vector PURPLE		= Vector(127,  0,255);
Vector PINK			= Vector(255,  0,127);
Vector TEAL			= Vector(  0,255,255);
Vector WHITE		= Vector(255,255,255);
Vector BLACK		= Vector(  0,  0,  0);
Vector GRAY			= Vector(127,127,127);


NightVision@ g_NightVision = @NightVision();


void NightVisionCVar(CCVar@ cvar, const string& in szOldValue, float flOldValue)
{
	g_NightVision.CVar(cvar, szOldValue, flOldValue);
}


final class NightVision
{
	private string m_szSndHudNV  = "player/hud_nightvision.wav";
	private string m_szSndFLight = "items/flashlight2.wav";
	private Vector m_vColor = NV_DEFAULT;
	private float  m_flVolume = 0.8f;
	private int    m_iRadius = 42;
	private int    m_iLife	= 2;
	private int    m_iDecay = 1;
	private float  m_flFadeTime = 0.01f;
	private float  m_flFadeHold = 0.5f;
	private int    m_iFadeAlpha = 64;
	private bool   m_bHookPlayerInitialized = false;
	private bool   m_bHookSayInitialized=false;
	private bool   m_bHookWTAInitialized=false;
	private CCVar@ m_ccvarEnabled;
	private dictionary m_dPlayer;
	private CScheduledFunction@ m_pThinkFunc = null;

	NightVision()
	{
		@m_ccvarEnabled = CCVar( "nvision", 0, "nightvision enabled", ConCommandFlag::None, @NightVisionCVar);
	}

	private void RegisterHooks(bool bEnableSay=false)
	{
		if(!m_bHookPlayerInitialized)
		{
			g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, ClientPutInServerHook(this.OnPlayerClient));
			g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect,  ClientDisconnectHook(this.OnPlayerClient));
			g_Hooks.RegisterHook(Hooks::Player::PlayerKilled,      PlayerKilledHook(this.OnPlayerKilled));
			m_bHookPlayerInitialized = true;
		}
		if(bEnableSay and !m_bHookSayInitialized)
		{
			g_Hooks.RegisterHook(Hooks::Player::ClientSay,         ClientSayHook(this.OnClientSay));
			m_bHookSayInitialized = true;
		}
	}

	void OnMapInit(bool bEnable=true, bool bEnableSay=false)
	{
		g_SoundSystem.PrecacheSound(m_szSndHudNV);
		g_SoundSystem.PrecacheSound(m_szSndFLight);

		RegisterHooks(bEnableSay);

		if(bEnable)
			Enable();
	}

	bool IsEnabled()	{ return  (m_ccvarEnabled.GetInt() != 0); }
	void Disable()		{ m_ccvarEnabled.SetInt(0); }
	void Enable()		{ m_ccvarEnabled.SetInt(1); }
	void EnableTA()		{ m_ccvarEnabled.SetInt(2); } // experimental Tertiary Key support // (probls with weapon tertiary action i.e. Crowbar)
	int  GetMode()	    { int mode = m_ccvarEnabled.GetInt(); return  ( (mode < 0 or mode > 2) ? 1 : mode); }

	HookReturnCode OnPlayerClient(CBasePlayer@ pPlayer)
	{
		if(pPlayer !is null)	
			NVoff(pPlayer);

		return HOOK_CONTINUE;
	}

	HookReturnCode OnPlayerKilled(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib)
	{
		return OnPlayerClient(pPlayer);
	}

	HookReturnCode OnClientSay(SayParameters@ pParams)
	{
		CBasePlayer@ plr = pParams.GetPlayer();
		const CCommand@ args = pParams.GetArguments();
		if(args[0] == "/nvis")
		{
			if (args.ArgC() < 2)
			{
				switch(GetMode())
				{
					case 0:	g_PlayerFuncs.ClientPrint(plr, HUD_PRINTTALK, "Nightvision is disabled\n");							break;
					case 1:	g_PlayerFuncs.ClientPrint(plr, HUD_PRINTTALK, "Nightvision with flash lamp key is enabled\n");		break;
					case 2: g_PlayerFuncs.ClientPrint(plr, HUD_PRINTTALK, "Nightvision with tertiary attack key is enabled\n"); break;
				}
			}
			else if (g_PlayerFuncs.AdminLevel(plr) < ADMIN_YES)
				g_PlayerFuncs.ClientPrint(plr, HUD_PRINTTALK, "You don't have access to that command.\n");
			else if(args[1] == "off")
			{
				Disable();
				g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Nightvision is disabled\n");
			}
			else if(args[1] == "on")
			{
				Enable();
				g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Nightvision with flash lamp key is enabled\n");
			}
			else if(args[1] == "onta")  // experimental Tertiary Key support // (probls with weapon tertiary action i.e. Crowbar)
			{
				EnableTA();
				g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Nightvision with tertiary attack key is enabled\n");
			}
			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/nvisoff")
		{
			if (g_PlayerFuncs.AdminLevel(plr) < ADMIN_YES)
				g_PlayerFuncs.ClientPrint(plr, HUD_PRINTTALK, "You don't have access to that command.\n");
			else
			{
				Disable();
				g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Nightvision is disabled\n");
			}
			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/nvison")
		{
			if (g_PlayerFuncs.AdminLevel(plr) < ADMIN_YES)
				g_PlayerFuncs.ClientPrint(plr, HUD_PRINTTALK, "You don't have access to that command.\n");
			else
			{
				Enable();
				g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Nightvision with flash lamp key is enabled\n");
			}
			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		else if(args[0] == "/nvisonta")  // experimental Tertiary Key support // (probls with weapon tertiary action i.e. Crowbar)
		{
			if (g_PlayerFuncs.AdminLevel(plr) < ADMIN_YES)
				g_PlayerFuncs.ClientPrint(plr, HUD_PRINTTALK, "You don't have access to that command.\n");
			else
			{
				EnableTA();
				g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Nightvision with tertiary attack key is enabled\n");
			}
			pParams.ShouldHide = true;
			return HOOK_HANDLED;
		}
		return HOOK_CONTINUE;
	}

	void CVar(CCVar@ cvar, string& in szOldValue, float flOldValue)
	{
		if(cvar.GetInt() != 0) // enabled ?!
		{
			if(cvar.GetInt() == 2) // experimental weapon tertiary attack key support
				g_Hooks.RegisterHook(Hooks::Weapon::WeaponTertiaryAttack, WeaponTertiaryAttackHook(this.OnWeaponTertiaryAttack));

			@m_pThinkFunc = g_Scheduler.SetInterval(@this, "Think", 0.05f);
		}
		else if(m_pThinkFunc !is null)
		{
			g_Scheduler.RemoveTimer(m_pThinkFunc);
			@m_pThinkFunc = null;
		}
		Think(); // switch off night vision effect for all
	}

	bool NVsetColor(Vector vColor = NV_DEFAULT)
	{
		if(vColor.x < 0 or vColor.x > 255 or vColor.y < 0 or vColor.y > 255 or vColor.z < 0 or vColor.z > 255)
			return false;
		
		m_vColor = vColor;
		return true;
	}

	private bool NVactivated(CBasePlayer@ pPlayer)
	{
		string szSteamId = g_EngineFuncs.GetPlayerAuthId( pPlayer.edict() );
		return m_dPlayer.exists(szSteamId);
	}

	private void NVon(CBasePlayer@ pPlayer)
	{
		string szSteamId = g_EngineFuncs.GetPlayerAuthId( pPlayer.edict() );
		if(!m_dPlayer.exists(szSteamId)) 
		{
			m_dPlayer[szSteamId] = true;
			g_PlayerFuncs.ScreenFade( pPlayer, m_vColor, m_flFadeTime, m_flFadeHold, m_iFadeAlpha, FFADE_OUT | FFADE_STAYOUT);
			g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_WEAPON, m_szSndHudNV, m_flVolume, ATTN_NORM, 0, PITCH_NORM );
		}

		Vector vecSrc = pPlayer.EyePosition();
		NetworkMessage netMsg( MSG_ONE, NetworkMessages::SVC_TEMPENTITY, pPlayer.edict() );
		netMsg.WriteByte( TE_DLIGHT );
		netMsg.WriteCoord( vecSrc.x );
		netMsg.WriteCoord( vecSrc.y );
		netMsg.WriteCoord( vecSrc.z );
		netMsg.WriteByte( m_iRadius );
		netMsg.WriteByte( int(m_vColor.x) );
		netMsg.WriteByte( int(m_vColor.y) );
		netMsg.WriteByte( int(m_vColor.z) );
		netMsg.WriteByte( m_iLife );
		netMsg.WriteByte( m_iDecay );
		netMsg.End();
	}

	private void NVoff(CBasePlayer@ pPlayer)
	{
		string szSteamId = g_EngineFuncs.GetPlayerAuthId( pPlayer.edict() );
		if(m_dPlayer.exists(szSteamId))
		{
			g_PlayerFuncs.ScreenFade( pPlayer, m_vColor, m_flFadeTime, m_flFadeHold, m_iFadeAlpha, FFADE_IN);
			g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_WEAPON, m_szSndFLight, m_flVolume, ATTN_NORM, 0, PITCH_NORM );
			m_dPlayer.delete(szSteamId);
		}
	}

	HookReturnCode OnWeaponTertiaryAttack(CBasePlayer@ pPlayer, CBasePlayerWeapon@ pWeapon)
	{	 // experimental Tertiary Key support // (probls with weapon tertiary action i.e. Crowbar)
		if(GetMode() == 2)
		{
			if(!NVactivated(pPlayer))	NVon(pPlayer);
			else						NVoff(pPlayer);
			return HOOK_HANDLED;
		}
		return HOOK_CONTINUE;
	}

	void Think()
	{
		for ( int i = 1; i <= g_Engine.maxClients; ++i )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
			if ( pPlayer !is null and pPlayer.IsConnected() and pPlayer.IsAlive())
			{
				switch(GetMode())
				{
					case 0:		NVoff(pPlayer);
								break;
					case 1: 	if(pPlayer.FlashlightIsOn())
								{
									pPlayer.FlashlightTurnOff();
									if(!NVactivated(pPlayer))	NVon(pPlayer);
									else						NVoff(pPlayer);
									break;
								}
					case 2:		if(NVactivated(pPlayer))	NVon(pPlayer);
								else						NVoff(pPlayer);
								break;
				}
			}
		}
	}

	private void UnRegisterHooks()
	{
		if(m_bHookPlayerInitialized)
		{
			g_Hooks.RemoveHook(Hooks::Player::ClientPutInServer, ClientPutInServerHook(this.OnPlayerClient));
			g_Hooks.RemoveHook(Hooks::Player::ClientDisconnect,  ClientDisconnectHook(this.OnPlayerClient));
			g_Hooks.RemoveHook(Hooks::Player::PlayerKilled,      PlayerKilledHook(this.OnPlayerKilled));
			m_bHookPlayerInitialized = false;
		}
		if(m_bHookSayInitialized)
		{
			g_Hooks.RemoveHook(Hooks::Player::ClientSay,         ClientSayHook(this.OnClientSay));
			m_bHookSayInitialized = false;
		}
		if(m_pThinkFunc !is null)
		{
			g_Scheduler.RemoveTimer(m_pThinkFunc);
			@m_pThinkFunc = null;
		}
		if(m_bHookWTAInitialized)
		{
			g_Hooks.RemoveHook(Hooks::Weapon::WeaponTertiaryAttack, WeaponTertiaryAttackHook(this.OnWeaponTertiaryAttack));
			m_bHookWTAInitialized = false;
		}
		m_dPlayer.deleteAll();
	}

	~NightVision()
	{
		UnRegisterHooks();
	}
}

}