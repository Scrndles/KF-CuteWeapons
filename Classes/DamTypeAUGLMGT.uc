class DamTypeAUGLMGT extends KFProjectileWeaponDamageType;

// Award also Shiver kills with 2x Stalker progress 
// Count only 1 kill from now on, because new version of Shiver.se calls 
// AwardKill() twice: for the decapitator and for the killer
static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
	if( Killed.IsA('ZombieStalker') || Killed.IsA('ZombieShiver') )
		KFStatsAndAchievements.AddStalkerKill();
} 

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
	KFStatsAndAchievements.AddBullpupDamage(Amount);
}

defaultproperties
{
     HeadShotDamageMult=1.3
     WeaponClass=Class'CuteWeapons.AUGLMGT'
     DeathString="%k killed %o (AUG LMG-T)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bRagdollBullet=True
     KDamageImpulse=5500.000000
     KDeathVel=175.000000
     KDeathUpKick=20.000000
}