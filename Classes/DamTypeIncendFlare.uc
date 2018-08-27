class DamTypeIncendFlare extends ScrnDamTypeFlare
    abstract;

defaultproperties
{
     WeaponClass=Class'CuteWeapons.L2A3SterlingSMG'
     MinBurnTime=1.5 //5
     MaxBurnTime=10 //8
     BurnTimeInc=0.25//0.5
     BurnTimeBoost=1//2
	 
     iDoT_FadeFactor=0.6//default 0.25
	 iDoT_MinBoostRatio=0.5//default 0.20
}