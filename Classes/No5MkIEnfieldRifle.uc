/** A Enfield with fancy code copied from Poosh's Colt
 * @author Scuddles
 * @see https://steamcommunity.com/groups/ScrNBalance/discussions/6/1696049513783762669/
 */
class No5MkIEnfieldRifle extends KFWeapon;

var name ReloadEmptyAnim; //stores name of my empty reload anim

var int ClipCapacity; //5 rounds per clip

var float ReloadMulti;

var float BoltOpenRate; //20 frames
var float LongBoltOpenRate; //40 frames
var float ClipInsertRate; //30 frames
var float FirstBulletLoadRate; //25 frames
var float BulletLoadRate; //4 frames each
var float ClipRemoveRate; //20 frames
var float BoltCloseRate; //25 frames

var float BoltOpenTime;
var float ClipInsertTime;
var float FirstBulletLoadTime; 
var float NextBulletLoadTime; 
var float ClipRemoveTime;
var float BoltCloseTime; 

var float ClipInsertRateMult;

var transient bool bInterruptedReload;

//these bools are used to track what state the weapon is in
var transient bool bUseLongReloadAnim; //whether weapon is playing the long reload anim or not
var transient bool bBoltOpened; //tracks if bolt is open or not
var transient bool bClipInRifle; //tracks if clip is in rifle or not, affects reload interrupt time
var transient bool bClipIsUsed; //flag if to remove clip or not
var transient bool bLoadAnotherClip; //bool to check if loading clip has begun
var transient bool bLoadBulletsStarted; //bool to check if loading bullets has begun, to set NextBulletLoadTime only once
var transient bool bClipRemoveTimerStarted; //bool to start timer that handles getting mid-clip removal interrupt timing
var transient bool bInterruptStarted; //bool to store if interrupted started to set anim frame only once



// Implemented Enfield-specific reloading

// Reload State 1: (uninterruptable): Opening bolt. (25 frames)
// Reload State 2: (interruptable): Inserting clip, if interrupted it will skip to state 5
// Reload State 3: (interruptable): loading rounds, if interrupted it will skip to state 4
// Reload State 4: (uninterruptable): removing partially used or empty charger, interrupting this will queue reload state 5
// Reload State 5: Closing bolt. (15 frames)


//test adding replication
replication
{
	reliable if(Role < ROLE_Authority)
		ServerGoToAnimFrame, ServerNewReloadTimer;

	reliable if(Role == ROLE_Authority)
		bClipInRifle, bClipRemoveTimerStarted, bInterruptStarted, ShowNewClip, ShowUsedClip, ClientGoToAnimFrame, ClientNewReloadTimer;
}

//this does a shell eject triggered by anim notify
simulated function Notify_EjectShell()
{
    if ( KFFire(FireMode[0]).ShellEjectEmitter != None )
    {
        if (!bIsReloading)
        KFFire(FireMode[0]).ShellEjectEmitter.Trigger(Self, Instigator);
    }
}

//this hides bullets in reverse order for cases where player has less than 5 rounds in reserve ammo
simulated function ShowNewClip(int RoundsToLoad)
{
    RoundsToLoad = Clamp(RoundsToLoad,1,5);
    switch (RoundsToLoad)
    {
    case 5: 
       SetBoneScale(5, 1.0, 'clipbullet005');
       SetBoneScale(4, 1.0, 'clipbullet004');
       SetBoneScale(3, 1.0, 'clipbullet003');
       SetBoneScale(2, 1.0, 'clipbullet002');
       SetBoneScale(1, 1.0, 'clipbullet001');
    break;
    case 4:
       SetBoneScale(5, 1.0, 'clipbullet005');
       SetBoneScale(4, 1.0, 'clipbullet004');
       SetBoneScale(3, 1.0, 'clipbullet003');
       SetBoneScale(2, 1.0, 'clipbullet002');
       SetBoneScale(1, 0.0, 'clipbullet001');
    break;
    case 3:
       SetBoneScale(5, 1.0, 'clipbullet005');
       SetBoneScale(4, 1.0, 'clipbullet004');
       SetBoneScale(3, 1.0, 'clipbullet003');
       SetBoneScale(2, 0.0, 'clipbullet002');
       SetBoneScale(1, 0.0, 'clipbullet001');
    break;
    case 2:
       SetBoneScale(5, 1.0, 'clipbullet005');
       SetBoneScale(4, 1.0, 'clipbullet004');
       SetBoneScale(3, 0.0, 'clipbullet003');
       SetBoneScale(2, 0.0, 'clipbullet002');
       SetBoneScale(1, 0.0, 'clipbullet001');
    break;
    case 1:
       SetBoneScale(5, 1.0, 'clipbullet005');
       SetBoneScale(4, 0.0, 'clipbullet004');
       SetBoneScale(3, 0.0, 'clipbullet003');
       SetBoneScale(2, 0.0, 'clipbullet002');
       SetBoneScale(1, 0.0, 'clipbullet001');
    break;
    default:
       SetBoneScale(5, 0.0, 'clipbullet005');
       SetBoneScale(4, 0.0, 'clipbullet004');
       SetBoneScale(3, 0.0, 'clipbullet003');
       SetBoneScale(2, 0.0, 'clipbullet002');
       SetBoneScale(1, 0.0, 'clipbullet001');
       //this is a fallback, shouldn't happen
    }
}

