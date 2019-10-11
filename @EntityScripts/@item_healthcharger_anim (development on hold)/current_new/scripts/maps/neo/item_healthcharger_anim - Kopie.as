


void RegisterItemHealthCustomEntity()
{
    g_CustomEntityFuncs.RegisterCustomEntity( "item_healthcharger_bottle", "item_healthcharger_bottle" );
    g_CustomEntityFuncs.RegisterCustomEntity( "item_healthcharger_custom", "item_healthcharger" );
}


const Vector ENV_SNOW_VEC_NULL = Vector(0, 0, 0);


// Sequences
enum BottleSeq
{
	HBOTTLE_SEQ_IDLE = 0,	// "still"
	HBOTTLE_SEQ_USE,		// "slosh"
	HBOTTLE_SEQ_STOP		// "to_rest"
};


class item_healthcharger_bottle : ScriptBaseAnimating
{
	private uint  m_uCrtlLvl		= 0;
	private float m_flCtrlLvlMin	= -11.0f;
	private float m_flCtrlLvlMax	= 0.0f;
	private string m_szModelName	= "models/decay/health_charger_both.mdl";

	void Precache()
	{
		g_Game.PrecacheModel( m_szModelName );
	}

	int ObjectCaps() 
    {
        return BaseClass.ObjectCaps() & ~FCAP_ACROSS_TRANSITION;
    }
	
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, m_szModelName );

		self.pev.movetype	= MOVETYPE_FLY;
		self.pev.solid		= SOLID_BBOX;

		g_EntityFuncs.SetSize( self.pev, ENV_SNOW_VEC_NULL, ENV_SNOW_VEC_NULL );

		self.pev.rendermode	= kRenderTransTexture;
		self.pev.renderamt	= 128;
		self.pev.sequence	= HBOTTLE_SEQ_IDLE;
		self.pev.frame		= 0;
		self.pev.nextthink	= g_Engine.time + 0.1f;
	}

	void Think()
	{
		self.pev.nextthink = g_Engine.time + 0.1f;
		self.StudioFrameAdvance( 0 );

		if( !self.m_fSequenceFinished )
			return;

		if( self.pev.sequence == HBOTTLE_SEQ_USE )
		{
			self.m_fSequenceFinished = false;
			self.pev.frame = 0;
		}
		else if( self.pev.sequence == HBOTTLE_SEQ_STOP)
			ChangeSequence( HBOTTLE_SEQ_IDLE );
	}
	
	void ChangeSequence( int NewSequence )
	{
		if( self.pev.sequence == NewSequence )
			return;

		self.pev.sequence = NewSequence;
		self.pev.frame = 0;
		self.ResetSequenceInfo();
	}

	void SetLevel( float Level )
	{
		Level = m_flCtrlLvlMin + Level * ( m_flCtrlLvlMax - m_flCtrlLvlMin );
		self.SetBoneController( m_uCrtlLvl, Level );
	}
}


enum HGSeq
{
	HCHG_SEQ_IDLE = 0,	// "still"
	HCHG_SEQ_DEPLOY,	// "deploy"
	HCHG_SEQ_HIBERNATE,	// "retract_arm"
	HCHG_SEQ_EXPAND,	// "give_shot"
	HCHG_SEQ_RETRACT,	// "retract_shot"
	HCHG_SEQ_RDY,		// "prep_shot"
	HCHG_SEQ_USE		// "shot_idle"
}


enum RechargeState2
{
	HCHG_STATE_IDLE = 0,	// No player near by, wait
	HCHG_STATE_ACTIVATE,	// Player is near - deploy
	HCHG_STATE_READY,		// Player is near and deployed - rotate arm to player position
	HCHG_STATE_START,		// Player hit use - expand arm
	HCHG_STATE_USE,			// Give charge
	HCHG_STATE_STOP,		// Player stopped using - retract arm, continue tracking
	HCHG_STATE_DEACTIVATE,	// PLayer went away - hibernate, reset arm position
	HCHG_STATE_EMPTY		// Charger is empty (dead end state in SP, wait for recharge in MP)
};


const float g_flTotalCharge = g_EngineFuncs.CVarGetFloat( "sk_healthcharger" );


