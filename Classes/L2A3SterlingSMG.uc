class L2A3SterlingSMG extends KFWeapon
config(user);

var 		name 			ReloadShortAnim;
var 		float 			ReloadShortRate;
var transient bool  bShortReload;

simulated function Notify_ShowBullets()
{
	local int AvailableAmmo;

	AvailableAmmo = AmmoAmount(0);

	if (AvailableAmmo == 0)
	{
		SetBoneScale (0, 0.0, 'bullet1');
		SetBoneScale (1, 0.0, 'bullet2');
		SetBoneScale (2, 1.0, 'follower');
	}
	else if (AvailableAmmo == 1)
	{
		SetBoneScale (0, 1.0, 'bullet1');
		SetBoneScale (1, 0.0, 'bullet2');
		SetBoneScale (2, 1.0, 'follower');
	}
	else
	{
		SetBoneScale (0, 1.0, 'bullet1');
		SetBoneScale (1, 1.0, 'bullet2');
		SetBoneScale (2, 0.0, 'follower');
	}
}

simulated function Notify_HideBullets()
{
	if (MagAmmoRemaining == 1)
	{
		SetBoneScale (0, 1.0, 'bullet1');
		SetBoneScale (1, 0.0, 'bullet2');
		SetBoneScale (2, 1.0, 'follower');
	}
	else if (MagAmmoRemaining == 0)
	{
		SetBoneScale (0, 0.0, 'bullet1');
		SetBoneScale (1, 0.0, 'bullet2');
		SetBoneScale (2, 1.0, 'follower');
	}
	else //if (MagAmmoRemaining >= 3)
	{
		SetBoneScale (0, 1.0, 'bullet1');
		SetBoneScale (1, 1.0, 'bullet2');
		SetBoneScale (2, 0.0, 'follower');
	}
}

exec function ReloadMeNow()
{
	local float ReloadMulti;
    
	if(!AllowReload())
		return;
	if ( bHasAimingMode && bAimingRifle )
	{
		FireMode[1].bIsFiring = False;

		ZoomOut(false);
		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
    
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	else
		ReloadMulti = 1.0;
        
	bIsReloading = true;
	ReloadTimer = Level.TimeSeconds;
    bShortReload = MagAmmoRemaining > 0;
	if ( bShortReload )
		ReloadRate = Default.ReloadShortRate / ReloadMulti;
    else
		ReloadRate = Default.ReloadRate / ReloadMulti;
        
	if( bHoldToReload )
	{
		NumLoadedThisReload = 0;
	}
	ClientReload();
	Instigator.SetAnimAction(WeaponReloadAnim);
	if ( Level.Game.NumPlayers > 1 && KFGameType(Level.Game).bWaveInProgress && KFPlayerController(Instigator.Controller) != none &&
		Level.TimeSeconds - KFPlayerController(Instigator.Controller).LastReloadMessageTime > KFPlayerController(Instigator.Controller).ReloadMessageDelay )
	{
		KFPlayerController(Instigator.Controller).Speech('AUTO', 2, "");
		KFPlayerController(Instigator.Controller).LastReloadMessageTime = Level.TimeSeconds;
	}
}

simulated function ClientReload()
{
	local float ReloadMulti;
	if ( bHasAimingMode && bAimingRifle )
	{
		FireMode[1].bIsFiring = False;

		ZoomOut(false);
		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
    
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	else
		ReloadMulti = 1.0;
        
	bIsReloading = true;
	if (MagAmmoRemaining <= 0)
	{
		PlayAnim(ReloadAnim, ReloadAnimRate*ReloadMulti, 0.1);
	}
	else if (MagAmmoRemaining >= 1)
	{
		PlayAnim(ReloadShortAnim, ReloadAnimRate*ReloadMulti, 0.1);
	}
}

function AddReloadedAmmo()
{
    local int a;
    
	UpdateMagCapacity(Instigator.PlayerReplicationInfo);

    a = MagCapacity;
    if ( bShortReload ) {
        //a++; // 1 bullet already bolted //no it's open bolt
		//MagAmmoRemaining = a;
    }
	if ( AmmoAmount(0) >= a )
		MagAmmoRemaining = a;
    else
        MagAmmoRemaining = AmmoAmount(0);

    // this seems redudant -- PooSH
	// if( !bHoldToReload )
	// {
		// ClientForceKFAmmoUpdate(MagAmmoRemaining,AmmoAmount(0));
	// }

	if ( PlayerController(Instigator.Controller) != none && KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements) != none )
	{
		KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements).OnWeaponReloaded();
	}
}    

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
    if(ReadyToFire(0))
    {
        DoToggle();
    }
}