//this function hides the bullets after a reload is complete
//clipbullet005 is at the top, and clipbullet001 is at the bottom
simulated function ShowUsedClip(int LocalNumLoadedThisReload)
{
    switch (LocalNumLoadedThisReload)
    {
    case 5: 
       SetBoneScale(5, 0.0, 'clipbullet005');
       SetBoneScale(4, 0.0, 'clipbullet004');
       SetBoneScale(3, 0.0, 'clipbullet003');
       SetBoneScale(2, 0.0, 'clipbullet002');
       SetBoneScale(1, 0.0, 'clipbullet001');
    break;
    case 4:
       SetBoneScale(5, 0.0, 'clipbullet005');
       SetBoneScale(4, 0.0, 'clipbullet004');
       SetBoneScale(3, 0.0, 'clipbullet003');
       SetBoneScale(2, 0.0, 'clipbullet002');
    break;
    case 3:
       SetBoneScale(5, 0.0, 'clipbullet005');
       SetBoneScale(4, 0.0, 'clipbullet004');
       SetBoneScale(3, 0.0, 'clipbullet003');
    break;
    case 2:
       SetBoneScale(5, 0.0, 'clipbullet005');
       SetBoneScale(4, 0.0, 'clipbullet004');
    break;
    case 1:
       SetBoneScale(5, 0.0, 'clipbullet005');
    break;
    default:
    //don't do anything
    }
}