class item_healthcharger_custom : ScriptBaseAnimating
{
	private float 	m_flHealthChargerRechargeTime = 60.0f;
	private float 	m_flNextCharge;
	private float  	m_flReactivate;
	private uint  	m_iJuice;
	private uint  	m_iOn;			// 0 = off, 1 = startup, 2 = going
	private float 	m_flSoundTime;
	private bool 	m_bIsUsed;
	private bool 	m_bIsFrontAngle;
	private RechargeState2 CurrentState;
	private item_healthcharger_bottle@ pBottle;
	private string 	m_szModelName  = "models/decay/health_charger_body.mdl";
	private string 	m_szMedShotSnd   = "items/medshot4.wav";
	private string 	m_szMedsHotNoSnd = "items/medshotno1.wav";
	private string 	m_szMedChargeSnd = "items/medcharge4.wav";

	void Precache()
	{
		g_Game.PrecacheModel( m_szModelName );
		g_SoundSystem.PrecacheSound( m_szMedShotSnd );
		g_SoundSystem.PrecacheSound( m_szMedsHotNoSnd );
		g_SoundSystem.PrecacheSound( m_szMedChargeSnd );
	}
	
	int ObjectCaps() 
    {
        return ( BaseClass.ObjectCaps() | FCAP_CONTINUOUS_USE ) & ~FCAP_ACROSS_TRANSITION;
    }
	
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, m_szModelName );

		self.pev.solid = SOLID_BBOX;//SOLID_TRIGGER;
		SetSequenceBox();

		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		self.InitBoneControllers();
		RotateCamArm( null );
		self.pev.movetype = MOVETYPE_FLY;		// This type enables bone controller interpolation in GoldSrc
		m_iJuice = int( g_flTotalCharge );
		self.pev.skin = 0;
		ChangeState( HCHG_STATE_IDLE, HCHG_SEQ_IDLE );
		
		// Spawn bottle entity
		CBaseEntity@ pBottleEnt = g_EntityFuncs.CreateEntity( "item_healthcharger_bottle", null,  false );
		@pBottle = cast<item_healthcharger_bottle@>(CastToScriptClass(@pBottleEnt));
		pBottle.Spawn();
		g_EntityFuncs.SetOrigin( pBottle.self, self.pev.origin );
		pBottle.pev.angles = self.pev.angles;
		@pBottle.pev.owner = @self.edict();
		pBottle.SetLevel( 1.0f );
		
		self.pev.nextthink = g_Engine.time + 0.1f;
	}
	
    bool KeyValue( const string& in szKey, const string& in szValue )
    {
		if( szKey == "dmdelay" )
        {
			m_flReactivate = atof( szValue );
			return true;
        }
		else if(szKey == "style"  or szKey == "height" or 
				szKey == "value1" or szKey == "value2" or szKey == "value3")
			return true;
        else
            return BaseClass.KeyValue( szKey, szValue );
    }

	void Think()
	{
		float CurrentTime = g_Engine.time;
		self.pev.nextthink = CurrentTime + 0.1f;
		self.StudioFrameAdvance( 0 );

		if( m_bIsUsed )
			pBottle.SetLevel( m_iJuice / g_flTotalCharge );
			
		CBaseEntity@ pPlayer = FindPlayer( 70.0f );
		if( CurrentState != HCHG_STATE_EMPTY && CurrentState != HCHG_STATE_DEACTIVATE )
			RotateCamArm( @pPlayer );
		else
			RotateCamArm( null );

		switch( CurrentState )
		{
			case HCHG_STATE_IDLE:		if( pPlayer !is null )
										{
											if(!m_bIsFrontAngle )
												return;
				
											g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, m_szMedShotSnd, 0.85, ATTN_NORM );
											ChangeState( HCHG_STATE_ACTIVATE, HCHG_SEQ_DEPLOY );
										}
										break;

			case HCHG_STATE_ACTIVATE:	if( self.m_fSequenceFinished )
											ChangeState( HCHG_STATE_READY, HCHG_SEQ_RDY );
										break;

			case HCHG_STATE_READY:		if( pPlayer is null )
											ChangeState( HCHG_STATE_DEACTIVATE, HCHG_SEQ_HIBERNATE );
										else if( !m_bIsFrontAngle )
										{
											ChangeState( HCHG_STATE_DEACTIVATE, HCHG_SEQ_HIBERNATE );
											return;
										}
										else if( m_bIsUsed )
										{
											ChangeState( HCHG_STATE_START, HCHG_SEQ_EXPAND );
											pBottle.ChangeSequence( HBOTTLE_SEQ_USE );
										}
										break;

			case HCHG_STATE_START:		if( self.m_fSequenceFinished )
											ChangeState( HCHG_STATE_USE, HCHG_SEQ_USE );
										break;

			case HCHG_STATE_USE:		if( !m_bIsUsed )
										{
											ChangeState( HCHG_STATE_STOP, HCHG_SEQ_RETRACT );
											pBottle.ChangeSequence( HBOTTLE_SEQ_STOP );
										}
										m_bIsUsed = false;
										break;

			case HCHG_STATE_STOP:		if( self.m_fSequenceFinished )
										{
											Off();
											ChangeState( HCHG_STATE_READY, HCHG_SEQ_RDY );
										}
										break;

			case HCHG_STATE_DEACTIVATE:	if( self.m_fSequenceFinished )
											ChangeState( HCHG_STATE_IDLE, HCHG_SEQ_IDLE );
										break;

			case HCHG_STATE_EMPTY:		if( self.pev.sequence == HCHG_SEQ_RETRACT && self.m_fSequenceFinished )
											ChangeSequence( HCHG_SEQ_HIBERNATE );

										if( self.pev.sequence == HCHG_SEQ_HIBERNATE && self.m_fSequenceFinished )
											ChangeSequence( HCHG_SEQ_IDLE );

										if( m_flNextCharge != -1 && CurrentTime > m_flNextCharge )
										{
											Recharge();
											ChangeState( HCHG_STATE_IDLE, HCHG_SEQ_IDLE );
										}
										break;
		}
	}
	
	void ChangeSequence( int NewSequence )
	{
		self.pev.sequence = NewSequence;
		self.pev.frame    = 0;
		self.ResetSequenceInfo();
	}
	
	void ChangeState( RechargeState2 NewState, int NewSequence )
	{
		CurrentState = NewState;
		ChangeSequence( NewSequence );
	}

	void RotateCamArm( CBaseEntity@ pPlayer )
	{
		float Angle;
		
		if( pPlayer !is null )
		{
			Vector ChToPl;

			ChToPl.x = self.pev.origin.x - pPlayer.pev.origin.x;
			ChToPl.y = self.pev.origin.y - pPlayer.pev.origin.y;
			ChToPl.z = self.pev.origin.z - pPlayer.pev.origin.z;
			ChToPl = Math.VecToAngles( ChToPl );
			Angle = ChToPl.y - self.pev.angles.y + 180;	// +180 - because player actually faces back side of the charger model

			if( Angle > 180)
			{
				while( Angle > 180 )
					Angle -= 360;
			}
			else if( Angle < -180 )
			{
				while( Angle < -180 )
					Angle += 360;
			}
			
			if( -90 > Angle || Angle > 90 )
			{
				m_bIsFrontAngle = false;
				Angle = 0;
			}
			else
				m_bIsFrontAngle = true;
		}
		else
			Angle = 0;

		self.SetBoneController( 0, Angle );
		self.SetBoneController( 1, Angle );
	}

	CBaseEntity@ FindPlayer( float Radius )
	{
		CBaseEntity@ pPlayer = null;	// Result
		CBaseEntity@ pEntity = null;	// Used for search

		while( ( @pEntity = g_EntityFuncs.FindEntityInSphere( pEntity, self.pev.origin, 70.0f, "*", "classname" ) ) !is null )
		{
			if( pEntity.IsPlayer() )
			{
				@pPlayer = @pEntity;
				break;
			}
		}
		
		return pPlayer;
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value )
	{
		if( pActivator is null or !pActivator.IsPlayer() or !m_bIsFrontAngle )
			return;

		Vector Dist = self.pev.origin - pActivator.pev.origin;
		if( Dist.Length2D() > 50.0f)
			return;
		
		if( m_iJuice <= 0 )
		{
			self.pev.skin = 1;
			Off();
			if( CurrentState != HCHG_STATE_EMPTY )
			{
				ChangeState( HCHG_STATE_EMPTY, HCHG_SEQ_RETRACT );
				pBottle.ChangeSequence( HBOTTLE_SEQ_STOP );

				if( ( m_iJuice == 0 ) && ( ( m_flReactivate = m_flHealthChargerRechargeTime ) > 0 ) )
					m_flNextCharge = g_Engine.time + m_flReactivate;
				else
					m_flNextCharge = -1;	// No recharge
			}
		}

		if(m_iJuice <= 0)
		{
			if( m_flSoundTime <= g_Engine.time )
			{
				m_flSoundTime = g_Engine.time + 0.62;
				g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, m_szMedsHotNoSnd, 1.0, ATTN_NORM );
			}
			return;
		}

		if( CurrentState != HCHG_STATE_START && CurrentState != HCHG_STATE_USE )
		{
			ChangeState( HCHG_STATE_START, HCHG_SEQ_EXPAND );
			pBottle.ChangeSequence( HBOTTLE_SEQ_USE );
		}
		
		m_bIsUsed = true;
		if( m_flNextCharge >= g_Engine.time )
			return;

		if( m_iOn == 0 )
		{
			m_iOn++;
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, m_szMedShotSnd, 1.0, ATTN_NORM );
			m_flSoundTime = 0.56 + g_Engine.time;
		}
		if( ( m_iOn == 1 ) && ( m_flSoundTime <= g_Engine.time ) )
		{
			m_iOn++;
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, m_szMedChargeSnd, 1.0, ATTN_NORM );
		}
		
		if( pActivator.TakeHealth( 1, DMG_GENERIC ) )
			m_iJuice--;

		m_flNextCharge = g_Engine.time + 0.1;
	}

	void Recharge()
	{
		g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, m_szMedShotSnd, 1.0, ATTN_NORM );
		m_iJuice = int( g_flTotalCharge );
		self.pev.skin = 0;
		pBottle.SetLevel( 1.0f );
	}

	void Off()
	{
		if( m_iOn > 1 )
			g_SoundSystem.StopSound( self.edict(), CHAN_ITEM, m_szMedChargeSnd );

		m_bIsUsed = false;
		m_iOn = 0;
	}

	void SetSequenceBox()
	{
		Vector mins, maxs;

		if( self.ExtractBbox( self.pev.sequence, mins, maxs ) )
		{
			mins.x = -4;
			maxs.x = 2;
			mins.y = -4;
			maxs.y = 4;

			float yaw = self.pev.angles.y * ( Math.PI / 180.0f );
			
			Vector xvector, yvector;
            xvector.x = cos( yaw );
            xvector.y = sin( yaw );
            yvector.x = -sin( yaw );
            yvector.y = cos( yaw );
            array<Vector> bounds( 2 );
			
			bounds[0] = mins;
            bounds[1] = maxs;
			
			Vector rmin( 9999, 9999, 9999 );
            Vector rmax( -9999, -9999, -9999 );
            Vector base, transformed;
			
			for( uint i = 0; i <= 1; i++ )
            {
                base.x = bounds[i].x;
                for( uint j = 0; j <= 1; j++ )
                {
                    base.y = bounds[j].y;
                    for( uint k = 0; k <= 1; k++ )
                    {
                        base.z = bounds[k].z;

                        // transform the point
                        transformed.x = ( xvector.x * base.x ) + ( yvector.x * base.y );
                        transformed.y = ( xvector.y * base.x ) + ( yvector.y * base.y );
                        transformed.z = base.z;
                        
                        if( transformed.x < rmin.x )
                            rmin.x = transformed.x;
                        if( transformed.x > rmax.x )
                            rmax.x = transformed.x;
                        if( transformed.y < rmin.y )
                            rmin.y = transformed.y;
                        if( transformed.y > rmax.y )
                            rmax.y = transformed.y;
                        if( transformed.z < rmin.z )
                            rmin.z = transformed.z;
                        if( transformed.z > rmax.z )
                            rmax.z = transformed.z;
                    }
                }
            }
            g_EntityFuncs.SetSize( self.pev, rmin, rmax );
		}
	}
}

