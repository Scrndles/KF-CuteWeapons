class FNMinimiFire extends KFFire;

var()           class<Emitter>  LinkEjectClass;            // class of the shell eject emitter
var()           Emitter         LinkEjectEmitter;          // The shell eject emitter
var()           name            LinkEjectBoneName;         // name of the shell eject bone

//adding link eject
simulated function DestroyEffects()
{
    super.DestroyEffects();
    
    if (ShellEjectEmitter != None)
        ShellEjectEmitter.Destroy();
        
    //if (LinkEjectEmitter != None)
    //    LinkEjectEmitter.Destroy();
}

//adding link eject
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
    if ( (LinkEjectClass != None) && ((LinkEjectEmitter == None) || LinkEjectEmitter.bDeleteMe) )
    {
        LinkEjectEmitter = Weapon.Spawn(LinkEjectClass);
        Weapon.AttachToBone(LinkEjectEmitter, LinkEjectBoneName);
    }
    if ( FlashEmitter != None )
        Weapon.AttachToBone(FlashEmitter, KFWeapon(Weapon).FlashBoneName);
}


// Sends the fire class to the looping state
function StartFiring()
{
    if( !bWaitForRelease )
    {
        GotoState('FireLoop');
    }
    else
    {
        Super.StartFiring();
    }
}


// Make sure we are in the fire looping state when we fire
event ModeDoFire()
{
    if( !bWaitForRelease )
    {
    	if( AllowFire() && IsInState('FireLoop'))
    	{
    	    Super.ModeDoFire();
    	}
	}
	else
	{
	   Super.ModeDoFire();
	}
}
 
//has looping anims fixed
state FireLoop
{
    function BeginState()
    {
		NextFireTime = Level.TimeSeconds - 0.000001; //fire now!

        if( KFWeap.bAimingRifle )
		{
            Weapon.LoopAnim(FireLoopAimedAnim, FireLoopAnimRate, TweenTime);
		}
		else
		{
            Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);
		}
    }
    
    function EndState()
    {
        Weapon.AnimStopLooping();
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
    				Weapon.LoopAnim(FireLoopAimedAnim, FireLoopAnimRate, 0.0);
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
    				Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
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
	   Weapon.Instigator.IsFirstPerson() /*&& StereoFireSound != none */)
	{
        if( bRandomPitchFireSound )
        {
            RandPitch = FRand() * RandomPitchAdjustAmt;

            if( FRand() < 0.5 )
            {
                RandPitch *= -1.0;
            }
        }

        Weapon.PlayOwnedSound(StereoFireSound,SLOT_Interact,TransientSoundVolume * 0.85,,TransientSoundRadius,(1.0 + RandPitch),false);
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

        Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,(1.0 + RandPitch),false);
    }
    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

function PlayFireEnd()
{
    if( !bWaitForRelease )
    {
        Super.PlayFireEnd();
    }
}

function FlashMuzzleFlash()
{
    super.FlashMuzzleFlash();

    if (LinkEjectEmitter != None)
    {
        LinkEjectEmitter.Trigger(Weapon, Instigator);
    }
}

defaultproperties
{
    FireLoopAnim=Fire_Loop
    FireLoopAimedAnim=Fire_Iron_Loop
    FireEndAnim=Fire_End
    FireEndAimedAnim=Fire_Iron_End
    
    NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
    
    FireSoundRef="CuteWeaponPack_Snd.FNMinimi_Snd.FNMinimi_fire_single_M"
    StereoFireSoundRef="CuteWeaponPack_Snd.FNMinimi_Snd.FNMinimi_fire_single_S"
	
     //NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
	 FireRate=0.075// 0.075 for 800RPM
     FireAnimRate=1.00
     
     FireEndAnimRate=1.00
     RecoilRate=0.06//0.065
     maxVerticalRecoilAngle=200 //250
     maxHorizontalRecoilAngle=125 //100

     bAccuracyBonusForSemiAuto=True
     DamageType=Class'CuteWeapons.DamTypeFNMinimi'
     DamageMax=37
     Momentum=12500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     AmmoClass=Class'CuteWeapons.FNMinimiAmmo'
     AmmoPerFire=1
        
    //bullpup's
    ShakeOffsetMag=(X=6.0,Y=3.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=75.0,Y=75.0,Z=250.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.5  
    
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=42.000000
     Spread=0.007500
     MaxSpread=0.06
     SpreadStyle=SS_Random
	 //ShellEjectClass=class'ROEffects.KFShellEjectM4Rifle'
     ShellEjectClass=class'ROEffects.KFShellEjectAK'
     ShellEjectBoneName="Shell_eject"
     LinkEjectClass=class'CuteWeapons.LinkEjectMinimi'
     LinkEjectBoneName="Link_eject"
}