simulated function WeaponTick(float dt)
{
    local float LastSeenSeconds;

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

        if( ForceZoomOutTime > 0 ) {
            if( bAimingRifle ) {
                if( Level.TimeSeconds - ForceZoomOutTime > 0 ) {
                    ForceZoomOutTime = 0;
                    ZoomOut(true);
                    if( Role < ROLE_Authority)
                        ServerZoomOut(false);
                }
            }
            else {
                ForceZoomOutTime = 0;
            }
        }      
    }
   
    if ( Role < ROLE_Authority )
    return;
    
    if ( bIsReloading )
    {
        if( Level.TimeSeconds >= ReloadTimer )
        {
            ActuallyFinishReloading(); //seems to work like a fallback
        }
        if (bInterruptedReload)
        {   
            ShowUsedClip(NumLoadedThisReload);
            NumLoadedThisReload = 0;
            InterruptReload();
        }
        if (!bInterruptedReload && Level.TimeSeconds > BoltOpenTime ) //if not interrupted and bolt opened, do reload stuff
        {
            //bolt is open, load a clip once entering this state
            bBoltOpened = true;
            if (bLoadAnotherClip && !bClipInRifle && !bClipIsUsed)
            {   
                bLoadAnotherClip = false;
                NumLoadedThisReload = 0; //reset this counter
                ShowNewClip(AmmoAmount(0)-MagAmmoRemaining); //refresh clip 
                if (bUseLongReloadAnim)
                GoToAnimFrame(40);
                if (!bUseLongReloadAnim)
                GoToAnimFrame(20);
                ClipInsertTime = Level.TimeSeconds + ClipInsertRate; //set clip load time
                NextBulletLoadTime = Level.TimeSeconds + ClipInsertRateMult*ClipInsertRate + FirstBulletLoadRate; //set time to next (first) bullet load with fudge factor because I'm bad
                //ReloadTimer = Level.TimeSeconds + BoltOpenRate + ClipInsertRate + FirstBulletLoadRate + ClipRemoveRate + BoltCloseRate; //set timer for 1 bullet load
                NewReloadTimer(Level.TimeSeconds + BoltOpenRate + ClipInsertRate + FirstBulletLoadRate + ClipRemoveRate + BoltCloseRate); //new function to set reload timer on server
            }
            if ( Level.TimeSeconds > ClipInsertTime)
            {
                bClipInRifle = true;
                if ( bClipInRifle && Level.TimeSeconds > NextBulletLoadTime) //only load if clip is in rifle
                {
                    if ( NumLoadedThisReload >= ClipCapacity || MagAmmoRemaining >= MagCapacity || MagAmmoRemaining >= AmmoAmount(0) )
                    {
                        //loaded all rounds, or magazine is full, or no reserve ammo
                        NextBulletLoadTime += 1000; // don't load bullets anymore
                        bClipIsUsed = true;
                        ShowUsedClip(NumLoadedThisReload); //update bullets in clip
                        if (!bUseLongReloadAnim)
                        GoToAnimFrame(90); //go to clip remove frame
                        if (bUseLongReloadAnim)
                        GoToAnimFrame(110);  //go to clip remove frame
                        if (!bClipRemoveTimerStarted)
                        {
                            ClipRemoveTime= Level.TimeSeconds + ClipRemoveRate;
                            bClipRemoveTimerStarted = true;
                        }
                    }
                    else
                    {
                        MagAmmoRemaining++; 
                        NextBulletLoadTime += BulletLoadRate; //set next bullet load time
                        NumLoadedThisReload++; //increment reload count
                    }
                }
                //exited ClipIsUsed loop
            }
            //exited ClipInsertTime loop
            if (ClipRemoveTime != 0 && bClipRemoveTimerStarted && Level.TimeSeconds > ClipRemoveTime)
            {
                bClipInRifle = false; //remove clip from rifle
                bClipRemoveTimerStarted = false;
                NumLoadedThisReload = 0; //reset this var
                //clip removed, check if to load another clip and extend reload or not
                if (MagAmmoRemaining < MagCapacity && AmmoAmount(0) > MagAmmoRemaining)
                {
                    bLoadAnotherClip = true; //set flag to load new clip after current clip gets unloaded
                    bClipIsUsed = false;
                }
                else
                InterruptReload(); //force reload interrupt because full or no ammo to load
            }
        }
        //exited BoltOpenTime loop
    }
    else if( !Instigator.IsHumanControlled() ) { // bot
        LastSeenSeconds = Level.TimeSeconds - Instigator.Controller.LastSeenTime;
        if(MagAmmoRemaining == 0 || ((LastSeenSeconds >= 5 || LastSeenSeconds > MagAmmoRemaining) && MagAmmoRemaining < MagCapacity))
        ReloadMeNow();
    }

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
}


simulated function bool AllowReload()
{
    if ( bIsReloading || MagAmmoRemaining >= AmmoAmount(0) )
        return false;

    UpdateMagCapacity(Instigator.PlayerReplicationInfo);
    if ( MagAmmoRemaining >= MagCapacity )
        return false;

    if( KFInvasionBot(Instigator.Controller) != none || KFFriendlyAI(Instigator.Controller) != none )
        return true;

    return !FireMode[0].IsFiring() && !FireMode[1].IsFiring()
            && Level.TimeSeconds > (FireMode[0].NextFireTime - 0.1);
}

