class AUGLMGTFire extends KFHighROFFire;
//featuring amazing pitch shift technology

var float AmbientSoundPitchMult; //stores ambient sound pitch multiplier
var             float           ZoomedRecoilMult; //zoomed recoil multiplier

// Overriden to change fire end sound pitch (to match FAL rpm to AUG LMG-T)
state FireLoop
{
    function BeginState()
    {
        super.BeginState();
		NextFireTime = Level.TimeSeconds - 0.000001; //fire now! // fixes double shot bug -- PooSH

        if( KFWeap.bAimingRifle )
		{
            Weapon.LoopAnim(FireLoopAimedAnim, FireLoopAnimRate, TweenTime);
		}
		else
		{
            Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);
		}

		PlayAmbientSound(AmbientFireSound);
    }

	// Overriden because we play an anbient fire sound
    function PlayFiring() {}
	function ServerPlayFiring() {}

    function EndState()
    {
        Weapon.AnimStopLooping();
        PlayAmbientSound(none);
    	if( Weapon.Instigator != none && Weapon.Instigator.IsLocallyControlled() &&
    	   Weapon.Instigator.IsFirstPerson() && StereoFireSound != none )
    	{
            Weapon.PlayOwnedSound(FireEndStereoSound,SLOT_None,AmbientFireVolume/127,,AmbientFireSoundRadius,1.0*AmbientSoundPitchMult,false); //1.25*64 = 80
        }
        else
        {
            Weapon.PlayOwnedSound(FireEndSound,SLOT_None,AmbientFireVolume/127,,AmbientFireSoundRadius,1.0*AmbientSoundPitchMult,false); //1.25*64 = 80
        }
        Weapon.StopFire(ThisModeNum);
    }

    function StopFiring()
    {
        GotoState('');
    }

    function ModeTick(float dt)
    {
	    Super.ModeTick(dt);

		if ( !bIsFiring ||  !AllowFire()  )  // stopped firing, magazine empty
        {
			GotoState('');
			return;
		}
    }
}

function PlayFiring()
{
    local float RandPitch;

	if ( Weapon.Mesh != None )
	{
		if ( FireCount > 0 )
		{
			if( KFWeap.bAimingRifle )
			{
                if ( Weapon.HasAnim(FireLoopAimedAnim) )
    			{
    				Weapon.PlayAnim(FireLoopAimedAnim, FireLoopAnimRate, 0.0);
    			}
    			else if( Weapon.HasAnim(FireAimedAnim) )
    			{
    				Weapon.PlayAnim(FireAimedAnim, FireAnimRate, TweenTime);
    			}
    			else
    			{
                    Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    			}
			}
			else
			{
                if ( Weapon.HasAnim(FireLoopAnim) )
    			{
    				Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
    			}
    			else
    			{
    				Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    			}
			}
		}
		else
		{
            if( KFWeap.bAimingRifle )
			{
                if( Weapon.HasAnim(FireAimedAnim) )
    			{
                    Weapon.PlayAnim(FireAimedAnim, FireAnimRate, TweenTime);
    			}
    			else
    			{
                    Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    			}
			}
			else
			{
                Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
			}
		}
	}


	if( Weapon.Instigator != none && Weapon.Instigator.IsLocallyControlled() &&
	   Weapon.Instigator.IsFirstPerson() && StereoFireSound != none )
	{
        if( bRandomPitchFireSound )
        {
            RandPitch = FRand() * RandomPitchAdjustAmt;

            if( FRand() < 0.5 )
            {
                RandPitch *= -1.0;
            }
        }

        Weapon.PlayOwnedSound(StereoFireSound,SLOT_Interact,TransientSoundVolume * 0.85,,TransientSoundRadius,(1.0*AmbientSoundPitchMult + RandPitch),false);
    }
    else
    {
        if( bRandomPitchFireSound )
        {
            RandPitch = FRand() * RandomPitchAdjustAmt;

            if( FRand() < 0.5 )
            {
                RandPitch *= -1.0;
            }
        }

        Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,(1.0*AmbientSoundPitchMult + RandPitch),false);
    }
    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

// Handles toggling the weapon attachment's ambient sound on and off
// Overriden to change ambient sound pitch (to match FAL rpm to AUG LMG-T)
function PlayAmbientSound(Sound aSound)
{
	local WeaponAttachment WA;

	WA = WeaponAttachment(Weapon.ThirdPersonActor);

    if ( Weapon == none || (WA == none))
        return;

	if(aSound == None)
	{
		WA.SoundVolume = WA.default.SoundVolume;
		WA.SoundRadius = WA.default.SoundRadius;
        WA.SoundPitch = WA.default.SoundPitch*AmbientSoundPitchMult;
	}
	else
	{
		WA.SoundVolume = AmbientFireVolume;
		WA.SoundRadius = AmbientFireSoundRadius;
        WA.SoundPitch = 64*AmbientSoundPitchMult;
	}

    WA.AmbientSound = aSound;
}


