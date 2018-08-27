class IncendImpactEffect extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseDirectionAs=PTDU_Up
        UseCollision=True
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        UseRegularSizeScale=False
        UniformSize=True
        ScaleSizeYByVelocity=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Acceleration=(Z=-400.000000)//-500
        ColorScale(0)=(Color=(B=120,G=120,R=255))//200
        ColorScale(1)=(RelativeTime=0.200000,Color=(B=140,G=140,R=242)) //B190 G220
        ColorScale(2)=(RelativeTime=0.400000,Color=(B=180,G=180,R=255)) //B200 G255
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=200,G=200,R=255)) //B200 G255
        FadeOutStartTime=0.800000 //0.8
        MaxParticles=8
        Name="SpriteEmitter4"
        SizeScale(2)=(RelativeTime=0.070000,RelativeSize=1.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
        ScaleSizeByVelocityMultiplier=(Y=0.005000)
        InitialParticlesPerSecond=500.000000
        Texture=Texture'KFX.KFSparkHead'
        TextureUSubdivisions=1
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.500000,Max=0.700000) //0.7, 1.0
        StartVelocityRange=(X=(Min=-450.000000,Max=450.000000),Y=(Min=-450.000000,Max=450.000000),Z=(Max=450.000000)) //-500 and 500
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'


    bNoDelete = false
    AutoDestroy = true

    SoundVolume = 255
    SoundRadius = 100
    bFullVolume = false
    AmbientSound = Sound'Amb_Destruction.Kessel_Fire_Small_Vehicle'//Sound'GeneralAmbience.firefx12' KFTODO: Replace this

    LightRadius = 1.5
    LightType = LT_Steady

    LightBrightness = 170 //255
    LightHue = 255 //255
    LightSaturation = 64 //64
    bDynamicLight = true
	LifeSpan=1//3
	//Duration = 0.5//
}