// Since vanilla reloading replication is totally fucked, I moved base code into separate,
// replication-free function, which is executed on both server and client side
// -- PooSH
simulated function DoReload()
{
    local int a;
    local int MaxRoundsToLoad; //used to set first reloadtimer accurately 
    a = AmmoAmount(0);
    if ( bHasAimingMode && bAimingRifle ) {
        FireMode[1].bIsFiring = False;
        ZoomOut(false);
        // ZoomOut() just a moment ago was executed on server side - why to force it again?  -- PooSH
        // if( Role < ROLE_Authority)
        // ServerZoomOut(false);
    }

    bUseLongReloadAnim = MagAmmoRemaining > 0;
    MaxRoundsToLoad = MagCapacity - MagAmmoRemaining;
    MaxRoundsToLoad = Clamp(MaxRoundsToLoad,1,5); //clamp to max of 5
    MaxRoundsToLoad = Clamp(MaxRoundsToLoad,1,(AmmoAmount(0) - MagAmmoRemaining)); //now clamp to number of reserve rounds, which could be less than 5
    
    
    if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
        ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
    else
        ReloadMulti = 1.0;

    bIsReloading = true;
    bInterruptedReload = false;
    
    //set all bools on reload start
    bBoltOpened = false;
    bClipInRifle = false; 
    bClipIsUsed = false;
    bClipRemoveTimerStarted=false;
    bLoadAnotherClip = false;
    bInterruptStarted = false;
    bLoadBulletsStarted=false;
    
    ShowNewClip(AmmoAmount(0) - MagAmmoRemaining); //refresh clip

    BoltOpenRate = default.BoltOpenRate / ReloadMulti;
    LongBoltOpenRate = default.LongBoltOpenRate / ReloadMulti;
    ClipInsertRate = default.ClipInsertRate / ReloadMulti;
    FirstBulletLoadRate = default.FirstBulletLoadRate / ReloadMulti;
    BulletLoadRate = default.BulletLoadRate / ReloadMulti;
    ClipRemoveRate = default.ClipRemoveRate / ReloadMulti;
    BoltCloseRate = default.BoltCloseRate / ReloadMulti;
    
    ReloadRate = default.ReloadRate / ReloadMulti; //set but not used
    
    //set times except FirstBulletLoadTime, ClipRemoveTime, BoltCloseTime; 
    if (bUseLongReloadAnim)
    {
        BoltOpenTime = Level.TimeSeconds + LongBoltOpenRate;
        ClipInsertTime = Level.TimeSeconds + LongBoltOpenRate + ClipInsertRate;
        NextBulletLoadTime = Level.TimeSeconds + LongBoltOpenRate + ClipInsertRate + FirstBulletLoadRate; //set time to first bullet load
        ClipRemoveTime = 0;
        ReloadTimer = Level.TimeSeconds + LongBoltOpenRate + ClipInsertRate + FirstBulletLoadRate + (MaxRoundsToLoad-1)*BulletLoadRate + ClipRemoveRate + BoltCloseRate; //its all of them except 4*BulletLoadRate
    }
    else //if (!bUseLongReloadAnim)
    {
        BoltOpenTime = Level.TimeSeconds + BoltOpenRate;
        ClipInsertTime = Level.TimeSeconds + BoltOpenRate + ClipInsertRate;
        NextBulletLoadTime = Level.TimeSeconds + BoltOpenRate + ClipInsertRate + FirstBulletLoadRate; //set time to first bullet load
        ClipRemoveTime = 0;
        ReloadTimer = Level.TimeSeconds + BoltOpenRate + ClipInsertRate + FirstBulletLoadRate + (MaxRoundsToLoad-1)*BulletLoadRate + ClipRemoveRate + BoltCloseRate; //its all of them except 4*BulletLoadRate
    }
    Instigator.SetAnimAction(WeaponReloadAnim);
}
// This function is triggered by client, replicated to server and NOT EXECUTED on client,
// even if marked as simulated

//ReloadMeNow is an exec function, which is called by client and replicated to the server, but server replicates to the client ClientReload().
exec function ReloadMeNow()
{
    local KFPlayerController PC;

    if ( !AllowReload() )
        return;

    DoReload();
    ClientReload();

    NumLoadedThisReload = 0;

    PC = KFPlayerController(Instigator.Controller);
    if ( PC != none && Level.Game.NumPlayers > 1 && KFGameType(Level.Game).bWaveInProgress
            && Level.TimeSeconds - PC.LastReloadMessageTime > PC.ReloadMessageDelay )
    {
        KFPlayerController(Instigator.Controller).Speech('AUTO', 2, "");
        KFPlayerController(Instigator.Controller).LastReloadMessageTime = Level.TimeSeconds;
    }
}

function ServerRequestAutoReload()
{
    ReloadMeNow();
}

