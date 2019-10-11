/*
*  |=============================================================================|
*  | E N V _ S N O W   E N T I T Y  -  M A P   S C R I P T   [#include version]  |
*  | Author:  Neo (Discord: NEO) Version: V1.41 / © 2019                         |
*  | Credits: y00tguy (V1.00 / techical protype with test map)                   |
*  | License: This code is protected and licensed with Creative Commons 3.0 - NC |
*  | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)        |
*  |=============================================================================|
*  | This entity map script enables winter snow weather effects.                 |
*  |=============================================================================|
*  | Map script install instructions:                                            |
*  |-----------------------------------------------------------------------------|
*  | 1. Extract the map script 'scripts/maps/neo/env_snow.as'                    |
*  |                      to  'svencoop_addon/scripts/maps/neo'.                 |
*  |-----------------------------------------------------------------------------|
*  | 2. Add to your main map script the following code:                          |
*  |                                                                             |
*  |    (a) #include "neo/env_snow"                                              |
*  |                                                                             |
*  |    (b) In function 'MapInit()' add the following code:                      |
*  |                                                                             |
*  |          RegisterEnvSnow();                                                 |
*  |-----------------------------------------------------------------------------|
*  | Additional notes to the Usage of 'env_snow' entity in your map              |
*  |-----------------------------------------------------------------------------|
*  | Add the file 'env_snow.fgd' to your favorite map editor                     |
*  | to add the new entity 'env_snow' to your map.                               |
*  |=============================================================================|
*/


const Vector ENV_SNOW_VEC_NULL			= Vector(0, 0, 0);
const string ENV_SNOW_SPR_4				= "sprites/snow4.spr";
const string ENV_SNOW_SPR_8				= "sprites/snow8.spr";
const string ENV_SNOW_SPR_16			= "sprites/snow16.spr";
const string ENV_SNOW_SPR_32			= "sprites/snow32.spr";

const uint   ENV_SNOW_MAX_SIZE			= 4;
const uint   ENV_SNOW_MAX_INTENSITY		= 10;
const float  ENV_SNOW_MIN_RADIUS		= 50;
const float  ENV_SNOW_MIN_SPEED_MULT	= 0.1f;
const float  ENV_SNOW_MAX_SPEED_MULT	= 10.0f;
const float  ENV_SNOW_MAX_Z_RAND_MIN	= 60.0f;
const float  ENV_SNOW_MAX_Z_RAND_MAX	= 650.0f;

const int    FL_ENV_SNOW_START_ON 		= 1;


void RegisterEnvSnow()
{	
	g_CustomEntityFuncs.RegisterCustomEntity( "env_snow", "env_snow" );
}


class EnvSnowCountPlr
{
	private EHandle m_hPlr;
	private uint    m_uParticleCounter = 0;

	EnvSnowCountPlr() 						{}
	EnvSnowCountPlr(CBasePlayer@ pPlr)	{ m_hPlr = EHandle(pPlr); }

	CBasePlayer@ GetPlayer()			{ return cast<CBasePlayer@>( m_hPlr.GetEntity() ); }
	uint GetParticleCounter()			{ return m_uParticleCounter; }

	void ResetParticleCounter()			{ m_uParticleCounter = 0;	 }
	void IncParticleCounter()			{ m_uParticleCounter++;	 }
	void DecParticleCounter()			{ if(m_uParticleCounter > 0)	m_uParticleCounter--; }
	bool CheckParticleCounter()			{ return (m_uParticleCounter < 500 and GetPlayer() !is null); }

