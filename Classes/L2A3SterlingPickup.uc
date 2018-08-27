class L2A3SterlingPickup extends KFWeaponPickup;

#exec OBJ LOAD FILE=CuteWeaponPack_A.ukx
#exec OBJ LOAD FILE=CuteWeaponPack_T.utx
#exec OBJ LOAD FILE=CuteWeaponPack_Snd.uax

defaultproperties
{
     cost=1000
     AmmoCost=18
     BuyClipSize=34
	 PowerValue=40
	 SpeedValue=30
	 RangeValue=65
     Weight=5
     Description="A British submachine gun. Fires special incendiary rounds."
     ItemName="L2A3 Sterling"
     ItemShortName="Sterling"
     AmmoItemName="9mm Incendiary Ammo"
     CorrespondingPerkIndex=5
     EquipmentCategoryID=3
     InventoryType=Class'CuteWeapons.L2A3SterlingSMG'
     PickupMessage="You got the Sterling SMG"
     PickupSound=Sound'CuteWeaponPack_Snd.L2A3Sterling_Snd.:2A3Sterling_bolt_pullback'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'CuteWeaponPack_A.L2A3Sterling_SM.L2A3Sterling_SM_two'
     DrawScale=1.1
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