// This function now is triggered by ReloadMeNow() and executed on local side only
simulated function ClientReload()
{
    DoReload();
    if (MagAmmoRemaining <= 0)
    {
        PlayAnim(ReloadEmptyAnim, ReloadAnimRate*ReloadMulti, 0.1);
    }
    else if (MagAmmoRemaining >= 1)
    {
        PlayAnim(ReloadAnim, ReloadAnimRate*ReloadMulti, 0.1);
    }
}

//copypaste from kffire to get firespeed bonus
function float GetFireSpeed()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		return KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetFireSpeedMod(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	}

	return 1;
}

// This function now is triggered by ReloadMeNow() and executed on local side only
function AddReloadedAmmo() {} // magazine is filled in WeaponTick now

simulated function bool StartFire(int Mode)
{
    local float FireRateBonus;
    FireRateBonus = GetFireSpeed();
    
    if ( MagAmmoRemaining <= 0 )
        return false;
    if ( bIsReloading ) {
        InterruptReload();
        return false;
    }
    if( Mode == 0 && ForceZoomOutOnFireTime > 0 )
    {
        ForceZoomOutTime = Level.TimeSeconds + ForceZoomOutOnFireTime;
    }
    return super(Weapon).StartFire(Mode);
}

simulated function AltFire(float F)
{
    InterruptReload();
}

// another fucked up replication...
// By the looks if it, InterruptReload() is called only on client, which triggers ServerInterruptReload().
// Anyway, why server would want to interrupt reload by its own?..
simulated function bool InterruptReload()
{
    if( bIsReloading && !bInterruptedReload )
    {
        // that's very lame how to do stuff like that - don't repeat it at home ;)
        // in theory client should send server a request to interrupt the reload,
        // and the server send back accept to client.
        // But in such case we have a double chance of screwing the shit up, so let's just
        // do it lazy way.
        ServerInterruptReload();
        ClientInterruptReload();
        return true;
    }

    return false;
}

//reloadtimer only on server
function ServerInterruptReload()
{
    if ( Role == ROLE_Authority  )
    {   
        bInterruptedReload = true;
        //handle ReloadTimer
        if (bClipRemoveTimerStarted)
        {
            ReloadTimer = ClipRemoveTime + BoltCloseRate;
        }
        else
        {
            if (bClipInRifle)
            ReloadTimer = Level.TimeSeconds + ClipRemoveRate + BoltCloseRate;
            if (!bClipInRifle)
            ReloadTimer = Level.TimeSeconds + BoltCloseRate;
        }
        //ReloadTimer = BoltCloseTime;
        
        //Handle animation frame
        if (bClipRemoveTimerStarted)
        {
            //don't do anything because the animation will magically finish
        }
        else
        {
            if (bClipInRifle)
            {
                if (bUseLongReloadAnim)
                SetAnimFrame(110, 0 , 1);  // go to clip remove
                else
                SetAnimFrame(90, 0 , 1);  // go to clip remove
            }
            if (!bClipInRifle)
            {
                if (bUseLongReloadAnim)
                SetAnimFrame(135, 0 , 1);  // go to bolt close
                else
                SetAnimFrame(115, 0 , 1);  // go to bolt close
            }
        }
    }
}

simulated function ClientInterruptReload()
{
    if ( Role < ROLE_Authority )
    {   
        bInterruptedReload = true;
        ShowUsedClip(NumLoadedThisReload);
        //handle ReloadTimer
        if (bClipRemoveTimerStarted)
        {
            //ReloadTimer = ClipRemoveTime + BoltCloseRate;
        }
        else
        {
        /*
            if (bClipInRifle)
            ReloadTimer = Level.TimeSeconds + ClipRemoveRate + BoltCloseRate;
            if (!bClipInRifle)
            ReloadTimer = Level.TimeSeconds + BoltCloseRate;
        */
        }
        
        //Handle animation frame
        if (bClipRemoveTimerStarted)
        {
            //don't do anything because the animation will magically finish
        }
        else
        {
            if (bClipInRifle)
            {
                if (bUseLongReloadAnim)
                SetAnimFrame(110, 0 , 1);  // go to clip remove
                else
                SetAnimFrame(90, 0 , 1);  // go to clip remove
            }
            if (!bClipInRifle)
            {
                if (bUseLongReloadAnim)
                SetAnimFrame(135, 0 , 1);  // go to bolt close
                else
                SetAnimFrame(115, 0 , 1);  // go to bolt close
            }
        }
    }
}