	private void te_model(Vector vecPos, Vector vecVelocity, float flYaw=0, string model=ENV_SNOW_SPR_16,
						  uint8 uBounceSound=2, uint8 iLifeTime=32, NetworkMessageDest nmdMsgType=MSG_BROADCAST, edict_t@ pDest=null)
	{
		NetworkMessage nmMessage(nmdMsgType, NetworkMessages::SVC_TEMPENTITY, pDest);
		nmMessage.WriteByte(TE_MODEL);
		nmMessage.WriteCoord(vecPos.x);
		nmMessage.WriteCoord(vecPos.y);
		nmMessage.WriteCoord(vecPos.z);
		nmMessage.WriteCoord(vecVelocity.x);
		nmMessage.WriteCoord(vecVelocity.y);
		nmMessage.WriteCoord(vecVelocity.z);
		nmMessage.WriteAngle(flYaw);
		nmMessage.WriteShort(g_EngineFuncs.ModelIndex(model));
		nmMessage.WriteByte(uBounceSound);
		nmMessage.WriteByte(iLifeTime);
		nmMessage.End();
	}

	void ImpactSnow(Vector vecPos, int iLifeTime, string szSnowSpr)
	{	// if we're close to the limit, don't spawn impact sprites that aren't immediately next to us
		if(!CheckParticleCounter())
			return; // don't go over this limit - or - drop it if player is invalid!
			
		te_model(vecPos, Vector(0,0,0), 0, szSnowSpr, 0, iLifeTime, MSG_ONE_UNRELIABLE, GetPlayer().edict());
		IncParticleCounter();
		g_Scheduler.SetTimeout("EnvSnowDecParticleCounter", iLifeTime*0.1f, @this);
	}
}

// persistent-ish player data, organized by steam-id or username if on a LAN server, values are @EnvSnowCountPlr
dictionary EnvSnowCounts;


// Will create a new snowcntplr if the requested one does not exit
EnvSnowCountPlr@ getEnvSnowCountPlr(CBasePlayer@ pPlr)
{
	if(pPlr is null)
		return null;
		
	string szSteamId = g_EngineFuncs.GetPlayerAuthId( pPlr.edict() );
	if(szSteamId == 'STEAM_ID_LAN' or szSteamId == 'BOT')
		szSteamId = pPlr.pev.netname;
	
	if( !EnvSnowCounts.exists(szSteamId) )
		EnvSnowCounts[szSteamId] = EnvSnowCountPlr(pPlr);

	return cast<EnvSnowCountPlr@>( EnvSnowCounts[szSteamId] );
}


void EnvSnowImpactSnow(EnvSnowCountPlr@ pSnowCntPlr, Vector vecPos, int iLifeTime, string szSnowSpr)
{
	if(pSnowCntPlr !is null)
		pSnowCntPlr.ImpactSnow(vecPos, iLifeTime, szSnowSpr);
}

void EnvSnowDecParticleCounter(EnvSnowCountPlr@ pSnowCntPlr)
{
	if(pSnowCntPlr !is null)
		pSnowCntPlr.DecParticleCounter();
}

void EnvSnowThink(EHandle hEnt)
{
	if(g_Engine.time < 2 or !hEnt)
		return;

	env_snow@ pEnt = cast<env_snow@>(CastToScriptClass(hEnt.GetEntity()));

	if(pEnt !is null)
		pEnt.Think();
}


env_snow@ g_env_snow_ent = null;


class env_snow : ScriptBaseEntity
{
	private uint   m_uSize 		  		= 0;
	private uint   m_uIntensity 		= 10;
	private float  m_flRadius			= 1280.0f;
	private float  m_flSpeedMult		= 1.0f;
	private bool   m_bActive			= true;
	private float  m_flZrandMin  		= 0;
	private float  m_flZrandMax  		= ENV_SNOW_MAX_Z_RAND_MAX;

	private bool   m_bZoneEnabled		= false; // snow on/off relative to player position inside/outside zone
	private Vector m_vecZoneMin			= ENV_SNOW_VEC_NULL;
	private Vector m_vecZoneMax			= ENV_SNOW_VEC_NULL;
	private string m_szParticleSprite	= "";

