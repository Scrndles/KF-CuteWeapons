class L2A3SterlingFlare extends ScrnFlareProjectile;

//disabling all explosion effect except explosionemitter
simulated function Explode(vector HitLocation, vector HitNormal)
{
    //
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(ExplosionEmitter,,,HitLocation + HitNormal*20,rotator(HitNormal));
    }

    bHasExploded = True;
    Destroy();
}


// Get the shake amount for when this projectile explodes
simulated function float GetShakeScale(vector ViewLocation, vector EventLocation)
{
    local float Dist;
    local float scale;

    Dist = VSize(ViewLocation - EventLocation);

	if (Dist < DamageRadius * 2.0 )
	{
		scale = (DamageRadius*2.0  - Dist) / (DamageRadius*2.0);
	}

	return scale;
}

defaultproperties
{
	HeadShotDamageMult=1.50000 //extra flare burn damage awarded on headshots
    Speed=7500
    MaxSpeed=8000
	ImpactDamage=35 //35
    Damage=10.000000 //initial fire damage, old value was 18
	
	StaticMeshRef="EffectsSM.Ger_Tracer" 
	bTrueBallistics=false
    bInitialAcceleration=false
	DrawScale=0.25 //0.50
	
	ImpactDamageType=Class'CuteWeapons.DamTypeIncendImpact'
	MyDamageType=Class'CuteWeapons.DamTypeIncendFlare'
	
	//Disable most of the default explosion effects
    ExplosionSoundRef="None"//"KF_IJC_HalloweenSnd.KF_FlarePistol_Projectile_Hit"
    AmbientSoundRef="None"//"KF_IJC_HalloweenSnd.KF_FlarePistol_Projectile_Loop"
    ExplosionDecal="None"//Class'KFMod.FlameThrowerBurnMark_Medium'
    ExplosionEmitter=Class'CuteWeapons.IncendImpactEffect'
    ExplosionSoundVolume=0.000000
    FlameTrailEmitterClass=Class'CuteWeapons.IncendBulletTrail'
	
	ShakeRotMag=(X=0.000000,Y=0.000000,Z=0.000000)
	ShakeOffsetMag=(X=0.000000,Y=0.000000,Z=0.000000)

	ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
	ShakeRotTime=0.000000

	ShakeOffsetRate=(X=0.000000,Y=0.000000,Z=0.000000)
	ShakeOffsetTime=0.000000
	RotMag=(X=0.000000,Y=0.000000,Z=0.000000)
	RotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
	RotTime=0.000000
	OffsetMag=(X=0.000000,Y=0.000000,Z=0.000000)
	OffsetRate=(X=0.000000,Y=0.000000,Z=0.000000)
	OffsetTime=0.000000

    LightType=LT_Steady
    LightBrightness=140 //255
    LightRadius=4.000000 //16
    LightHue=10 //255
    LightSaturation=32 //64
    LightCone=4
    bDynamicLight=True

    bUnlit=True
    AmbientGlow=80 //254
    AmbientVolumeScale=1.5 //2.5
}