//copypasta to support forced looping reloads
simulated function bool GoToAnimFrame(int AnimFrame)
{
    if( Role == ROLE_Authority && bIsReloading )
    {
        // that's very lame how to do stuff like that - don't repeat it at home ;)
        // in theory client should send server a request to interrupt the reload,
        // and the server send back accept to client.
        // But in such case we have a double chance of screwing the shit up, so let's just
        // do it lazy way.
        ServerGoToAnimFrame(AnimFrame);
        ClientGoToAnimFrame(AnimFrame);
        return true;
    }
    return false;
}

function ServerGoToAnimFrame(int AnimFrame)
{
    //servers don't play anims so this should be disabled
    if ( Role == ROLE_Authority )
    SetAnimFrame(AnimFrame, 0 , 1);  //go to frame specified
}

simulated function ClientGoToAnimFrame(int AnimFrame)
{
    if ( Role < ROLE_Authority )
    SetAnimFrame(AnimFrame, 0, 1); //go to frame
}

simulated exec function ToggleIronSights()
{
    if( bHasAimingMode ) {
        if( bAimingRifle )
            PerformZoom(false);
        else
            IronSightZoomIn();
    }
}

//copypasta to set new reload timer from WeaponTick
simulated function bool NewReloadTimer(float NewReloadTime)
{
    if( bIsReloading )
    {
        // that's very lame how to do stuff like that - don't repeat it at home ;)
        // in theory client should send server a request to interrupt the reload,
        // and the server send back accept to client.
        // But in such case we have a double chance of screwing the shit up, so let's just
        // do it lazy way.
        ServerNewReloadTimer(NewReloadTime);
        ClientNewReloadTimer(NewReloadTime);
        return true;
    }
    return false;
}

function ServerNewReloadTimer(float NewReloadTime)
{
    //servers don't play anims so this should be disabled
    if ( Role == ROLE_Authority )
    ReloadTimer = NewReloadTime;
}

simulated function ClientNewReloadTimer(float NewReloadTime)
{
    if ( Role < ROLE_Authority )
    ReloadTimer = NewReloadTime;
}

simulated exec function IronSightZoomIn()
{
    if( bHasAimingMode ) {
        if( Owner != none && Owner.Physics == PHYS_Falling
                && Owner.PhysicsVolume.Gravity.Z <= class'PhysicsVolume'.default.Gravity.Z )
        return;

        if( bIsReloading ) {
            InterruptReload(); // finish reloading while zooming in  -- PooSH
        }
        PerformZoom(True);
    }
}