exec function SwitchModes()
{
	DoToggle();
}

function bool RecommendRangedAttack()
{
	return true;
}

//TODO: LONG ranged?
function bool RecommendLongRangedAttack()
{
	return true;
}

function float SuggestAttackStyle()
{
	return -1.0;
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return AIRating;
}

function byte BestMode()
{
	return 0;
}

simulated function SetZoomBlendColor(Canvas c)
{
	local Byte    val;
	local Color   clr;
	local Color   fog;

	clr.R = 255;
	clr.G = 255;
	clr.B = 255;
	clr.A = 255;

	if( Instigator.Region.Zone.bDistanceFog )
	{
		fog = Instigator.Region.Zone.DistanceFogColor;
		val = 0;
		val = Max( val, fog.R);
		val = Max( val, fog.G);
		val = Max( val, fog.B);
		if( val > 128 )
		{
			val -= 128;
			clr.R -= val;
			clr.G -= val;
			clr.B -= val;
		}
	}
	c.DrawColor = clr;
}

defaultproperties
{
	HudImageRef="CuteWeaponPack_T.L2A3Sterling_T.L2A3Sterling_unselected" //unselected
	SelectedHudImageRef="CuteWeaponPack_T.L2A3Sterling_T.L2A3Sterling_selected"
    TraderInfoTexture=texture'CuteWeaponPack_T.L2A3Sterling_T.L2A3Sterling_trader'
    
    
    SelectSoundRef="KF_PumpSGSnd.SG_Select"
	MeshRef="CuteWeaponPack_A.L2A3Sterling_1st"
    SkinRefs(0)="KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P"
    SkinRefs(1)="CuteWeaponPack_T.L2A3Sterling_T.L2A3Sterling_cmb"
	FlashBoneName="tip"
    MagCapacity=34
    ReloadShortAnim="Reload" //short reload exists but is intentionally disabled 
    ReloadShortRate=3.57 //for balance and consistency with the other firebug SMGs
    ReloadRate=3.57
    ReloadAnim="Reload"
    ReloadAnimRate=1.00
    WeaponReloadAnim="Reload_Mac10"
    Weight=5 // 5
    bHasAimingMode=True
    IdleAimAnim="idle_iron"
	StandardDisplayFOV=75.000000 //65.0
    bModeZeroCanDryFire=True
    SleeveNum=0
    
    bIsTier2Weapon=True
    PlayerIronSightFOV=65.000000
    ZoomedDisplayFOV=60.000000 //35
    FireModeClass(0)=Class'CuteWeapons.L2A3SterlingFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.550000
    CurrentRating=0.550000
    bShowChargingBar=True
    Description="A British submachine gun. Fires special incendiary rounds."
    EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
	DisplayFOV=70.000000 //65
    Priority=105
    CustomCrosshair=11
    CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
    InventoryGroup=3
    GroupOffset=7
    PickupClass=Class'CuteWeapons.L2A3SterlingPickup'
    PlayerViewOffset=(X=-4.000000,Y=20.000000,Z=-14.000000) //-8 24 -20
    BobDamping=5.000000
    AttachmentClass=Class'CuteWeapons.L2A3SterlingAttachment'
    IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
    ItemName="L2A3 Sterling"
    TransientSoundVolume=1.250000
}