//adding zoomed recoil multiplier
function ModeDoFire()
{
	local float Rec;

	if (!AllowFire())
		return;

	Spread = Default.Spread;

	Rec = GetFireSpeed();
	FireRate = default.FireRate/Rec;
	FireAnimRate = default.FireAnimRate*Rec;
	Rec = 1;

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		Spread *= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.ModifyRecoilSpread(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self, Rec);
	}

	if( !bFiringDoesntAffectMovement )
	{
		if (FireRate > 0.25)
		{
			Instigator.Velocity.x *= 0.1;
			Instigator.Velocity.y *= 0.1;
		}
		else
		{
			Instigator.Velocity.x *= 0.5;
			Instigator.Velocity.y *= 0.5;
		}
	}

    if( KFWeapon(Weapon).bAimingRifle )
    {
        if ( AUGLMGT(Weapon).KFScopeDetail != KF_TextureScope)
        {
            maxVerticalRecoilAngle=default.maxVerticalRecoilAngle*ZoomedRecoilMult;
            maxHorizontalRecoilAngle=default.maxVerticalRecoilAngle*ZoomedRecoilMult;
        }
        else
        {
            maxVerticalRecoilAngle=default.maxVerticalRecoilAngle*ZoomedRecoilMult*2.0;
            maxHorizontalRecoilAngle=default.maxVerticalRecoilAngle*ZoomedRecoilMult*2.0;
        }
    }
    else 
    {
        maxVerticalRecoilAngle=default.maxVerticalRecoilAngle;
        maxHorizontalRecoilAngle=default.maxVerticalRecoilAngle;
    }

	Super.ModeDoFire();

    // client
    if (Instigator.IsLocallyControlled())
    {
        HandleRecoil(Rec);
    }
}


defaultproperties
{
    FireAimedAnim=Fire_Iron
    FireLoopAnim=Fire_Loop
    FireLoopAimedAnim=Fire_Iron_Loop
    FireEndAnim=Fire_End
    FireEndAimedAnim=Fire_Iron_End
    //EmptyFireAnim="Bolt_Close_Iron"
    //EmptyFireAnimRate=1.000000
	

    FireSoundRef="KF_FNFALSnd.FNFAL_Fire_Loop_End_M"
    StereoFireSoundRef="KF_FNFALSnd.FNFAL_Fire_Loop_End_S"
    AmbientFireSoundRef="KF_FNFALSnd.FNFAL_Fire_Loop"
    FireEndSoundRef="KF_FNFALSnd.FNFAL_Fire_Loop_End_M"
    FireEndStereoSoundRef="KF_FNFALSnd.FNFAL_Fire_Loop_End_S"

    
     AmbientSoundPitchMult=1.25// only values above 1

     AmbientFireSoundRadius=500
     AmbientFireVolume=255	
	
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
	 FireRate=0.092// 650RPM (actually 652)
     
     FireLoopAnimRate=1.806 // 650 // for 700 use 1.943
     FireEndAnimRate=1.806
     
     RecoilRate=0.065//0.065
     maxVerticalRecoilAngle=225
     maxHorizontalRecoilAngle=100

     DamageType=Class'CuteWeapons.DamTypeAUGLMGT'
     DamageMax=37
     Momentum=12500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     bAccuracyBonusForSemiAuto=false
     ZoomedRecoilMult=0.4 //only applies to 3d scope zoom, textured scopes get 0.8
     
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     AmmoClass=Class'CuteWeapons.AUGLMGTAmmo'
     AmmoPerFire=1
     
	 ShakeOffsetMag=(X=0.0,Y=0.0,Z=0.5)
	 ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
	 ShakeOffsetTime=1.15
	 ShakeRotMag=(X=50.0,Y=50.0,Z=300.0)
	 ShakeRotRate=(X=7500.0,Y=7500.0,Z=7500.0)
	 ShakeRotTime=0.65
     
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=42.000000
     Spread=0.006
     MaxSpread=0.06
     SpreadStyle=SS_Random
	 ShellEjectClass=class'ROEffects.KFShellEjectM4Rifle'
     ShellEjectBoneName="Shell_eject"
}