simulated function bool PutDown()
{
    local int Mode;

    // continue here, because there is nothing to stop us from interrupting the reload  -- PooSH
    if ( bIsReloading )
        InterruptReload();

    if( bAimingRifle )
        ZoomOut(False);

    // From Weapon.uc
    if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
    {
        if ( (Instigator.PendingWeapon != None) && !Instigator.PendingWeapon.bForceSwitch )
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                // if _RO_
                if( FireMode[Mode] == none )
                    continue;
                // End _RO_

                if ( FireMode[Mode].bFireOnRelease && FireMode[Mode].bIsFiring )
                    return false;
                if ( FireMode[Mode].NextFireTime > Level.TimeSeconds + FireMode[Mode].FireRate*(1.f - MinReloadPct))
                    DownDelay = FMax(DownDelay, FireMode[Mode].NextFireTime - Level.TimeSeconds - FireMode[Mode].FireRate*(1.f - MinReloadPct));
            }
        }

        if (Instigator.IsLocallyControlled())
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                // if _RO_
                if( FireMode[Mode] == none )
                    continue;
                // End _RO_

                if ( FireMode[Mode].bIsFiring )
                    ClientStopFire(Mode);
            }

            if (  DownDelay <= 0  || KFPawn(Instigator).bIsQuickHealing > 0)
            {
                if ( ClientState == WS_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
                    TweenAnim(SelectAnim,PutDownTime);
                else if ( HasAnim(PutDownAnim) )
                {
                    if( ClientGrenadeState == GN_TempDown || KFPawn(Instigator).bIsQuickHealing > 0)
                        PlayAnim(PutDownAnim, PutDownAnimRate * (PutDownTime/QuickPutDownTime), 0.0);
                    else
                        PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);

                }
            }
        }
        ClientState = WS_PutDown;
        if ( Level.GRI.bFastWeaponSwitching )
            DownDelay = 0;
        if ( DownDelay > 0 )
        {
            SetTimer(DownDelay, false);
        }
        else
        {
            if( ClientGrenadeState == GN_TempDown )
            {
                SetTimer(QuickPutDownTime, false);
            }
            else
            {
                SetTimer(PutDownTime, false);
            }
        }
    }
    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
    {
        // if _RO_
        if( FireMode[Mode] == none )
            continue;
        // End _RO_

        FireMode[Mode].bServerDelayStartFire = false;
        FireMode[Mode].bServerDelayStopFire = false;
    }
    Instigator.AmbientSound = None;
    OldWeapon = None;
    return true; // return false if preventing weapon switch
}
//old values for reloadanimrate 1.0
/*
    BoltOpenRate=0.667 //20 frames
    LongBoltOpenRate=1.333 //40 frames
    ClipInsertRate=1.0 //30 frames
    ClipInsertRateMult=0.90 //used for second reload for timing
    FirstBulletLoadRate= 0.833 //around 25 frames (last value 0.811)
    BulletLoadRate=0.115 // around 4 frames
    ClipRemoveRate=0.667 //20 frames
    BoltCloseRate=0.667 //20 frames
    ReloadRate=7.193 //time for reloading 10 rounds from empty
*/    
defaultproperties
{
    BoltOpenRate=0.476 //20 frames
    LongBoltOpenRate=0.952 //40 frames
    ClipInsertRate=0.714 //30 frames
    ClipInsertRateMult=0.87 //used for second reload for timing
    FirstBulletLoadRate=0.595 //around 25 frames (last value 0.811)
    BulletLoadRate=0.09 // around 4 frames
    ClipRemoveRate=0.476 //20 frames
    BoltCloseRate=0.476 //20 frames
    
    ClipCapacity=5

    PlayerIronSightFOV=65.000000 //70
    ZoomedDisplayFOV=40.000000 //35
	StandardDisplayFOV=65.0 //70
    MagCapacity=10
    ReloadRate=5.137 //time for reloading 10 rounds from empty
    ReloadAnim="Reload"
    ReloadEmptyAnim="Reload_Empty"
    ReloadAnimRate=1.4
    WeaponReloadAnim="Reload_M14"
    Weight=5.000000
    bHasAimingMode=True
    IdleAimAnim="Idle_Iron"
    bModeZeroCanDryFire=True
    
    TraderInfoTexture=texture'CuteWeaponPack_T.No5MkIEnfield_T.No5MkIEnfield_trader'
    MeshRef="CuteWeaponPack_A.No5MkIEnfield_1st"
    SkinRefs(0)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
    SkinRefs(1)="CuteWeaponPack_T.No5MkIEnfield_T.No5MkIEnfield_cmb" 
    SkinRefs(2)="CuteWeaponPack_T.No5MkIEnfield_T.clip_cmb" 
	
	SleeveNum=0
	FlashBoneName="tip"
	SelectSoundRef="KF_M4ShotgunSnd.foley.WEP_Benelli_Foley_Select"
    	
    HudImageRef="CuteWeaponPack_T.No5MkIEnfield_T.No5MkIEnfield_unselected"
	SelectedHudImageRef="CuteWeaponPack_T.No5MkIEnfield_T.No5MkIEnfield_selected"
    FireModeClass(0)=Class'CuteWeapons.No5MkIEnfieldFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.550000
    CurrentRating=0.550000
    Description="The Rifle No. 5 Mk I, was a shorter and lighter derivative of the British Lee Enfield No. 4 Mk I. Also informally known as the "Jungle Carbine". Loads from 5 round clips."
    DisplayFOV=70.000000
    Priority=200
    InventoryGroup=3
    GroupOffset=3
    PickupClass=Class'CuteWeapons.No5MkIEnfieldPickup'
	PlayerViewOffset=(X=5.0,Y=14,Z=-8.0) //4,14,-7.5
    BobDamping=6.000000
    AttachmentClass=Class'CuteWeapons.No5MkIEnfieldAttachment'
    IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
    ItemName="No.5 Mk.I Enfield"
}