	private void   SetSnowSize(uint   uSize)		{ m_uSize       = (uSize <= ENV_SNOW_MAX_SIZE)            ? uSize      : 0; }
	private void   SetIntensity(uint  uIntensity)	{ m_uIntensity  = (uIntensity <= ENV_SNOW_MAX_INTENSITY)  ? uIntensity : ENV_SNOW_MAX_INTENSITY; }
	private void   SetRadius(float    flRadius)		{ m_flRadius    = (flRadius >= ENV_SNOW_MIN_RADIUS)       ? flRadius   : ENV_SNOW_MIN_RADIUS; }
	private void   SetSpeedMult(float flSpeedMult)	{ m_flSpeedMult = (flSpeedMult < ENV_SNOW_MIN_SPEED_MULT) ? ENV_SNOW_MIN_SPEED_MULT : ( (flSpeedMult <= ENV_SNOW_MAX_SPEED_MULT) ? flSpeedMult : ENV_SNOW_MAX_SPEED_MULT ); }
	private void   SetZRandMin(float  flZrandMin)	{ m_flZrandMin  = (flZrandMin < 0.0f)                            ? 0.0f                            : ( (flZrandMin <= ENV_SNOW_MAX_Z_RAND_MIN) ? flZrandMin : ENV_SNOW_MAX_Z_RAND_MIN ); }
	private void   SetZRandMax(float  flZrandMax)	{ m_flZrandMax  = (flZrandMax < (ENV_SNOW_MAX_Z_RAND_MIN+10.0f)) ? (ENV_SNOW_MAX_Z_RAND_MIN+10.0f) : ( (flZrandMax <= ENV_SNOW_MAX_Z_RAND_MAX) ? flZrandMax : ENV_SNOW_MAX_Z_RAND_MAX ); }
    private void   SetDynamic(int     iDynamic)		{ if(iDynamic != 0 and g_env_snow_ent is null)    @g_env_snow_ent = @this; }
	private void   SetZoneMin(string snow_zone_min)	{ g_Utility.StringToVector(m_vecZoneMin, snow_zone_min); m_bZoneEnabled = (m_vecZoneMin != ENV_SNOW_VEC_NULL and m_vecZoneMax != ENV_SNOW_VEC_NULL); }
	private void   SetZoneMax(string snow_zone_max)	{ g_Utility.StringToVector(m_vecZoneMax, snow_zone_max); m_bZoneEnabled = (m_vecZoneMin != ENV_SNOW_VEC_NULL and m_vecZoneMax != ENV_SNOW_VEC_NULL); }
	private bool   IsInZone(Vector   player_origin)	{ return  (	player_origin.x >= m_vecZoneMin.x and player_origin.x <= m_vecZoneMax.x and
																	player_origin.y >= m_vecZoneMin.y and player_origin.y <= m_vecZoneMax.y and
																	player_origin.z >= m_vecZoneMin.z and player_origin.z <= m_vecZoneMax.z    ); }

	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if     (@g_env_snow_ent !is null and @g_env_snow_ent != @this)	g_EntityFuncs.Remove(cast<CBaseEntity@>(this)); // delete instance,  if dynamic mode is on
		else if(szKey == "snow_size")		SetSnowSize(atoui(szValue));
		else if(szKey == "intensity")		SetIntensity(atoui(szValue));
		else if(szKey == "radius")			SetRadius(atof(szValue));
		else if(szKey == "speed_mult")		SetSpeedMult(atof(szValue));
		else if(szKey == "z_rand_min")		SetZRandMin(atof(szValue));
		else if(szKey == "z_rand_max")		SetZRandMax(atof(szValue));
		else if(szKey == "dynamic")			SetDynamic(atoui(szValue));
		else if(szKey == "zone_min")		SetZoneMin(szValue);
		else if(szKey == "zone_max")		SetZoneMax(szValue);
		else if(szKey == "particle_spr")	m_szParticleSprite = szValue;
		else 								return BaseClass.KeyValue(szKey, szValue);
		return true;
	}
	
	void Spawn()
	{
		if(!m_szParticleSprite.IsEmpty()) // custom sprite ?
			m_uSize = 0; // set m_uSize to custom

		switch(m_uSize)
		{
			case 0: if(!m_szParticleSprite.IsEmpty())     break;
			case 1: m_szParticleSprite = ENV_SNOW_SPR_4;  break;
			case 2: m_szParticleSprite = ENV_SNOW_SPR_8;  break;
			case 3: m_szParticleSprite = ENV_SNOW_SPR_16; break;
			case 4: m_szParticleSprite = ENV_SNOW_SPR_32; break;
		}
		Precache();
		
		EHandle hSelf = self;
		g_Scheduler.SetInterval("EnvSnowThink", 0.05, -1, hSelf);

		m_bActive = (pev.spawnflags & FL_ENV_SNOW_START_ON) != 0;
	}
	
	void Precache()
	{
		//g_SoundSystem.PrecacheSound( sound );
		g_Game.PrecacheModel(m_szParticleSprite);
	}
	
	void On()     { m_bActive = true;    }
	void Off()    { m_bActive = false;   }
	void Toggle() { m_bActive = !m_bActive; }

	void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue = 0.0f)
	{
		if(useType == USE_ON)	On();
		if(useType == USE_OFF)	Off();
		else					Toggle();
	}

	private void te_projectile(Vector pos, Vector velocity, CBaseEntity@ owner=null, string model="models/grenade.mdl",
											uint8 life=1, NetworkMessageDest msgType=MSG_BROADCAST, edict_t@ dest=null)
	{
		int ownerId = (owner is null) ? 0 : owner.entindex();
		NetworkMessage m(msgType, NetworkMessages::SVC_TEMPENTITY, dest);
		m.WriteByte(TE_PROJECTILE);
		m.WriteCoord(pos.x);
		m.WriteCoord(pos.y);
		m.WriteCoord(pos.z);
		m.WriteCoord(velocity.x);
		m.WriteCoord(velocity.y);
		m.WriteCoord(velocity.z);
		m.WriteShort(g_EngineFuncs.ModelIndex(model));
		m.WriteByte(life);
		m.WriteByte(ownerId);
		m.End();
	}

	private array<float> rotationMatrix(Vector axis, float angle)
	{
		axis = axis.Normalize();
		float s = sin(angle);
		float c = cos(angle);
		float oc = 1.0 - c;
	 
		array<float> mat = {
			oc * axis.x * axis.x + c,          oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s, 0.0,
			oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c,          oc * axis.y * axis.z - axis.x * s, 0.0,
			oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c,			 0.0,
			0.0,                               0.0,                               0.0,								 1.0
		};
		return mat;
	}

	// multiply a matrix with a vector (assumes w component of vector is 1.0f) 
	private Vector matMultVector(array<float> rotMat, Vector v)
	{
		Vector outv;
		outv.x = rotMat[0]*v.x + rotMat[4]*v.y + rotMat[8]*v.z  + rotMat[12];
		outv.y = rotMat[1]*v.x + rotMat[5]*v.y + rotMat[9]*v.z  + rotMat[13];
		outv.z = rotMat[2]*v.x + rotMat[6]*v.y + rotMat[10]*v.z + rotMat[14];
		return outv;
	}

	// Randomize the direction of a vector by some amount
	// Max degrees = 360, which makes a full sphere
	private Vector spreadDir(Vector dir, float degrees)
	{
		float spread = Math.DegreesToRadians(degrees) * 0.5f;
		float x, y;
		Vector vecAiming = dir;

		float c = Math.RandomFloat(0, Math.PI*2); // random point on circle
		float r = Math.RandomFloat(-1, 1); // random radius
		x = cos(c) * r * spread;
		y = sin(c) * r * spread;
		
		// get "up" vector relative to aim direction
		Vector up = Vector(0, 0, 1);
		if(abs(dir.z) > 0.9)
			up = Vector(1, 0, 0);
		Vector pitAxis = CrossProduct(dir, up).Normalize(); // get left vector of aim dir
		Vector yawAxis = CrossProduct(dir, pitAxis).Normalize(); // get up vector relative to aim dir
		
		// Apply rotation around arbitrary "up" axis
		array<float> yawRotMat = rotationMatrix(yawAxis, x);
		vecAiming = matMultVector(yawRotMat, vecAiming).Normalize();
		
		// Apply rotation around "left/right" axis
		array<float> pitRotMat = rotationMatrix(pitAxis, y);
		vecAiming = matMultVector(pitRotMat, vecAiming).Normalize();
				
		return vecAiming;
	}

	private void snow(EnvSnowCountPlr@ pSnowCntPlr, float flFov)
	{
		if(pSnowCntPlr is null or !pSnowCntPlr.CheckParticleCounter())
			return; // don't go over this limit - or - drop it if player is invalid!

		float c = Math.RandomFloat(0, flFov) + self.pev.v_angle.y*(Math.PI/180.0f) - flFov*0.5f; // random point on circle
		float r = Math.RandomFloat(0, 1); // random radius
		float x = cos(c) * r * m_flRadius;
		float y = sin(c) * r * m_flRadius;
		
		Math.MakeVectors(self.pev.angles);
		Vector vel = g_Engine.v_forward;
		vel = spreadDir(vel, 30);
		Vector dir = vel.Normalize();
		Vector angleOffset = g_Engine.v_forward*-600;
		angleOffset.z = 0;
		Vector offset = self.pev.velocity*0.5f + angleOffset;
		
		float height = Math.RandomFloat(m_flZrandMin, m_flZrandMax);
		Vector vecSrc = ((g_env_snow_ent is null) ? self.pev.origin : pSnowCntPlr.GetPlayer().pev.origin) + Vector(x,y,height) + offset;
		
		// Don't spawn snow indoors
		TraceResult tr;
		Vector checkDir = g_Engine.v_forward*-4096;
		g_Utility.TraceLine( vecSrc, vecSrc + checkDir, ignore_monsters, self.edict(), tr );
		CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );

		if(tr.flFraction >= 1.0f or (pHit !is null and pHit.pev.classname != "worldspawn"))
			return;
		
		edict_t@ pEdict = g_EngineFuncs.PEntityOfEntIndex( 0 );
		string tex = g_Utility.TraceTexture( pEdict, vecSrc, vecSrc + checkDir );
		if(tex.ToLowercase() != "sky")
			return;

		pSnowCntPlr.IncParticleCounter();
		
		// spawn some stationary snow when the projectile snow hits a surface
		g_Utility.TraceLine( vecSrc, vecSrc + dir*4096, ignore_monsters, self.edict(), tr );
		@pHit = g_EntityFuncs.Instance( tr.pHit );
		float dist = tr.flFraction * 4096;
		float speed = (vel*200*m_flSpeedMult).Length();
		float delay = speed > 0 ? dist / speed : 0;
		Vector spawnOri = vecSrc + dir*dist;
		int lifeTime = 8;

		if(pHit !is null and pHit.pev.classname != "worldspawn" or abs(tr.vecPlaneNormal.z) < 0.5f)
			lifeTime = 2;

		if(speed > 0)
			g_Scheduler.SetTimeout("EnvSnowImpactSnow", delay, @pSnowCntPlr, spawnOri, lifeTime, m_szParticleSprite);

		g_Scheduler.SetTimeout("EnvSnowDecParticleCounter", delay, @pSnowCntPlr);
		te_projectile(vecSrc, vel*200*m_flSpeedMult, null, m_szParticleSprite, int(delay+1), MSG_ONE_UNRELIABLE, pSnowCntPlr.GetPlayer().edict());
	}

	void Think()
	{
		if (!m_bActive)
			return;
			
		CBaseEntity@ ent = null;
		do {
			@ent = g_EntityFuncs.FindEntityByClassname(ent, "player"); 
			if(ent is null)
				break;

			CBasePlayer@ pPlr = cast<CBasePlayer@>(ent);
			EnvSnowCountPlr@ pSnowCntPlr = getEnvSnowCountPlr(pPlr);

			if(pSnowCntPlr is null or !pPlr.IsAlive() or (@g_env_snow_ent is null and m_bZoneEnabled and !IsInZone(pPlr.GetOrigin())))
				continue;

			int effects_intensity = (int(g_Engine.time) % 19) - 2;
			
			for (uint k = 0; k < m_uIntensity; k++)
				snow(pSnowCntPlr, Math.PI*2.0f);
		} while (ent !is null);
	}
};



