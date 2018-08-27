class LinkEjectMinimi extends KFShellEject;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
	Emitters[0].SpawnParticle(1); //link
	//Emitters[1].SpawnParticle(1); //sparks
}

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'CuteWeaponPack_A.FNMinimi_SM.bulletlink_SM'
         RespawnDeadParticles=False
         ZTest=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-250.000000) //-500
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         MaxParticles=50
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         StartSizeRange=(X=(Min=4.500000,Max=4.500000),Y=(Min=4.500000,Max=4.500000),Z=(Min=4.500000,Max=4.500000)) //2.5 for all
         LifetimeRange=(Min=5.000000,Max=5.000000)
         StartVelocityRange=(Y=(Min=-25.000000,Max=-25.000000),Z=(Min=100.000000,Max=150.000000))
     End Object
     Emitters(0)=MeshEmitter'MeshEmitter0'
}
