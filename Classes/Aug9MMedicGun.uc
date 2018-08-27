class AUG9MMedicGun extends MP7MMedicGun;
//AYAYA Clap

var int MaxHealAmmo;

var 		name 			ReloadShortAnim;
var 		float 			ReloadShortRate;

var transient bool  bShortReload;

simulated function Notify_ShowBullets()
{
	local int AvailableAmmo;

	AvailableAmmo = AmmoAmount(0);

	if (AvailableAmmo == 0)
	{
		SetBoneScale (1, 0.0, 'bullet01');
		SetBoneScale (2, 0.0, 'bullet02');
		SetBoneScale (3, 1.0, 'follower');
	}
	else if (AvailableAmmo == 1)
	{
		SetBoneScale (1, 1.0, 'bullet01');
		SetBoneScale (2, 0.0, 'bullet02');
		SetBoneScale (3, 1.0, 'follower');
	}
	else //if (AvailableAmmo == 0)
	{
		SetBoneScale (1, 1.0, 'bullet01');
		SetBoneScale (2, 1.0, 'bullet02');
		SetBoneScale (3, 0.0, 'follower');
	}
}

simulated function Notify_HideBullets()
{
	if (MagAmmoRemaining == 2)
	{
		SetBoneScale (1, 0.0, 'bullet01');
		SetBoneScale (2, 1.0, 'bullet02');
		SetBoneScale (3, 1.0, 'follower');
	}
	else if (MagAmmoRemaining <= 1)
	{
		SetBoneScale (1, 0.0, 'bullet01');
		SetBoneScale (2, 0.0, 'bullet02');
		SetBoneScale (3, 1.0, 'follower');
	}
	else //if (MagAmmoRemaining >= 3)
	{
		SetBoneScale (1, 1.0, 'bullet01');
		SetBoneScale (2, 1.0, 'bullet02');
		SetBoneScale (3, 0.0, 'follower');
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
    if ( bShortReload )
        a++; // 1 bullet already bolted
    
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

defaultproperties
{
     SkinRefs(0)="KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P" //hands
     SkinRefs(1)="CuteWeaponPack_T.AUG9M_T.AUG9M_cmb" 						//AUG
     SkinRefs(2)="CuteWeaponPack_T.medicattachment_T.medicattachment_cmb" 	//medic attachment
     	
     SkinRefs(3)="CuteWeaponPack_T.reflexsight_T.reflex_shdr" //reflex reticle shader
     SkinRefs(4)="CuteWeaponPack_T.reflexsight_T.glass_shdr" //reflex glass shader

	 SleeveNum=0
	 
     MeshRef="CuteWeaponPack_A.AUG9M_1st"
	 FlashBoneName="tip"
     SelectSound=Sound'KF_BullpupSnd.Bullpup_Select' //fix this later
     HudImageRef="CuteWeaponPack_T.AUG9M_T.AUG9M_unselected"
     SelectedHudImageRef="CuteWeaponPack_T.AUG9M_T.AUG9M_selected"
     TraderInfoTexture=texture'CuteWeaponPack_T.AUG9M_T.AUG9M_trader'

	 HealAmmoCharge=0 //initial heal ammo charge
     MaxHealAmmo=500 //default of 500
     AmmoRegenRate=0.300000 //0.3
     
     ReloadShortAnim="Reload"
     ReloadShortRate=2.00
     MagCapacity=25
     ReloadRate=2.72
     ReloadAnim="Reload"
     ReloadAnimRate=1.2
     WeaponReloadAnim="Reload_Bullpup"
     
     Weight=4.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     bModeZeroCanDryFire=True
     bIsTier2Weapon=True
     
     StandardDisplayFOV=65.000000 //60.0
     PlayerIronSightFOV=65.000000 //65.0
     ZoomedDisplayFOV=32.000000 //32.0
     FireModeClass(0)=Class'CuteWeapons.AUG9MFire'
     FireModeClass(1)=Class'CuteWeapons.AUG9MAltFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="AUG 9mm sub machine gun. Modified to fire healing darts. Can fire more darts with a single charge."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=60.000000 //60.0
     Priority=94 //95
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=4 //7
     PickupClass=Class'CuteWeapons.AUG9MPickup'
     //PlayerViewOffset=(X=10.000000,Y=15.000000,Z=-3.000000)
	 PlayerViewOffset=(X=12.000000,Y=20.000000,Z=-3.000000)
     BobDamping=5.000000
	 AttachmentClass=Class'CuteWeapons.AUG9MAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="AUG9M Medic Gun"
     TransientSoundVolume=1.250000
}
