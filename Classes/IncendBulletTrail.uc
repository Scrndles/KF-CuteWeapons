class IncendBulletTrail extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UniformSize=True
        ColorScale(0)=(Color=(R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=255,A=255)) //255 on all
        ColorMultiplierRange=(Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        Opacity=0.33000 //0.33
        FadeOutStartTime=10.000000
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        Name="SpriteEmitter0"
        StartSizeRange=(X=(Min=7.000000,Max=7.000000),Y=(Min=7.000000,Max=7.000000),Z=(Min=7.000000,Max=7.000000))
        InitialParticlesPerSecond=1.000000
        Texture=Texture'Waterworks_T.General.glow_dam01'
        LifetimeRange=(Min=0.100000,Max=0.100000)
        WarmupTicksPerSecond=1.000000
        RelativeWarmupTime=30.000000
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        FadeOut=True
        UseRegularSizeScale=False
        ScaleSizeYByVelocity=True
        Acceleration=(Z=-500.000000)
        DampingFactorRange=(X=(Min=0.200000),Y=(Min=0.200000),Z=(Min=0.200000,Max=0.500000))
        ColorScale(0)=(Color=(R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=128))
        FadeOutStartTime=0.500000
        MaxParticles=100 //100
		Opacity=0.70000 //1.0
        Name="SpriteEmitter2"
        DetailMode=DM_High
        UseRotationFrom=PTRS_Actor
        SizeScale(2)=(RelativeTime=0.070000,RelativeSize=1.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=0.2500000,Max=0.500000),Y=(Min=0.2500000,Max=0.500000),Z=(Min=0.2500000,Max=0.500000))
        ScaleSizeByVelocityMultiplier=(Y=0.020000)
        DrawStyle=PTDS_Brighten
        Texture=Texture'KFX.KFSparkHead'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.700000,Max=1.000000)
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    bNetTemporary=True
    RemoteRole=ROLE_None
    bNoDelete=false
    Physics=PHYS_Trailer
    DrawScale = 1.0
}


