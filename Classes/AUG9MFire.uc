class AUG9MFire extends KFFire;

// overwriting to give this weapon custom spread, copypasted from KFFire
// Calculate modifications to spread
simulated function float GetSpread()
{
    local float NewSpread;
    local float AccuracyMod;

    AccuracyMod = 1.0;

    // Spread bonus for firing aiming
    if( KFWeap.bAimingRifle )
    {
        AccuracyMod *= 0.5;
    }

    // Small spread bonus for firing crouched
    if( Instigator != none && Instigator.bIsCrouched )
    {
        AccuracyMod *= 0.85;
    }

    // Small spread bonus for firing in semi auto mode
    if( bAccuracyBonusForSemiAuto && bWaitForRelease )
    {
        AccuracyMod *= 0.85;
    }

    NumShotsInBurst += 1;

	if ( Level.TimeSeconds - LastFireTime > 0.35 ) //changed from 0.5 to 0.35
	{
		NewSpread = Default.Spread;
		NumShotsInBurst=0;
	}
	else
    {
        // Decrease accuracy up to MaxSpread by the number of recent shots up to a max of six
        NewSpread = FMin(Default.Spread + (NumShotsInBurst * (MaxSpread/6.0)),MaxSpread);
    }

    NewSpread *= AccuracyMod;

    return NewSpread;
}

defaultproperties
{

	 FireSoundRef="CuteWeaponPack_Snd.AUG9M_S.AUG9M_fire_single_M"
	 StereoFireSoundRef="CuteWeaponPack_Snd.AUG9M_S.AUG9M_fire_single_S"
     NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
	 FireAimedAnim=Fire_Iron 
	 FireAnim=Fire 
     FireAnimRate=1.25
     
     RecoilRate=0.070000 //0.08
     maxVerticalRecoilAngle=140 //125
     maxHorizontalRecoilAngle=75 //75

     bAccuracyBonusForSemiAuto=True
     DamageType=Class'CuteWeapons.DamTypeAUG9M'
     DamageMax=35
     Momentum=12500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.093000 //645 RPM
     AmmoClass=Class'CuteWeapons.AUG9MAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=25.000000,Y=25.000000,Z=125.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=1.0 //3.0
     ShakeOffsetMag=(X=4.000000,Y=2.500000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=42.000000
     Spread=0.007500
     MaxSpread=0.09 //default was 0.12
     bRandomPitchFireSound=true
     RandomPitchAdjustAmt=0.05 //0.05
     SpreadStyle=SS_Random
	 ShellEjectClass=class'ROEffects.KFShellEjectMP'
     ShellEjectBoneName="Shell_eject"
}