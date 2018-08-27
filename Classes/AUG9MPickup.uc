class AUG9MPickup extends KFWeaponPickup;

#exec OBJ LOAD FILE=CuteWeaponPack_A.ukx
#exec OBJ LOAD FILE=CuteWeaponPack_T.utx
#exec OBJ LOAD FILE=CuteWeaponPack_Snd.uax

defaultproperties
{
     Weight=4.000000
     cost=1500 
     AmmoCost=14
     BuyClipSize=25
     PowerValue=45
     SpeedValue=85
     RangeValue=70
     Description="AUG 9mm sub machine gun. Modified to fire healing darts. Can fire more darts with a single charge."
     ItemName="AUG9M Medic Gun"
     ItemShortName="AUG9M"
     AmmoItemName="9mm Ammo"
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=0
     EquipmentCategoryID=3
     InventoryType=Class'CuteWeapons.AUG9MMedicGun'
     PickupMessage="You got the AUG9M Medic Gun"
	 PickupSound=Sound'KF_BullpupSnd.Bullpup_Pickup'
	 StaticMesh=StaticMesh'CuteWeaponPack_A.AUG9M_SM.AUG9M_pickup'
     DrawScale=1.1
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}