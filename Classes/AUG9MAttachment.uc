class AUG9MAttachment extends KFWeaponAttachment;

defaultproperties
{
     MeshRef="CuteWeaponPack_A.AUG9M_3rd"

     mMuzFlashClass=Class'ROEffects.MuzzleFlash3rdMP'
     mTracerClass=Class'KFMod.KFNewTracer'
     mShellCaseEmitterClass=Class'KFMod.KFShellSpewer'
	 MovementAnims(0)=JogF_Bullpup
     MovementAnims(1)=JogB_Bullpup
     MovementAnims(2)=JogL_Bullpup
     MovementAnims(3)=JogR_Bullpup
     CrouchAnims(0)=CHwalkF_BullPup
     CrouchAnims(1)=CHwalkB_BullPup
     CrouchAnims(2)=CHwalkL_BullPup
     CrouchAnims(3)=CHwalkR_BullPup
     WalkAnims(0)=WalkF_Bullpup
     WalkAnims(1)=WalkB_Bullpup
     WalkAnims(2)=WalkL_Bullpup
     WalkAnims(3)=WalkR_Bullpup
     AirStillAnim=JumpF_Mid
     AirAnims(0)=JumpF_Mid
     AirAnims(1)=JumpF_Mid
     AirAnims(2)=JumpL_Mid
     AirAnims(3)=JumpR_Mid
     TakeoffStillAnim=JumpF_Takeoff
     TakeoffAnims(0)=JumpF_Takeoff
     TakeoffAnims(1)=JumpF_Takeoff
     TakeoffAnims(2)=JumpL_Takeoff
     TakeoffAnims(3)=JumpR_Takeoff
     LandAnims(0)=JumpF_Land
     LandAnims(1)=JumpF_Land
     LandAnims(2)=JumpL_Land
     LandAnims(3)=JumpR_Land
     
     TurnRightAnim=TurnR_Bullpup
     TurnLeftAnim=TurnL_Bullpup
     CrouchTurnRightAnim=CH_TurnR_Bullpup
     CrouchTurnLeftAnim=CH_TurnL_Bullpup
     IdleRestAnim=Idle_Bullpup//Idle_Rest
     IdleCrouchAnim=CHIdle_BullPup
     IdleSwimAnim=Swim_Tread
     IdleWeaponAnim=Idle_Bullpup//Idle_Rifle
     IdleHeavyAnim=Idle_Bullpup//Idle_Biggun
     IdleRifleAnim=Idle_Bullpup//Idle_Rifle
     IdleChatAnim=Idle_Bullpup
     FireAnims(0)=Fire_Bullpup
     FireAnims(1)=Fire_Bullpup
     FireAnims(2)=Fire_Bullpup
     FireAnims(3)=Fire_Bullpup
     FireAltAnims(0)=Fire_Bullpup
     FireAltAnims(1)=Fire_Bullpup
     FireAltAnims(2)=Fire_Bullpup
     FireAltAnims(3)=Fire_Bullpup
     FireCrouchAnims(0)=CHFire_BullPup
     FireCrouchAnims(1)=CHFire_BullPup
     FireCrouchAnims(2)=CHFire_BullPup
     FireCrouchAnims(3)=CHFire_BullPup
     FireCrouchAltAnims(0)=CHFire_BullPup
     FireCrouchAltAnims(1)=CHFire_BullPup
     FireCrouchAltAnims(2)=CHFire_BullPup
     FireCrouchAltAnims(3)=CHFire_BullPup
     HitAnims(0)=HitF_Bullpup
     HitAnims(1)=HitB_Bullpup
     HitAnims(2)=HitL_Bullpup
     HitAnims(3)=HitR_Bullpup
     PostFireBlendStandAnim=Blend_Bullpup
     PostFireBlendCrouchAnim=CHBlend_Bullpup
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
}