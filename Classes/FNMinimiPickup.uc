class FNMinimiPickup extends KFWeaponPickup;

#exec OBJ LOAD FILE=CuteWeaponPack_T.utx
#exec OBJ LOAD FILE=CuteWeaponPack_A.ukx
#exec OBJ LOAD FILE=CuteWeaponPack_Snd.uax

defaultproperties
{
     Weight=8.000000
     cost=1750
     AmmoCost=35
     BuyClipSize=75
     PowerValue=80
     SpeedValue=40
     RangeValue=100
     Description="FN Minimi pickup description."
     ItemName="FN Minimi"
     ItemShortName="FN Minimi"
     AmmoItemName="5.56mm Rounds"
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'CuteWeapons.FNMinimiLMG'
     PickupSound=Sound'CuteWeaponPack_Snd.FNMinimi_Snd.FNMinimi_minimipickup'
     PickupMessage="You got the FN Minimi Light Machine Gun"
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'CuteWeaponPack_A.FNMinimi_SM.FNMinimi_pickup'
     DrawScale=1.0
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}