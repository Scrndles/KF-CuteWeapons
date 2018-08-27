class FNMinimiLMG extends KFWeapon;
//FN Minimi light machine gun with amazing bullet disappearing magic

var 		name 			ReloadShortAnim;
var 		float 			ReloadShortRate;

var transient bool  bShortReload;
var int OldMagAmmoRemaining; //stores last magammoremaining
var float UpdateBulletsTime; //time after firing to update bullet display
var float UpdateBulletsOnFireTime; //time after firing to update bullet display

replication
{
	reliable if(Role == ROLE_Authority)
		DoBullets;
}

simulated function Notify_ShowBullets()
{
    if ( !Instigator.IsLocallyControlled() )
    return ;
    DoBullets(AmmoAmount(0)); //show/hide bullets for AmmoAmount(0);
}

//this function controls bullet visibility, it is called in the middle with ammoamount on reloads to show bullets, and called during/after every fire with magammoremaining to hide bullets
simulated function DoBullets( int NumBullets)
{    
    if ( !Instigator.IsLocallyControlled() )
        return ;
    if ( NumBullets > 13)
    NumBullets = 13; //clamp NumBullets to max of 13
        switch ( NumBullets ) {
            case 13:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 1.0, 'b11');
                SetBoneScale(12, 1.0, 'b12');
                SetBoneScale(13, 1.0, 'b13');
                break; 
            case 12:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 1.0, 'b11');
                SetBoneScale(12, 1.0, 'b12');
                SetBoneScale(13, 0.0, 'b13');    
                break; 
            case 11:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 1.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 10:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 9:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 8:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 7:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 6:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 5:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 4:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;            
            case 3:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 0.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;            
            case 2:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 0.0, 'b3');
                SetBoneScale(4, 0.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;            
            case 1:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 0.0, 'b2');
                SetBoneScale(3, 0.0, 'b3');
                SetBoneScale(4, 0.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;     
            case 0:
                SetBoneScale(1, 0.0, 'b1');
                SetBoneScale(2, 0.0, 'b2');
                SetBoneScale(3, 0.0, 'b3');
                SetBoneScale(4, 0.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;                  
            default:
                //this shouldn't happen but its a fallback so show staggered bullets to indicate something is broken
                SetBoneScale(1, 0.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 0.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 1.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
        }
}

//this is a copypasta for select animnotify to do DoBullets without firing and with MagAmmoRemaining
simulated function Notify_DoBullets()
{    
    local int LocalMagAmmo;
    if ( !Instigator.IsLocallyControlled() )
        return ;
    LocalMagAmmo = MagAmmoRemaining;
    if ( MagAmmoRemaining > 13)
    LocalMagAmmo = 13; //clamp LocalMagAmmo to max of 13
        switch ( LocalMagAmmo ) {
            case 13:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 1.0, 'b11');
                SetBoneScale(12, 1.0, 'b12');
                SetBoneScale(13, 1.0, 'b13');
                break; 
            case 12:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 1.0, 'b11');
                SetBoneScale(12, 1.0, 'b12');
                SetBoneScale(13, 0.0, 'b13');    
                break; 
            case 11:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 1.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 10:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 9:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 1.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 8:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 7:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 1.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 6:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 5:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 1.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break; 
            case 4:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;            
            case 3:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 1.0, 'b3');
                SetBoneScale(4, 0.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;            
            case 2:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 0.0, 'b3');
                SetBoneScale(4, 0.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;            
            case 1:
                SetBoneScale(1, 1.0, 'b1');
                SetBoneScale(2, 0.0, 'b2');
                SetBoneScale(3, 0.0, 'b3');
                SetBoneScale(4, 0.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;     
            case 0:
                SetBoneScale(1, 0.0, 'b1');
                SetBoneScale(2, 0.0, 'b2');
                SetBoneScale(3, 0.0, 'b3');
                SetBoneScale(4, 0.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 0.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 0.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 0.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 0.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
                break;                  
            default:
                //this shouldn't happen but its a fallback so show staggered bullets to indicate something is broken
                SetBoneScale(1, 0.0, 'b1');
                SetBoneScale(2, 1.0, 'b2');
                SetBoneScale(3, 0.0, 'b3');
                SetBoneScale(4, 1.0, 'b4');
                SetBoneScale(5, 0.0, 'b5');
                SetBoneScale(6, 1.0, 'b6');
                SetBoneScale(7, 0.0, 'b7');
                SetBoneScale(8, 1.0, 'b8');
                SetBoneScale(9, 0.0, 'b9');
                SetBoneScale(10, 1.0, 'b10');
                SetBoneScale(11, 0.0, 'b11');
                SetBoneScale(12, 1.0, 'b12');
                SetBoneScale(13, 0.0, 'b13'); 
        }
}

//copypasta
simulated function bool StartFire(int Mode)
{
	if( KFFire(FireMode[Mode]) == none || FireMode[Mode].bWaitForRelease )
		return super.StartFire(Mode);

	if( !super.StartFire(Mode) )  // returns false when mag is empty
	   return false;

	if( AmmoAmount(0) <= 0 )
	{
    	return false;
    }

	AnimStopLooping();

	if( !FireMode[Mode].IsInState('FireLoop') && (AmmoAmount(0) > 0) )
	{
		FireMode[Mode].StartFiring();
		return true;
	}
	else
	{
		return false;
	}

	return true;
}

simulated function AnimEnd(int channel)
{
    local name anim;
    local float frame, rate;

	if(!FireMode[0].IsInState('FireLoop'))
	{
        GetAnimParams(0, anim, frame, rate);

        if (ClientState == WS_ReadyToFire)
        {
             if ((FireMode[0] == None || !FireMode[0].bIsFiring) && (FireMode[1] == None || !FireMode[1].bIsFiring))
            {
                PlayIdle();
            }
        }
	}
}

simulated event OnZoomOutFinished()
{
	local name anim;
	local float frame, rate;

	GetAnimParams(0, anim, frame, rate);

	if (ClientState == WS_ReadyToFire)
	{
		// Play the regular idle anim when we're finished zooming out
		if (anim == IdleAimAnim)
		{
            PlayIdle();
		}
		// Switch looping fire anims if we switched to/from zoomed
		else if( FireMode[0].IsInState('FireLoop') && anim == 'Fire_Iron_Loop')
		{
            LoopAnim('Fire_Loop', FireMode[0].FireLoopAnimRate, FireMode[0].TweenTime);
		}
	}
}

/**
 * Called by the native code when the interpolation of the first person weapon to the zoomed position finishes
 */
simulated event OnZoomInFinished()
{
	local name anim;
	local float frame, rate;

	GetAnimParams(0, anim, frame, rate);

	if (ClientState == WS_ReadyToFire)
	{
		// Play the iron idle anim when we're finished zooming in
		if (anim == IdleAnim)
		{
		   PlayIdle();
		}
		// Switch looping fire anims if we switched to/from zoomed
		else if( FireMode[0].IsInState('FireLoop') && anim == 'Fire_Loop' )
		{
            LoopAnim('Fire_Iron_Loop', FireMode[0].FireLoopAnimRate, FireMode[0].TweenTime);
		}
	}
}

//added updatebullettime and updatebulletonfiretime
simulated function WeaponTick(float dt)
{
	local float LastSeenSeconds,ReloadMulti;

	if( bHasAimingMode )
	{
        if( bForceLeaveIronsights )
        {
        	if( bAimingRifle )
        	{
                ZoomOut(true);

            	if( Role < ROLE_Authority)
        			ServerZoomOut(false);
            }

            bForceLeaveIronsights = false;
        }

        if( ForceZoomOutTime > 0 )
        {
            if( bAimingRifle )
            {
        	    if( Level.TimeSeconds - ForceZoomOutTime > 0 )
        	    {
                    ForceZoomOutTime = 0;

                	ZoomOut(true);

                	if( Role < ROLE_Authority)
            			ServerZoomOut(false);
        		}
    		}
    		else
    		{
                ForceZoomOutTime = 0;
    		}
    	}
	}
    
    //updated to only play everytime magammo changes and is 13 or below
    if( MagAmmoRemaining <= 13 && MagAmmoRemaining != OldMagAmmoRemaining && Level.TimeSeconds - FireMode[0].NextFireTime > -0.04 )
    {
        OldMagAmmoRemaining = MagAmmoRemaining;
        DoBullets(MagAmmoRemaining); //update ammo belt display
    }

	 if ( (Level.NetMode == NM_Client) || Instigator == None || KFFriendlyAI(Instigator.Controller) == none && Instigator.PlayerReplicationInfo == None)
		return;

	// Turn it off on death  / battery expenditure
	if (FlashLight != none)
	{
		// Keep the 1Pweapon client beam up to date.
		AdjustLightGraphic();
		if (FlashLight.bHasLight)
		{
			if (Instigator.Health <= 0 || KFHumanPawn(Instigator).TorchBatteryLife <= 0 || Instigator.PendingWeapon != none )
			{
				//Log("Killing Light...you're out of batteries, or switched / dropped weapons");
				KFHumanPawn(Instigator).bTorchOn = false;
				ServerSpawnLight();
			}
		}
	}

	UpdateMagCapacity(Instigator.PlayerReplicationInfo);

	if(!bIsReloading)
	{
		if(!Instigator.IsHumanControlled())
		{
			LastSeenSeconds = Level.TimeSeconds - Instigator.Controller.LastSeenTime;
			if(MagAmmoRemaining == 0 || ((LastSeenSeconds >= 5 || LastSeenSeconds > MagAmmoRemaining) && MagAmmoRemaining < MagCapacity))
				ReloadMeNow();
		}
	}
	else
	{
		if((Level.TimeSeconds - ReloadTimer) >= ReloadRate)
		{
			if(AmmoAmount(0) <= MagCapacity && !bHoldToReload)
			{
				MagAmmoRemaining = AmmoAmount(0);
				ActuallyFinishReloading();
			}
			else
			{
				if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
				{
					ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
				}
				else
				{
					ReloadMulti = 1.0;
				}

				AddReloadedAmmo();

				if( bHoldToReload )
                {
                    NumLoadedThisReload++;
                }

				if(MagAmmoRemaining < MagCapacity && MagAmmoRemaining < AmmoAmount(0) && bHoldToReload)
					ReloadTimer = Level.TimeSeconds;
				if(MagAmmoRemaining >= MagCapacity || MagAmmoRemaining >= AmmoAmount(0) || !bHoldToReload || bDoSingleReload)
					ActuallyFinishReloading();
				else if( Level.NetMode!=NM_Client )
					Instigator.SetAnimAction(WeaponReloadAnim);
			}
		}
		else if(bIsReloading && !bReloadEffectDone && Level.TimeSeconds - ReloadTimer >= ReloadRate / 2)
		{
			bReloadEffectDone = true;
			ClientReloadEffects();
		}
	}
}


exec function ReloadMeNow()
{
	local float ReloadMulti;
    
	if(!AllowReload())
		return;
	if ( bHasAimingMode && bAimingRifle )
	{
		FireMode[1].bIsFiring = False;

		ZoomOut(false);
		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
    
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	else
		ReloadMulti = 1.0;
        
	bIsReloading = true;
	ReloadTimer = Level.TimeSeconds;
    bShortReload = MagAmmoRemaining > 0;
	if ( bShortReload )
		ReloadRate = Default.ReloadShortRate / ReloadMulti;
    else
		ReloadRate = Default.ReloadRate / ReloadMulti;
        
	if( bHoldToReload )
	{
		NumLoadedThisReload = 0;
	}
	ClientReload();
	Instigator.SetAnimAction(WeaponReloadAnim);
	if ( Level.Game.NumPlayers > 1 && KFGameType(Level.Game).bWaveInProgress && KFPlayerController(Instigator.Controller) != none &&
		Level.TimeSeconds - KFPlayerController(Instigator.Controller).LastReloadMessageTime > KFPlayerController(Instigator.Controller).ReloadMessageDelay )
	{
		KFPlayerController(Instigator.Controller).Speech('AUTO', 2, "");
		KFPlayerController(Instigator.Controller).LastReloadMessageTime = Level.TimeSeconds;
	}
}

simulated function ClientReload()
{
	local float ReloadMulti;
	if ( bHasAimingMode && bAimingRifle )
	{
		FireMode[1].bIsFiring = False;

		ZoomOut(false);
		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
    
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	else
		ReloadMulti = 1.0;
        
	bIsReloading = true;
	if (MagAmmoRemaining <= 0)
	{
		PlayAnim(ReloadAnim, ReloadAnimRate*ReloadMulti, 0.1);
	}
	else if (MagAmmoRemaining >= 1)
	{
		PlayAnim(ReloadShortAnim, ReloadAnimRate*ReloadMulti, 0.1);
	}
}

function AddReloadedAmmo()
{
    local int a;
    
	UpdateMagCapacity(Instigator.PlayerReplicationInfo);

    a = MagCapacity;
    //if ( bShortReload )
        //a=a; // disabled +1 chambering for open bolt weapon
    
	if ( AmmoAmount(0) >= a )
		MagAmmoRemaining = a;
    else
        MagAmmoRemaining = AmmoAmount(0);

    // this seems redudant -- PooSH
	// if( !bHoldToReload )
	// {
		// ClientForceKFAmmoUpdate(MagAmmoRemaining,AmmoAmount(0));
	// }

	if ( PlayerController(Instigator.Controller) != none && KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements) != none )
	{
		KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements).OnWeaponReloaded();
	}
}

defaultproperties
{
     SkinRefs(0)="KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P"         //hands
     SkinRefs(1)="CuteWeaponPack_T.FNMinimi_T.FNMinimi_cmb"                 //Minimi

	 SleeveNum=0
	 
     MeshRef="CuteWeaponPack_A.FNMinimi_1st"
	 FlashBoneName="tip"
     SelectSound=Sound'KF_BullpupSnd.Bullpup_Select' //fix this later
     HudImageRef="CuteWeaponPack_T.FNMinimi_T.FNMinimi_unselected"
     SelectedHudImageRef="CuteWeaponPack_T.FNMinimi_T.FNMinimi_selected"
     TraderInfoTexture=texture'CuteWeaponPack_T.FNMinimi_T.FNMinimi_trader'
    
     ReloadShortAnim="Reload_Short"
     ReloadShortRate=5.5 //6.6
     MagCapacity=75//for testing
     ReloadRate=5.75//
     ReloadAnim="Reload"
     ReloadAnimRate=1.20
     WeaponReloadAnim="Reload_AK47"
     Weight=8.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000 //60.0
     bModeZeroCanDryFire=True

     UpdateBulletsOnFireTime=0.04 //update about halfway through fire animation
     PlayerIronSightFOV=65.000000 //65.0
     ZoomedDisplayFOV=40.000000 //45
	 FireModeClass(0)=Class'CuteWeapons.FNMinimiFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="FN Minimi light machine gun. Has large ammo capacity but long reload times."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000 //65
     Priority=150
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=4 //7
     PickupClass=Class'CuteWeapons.FNMinimiPickup'
     //PlayerViewOffset=(X=10.000000,Y=15.000000,Z=-3.000000)
	 PlayerViewOffset=(X=-5.000000,Y=20.000000,Z=-8.000000)
     BobDamping=6.000000
	 AttachmentClass=Class'CuteWeapons.FNMinimiAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="FN Minimi LMG"
     TransientSoundVolume=1.250000    
}