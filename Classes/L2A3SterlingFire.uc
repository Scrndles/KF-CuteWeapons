class L2A3SterlingFire extends KFShotgunFire;

var()           class<Emitter>  ShellEjectClass;            // class of the shell eject emitter
var()           Emitter         ShellEjectEmitter;          // The shell eject emitter
var()           name            ShellEjectBoneName;         // name of the shell eject bone

simulated function bool AllowFire()
{
	if(KFWeapon(Weapon).bIsReloading)
		return false;
	if(KFPawn(Instigator).SecondaryItem!=none)
		return false;
	if(KFPawn(Instigator).bThrowingNade)
		return false;

	if(KFWeapon(Weapon).MagAmmoRemaining < 1)
	{
    	if( Level.TimeSeconds - LastClickTime>FireRate )
    	{
    		LastClickTime = Level.TimeSeconds;
    	}

		if( AIController(Instigator.Controller)!=None )
			KFWeapon(Weapon).ReloadMeNow();
		return false;
	}

    //log("Spread = "$Spread);

	return super(WeaponFire).AllowFire();
}

simulated function InitEffects()
{
    super.InitEffects();

    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    if ( (ShellEjectClass != None) && ((ShellEjectEmitter == None) || ShellEjectEmitter.bDeleteMe) )
    {
        ShellEjectEmitter = Weapon.Spawn(ShellEjectClass);
        Weapon.AttachToBone(ShellEjectEmitter, ShellEjectBoneName);
    }
}

function DrawMuzzleFlash(Canvas Canvas)
{
    super.DrawMuzzleFlash(Canvas);
    // Draw shell ejects
    if (ShellEjectEmitter != None )
    {
        Canvas.DrawActor( ShellEjectEmitter, false, false, Weapon.DisplayFOV );
    }
}

function FlashMuzzleFlash()
{
    super.FlashMuzzleFlash();

    if (ShellEjectEmitter != None)
    {
        ShellEjectEmitter.Trigger(Weapon, Instigator);
    }
}

simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (ShellEjectEmitter != None)
        ShellEjectEmitter.Destroy();
}

function DoFireEffect()
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int p;
    local int SpawnCount;
    local float theta;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();// + X*Instigator.CollisionRadius;
    StartProj = StartTrace + X*ProjSpawnOffset.X;
    if ( !Weapon.WeaponCentered() && !KFWeap.bAimingRifle )
	    StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

// Collision attachment debugging
 /*   if( Other.IsA('ROCollisionAttachment'))
    {
    	log(self$"'s trace hit "$Other.Base$" Collision attachment");
    }*/

    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    SpawnCount = Max(1, ProjPerFire * int(Load));

    switch (SpreadStyle)
    {
    case SS_Random:
        X = Vector(Aim);
        for (p = 0; p < SpawnCount; p++)
        {
            R.Yaw = Spread * (FRand()-0.5);
            R.Pitch = Spread * (FRand()-0.5);
            R.Roll = Spread * (FRand()-0.5);
            SpawnProjectile(StartProj, Rotator(X >> R));
        }
        break;
    case SS_Line:
        for (p = 0; p < SpawnCount; p++)
        {
            theta = Spread*PI/32768*(p - float(SpawnCount-1)/2.0);
            X.X = Cos(theta);
            X.Y = Sin(theta);
            X.Z = 0.0;
            SpawnProjectile(StartProj, Rotator(X >> Aim));
        }
        break;
    default:
        SpawnProjectile(StartProj, Aim);
    }
}

function float MaxRange()
{
    return 10000;
}

defaultproperties
{
     FireSoundRef="CuteWeaponPack_Snd.L2A3Sterling_Snd.L2A3Sterling_fire_single_M"
     StereoFireSoundRef="CuteWeaponPack_Snd.L2A3Sterling_Snd.L2A3Sterling_fire_single_S"
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
	 TweenTime=0.025 //0.025
	 
	 ProjPerFire=1
	 AmmoPerFire=1
	 
	 ProjectileClass=Class'CuteWeapons.L2A3SterlingFlare'
	 ProjSpawnOffset=(X=22,Y=11,Z=-12) //40, 17, -22.5
	  
     maxVerticalRecoilAngle=150 //150
	 maxHorizontalRecoilAngle=100 //100
     FireAimedAnim=Fire_Iron //"Fire_Iron"
	 
     bWaitForRelease=False
	 
     bAttachSmokeEmitter=False
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
	 
     FireRate=0.1200000 //0.12
	 RecoilRate=0.1 //0.07
	 
     AmmoClass=Class'CuteWeapons.L2A3SterlingAmmo'
	 
	 //view shake
	 ShakeOffsetMag=(X=3.5,Y=2.0,Z=3.5) //4.5, 2.8, 5.5
	 ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
	 ShakeOffsetTime=1.25
	 ShakeRotMag=(X=22.0,Y=22.0,Z=200.0) //35,35,200
	 ShakeRotRate=(X=8000.0,Y=8000.0,Z=8000.0)
	 ShakeRotTime=1.5 //3.0
	 bRandomPitchFireSound=true
     RandomPitchAdjustAmt=0.05
	 
	 ShellEjectClass=class'ROEffects.KFShellEjectMP'
	 ShellEjectBoneName=Shell_eject
     //bRandomPitchFireSound=false
	 FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=35.000000
     Spread=0.013
     SpreadStyle=SS_Random
	 FireForce="AssaultRifleFire"
}
