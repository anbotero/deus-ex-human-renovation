//=============================================================================
// DeusExWeapon.
//=============================================================================
class DeusExWeapon extends Weapon
	abstract;

//
// enums for weapons (duh)
//
enum EEnemyEffective
{
	ENMEFF_All,
	ENMEFF_Organic,
	ENMEFF_Robot
};

enum EEnviroEffective
{
	ENVEFF_All,
	ENVEFF_Air,
	ENVEFF_Water,
	ENVEFF_Vacuum,
	ENVEFF_AirWater,
	ENVEFF_AirVacuum,
	ENVEFF_WaterVacuum
};

enum EConcealability
{
	CONC_None,
	CONC_Visual,
	CONC_Metal,
	CONC_All
};

enum EAreaType
{
	AOE_Point,
	AOE_Cone,
	AOE_Sphere
};

enum ELockMode
{
	LOCK_None,
	LOCK_Invalid,
	LOCK_Range,
	LOCK_Acquire,
	LOCK_Locked
};

var bool				bReadyToFire;			// true if our bullets are loaded, etc.
var() int				LowAmmoWaterMark;		// critical low ammo count
var travel int			ClipCount;				// number of bullets remaining in current clip

var() class<Skill>		GoverningSkill;			// skill that affects this weapon
var() travel float		NoiseLevel;				// amount of noise that weapon makes when fired
var() EEnemyEffective	EnemyEffective;			// type of enemies that weapon is effective against
var() EEnviroEffective	EnviroEffective;		// type of environment that weapon is effective in
var() EConcealability	Concealability;			// concealability of weapon
var() travel bool		bAutomatic;				// is this an automatic weapon?
var() travel float		ShotTime;				// number of seconds between shots
var() travel float		ReloadTime;				// number of seconds needed to reload the clip
var() int				HitDamage;				// damage done by a single shot (or for shotguns, a single slug)
var() int				MaxRange;				// absolute maximum range in world units (feet * 16)
var() travel int		AccurateRange;			// maximum accurate range in world units (feet * 16)
var() travel float		BaseAccuracy;			// base accuracy (0.0 is dead on, 1.0 is far off)

var bool				bCanHaveScope;			// can this weapon have a scope?
var() travel bool		bHasScope;				// does this weapon have a scope?
var() int				ScopeFOV;				// FOV while using scope
var bool				bZoomed;				// are we currently zoomed?
var bool				bWasZoomed;				// were we zoomed? (used during reloading)

var bool				bCanHaveLaser;			// can this weapon have a laser sight?
var() travel bool		bHasLaser;				// does this weapon have a laser sight?
var bool				bLasing;				// is the laser sight currently on?
var LaserEmitter		Emitter;				// actual laser emitter - valid only when bLasing == True

var bool				bCanHaveSilencer;		// can this weapon have a silencer?
var() travel bool		bHasSilencer;			// does this weapon have a silencer?

var() bool				bCanTrack;				// can this weapon lock on to a target?
var() float				LockTime;				// how long the target must stay targetted to lock
var float				LockTimer;				// used for lock checking
var float            MaintainLockTimer;   // Used for maintaining a lock even after moving off target.
var Actor            LockTarget;          // Used for maintaining a lock even after moving off target.
var Actor				Target;					// actor currently targetted
var ELockMode			LockMode;				// is this target locked?
var string				TargetMessage;			// message to print during targetting
var float				TargetRange;			// range to current target
var() Sound				LockedSound;			// sound to play when locked
var() Sound				TrackingSound;			// sound to play while tracking a target
var float				SoundTimer;				// to time the sounds correctly

var() class<Ammo>		AmmoNames[3];			// three possible types of ammo per weapon
var() class<Projectile> ProjectileNames[3];		// projectile classes for different ammo
var() EAreaType			AreaOfEffect;			// area of effect of the weapon
var() bool				bPenetrating;			// shot will penetrate and cause blood
var() float				StunDuration;			// how long the shot stuns the target
var() bool				bHasMuzzleFlash;		// does this weapon have a flash when fired?
var() bool				bHandToHand;			// is this weapon hand to hand (no ammo)?
var globalconfig vector SwingOffset;     // offsets for this weapon swing.
var() travel float		recoilStrength;			// amount that the weapon kicks back after firing (0.0 is none, 1.0 is large)
var bool				bFiring;				// True while firing, used for recoil
var bool				bOwnerWillNotify;		// True if firing hand-to-hand weapons is dependent on the owner's animations
var bool				bFallbackWeapon;		// If True, only use if no other weapons are available
var bool				bNativeAttack;			// True if weapon represents a native attack
var bool				bEmitWeaponDrawn;		// True if drawing this weapon should make NPCs react
var bool				bUseWhileCrouched;		// True if NPCs should crouch while using this weapon
var bool				bUseAsDrawnWeapon;		// True if this weapon should be carried by NPCs as a drawn weapon
var bool				bWasInFiring;

var bool bNearWall;								// used for prox. mine placement
var Vector placeLocation;						// used for prox. mine placement
var Vector placeNormal;							// used for prox. mine placement
var Mover placeMover;							// used for prox. mine placement

var float ShakeTimer;
var float ShakeYaw;
var float ShakePitch;

//G-Flex: for better and more consisting shakiness
var float ShakeMagnitude;
var float ShakeMagnitudeAdjust;
var float ShakeAngle;
var float ShakeAngleAccel;
var float ShakeMagnitudeToward;
//G-Flex: for circular laser wander, we need these
//var float LaserOffPercent;
var float LaserPitchProportion;
var float LaserYawProportion;

var float LaserYaw;								// Yaw of the Laser emitter, relative to the gun
var float LaserPitch;							// Pitch of the Laser emitter, relative to the gun
var float AIMinRange;							// minimum "best" range for AI; 0=default min range
var float AIMaxRange;							// maximum "best" range for AI; 0=default max range
var float AITimeLimit;							// maximum amount of time an NPC should hold the weapon; 0=no time limit
var float AIFireDelay;							// Once fired, use as fallback weapon until the timeout expires; 0=no time limit

var float standingTimer;						// how long we've been standing still (to increase accuracy)
var float currentAccuracy;						// what the currently calculated accuracy is (updated every tick)

var MuzzleFlash flash;							// muzzle flash actor

var float MinSpreadAcc;        // Minimum accuracy for multiple slug weapons (shotgun).  Affects only multiplayer,
                               // keeps shots from all going in same place (ruining shotgun effect)
var float MinProjSpreadAcc;
var float MinWeaponAcc;        // Minimum accuracy for a weapon at all.  Affects only multiplayer.
var bool bNeedToSetMPPickupAmmo;

var bool	bDestroyOnFinish;

var float	mpReloadTime;			
var int		mpHitDamage;
var float	mpBaseAccuracy;
var int		mpAccurateRange;
var int		mpMaxRange;
var int		mpReloadCount;
var int		mpPickupAmmoCount;

// Used to track weapon mods accurately.
var bool bCanHaveModBaseAccuracy;
var bool bCanHaveModReloadCount;
var bool bCanHaveModAccurateRange;
var bool bCanHaveModReloadTime;
var bool bCanHaveModRecoilStrength;
var travel float ModBaseAccuracy;
var travel float ModReloadCount;
var travel float ModAccurateRange;
var travel float ModReloadTime;
var travel float ModRecoilStrength;

var localized String msgCannotBeReloaded;
var localized String msgOutOf;
var localized String msgNowHas;
var localized String msgAlreadyHas;
var localized String msgNone;
var localized String msgLockInvalid;
var localized String msgLockRange;
var localized String msgLockAcquire;
var localized String msgLockLocked;
var localized String msgRangeUnit;
var localized String msgTimeUnit;
var localized String msgMassUnit;
var localized String msgNotWorking;

//
// strings for info display
//
var localized String msgInfoAmmoLoaded;
var localized String msgInfoAmmo;
var localized String msgInfoDamage;
var localized String msgInfoClip;
var localized String msgInfoROF;
var localized String msgInfoReload;
var localized String msgInfoRecoil;
var localized String msgInfoAccuracy;
var localized String msgInfoAccRange;
var localized String msgInfoMaxRange;
var localized String msgInfoMass;
var localized String msgInfoLaser;
var localized String msgInfoScope;
var localized String msgInfoSilencer;
var localized String msgInfoNA;
var localized String msgInfoYes;
var localized String msgInfoNo;
var localized String msgInfoAuto;
var localized String msgInfoSingle;
var localized String msgInfoRounds;
var localized String msgInfoRoundsPerSec;
var localized String msgInfoSkill;
var localized String msgInfoWeaponStats;

var bool		bClientReadyToFire, bClientReady, bInProcess, bFlameOn, bLooping;
var int		SimClipCount, flameShotCount, SimAmmoAmount;
var float	TimeLockSet;

//
// network replication
//
replication
{
    // server to client
    reliable if ((Role == ROLE_Authority) && (bNetOwner))
        ClipCount, bZoomed, bHasSilencer, bHasLaser, ModBaseAccuracy, ModReloadCount, ModAccurateRange, ModReloadTime, ModRecoilStrength;

	// Things the client should send to the server
	//reliable if ( (Role<ROLE_Authority) )
		//LockTimer, Target, LockMode, TargetMessage, TargetRange, bCanTrack, LockTarget;

    // Functions client calls on server
    reliable if ( Role < ROLE_Authority )
        ReloadAmmo, LoadAmmo, CycleAmmo, LaserOn, LaserOff, LaserToggle, ScopeOn, ScopeOff, ScopeToggle, PropagateLockState, ServerForceFire, 
		  ServerGenerateBullet, ServerGotoFinishFire, ServerHandleNotify, StartFlame, StopFlame, ServerDoneReloading, DestroyOnFinish;

    // Functions Server calls in client
    reliable if ( Role == ROLE_Authority )
      RefreshScopeDisplay, ReadyClientToFire, SetClientAmmoParams, ClientDownWeapon, ClientActive, ClientReload;
}

// ---------------------------------------------------------------------
// PropagateLockState()
// ---------------------------------------------------------------------
simulated function PropagateLockState(ELockMode NewMode, Actor NewTarget)
{
   LockMode = NewMode;
   LockTarget = NewTarget;
}

// ---------------------------------------------------------------------
// SetLockMode()
// ---------------------------------------------------------------------
simulated function SetLockMode(ELockMode NewMode)
{
   if ((LockMode != NewMode) && (Role != ROLE_Authority))
   {
      if (NewMode != LOCK_Locked)
         PropagateLockState(NewMode, None);
      else
         PropagateLockState(NewMode, Target);
   }
	TimeLockSet = Level.Timeseconds;
   LockMode = NewMode;
}

// ---------------------------------------------------------------------
// PlayLockSound()
// Because playing a sound from a simulated function doesn't play it 
// server side.
// ---------------------------------------------------------------------
function PlayLockSound()
{
   Owner.PlaySound(LockedSound, SLOT_None);
}

//
// install the correct projectile info if needed
//
function TravelPostAccept()
{
	local int i;

	Super.TravelPostAccept();

	// make sure the AmmoName matches the currently loaded AmmoType
	if (AmmoType != None)
		AmmoName = AmmoType.Class;

	if (!bInstantHit)
	{
		if (ProjectileClass != None)
			ProjectileSpeed = ProjectileClass.Default.speed;

		// make sure the projectile info matches the actual AmmoType
		// since we can't "var travel class" (AmmoName and ProjectileClass)
		if (AmmoType != None)
		{
			FireSound = None;
			for (i=0; i<ArrayCount(AmmoNames); i++)
			{
				if (AmmoNames[i] == AmmoName)
				{
					ProjectileClass = ProjectileNames[i];
					break;
				}
			}
		}
	}
}


//
// PreBeginPlay
//

function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Default.mpPickupAmmoCount == 0 )
	{
		Default.mpPickupAmmoCount = Default.PickupAmmoCount;
	}
	if(Level.NetMode == NM_Standalone)
		Facelift(true);
}

function bool Facelift(bool bOn)
{
	//== Only do this for DeusEx classes
	if(instr(String(Class.Name), ".") > -1 && bOn)
		if(instr(String(Class.Name), "DeusEx.") <= -1)
			return false;
	else
		if((Class != Class(DynamicLoadObject("DeusEx."$ String(Class.Name), class'Class', True))) && bOn)
			return false;

	return true;
}

//
// PostBeginPlay
//

function PostBeginPlay()
{
	Super.PostBeginPlay();
   if (Level.NetMode != NM_Standalone)
   {
      bWeaponStay = True;
      if (bNeedToSetMPPickupAmmo)
      {
         PickupAmmoCount = PickupAmmoCount * 3;
         bNeedToSetMPPickupAmmo = False;
      }
   }
}

singular function BaseChange()
{
	Super.BaseChange();

	// Make sure we fall if we don't have a base
	if ((base == None) && (Owner == None))
		SetPhysics(PHYS_Falling);
}

function bool HandlePickupQuery(Inventory Item)
{
	local DeusExWeapon W;
	local DeusExPlayer player;
	local bool bResult;
	local class<Ammo> defAmmoClass;
	local Ammo defAmmo;
	
	// make sure that if you pick up a modded weapon that you
	// already have, you get the mods
	W = DeusExWeapon(Item);
	if ((W != None) && (W.Class == Class))
	{
		//== We should be able to use multiple copies of single-use weapons
		if(W.PickupAmmoCount == 0 && W.ReloadCount == 0 && W.AmmoName != None)
		{
			return false; //== Returning false makes it so it'll search for another slot to store a second copy of the weapon
		}
		
		if (W.ModBaseAccuracy > ModBaseAccuracy)
			ModBaseAccuracy = W.ModBaseAccuracy;
		if (W.ModReloadCount > ModReloadCount)
			ModReloadCount = W.ModReloadCount;
		if (W.ModAccurateRange > ModAccurateRange)
			ModAccurateRange = W.ModAccurateRange;

		// these are negative
		if (W.ModReloadTime < ModReloadTime)
			ModReloadTime = W.ModReloadTime;
		if (W.ModRecoilStrength < ModRecoilStrength)
			ModRecoilStrength = W.ModRecoilStrength;

		if (W.bHasLaser)
			bHasLaser = True;
		if (W.bHasSilencer)
			bHasSilencer = True;
		if (W.bHasScope)
			bHasScope = True;

		// copy the actual stats as well
		if (W.ReloadCount > ReloadCount)
			ReloadCount = W.ReloadCount;
		if (W.AccurateRange > AccurateRange)
			AccurateRange = W.AccurateRange;

		// these are negative
		if (W.BaseAccuracy < BaseAccuracy)
			BaseAccuracy = W.BaseAccuracy;
		if (W.ReloadTime < ReloadTime)
			ReloadTime = W.ReloadTime;
		if (W.RecoilStrength < RecoilStrength)
			RecoilStrength = W.RecoilStrength;
	}
	player = DeusExPlayer(Owner);

	if (Item.Class == Class)
	{
      if (!( (Weapon(item).bWeaponStay && (Level.NetMode == NM_Standalone)) && (!Weapon(item).bHeldItem || Weapon(item).bTossedOut)))
		{
			// Only add ammo of the default type
			// There was an easy way to get 32 20mm shells, buy picking up another assault rifle with 20mm ammo selected
			if ( AmmoType != None )
			{
				// Add to default ammo only
				if ( AmmoNames[0] == None )
					defAmmoClass = AmmoName;
				else
					defAmmoClass = AmmoNames[0];

				defAmmo = Ammo(player.FindInventoryType(defAmmoClass));
				defAmmo.AddAmmo( Weapon(Item).PickupAmmoCount );

				if ( Level.NetMode != NM_Standalone )
				{
					if (( player != None ) && ( player.InHand != None ))
					{
						if ( DeusExWeapon(item).class == DeusExWeapon(player.InHand).class )
							ReadyToFire();
					}
				}
			}
		}
	}

	bResult = Super.HandlePickupQuery(Item);

	// Notify the object belt of the new ammo
	if (player != None)
		player.UpdateBeltText(Self);

	return bResult;
}

function BringUp()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( False );

	// alert NPCs that I'm whipping it out
	if (!bNativeAttack && bEmitWeaponDrawn)
		AIStartEvent('WeaponDrawn', EAITYPE_Visual);

	// Y|yukichigai
	// activate the laser on draw, if this weapon has one
	if (bHasLaser)
		LaserOn();
	
	ResetShake();

	// reset the standing still accuracy bonus
	standingTimer = 0;

	Super.BringUp();
}

function bool PutDown()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( False );

	// alert NPCs that I'm putting away my gun
	AIEndEvent('WeaponDrawn', EAITYPE_Visual);

	// reset the standing still accuracy bonus
	standingTimer = 0;

	// Y|yukichigai
	// If it's not deactivated as the weapon goes down, it's possible to get a
	//  "ghost" laser that's not attached to anything if it's not finished before
	//  the level changes.
	if(bHasLaser)
		LaserOff();
	return Super.PutDown();
}

function ReloadAmmo()
{
	// single use or hand to hand weapon if ReloadCount == 0
	if (ReloadCount == 0)
	{
		Pawn(Owner).ClientMessage(msgCannotBeReloaded);
		return;
	}

	if (!IsInState('Reload') && CanReload()) //Lork: Prevents you from reloading if you shouldn't be able to
	{
		TweenAnim('Still', 0.1);
		GotoState('Reload');
	}
}

//Lork: Reload function intended for changing to different ammo types
function ReloadNewAmmo()
{
	// single use or hand to hand weapon if ReloadCount == 0
	if (ReloadCount == 0)
	{
		Pawn(Owner).ClientMessage(msgCannotBeReloaded);
		return;
	}

	if (!IsInState('Reload'))
	{
		TweenAnim('Still', 0.1);
		GotoState('Reload');
	}
}

//
// Note we need to control what's calling this...but I'll get rid of the access nones for now
//
simulated function float GetWeaponSkill()
{
	local DeusExPlayer player;
	local float value;

	value = 0;

	if ( Owner != None )
	{
		player = DeusExPlayer(Owner);
		if (player != None)
		{
			if ((player.AugmentationSystem != None ) && ( player.SkillSystem != None ))
			{
				// get the target augmentation
				//G-Flex: kludge so targeting aug doesn't affect melee
				//G-Flex: as if the DTS needs the extra 20% damage
				//G-Flex: in theory this affects extremely short-range guns too, but that's okay
				if (MaxRange > 99)
				{
					value = player.AugmentationSystem.GetAugLevelValue(class'AugTarget');
					if (value == -1.0)
						value = 0;
				}

				// get the skill
				value += player.SkillSystem.GetSkillLevelValue(GoverningSkill);
			}
		}
	}
	return value;
}

// calculate the accuracy for this weapon and the owner's damage
simulated function float CalculateAccuracy()
{
	local float accuracy;	// 0 is dead on, 1 is pretty far off
	local float tempacc, div, diff;
	local float weapskill; // so we don't keep looking it up (slower).
	local int HealthArmRight, HealthArmLeft, HealthHead;
	local int BestArmRight, BestArmLeft, BestHead;
	local bool checkit;
	local DeusExPlayer player;

	accuracy = BaseAccuracy;		// start with the weapon's base accuracy
   weapskill = GetWeaponSkill();

	player = DeusExPlayer(Owner);
	
	diff = DeusExPlayer(GetPlayerPawn()).combatDifficulty;
	if (player != None)
	{
		// check the player's skill
		// 0.0 = dead on, 1.0 = way off
		accuracy += weapskill;

		// get the health values for the player
		HealthArmRight = player.HealthArmRight;
		HealthArmLeft  = player.HealthArmLeft;
		HealthHead     = player.HealthHead;
		BestArmRight   = player.Default.HealthArmRight;
		BestArmLeft    = player.Default.HealthArmLeft;
		BestHead       = player.Default.HealthHead;
		checkit = True;
	}
	else if (ScriptedPawn(Owner) != None)
	{
		// update the weapon's accuracy with the ScriptedPawn's BaseAccuracy
		// (BaseAccuracy uses higher values for less accuracy, hence we add)
		accuracy += ScriptedPawn(Owner).BaseAccuracy;

		// get the health values for the NPC
		HealthArmRight = ScriptedPawn(Owner).HealthArmRight;
		HealthArmLeft  = ScriptedPawn(Owner).HealthArmLeft;
		HealthHead     = ScriptedPawn(Owner).HealthHead;
		BestArmRight   = ScriptedPawn(Owner).Default.HealthArmRight;
		BestArmLeft    = ScriptedPawn(Owner).Default.HealthArmLeft;
		BestHead       = ScriptedPawn(Owner).Default.HealthHead;
		checkit = True;
	}
	else
		checkit = False;

	// Disabled accuracy mods based on health in multiplayer
	if ( Level.NetMode != NM_Standalone )
		checkit = False;

	if (checkit)
	{
		if (HealthArmRight < 1)
			accuracy += 0.5;
		else if (HealthArmRight < BestArmRight * 0.34)
			accuracy += 0.2;
		else if (HealthArmRight < BestArmRight * 0.67)
			accuracy += 0.1;

		if (HealthArmLeft < 1)
			accuracy += 0.5;
		else if (HealthArmLeft < BestArmLeft * 0.34)
			accuracy += 0.2;
		else if (HealthArmLeft < BestArmLeft * 0.67)
			accuracy += 0.1;

		//G-Flex: Harsher aiming penalties for head wounds, because why not
		if (HealthHead < BestHead * 0.10)
			accuracy += 0.3;
		else if (HealthHead < BestHead * 0.25)
			accuracy += 0.2;
		else if (HealthHead < BestHead * 0.67)
			accuracy += 0.1;
	}
	// increase accuracy (decrease value) if we haven't been moving for awhile
	// this only works for the player, because NPCs don't need any more aiming help!
	//  EXCEPT now they do because of my changes -- Y|yukichigai
	if (player != None || diff >= 1.0)
	{
		tempacc = accuracy;
		if (standingTimer > 0)
		{
			// higher skill makes standing bonus greater
			//G-Flex: weapskill range is [0.0,-0.7] (max skill+aug)
			//div = Max(15.0 + 29.0 * weapskill, 0.0);
			//G-Flex: fix integer rounding and divide-by-zero problem
			div = FMax(15.0 + 29.0 * weapskill, 1.5);
			// NPCs get a decreased standing bonus on lower difficulty levels
			if(player == None)
				div *= 4.0/diff;
			accuracy -= FClamp(standingTimer/div, 0.0, 0.6);
			// don't go too low
			if ((accuracy < 0.1) && (tempacc > 0.1))
				accuracy = 0.1;
		}
	}

	// make sure we don't go negative
	if (accuracy < 0.0)
		accuracy = 0.0;

   if (Level.NetMode != NM_Standalone)
      if (accuracy < MinWeaponAcc)
         accuracy = MinWeaponAcc;

	// Let's do scope accuracy over here
	//G-Flex: switch order of things a bit to penalize sniper rifles less
	if(bHasScope && !bZoomed)
	{
		if(Default.bHasScope)
			accuracy += 0.1;
		accuracy = FMax(accuracy, 0.05);
	}
	return accuracy;
}

//
// functions to change ammo types
//
function bool LoadAmmo(int ammoNum)
{
	local class<Ammo> newAmmoClass;
	local Ammo newAmmo;
	local Pawn P;

	if ((ammoNum < 0) || (ammoNum > 2))
		return False;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return False;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass != None)
	{
		if (newAmmoClass != AmmoName)
		{
			newAmmo = Ammo(P.FindInventoryType(newAmmoClass));
			if (newAmmo == None)
			{
				P.ClientMessage(Sprintf(msgOutOf, newAmmoClass.Default.ItemName));
				return False;
			}
			
			// if we don't have a projectile for this ammo type, then set instant hit
			if (ProjectileNames[ammoNum] == None)
			{
				bInstantHit = True;
				bAutomatic = Default.bAutomatic;
				ShotTime = Default.ShotTime;
				if ( Level.NetMode != NM_Standalone )
				{
					if (HasReloadMod())
						ReloadTime = mpReloadTime * (1.0+ModReloadTime);
					else
						ReloadTime = mpReloadTime;
				}
				else
				{
					if (HasReloadMod())
						ReloadTime = Default.ReloadTime * (1.0+ModReloadTime);
					else
						ReloadTime = Default.ReloadTime;
				}
				FireSound = Default.FireSound;
				ProjectileClass = None;
			}
			else
			{
				// otherwise, set us to fire projectiles
				bInstantHit = False;
				bAutomatic = False;
				ShotTime = 1.0;
				if (HasReloadMod())
					ReloadTime = 2.0 * (1.0+ModReloadTime);
				else
					ReloadTime = 2.0;
				FireSound = None;		// handled by the projectile
				ProjectileClass = ProjectileNames[ammoNum];
				ProjectileSpeed = ProjectileClass.Default.Speed;
			}

			AmmoName = newAmmoClass;
			AmmoType = newAmmo;

			// AlexB had a new sound for 20mm but there's no mechanism for playing alternate sounds per ammo type
			// Same for WP rocket
			if ( Ammo20mm(newAmmo) != None )
				FireSound=Sound'AssaultGunFire20mm';
			else if ( AmmoRocketWP(newAmmo) != None )
				FireSound=Sound'GEPGunFireWP';
			else if ( AmmoRocket(newAmmo) != None )
				FireSound=Sound'GEPGunFire';

			if ( Level.NetMode != NM_Standalone )
				SetClientAmmoParams( bInstantHit, bAutomatic, ShotTime, FireSound, ProjectileClass, ProjectileSpeed );

			// Notify the object belt of the new ammo
			if (DeusExPlayer(P) != None)
				DeusExPlayer(P).UpdateBeltText(Self);

			ReloadNewAmmo(); //Lork: Use the 'old' function so the reload animation will still play

			P.ClientMessage(Sprintf(msgNowHas, ItemName, newAmmoClass.Default.ItemName));
			return True;
		}
		else
		{
			P.ClientMessage(Sprintf(MsgAlreadyHas, ItemName, newAmmoClass.Default.ItemName));
		}
	}

	return False;
}

// ----------------------------------------------------------------------
//
// ----------------------------------------------------------------------

simulated function SetClientAmmoParams( bool bInstant, bool bAuto, float sTime, Sound FireSnd, class<projectile> pClass, float pSpeed )
{
	bInstantHit = bInstant;
	bAutomatic = bAuto;
	ShotTime = sTime;
	FireSound = FireSnd;
	ProjectileClass = pClass;
	ProjectileSpeed = pSpeed;
}

// ----------------------------------------------------------------------
// CanLoadAmmoType()
//
// Returns True if this ammo type can be used with this weapon
// ----------------------------------------------------------------------

simulated function bool CanLoadAmmoType(Ammo ammo)
{
	local int  ammoIndex;
	local bool bCanLoad;

	bCanLoad = False;

	if (ammo != None)
	{
		// First check "AmmoName"

		if (AmmoName == ammo.Class)
		{
			bCanLoad = True;
		}
		else
		{
			for (ammoIndex=0; ammoIndex<3; ammoIndex++)
			{
				if (AmmoNames[ammoIndex] == ammo.Class)
				{
					bCanLoad = True;
					break;
				}
			}
		}
	}

	return bCanLoad;
}

// ----------------------------------------------------------------------
// LoadAmmoType()
// 
// Load this ammo type given the actual object
// ----------------------------------------------------------------------

function LoadAmmoType(Ammo ammo)
{
	local int i;

	if (ammo != None)
		for (i=0; i<3; i++)
			if (AmmoNames[i] == ammo.Class)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// LoadAmmoClass()
// 
// Load this ammo type given the class
// ----------------------------------------------------------------------

function LoadAmmoClass(Class<Ammo> ammoClass)
{
	local int i;

	if (ammoClass != None)
		for (i=0; i<3; i++)
			if (AmmoNames[i] == ammoClass)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// CycleAmmo()
// ----------------------------------------------------------------------

function CycleAmmo()
{
	local int i, last;

	if (NumAmmoTypesAvailable() < 2)
		return;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == AmmoName)
			break;

	last = i;

	do
	{
		if (++i >= 3)
			i = 0;

		if (LoadAmmo(i))
			break;
	} until (last == i);
}

simulated function bool CanReload()
{
	if ((ClipCount > 0) && (ReloadCount != 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0) &&
	    (AmmoType.AmmoAmount > (ReloadCount-ClipCount)))
		return true;
	else
		return false;
}

simulated function bool MustReload()
{
	if ((AmmoLeftInClip() == 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0))
		return true;
	else
		return false;
}

simulated function int AmmoLeftInClip()
{
	if (ReloadCount == 0)	// if this weapon is not reloadable
		return 1;
	else if (AmmoType == None)
		return 0;
	else if (AmmoType.AmmoAmount == 0)		// if we are out of ammo
		return 0;
	else if (ReloadCount - ClipCount > AmmoType.AmmoAmount)		// if we have no clips left
		return AmmoType.AmmoAmount;
	else
		return ReloadCount - ClipCount;
}

simulated function int NumClips()
{
	if (ReloadCount == 0)  // if this weapon is not reloadable
		return 0;
	else if (AmmoType == None)
		return 0;
	else if (AmmoType.AmmoAmount == 0)	// if we are out of ammo
		return 0;
	else  // compute remaining clips
		return ((AmmoType.AmmoAmount-AmmoLeftInClip()) + (ReloadCount-1)) / ReloadCount;
}

simulated function int AmmoAvailable(int ammoNum)
{
	local class<Ammo> newAmmoClass;
	local Ammo newAmmo;
	local Pawn P;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return 0;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass == None)
		return 0;

	newAmmo = Ammo(P.FindInventoryType(newAmmoClass));

	if (newAmmo == None)
		return 0;

	return newAmmo.AmmoAmount;
}

simulated function int NumAmmoTypesAvailable()
{
	local int i;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == None)
			break;

	// to make Al fucking happy
	if (i == 0)
		i = 1;

	return i;
}

function name WeaponDamageType()
{
	local name                    damageType;
	local Class<DeusExProjectile> projClass;

	projClass = Class<DeusExProjectile>(ProjectileClass);
	if (bInstantHit)
	{
		if (StunDuration > 0)
			damageType = 'Stunned';
		else
			damageType = 'Shot';

		if (AmmoType != None)
			if (AmmoType.IsA('AmmoSabot'))
				damageType = 'Sabot';
	}
	else if (projClass != None)
		damageType = projClass.Default.damageType;
	else
		damageType = 'None';

	return (damageType);
}


//
// target tracking info
//
simulated function Actor AcquireTarget()
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor hit, retval;
	local Pawn p;

	p = Pawn(Owner);
	if (p == None)
		return None;

	StartTrace = p.Location;
	if (PlayerPawn(p) != None)
		EndTrace = p.Location + (10000 * Vector(p.ViewRotation));
	else
		EndTrace = p.Location + (10000 * Vector(p.Rotation));

	// adjust for eye height
	StartTrace.Z += p.BaseEyeHeight;
	EndTrace.Z += p.BaseEyeHeight;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
		if (!hit.bHidden && (hit.IsA('Decoration') || hit.IsA('Pawn')))
			return hit;

	return None;
}

//
// Used to determine if we are near (and facing) a wall for placing LAMs, etc.
//
simulated function bool NearWallCheck()
{
	local Vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor HitActor;

	// Scripted pawns can't place LAMs
	if (ScriptedPawn(Owner) != None)
		return False;

	// Don't let players place grenades when they have something highlighted
	if ( Level.NetMode != NM_Standalone )
	{
		if ( Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).frobTarget != None) )
		{
			if ( DeusExPlayer(Owner).IsFrobbable( DeusExPlayer(Owner).frobTarget ) )
				return False;
		}
	}

	// trace out one foot in front of the pawn
	StartTrace = Owner.Location;
	EndTrace = StartTrace + Vector(Pawn(Owner).ViewRotation) * 32;

	StartTrace.Z += Pawn(Owner).BaseEyeHeight;
	EndTrace.Z += Pawn(Owner).BaseEyeHeight;

	HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
	if ((HitActor == Level) || ((HitActor != None) && HitActor.IsA('Mover')))
	{
		placeLocation = HitLocation;
		placeNormal = HitNormal;
		placeMover = Mover(HitActor);
		return True;
	}

	return False;
}

//
// used to place a grenade on the wall
//
function PlaceGrenade()
{
	local ThrownProjectile gren;
	local float dmgX;

	gren = ThrownProjectile(spawn(ProjectileClass, Owner,, placeLocation, Rotator(placeNormal)));
	if (gren != None)
	{
		AmmoType.UseAmmo(1);
		if ( AmmoType.AmmoAmount <= 0 )
			bDestroyOnFinish = True;

		gren.PlayAnim('Open');
		gren.PlaySound(gren.MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		gren.SetPhysics(PHYS_None);
		gren.bBounce = False;
		gren.bProximityTriggered = True;
		gren.bStuck = True;
		if (placeMover != None)
			gren.SetBase(placeMover);

		// up the damage based on the skill
		// returned value from GetWeaponSkill is negative, so negate it to make it positive
		// dmgX value ranges from 1.0 to 2.4 (max demo skill and max target aug)
		dmgX = -2.0 * GetWeaponSkill() + 1.0;
		gren.Damage *= dmgX;

		// Update ammo count on object belt
		if (DeusExPlayer(Owner) != None)
			DeusExPlayer(Owner).UpdateBeltText(Self);
	}
}

//
// scope, laser, and targetting updates are done here
//
simulated function Tick(float deltaTime)
{
	local vector loc;
	local rotator rot;
	local float beepspeed, recoil;
	local DeusExPlayer player;
	local Actor RealTarget;
	local Pawn pawn;
	
	local int accunit; //Multiplier to apply to the accuracy to get our effective spread
	
	local float velMagnitude; //G-Flex: so we don't have to use VSize() as much

	player = DeusExPlayer(Owner);
	pawn = Pawn(Owner);
	
	if (Owner != None)
		velMagnitude = VSize(Owner.Velocity);

	Super.Tick(deltaTime);

	// don't do any of this if this weapon isn't currently in use
	if (pawn == None)
   {
      LockMode = LOCK_None;
      MaintainLockTimer = 0;
      LockTarget = None;
      LockTimer = 0;
		return;
   }

	if (pawn.Weapon != self)
   {
      LockMode = LOCK_None;
      MaintainLockTimer = 0;
      LockTarget = None;
      LockTimer = 0;
		return;
   }

	// all this should only happen IF you have ammo loaded
	if (ClipCount < ReloadCount)
	{
		// check for LAM or other placed mine placement
		if (bHandToHand && (ProjectileClass != None) && (!Self.IsA('WeaponShuriken')))
		{
			if (NearWallCheck())
			{
				if (( Level.NetMode != NM_Standalone ) && IsAnimating() && (AnimSequence == 'Select'))
				{
				}
				else
				{
					if (!bNearWall || (AnimSequence == 'Select'))
					{
						PlayAnim('PlaceBegin',, 0.1);
						bNearWall = True;
					}
				}
			}
			else
			{
				if (bNearWall)
				{
					PlayAnim('PlaceEnd',, 0.1);
					bNearWall = False;
				}
			}
		}


      SoundTimer += deltaTime;

      if ( (Level.Netmode == NM_Standalone) || ( (Player != None) && (Player.PlayerIsClient()) ) )
      {
         if (bCanTrack)
         {
            Target = AcquireTarget();
            RealTarget = Target;
            
            // calculate the range
            if (Target != None)
               TargetRange = Abs(VSize(Target.Location - Location));
            
            // update our timers
            //SoundTimer += deltaTime;
            MaintainLockTimer -= deltaTime;
            
            // check target and range info to see what our mode is
            if ((Target == None) || IsInState('Reload'))
            {
               if (MaintainLockTimer <= 0)
               {				
                  SetLockMode(LOCK_None);
                  MaintainLockTimer = 0;
                  LockTarget = None;
               }
               else if (LockMode == LOCK_Locked)
               {
                  Target = LockTarget;
               }
            }
            else if ((Target != LockTarget) && (Target.IsA('Pawn')) && (LockMode == LOCK_Locked))
            {
               SetLockMode(LOCK_None);
               LockTarget = None;
            }
            else if (!Target.IsA('Pawn'))
            {
               if (MaintainLockTimer <=0 )
               {
                  SetLockMode(LOCK_Invalid);
               }
            }
            else if ( (Target.IsA('DeusExPlayer')) && (Target.Style == STY_Translucent) )
            {
               //DEUS_EX AMSD Don't allow locks on cloaked targets.
               SetLockMode(LOCK_Invalid);
            }
            else if ( (Target.IsA('DeusExPlayer')) && (Player != None) && (Player.DXGame.IsA('TeamDMGame')) && (TeamDMGame(Player.DXGame).ArePlayersAllied(Player,DeusExPlayer(Target))) )
            {
               //DEUS_EX AMSD Don't allow locks on allies.
               SetLockMode(LOCK_Invalid);
            }
            else
            {
               if (TargetRange > MaxRange)
               {
                  SetLockMode(LOCK_Range);
               }
               else
               {
                  // change LockTime based on skill
                  // -0.7 = max skill
                  // DEUS_EX AMSD Only do weaponskill check here when first checking.
                  if (LockTimer == 0)
                  {
                     LockTime = FMax(Default.LockTime + 3.0 * GetWeaponSkill(), 0.0);
                     if ((Level.Netmode != NM_Standalone) && (LockTime < 0.25))
                        LockTime = 0.25;
                  }
                  
                  LockTimer += deltaTime;
                  if (LockTimer >= LockTime)
                  {
                     SetLockMode(LOCK_Locked);
                  }
                  else
                  {
                     SetLockMode(LOCK_Acquire);
                  }
               }
            }
            
            // act on the lock mode
            switch (LockMode)
            {
            case LOCK_None:
               TargetMessage = msgNone;
               LockTimer -= deltaTime;
               break;
               
            case LOCK_Invalid:
               TargetMessage = msgLockInvalid;
               LockTimer -= deltaTime;
               break;
               
            case LOCK_Range:
               TargetMessage = msgLockRange @ Int(TargetRange/16) @ msgRangeUnit;
               LockTimer -= deltaTime;
               break;
               
            case LOCK_Acquire:
               TargetMessage = msgLockAcquire @ Left(String(LockTime-LockTimer), 4) @ msgTimeUnit;
               beepspeed = FClamp((LockTime - LockTimer) / Default.LockTime, 0.2, 1.0);
               if (SoundTimer > beepspeed)
               {
                  Owner.PlaySound(TrackingSound, SLOT_None);
                  SoundTimer = 0;
               }
               break;
               
            case LOCK_Locked:
               // If maintaining a lock, or getting a new one, increment maintainlocktimer
               if ((RealTarget != None) && ((RealTarget == LockTarget) || (LockTarget == None)))
               {
                  if (Level.NetMode != NM_Standalone)
                     MaintainLockTimer = default.MaintainLockTimer;
                  else
                     MaintainLockTimer = 0;
                  LockTarget = Target;
               }
               TargetMessage = msgLockLocked @ Int(TargetRange/16) @ msgRangeUnit;
               // DEUS_EX AMSD Moved out so server can play it so that client knows for sure when locked.
               /*if (SoundTimer > 0.1)
               {
                  Owner.PlaySound(LockedSound, SLOT_None);
                  SoundTimer = 0;
               }*/
               break;
            }
         }
	 //G-Flex: I'm not sure what this next condition is for.
	 else if(bLasing)
	 {
	    if(Emitter.Spot[0] != None)
	    {
		TargetRange = Abs(VSize(Owner.Location - Emitter.Spot[0].Location));
		TargetMessage = Int(TargetRange/16) @ msgRangeUnit;
	    }
	    else
	    {
		TargetRange = Float(MaxRange) + 2.000000;
		TargetMessage = "Out of Range";
	    }

	    if(Int(TargetRange) <= AccurateRange)
	    {
		LockMode = LOCK_None;
	    }
	    else if(Int(TargetRange) <= MaxRange)
	    {
		LockMode = LOCK_Acquire;
	    }
	    else
	    {
		LockMode = LOCK_Locked;
	    }

            LockTimer = 0;
            MaintainLockTimer = 0;
            LockTarget = None;
         }
         else
         {
            LockMode = LOCK_None;
            TargetMessage = msgNone;
            LockTimer = 0;
            MaintainLockTimer = 0;
            LockTarget = None;
         }
         
         if (LockTimer < 0)
            LockTimer = 0;
      }
   }
   else
   {
      LockMode = LOCK_None;
	  TargetMessage=msgNone;
      MaintainLockTimer = 0;
      LockTarget = None;
      LockTimer = 0;
   }

   if ((LockMode == LOCK_Locked) && (SoundTimer > 0.1) && (Role == ROLE_Authority))
   {
      PlayLockSound();
      SoundTimer = 0;
   }

	currentAccuracy = CalculateAccuracy();

	if (player != None)
	{
		// reduce the recoil based on skill
		recoil = recoilStrength + GetWeaponSkill() * 2.0;
		if (recoil < 0.0)
			recoil = 0.0;

		// simulate recoil while firing
		if (bFiring && IsAnimating() && (AnimSequence == 'Shoot') && (recoil > 0.0))
		{
			player.ViewRotation.Yaw += deltaTime * (Rand(4096) - 2048) * recoil;
			player.ViewRotation.Pitch += deltaTime * (Rand(4096) + 4096) * recoil;
			if ((player.ViewRotation.Pitch > 16384) && (player.ViewRotation.Pitch < 32768))
				player.ViewRotation.Pitch = 16384;
		}
	}

	// if were standing still, increase the timer
	//== Y|y: but only to a point, unless we want to build up a "credit" of standing still.  Thanks to Lork
	if (velMagnitude < 10)
	{
		//G-Flex: don't go as high; 10.0 here was 15.0 
		//G-Flex: also increase timer 120% as fast as normal, and don't increase if reloading
		if((standingTimer < 10.0) && !IsInState('Reload'))
			standingTimer += (1.20 * deltaTime);
	}
	else	// otherwise, decrease it slowly based on velocity
	{
		//G-Flex: decrease by 2/3 former value
		standingTimer = FMax(0.00, standingTimer - 0.02*deltaTime*velMagnitude);
	}

	if (bLasing || bZoomed)
	{
		//== Though it uses the same code, the laser shake is different than the zoom shake
		if(bZoomed)
			accunit = 2048;
		else if (bLasing)
			//G-Flex: this value is used to match the edge of the firing cone,
			//G-Flex: so don't change it unless you know what you're doing
			accunit=1536;

		// shake our view to simulate poor aiming
		if (ShakeTimer > 0.25)
		{
			//G-Flex: Old method below, results in anomalies similar to
			//G-Flex: the old square bullet spread, also fixed
			//ShakeYaw = currentAccuracy * (Rand(accunit * 2) - accunit);
			//ShakePitch = currentAccuracy * (Rand(accunit * 2) - accunit);
			if (bZoomed)
			{
				//G-Flex: just use the old method
				ShakeYaw = currentAccuracy * (Rand(accunit * 2) - accunit);
				ShakePitch = currentAccuracy * (Rand(accunit * 2) - accunit);
				//ShakeTimer -= 0.25;
				//G-Flex: randomize this a bit to make change of shake direction less predictable
				//G-Flex: now is between 0.20 and 0.40 seconds, randomly
				ShakeTimer -= 0.20 + (Rand(21) / 100.00);
			}
			else if (bLasing)
			{
				//ShakeMagnitude and ShakeAngle start off randomized
				//gravitate ShakeMagnitude toward ShakeMagnitudeToward
				ShakeMagnitudeToward = 900 + (0.75 * Rand(accunit));
				//how much ShakeAngle changes per second in angle units
				//between -360 and 360 degrees
				ShakeAngleAccel = (FRand() * 3 * pi) - (1.5 * pi);
				//G-Flex: laser varies less often
				ShakeTimer -= 0.50 + (Rand(21) / 100.00);
			}
		}

		ShakeTimer += deltaTime;

		if (bLasing && (Emitter != None))
		{
			loc = Owner.Location;
			loc.Z += Pawn(Owner).BaseEyeHeight;

			// add a little random jitter - looks cool!
			rot = Pawn(Owner).ViewRotation;
			rot.Yaw += Rand(5) - 2;
			rot.Pitch += Rand(5) - 2;

			if(!bZoomed && (currentAccuracy != 0.0))
			{
				ShakeMagnitude += 2.25 * (ShakeMagnitudeToward - ShakeMagnitude) * deltaTime;
								
				//G-Flex: adjust for accuracy and movement
				ShakeMagnitudeAdjust = ShakeMagnitude * (1.0 + velMagnitude/200.0);
				
				//G-Flex: ShakeMagnitudeAdjust max is 50 + (0.50*(500+accunit)) * currentAccuracy * (1 + velMagnitude/200)
				//G-Flex: = 300 + 0.5*accunit * currentAccuracy * (1 + velMagnitude/200)

				ShakeAngle += ShakeAngleAccel * deltaTime;
				//G-Flex: using mixed units sucks, but we need to
				ShakeYaw = 10430.3783505 * atan(tan(ShakeMagnitudeAdjust * 0.000095873799)*cos(ShakeAngle));//ShakeMagnitudeAdjust * Cos(ShakeAngle);
				ShakePitch = 10430.3783505 * atan(tan(ShakeMagnitudeAdjust * 0.000095873799)*sin(ShakeAngle));//ShakeMagnitudeAdjust * Sin(ShakeAngle);
				LaserYaw += ShakeYaw * deltaTime;
				LaserPitch += ShakePitch * deltaTime;
				LaserYawProportion = LaserYaw / accunit;
				LaserPitchProportion = LaserPitch / accunit;
				LaserYawProportion = Square(LaserYawProportion);
				LaserPitchProportion = Square(LaserPitchProportion);
				if (LaserYaw < 0)
					LaserYawProportion *= -1.0;
				if (LaserPitch < 0)
					LaserPitchProportion *= -1.0;
				LaserYaw -= LaserYawProportion * deltaTime * (900 + 0.75*accunit * (1 + velMagnitude/200));
				LaserPitch -= LaserPitchProportion * deltaTime * (900 + 0.75*accunit * (1 + velMagnitude/200));
				rot.Yaw += LaserYaw * currentAccuracy;
				rot.Pitch += LaserPitch * currentAccuracy;
			}
			Emitter.SetLocation(loc);
			Emitter.SetRotation(rot);
		}

		if ((player != None) && bZoomed)
		{
			player.ViewRotation.Yaw += deltaTime * ShakeYaw;
			player.ViewRotation.Pitch += deltaTime * ShakePitch;
		}
	}
}

//
// scope functions for weapons which have them
//

function ScopeOn()
{
	if (bHasScope && !bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		// Show the Scope View
		bZoomed = True;
		RefreshScopeDisplay(DeusExPlayer(Owner), False, bZoomed);
	}
}

function ScopeOff()
{
	if (bHasScope && bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		bZoomed = False;
		//== If we disable the scope in the middle of a reload, don't go back
		if(bWasZoomed)
			bWasZoomed = False;
		// Hide the Scope View
		RefreshScopeDisplay(DeusExPlayer(Owner), False, bZoomed);
		//DeusExRootWindow(DeusExPlayer(Owner).rootWindow).scopeView.DeactivateView();
	}
}

simulated function ScopeToggle()
{
	//G-Flex: toggle the scope unless we're reloading
	//G-Flex: if reloading, toggle whether it comes back
	if (bHasScope && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		if (IsInState('Reload'))
		{
			bWasZoomed = !bWasZoomed;
		}
		else
		{
			if (bZoomed)
				ScopeOff();
			else
				ScopeOn();
		}
	}
}

// ----------------------------------------------------------------------
// RefreshScopeDisplay()
// ----------------------------------------------------------------------

simulated function RefreshScopeDisplay(DeusExPlayer player, bool bInstant, bool bScopeOn)
{
	if (bScopeOn && (player != None))
	{
		// Show the Scope View
		DeusExRootWindow(player.rootWindow).scopeView.ActivateView(ScopeFOV, False, bInstant);
		ResetShake();
	}
   else if (!bScopeOn)
   {
      DeusExrootWindow(player.rootWindow).scopeView.DeactivateView();
	  ResetShake();
   }
}

//
// laser functions for weapons which have them
//

function LaserOn()
{
	if (bHasLaser && !bLasing)
	{
		// if we don't have an emitter, then spawn one
		// otherwise, just turn it on
		if (Emitter == None)
		{
			Emitter = Spawn(class'LaserEmitter', Self, , Location, Pawn(Owner).ViewRotation);
			if (Emitter != None)
			{
				Emitter.SetHiddenBeam(True);
				Emitter.AmbientSound = None;
				Emitter.TurnOn();
			}
		}
		else
			Emitter.TurnOn();

		bLasing = True;
		ResetShake();
	}
}

function LaserOff()
{
	if (bHasLaser && bLasing)
	{
		if (Emitter != None)
			Emitter.TurnOff();

		bLasing = False;
		ResetShake();
	}
}

function LaserToggle()
{
	if (IsInState('Idle'))
	{
		if (bHasLaser)
		{
			if (bLasing)
				LaserOff();
			else
				LaserOn();
		}
	}
}

simulated function SawedOffCockSound()
{
	if ((AmmoType.AmmoAmount > 0) && (WeaponSawedOffShotgun(Self) != None))
		Owner.PlaySound(SelectSound, SLOT_None,,, 1024);
}

//
// called from the MESH NOTIFY
//
simulated function SwapMuzzleFlashTexture()
{
   if (!bHasMuzzleFlash)
      return;
	if (FRand() < 0.5)
		MultiSkins[2] = Texture'FlatFXTex34';
	else
		MultiSkins[2] = Texture'FlatFXTex37';

	MuzzleFlashLight();
	SetTimer(0.1, False);
}

simulated function EraseMuzzleFlashTexture()
{
	MultiSkins[2] = None;
}

simulated function Timer()
{
	EraseMuzzleFlashTexture();
}

simulated function MuzzleFlashLight()
{
	local Vector offset, X, Y, Z;

 	if (!bHasMuzzleFlash)
		return;

	if ((flash != None) && !flash.bDeleteMe)
		flash.LifeSpan = flash.Default.LifeSpan;
	else
	{
		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		offset = Owner.Location;
		offset += X * Owner.CollisionRadius * 2;
		flash = spawn(class'MuzzleFlash',,, offset);
		if (flash != None)
			flash.SetBase(Owner);
	}
}

function ServerHandleNotify( bool bInstantHit, class<projectile> ProjClass, float ProjSpeed, bool bWarn )
{
	if (bInstantHit)
		DoTraceFire(0.0);
	else
		DoProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
}

//
// HandToHandAttack
// called by the MESH NOTIFY for the H2H weapons
//
simulated function HandToHandAttack()
{
	local bool bOwnerIsPlayerPawn;

	if (bOwnerWillNotify)
		return;

	// The controlling animator should be the one to do the tracefire and projfire
	if ( Level.NetMode != NM_Standalone )
	{
		bOwnerIsPlayerPawn = (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn()));

		if (( Role < ROLE_Authority ) && bOwnerIsPlayerPawn )
			ServerHandleNotify( bInstantHit, ProjectileClass, ProjectileSpeed, bWarnTarget );
		else if ( !bOwnerIsPlayerPawn )
			return;
	}

	if (ScriptedPawn(Owner) != None)
		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		DoTraceFire(0.0);
	else
		DoProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

	// if we are a thrown weapon and we run out of ammo, destroy the weapon
	if ( bHandToHand && (ReloadCount > 0) && (SimAmmoAmount <= 0))
	{
		DestroyOnFinish();
		if ( Role < ROLE_Authority )
		{
			ServerGotoFinishFire();
			GotoState('SimQuickFinish');
		}
	}
}

//
// OwnerHandToHandAttack
// called by the MESH NOTIFY for this weapon's owner
//
simulated function OwnerHandToHandAttack()
{
	local bool bOwnerIsPlayerPawn;

	if (!bOwnerWillNotify)
		return;

	// The controlling animator should be the one to do the tracefire and projfire
	if ( Level.NetMode != NM_Standalone )
	{
		bOwnerIsPlayerPawn = (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn()));

		if (( Role < ROLE_Authority ) && bOwnerIsPlayerPawn )
			ServerHandleNotify( bInstantHit, ProjectileClass, ProjectileSpeed, bWarnTarget );
		else if ( !bOwnerIsPlayerPawn )
			return;
	}

	if (ScriptedPawn(Owner) != None)
		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		DoTraceFire(0.0);
	else
		DoProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
}

function ForceFire()
{
	Fire(0);
}

function ForceAltFire()
{
	AltFire(0);
}

//
// ReadyClientToFire is called by the server telling the client it's ok to fire now
//

simulated function ReadyClientToFire( bool bReady )
{
	bClientReadyToFire = bReady;
}

//
// ClientReFire is called when the client is holding down the fire button, loop firing
//

simulated function ClientReFire( float value )
{
	bClientReadyToFire = True;
	bLooping = True;
	bInProcess = False;
	ClientFire(0);
}

function StartFlame()
{
	flameShotCount = 0;
	bFlameOn = True;
	GotoState('FlameThrowerOn');
}

function StopFlame()
{
	bFlameOn = False;
}

//
// ServerForceFire is called from the client when loop firing
//
function ServerForceFire()
{
	bClientReady = True;
	Fire(0);
}

simulated function int PlaySimSound( Sound snd, ESoundSlot Slot, float Volume, float Radius )
{
	if ( Owner != None )
	{
		if ( Level.NetMode == NM_Standalone )
			return ( Owner.PlaySound( snd, Slot, Volume, , Radius ) );
		else
		{
			Owner.PlayOwnedSound( snd, Slot, Volume, , Radius );
			return 1;
		}
	}
	return 0;
}

//
// ClientFire - Attempts to play the firing anim, sounds, and trace fire hits for instant weapons immediately
//				on the client.  The server may have a different interpretation of what actually happen, but this at least
//				cuts down on preceived lag.
//
simulated function bool ClientFire( float value )
{
	local bool bWaitOnAnim;
	local vector shake;

	// check for surrounding environment
	if ((EnviroEffective == ENVEFF_Air) || (EnviroEffective == ENVEFF_Vacuum) || (EnviroEffective == ENVEFF_AirVacuum))
	{
		if (Region.Zone.bWaterZone)
		{
			if (Pawn(Owner) != None)
			{
				Pawn(Owner).ClientMessage(msgNotWorking);
				if (!bHandToHand)
					PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );
			}
			return false;
		}
	}

	if ( !bLooping ) // Wait on animations when not looping
	{
		bWaitOnAnim = ( IsAnimating() && ((AnimSequence == 'Select') || (AnimSequence == 'Shoot') || (AnimSequence == 'ReloadBegin') || (AnimSequence == 'Reload') || (AnimSequence == 'ReloadEnd') || (AnimSequence == 'Down')));
	}
	else
	{
		bWaitOnAnim = False;
		bLooping = False;
	}

	if ( (Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).NintendoImmunityTimeLeft > 0.01)) ||
		  (!bClientReadyToFire) || bInProcess || bWaitOnAnim )
	{
		DeusExPlayer(Owner).bJustFired = False;
		bPointing = False;
		bFiring = False;
		return false;
	}

	if ( !Self.IsA('WeaponFlamethrower') )
		ServerForceFire();

	if (bHandToHand)
	{
		SimAmmoAmount = AmmoType.AmmoAmount - 1;

		bClientReadyToFire = False;
		bInProcess = True;
		GotoState('ClientFiring');
		bPointing = True;
		if ( PlayerPawn(Owner) != None )
			PlayerPawn(Owner).PlayFiring();
		PlaySelectiveFiring();
		PlayFiringSound();
	}
	else if ((ClipCount < ReloadCount) || (ReloadCount == 0))
	{
		if ((ReloadCount == 0) || (AmmoType.AmmoAmount > 0))
		{
			SimClipCount = ClipCount + 1;

			if ( AmmoType != None )
				AmmoType.SimUseAmmo();

			bFiring = True;
			bPointing = True;
			bClientReadyToFire = False;
			bInProcess = True;
			GotoState('ClientFiring');
			if ( PlayerPawn(Owner) != None )
			{
				shake.X = 0.0;
				shake.Y = 100.0 * (ShakeTime*0.5);
				shake.Z = 100.0 * -(currentAccuracy * ShakeVert);
				PlayerPawn(Owner).ClientShake( shake );
				PlayerPawn(Owner).PlayFiring();
			}
			// Don't play firing anim for 20mm
			if ( Ammo20mm(AmmoType) == None )
				PlaySelectiveFiring();
			PlayFiringSound();

			if ( bInstantHit &&  ( Ammo20mm(AmmoType) == None ))
				DoTraceFire(currentAccuracy);
			else
			{
				if ( !bFlameOn && Self.IsA('WeaponFlamethrower'))
				{
					bFlameOn = True;
					StartFlame();
				}
				DoProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
			}
		}
		else
		{
			if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
			{
				if ( MustReload() && CanReload() )
				{
					bClientReadyToFire = False;
					bInProcess = False;
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();

					ReloadAmmo();
				}
			}
			PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );		// play dry fire sound
		}
	}
	else
	{
		if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
		{
			if ( MustReload() && CanReload() )
			{
				bClientReadyToFire = False;
				bInProcess = False;
				if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
					CycleAmmo();
				ReloadAmmo();
			}
		}
		PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );		// play dry fire sound
	}
	return true;
}

//
// from Weapon.uc - modified so we can have the accuracy in TraceFire
//
function Fire(float Value)
{
	local float sndVolume;
	local bool bListenClient;

	bListenClient = (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient());

	sndVolume = TransientSoundVolume;

	if ( Level.NetMode != NM_Standalone )  // Turn up the sounds a bit in mulitplayer
	{
		sndVolume = TransientSoundVolume * 2.0;
		if ( Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).NintendoImmunityTimeLeft > 0.01) || (!bClientReady && (!bListenClient)) )
		{
			DeusExPlayer(Owner).bJustFired = False;
			bReadyToFire = True;
			bPointing = False;
			bFiring = False;
			return;
		}
	}
	// check for surrounding environment
	if ((EnviroEffective == ENVEFF_Air) || (EnviroEffective == ENVEFF_Vacuum) || (EnviroEffective == ENVEFF_AirVacuum))
	{
		if (Region.Zone.bWaterZone)
		{
			if (Pawn(Owner) != None)
			{
				Pawn(Owner).ClientMessage(msgNotWorking);
				if (!bHandToHand)
					PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound
			}
			GotoState('Idle');
			return;
		}
	}


	if (bHandToHand)
	{
		if (ReloadCount > 0)
			AmmoType.UseAmmo(1);

		if (( Level.NetMode != NM_Standalone ) && !bListenClient )
			bClientReady = False;
		bReadyToFire = False;
		GotoState('NormalFire');
		bPointing=True;
		if ( Owner.IsA('PlayerPawn') )
			PlayerPawn(Owner).PlayFiring();
		PlaySelectiveFiring();
		PlayFiringSound();
	}
	// if we are a single-use weapon, then our ReloadCount is 0 and we don't use ammo
	else if ((ClipCount < ReloadCount) || (ReloadCount == 0))
	{
		if ((ReloadCount == 0) || AmmoType.UseAmmo(1))
		{
			if (( Level.NetMode != NM_Standalone ) && !bListenClient )
				bClientReady = False;

			ClipCount++;
			bFiring = True;
			bReadyToFire = False;
			GotoState('NormalFire');
			if (( Level.NetMode == NM_Standalone ) || ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
			{
				//G-Flex: lower standing timer a bit per shot (or burst)
				if (Owner.IsA('DeusExPlayer'))
					StandingTimer = FMax(0.00,StandingTimer - FMax(0.00,(recoilStrength + GetWeaponSkill() * 2.0)) * 2.0);
				if ( PlayerPawn(Owner) != None )		// shake us based on accuracy
					PlayerPawn(Owner).ShakeView(ShakeTime, currentAccuracy * ShakeMag + ShakeMag, currentAccuracy * ShakeVert);
			}
			bPointing=True;
			if ( bInstantHit )
				DoTraceFire(currentAccuracy);
			else
				DoProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

			if ( Owner.IsA('PlayerPawn') )
				PlayerPawn(Owner).PlayFiring();
			// Don't play firing anim for 20mm
			if ( Ammo20mm(AmmoType) == None )
				PlaySelectiveFiring();
			PlayFiringSound();
			if ( Owner.bHidden )
				CheckVisibility();
		}
		else
			PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound
	}
	else
		PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound

	// Update ammo count on object belt
	if (DeusExPlayer(Owner) != None)
		DeusExPlayer(Owner).UpdateBeltText(Self);
}

function ReadyToFire()
{
	if (!bReadyToFire)
	{
		// BOOGER!
		//if (ScriptedPawn(Owner) != None)
		//	ScriptedPawn(Owner).ReadyToFire();
		bReadyToFire = True;
		if ( Level.NetMode != NM_Standalone )
			ReadyClientToFire( True );
	}
}

simulated function ResetShake()
{
	local float pi, LaserAngle, LaserDirection;
	pi = 3.1415926535897932;
	
	if((!bZoomed) && (bLasing))
	{
		//G-Flex: we need radians for trig math, but URot units for the results. Sigh.
		LaserAngle = (Rand(3072) - 1536);
		LaserDirection = (FRand() * 2 * pi);
		LaserYaw = 10430.3783505 * atan(tan(LaserAngle * 0.000095873799) * cos(LaserDirection));//LaserAngle * Cos(LaserDirection);
		LaserPitch = 10430.3783505 * atan(tan(LaserAngle * 0.000095873799) * sin(LaserDirection));//LaserAngle * Sin(LaserDirection);
		ShakeMagnitude = 900 + (0.75 * Rand(1536));
		ShakeMagnitudeToward = 900 + (0.75 * Rand(1536));
		ShakeAngleAccel = (FRand() * 4 * pi) - (2 * pi);
		ShakeAngle = Rand(2*pi);
	}
	else if (bZoomed)
	{
		ShakeYaw = currentAccuracy * (Rand(2048 * 2) - 2048);
		ShakePitch = currentAccuracy * (Rand(2048 * 2) - 2048);
	}
	
	ShakeTimer = (FRand() * 0.15) + 0.20;
}

function PlayPostSelect()
{
	// let's not zero the ammo count anymore - you must always reload
//	ClipCount = 0;		
}

simulated function PlaySelectiveFiring()
{
	local Pawn aPawn;
	local float rnd;
	local Name anim;

	anim = 'Shoot';

	if (bHandToHand)
	{
		rnd = FRand();
		if (rnd < 0.33)
			anim = 'Attack';
		else if (rnd < 0.66)
			anim = 'Attack2';
		else
			anim = 'Attack3';
	}

	if (( Level.NetMode == NM_Standalone ) || ( DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
	{
		if (bAutomatic)
			LoopAnim(anim,, 0.1);
		else
			PlayAnim(anim,,0.1);
	}
	else if ( Role == ROLE_Authority )
	{
		for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
		{
			if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(Owner) != DeusExPlayer(aPawn) ) )
			{
				// If they can't see the weapon, don't bother
				if ( DeusExPlayer(aPawn).FastTrace( DeusExPlayer(aPawn).Location, Location ))
					DeusExPlayer(aPawn).ClientPlayAnimation( Self, anim, 0.1, bAutomatic );
			}
		}
	}
}

simulated function PlayFiringSound()
{
	if (bHasSilencer)
		PlaySimSound( Sound'StealthPistolFire', SLOT_None, TransientSoundVolume, 2048 );
	else
	{
		// The sniper rifle sound is heard to it's range in multiplayer
		if ( ( Level.NetMode != NM_Standalone ) &&  Self.IsA('WeaponRifle') )	
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, class'WeaponRifle'.Default.mpMaxRange );
		else
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, 2048 );
	}
}

simulated function PlayIdleAnim()
{
	local float rnd;

	if (bZoomed || bNearWall)
		return;

	rnd = FRand();

	if (rnd < 0.1)
		PlayAnim('Idle1',,0.1);
	else if (rnd < 0.2)
		PlayAnim('Idle2',,0.1);
	else if (rnd < 0.3)
		PlayAnim('Idle3',,0.1);
}

//
// SpawnBlood
//

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
   if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
      return;

   spawn(class'BloodSpurt',,,HitLocation+HitNormal);
	spawn(class'BloodDrop',,,HitLocation+HitNormal);
	if (FRand() < 0.5)
		spawn(class'BloodDrop',,,HitLocation+HitNormal);
}

//
// SelectiveSpawnEffects - Continues the simulated chain for the owner, and spawns the effects for other players that can see them
//			No actually spawning occurs on the server itself.
//
simulated function SelectiveSpawnEffects( Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
	local DeusExPlayer fxOwner;
	local Pawn aPawn;

	// The normal path before there was multiplayer
	if ( Level.NetMode == NM_Standalone )
	{
		SpawnEffects(HitLocation, HitNormal, Other, Damage);
		return;
	}

	fxOwner = DeusExPlayer(Owner);

	if ( Role == ROLE_Authority )
	{
		SpawnEffectSounds(HitLocation, HitNormal, Other, Damage );

		for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
		{
			if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(aPawn) != fxOwner ) )
			{
				if ( DeusExPlayer(aPawn).FastTrace( DeusExPlayer(aPawn).Location, HitLocation ))
					DeusExPlayer(aPawn).ClientSpawnHits( bPenetrating, bHandToHand, HitLocation, HitNormal, Other, Damage );
			}
		}
	}
	if ( fxOwner == DeusExPlayer(GetPlayerPawn()) )
	{
			fxOwner.ClientSpawnHits( bPenetrating, bHandToHand, HitLocation, HitNormal, Other, Damage );
			SpawnEffectSounds( HitLocation, HitNormal, Other, Damage );
	}
}

//
//	 SpawnEffectSounds - Plays the sound for the effect owner immediately, the server will play them for the other players
//	
simulated function SpawnEffectSounds( Vector HitLocation, Vector HitNormal, Actor Other, float Damage )
{
	if (bHandToHand)
	{
		// if we are hand to hand, play an appropriate sound
		if (Other.IsA('DeusExDecoration'))
			Owner.PlayOwnedSound(Misc3Sound, SLOT_None,,, 1024);
		else if (Other.IsA('Pawn'))
			Owner.PlayOwnedSound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('BreakableGlass'))
			Owner.PlayOwnedSound(sound'GlassHit1', SLOT_None,,, 1024);
		else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
			Owner.PlayOwnedSound(sound'BulletProofHit', SLOT_None,,, 1024);
		else
			Owner.PlayOwnedSound(Misc2Sound, SLOT_None,,, 1024);
	}
}

//
//	SpawnEffects - Spawns the effects like it did in single player
//
function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
   local TraceHitSpawner hitspawner;
	local Name damageType;

	damageType = WeaponDamageType();

   if (bPenetrating)
   {
      if (bHandToHand)
      {
         hitspawner = Spawn(class'TraceHitHandSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
      else
      {
         hitspawner = Spawn(class'TraceHitSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
   }
   else
   {
      if (bHandToHand)
      {
         hitspawner = Spawn(class'TraceHitHandNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
      else
      {
         hitspawner = Spawn(class'TraceHitNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
   }
   if (hitSpawner != None)
	{
      hitspawner.HitDamage = Damage;
		hitSpawner.damageType = damageType;
	}
	if (bHandToHand)
	{
		// if we are hand to hand, play an appropriate sound
		if (Other.IsA('DeusExDecoration'))
			Owner.PlaySound(Misc3Sound, SLOT_None,,, 1024);
		else if (Other.IsA('Pawn'))
			Owner.PlaySound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('BreakableGlass'))
			Owner.PlaySound(sound'GlassHit1', SLOT_None,,, 1024);
		else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
			Owner.PlaySound(sound'BulletProofHit', SLOT_None,,, 1024);
		else
			Owner.PlaySound(Misc2Sound, SLOT_None,,, 1024);
	}
}


function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
	local vector EndTrace, StartTrace;
	local actor target;
	local int texFlags;
	local name texName, texGroup;

	StartTrace = HitLocation + HitNormal*16;		// make sure we start far enough out
	EndTrace = HitLocation - HitNormal;

	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
		if ((target == Level) || target.IsA('Mover'))
			break;

	return texGroup;
}

simulated function SimGenerateBullet()
{
	if ( Role < ROLE_Authority )
	{
		if ((ClipCount < ReloadCount) && (ReloadCount != 0))
		{
			if ( AmmoType != None )
				AmmoType.SimUseAmmo();

			//== Y|y: Automatic weapons need to play the silenced firing sound more than once
			if ( bHasSilencer )
				PlayFiringSound();

			if ( bInstantHit )
				DoTraceFire(currentAccuracy);
			else
				DoProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

			SimClipCount++;

			if ( !Self.IsA('WeaponFlamethrower') )
				ServerGenerateBullet();
		}
		else
			GotoState('SimFinishFire');
	}
}

function DestroyOnFinish()
{
	bDestroyOnFinish = True;
}

function ServerGotoFinishFire()
{
	GotoState('FinishFire');
}

function ServerDoneReloading()
{
	ClipCount = 0;
}

function ServerGenerateBullet()
{
	if ( ClipCount < ReloadCount )
		GenerateBullet();
}

function GenerateBullet()
{
	if (AmmoType.UseAmmo(1))
	{
		//== Y|y: Silenced, automatic weapons don't play enough bullet sounds
		if(bHasSilencer)
			PlayFiringSound();

		if ( bInstantHit )
			DoTraceFire(currentAccuracy);
		else
			DoProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

		ClipCount++;
	}
	else
		GotoState('FinishFire');
}


function PlayLandingSound()
{
	if (LandSound != None)
	{
		if (Velocity.Z <= -200)
		{
			PlaySound(LandSound, SLOT_None, TransientSoundVolume,, 768);
			AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 768);
		}
	}
}


function GetWeaponRanges(out float wMinRange,
                         out float wMaxAccurateRange,
                         out float wMaxRange)
{
	local Class<DeusExProjectile> dxProjectileClass;

	dxProjectileClass = Class<DeusExProjectile>(ProjectileClass);
	if (dxProjectileClass != None)
	{
		wMinRange         = dxProjectileClass.Default.blastRadius;
		wMaxAccurateRange = dxProjectileClass.Default.AccurateRange;
		wMaxRange         = dxProjectileClass.Default.MaxRange;
	}
	else
	{
		wMinRange         = 0;
		wMaxAccurateRange = AccurateRange;
		wMaxRange         = MaxRange;
	}
}

//
// computes the start position of a projectile/trace
//
simulated function Vector ComputeProjectileStart(Vector X, Vector Y, Vector Z)
{
	local Vector Start;

	// if we are instant-hit, non-projectile, then don't offset our starting point by PlayerViewOffset
	if (bInstantHit)
		Start = Owner.Location + Pawn(Owner).BaseEyeHeight * vect(0,0,1);// - Vector(Pawn(Owner).ViewRotation)*(0.9*Pawn(Owner).CollisionRadius);
	else
		Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	return Start;
}

//
// Modified to work better with scripted pawns
//
simulated function vector CalcDrawOffset()
{
	local vector		DrawOffset, WeaponBob;
	local ScriptedPawn	SPOwner;
	local Pawn			PawnOwner;

	SPOwner = ScriptedPawn(Owner);
	if (SPOwner != None)
	{
		DrawOffset = ((0.9/SPOwner.FOVAngle * PlayerViewOffset) >> SPOwner.ViewRotation);
		DrawOffset += (SPOwner.BaseEyeHeight * vect(0,0,1));
	}
	else
	{
		// copied from Engine.Inventory to not be FOVAngle dependent
		PawnOwner = Pawn(Owner);
		DrawOffset = ((0.9/PawnOwner.Default.FOVAngle * PlayerViewOffset) >> PawnOwner.ViewRotation);

		DrawOffset += (PawnOwner.EyeHeight * vect(0,0,1));
		WeaponBob = BobDamping * PawnOwner.WalkBob;
		WeaponBob.Z = (0.45 + 0.55 * BobDamping) * PawnOwner.WalkBob.Z;
		DrawOffset += WeaponBob;
	}

	return DrawOffset;
}

function GetAIVolume(out float volume, out float radius)
{
	volume = 0;
	radius = 0;

	if (!bHasSilencer && !bHandToHand)
	{
		volume = NoiseLevel*Pawn(Owner).SoundDampening;
		radius = volume * 800.0;
	}
}

//G-Flex: dummy function like TraceFire() now
simulated function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	return DoProjectileFire(ProjClass, ProjSpeed, bWarn);
}

//
// copied from Weapon.uc
//
//G-Flex: modify as per DoTraceFire() to account for laser and accuracy changes
simulated function Projectile DoProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X, Y, Z;
	local DeusExProjectile proj;
	local float mult;
	local float volume, radius;
	local int i, numProj;
	local Pawn aPawn;
	local float pi;
	local float fireAngle, fireRotationAngle, Accuracy;
	pi = 3.1415926535897932;
	
	Accuracy = currentAccuracy;
	
	if (bLasing || bZoomed)
		Accuracy = 0.0;
	
	// AugCombat increases our speed (distance) if hand to hand
	mult = 1.0;
	if (bHandToHand && (DeusExPlayer(Owner) != None))
	{
		mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
		if (mult == -1.0)
			mult = 1.0;
		ProjSpeed *= mult;
	}

	// skill also affects our damage
	// GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
	mult += -2.0 * GetWeaponSkill();

	// make noise if we are not silenced
	if (!bHasSilencer && !bHandToHand)
	{
		GetAIVolume(volume, radius);
		Owner.AISendEvent('WeaponFire', EAITYPE_Audio, volume, radius);
		Owner.AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			Owner.AISendEvent('Distress', EAITYPE_Audio, volume, radius);
	}

	// should we shoot multiple projectiles in a spread?
	if (AreaOfEffect == AOE_Cone)
		numProj = 3;
	else
		numProj = 1;

	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = ComputeProjectileStart(X, Y, Z);

	for (i=0; i<numProj; i++)
	{
      // If we have multiple slugs, then lower our accuracy a bit after the first slug so the slugs DON'T all go to the same place
      //G-Flex: similar to normal guns, also implement a (smaller) penalty in single player
      if ((i > 0) && (Accuracy < MinProjSpreadAcc))
	  {
         if (Level.NetMode != NM_Standalone)
            Accuracy = MinProjSpreadAcc;
         else if (Accuracy < (MinProjSpreadAcc * 0.2))
            Accuracy = (MinProjSpreadAcc * 0.2);
      }
        if (bLasing && Emitter != None)
			AdjustedAim = Emitter.Rotation;
		else
			AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);
		if ((Accuracy > 0.0) && (Owner.IsA('PlayerPawn')) && !bHandToHand)
		{
			fireAngle = Accuracy * (Rand(3072) - 1536);
			fireRotationAngle = FRand() * 2 * pi;
			AdjustedAim.Yaw += 10430.3783505 * atan(tan(fireAngle * 0.000095873799) * cos(fireRotationAngle));//fireAngle * Cos(fireRotationAngle);
			AdjustedAim.Pitch += 10430.3783505 * atan(tan(fireAngle * 0.000095873799) * sin(fireRotationAngle));//fireangle * Sin(fireRotationAngle);
		}
		//G-Flex: use old method for NPCs/hand-to-hand like DoTraceFire()
		else
		{
		AdjustedAim.Yaw += Accuracy * (Rand(1024) - 512);
		AdjustedAim.Pitch += Accuracy * (Rand(1024) - 512);
		}

		if (( Level.NetMode == NM_Standalone ) || ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
		{
			proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
			if (proj != None)
			{
				// AugCombat increases our damage as well
				proj.Damage *= mult;

				// send the targetting information to the projectile
				if (bCanTrack && (LockTarget != None) && (LockMode == LOCK_Locked))
				{
					proj.Target = LockTarget;
					proj.bTracking = True;
				}
			}
		}
		else
		{
			if (( Role == ROLE_Authority ) || (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
			{
				// Do it the old fashioned way if it can track, or if we are a projectile that we could pick up again
				if ( bCanTrack || Self.IsA('WeaponShuriken') || Self.IsA('WeaponMiniCrossbow') || Self.IsA('WeaponLAM') || Self.IsA('WeaponEMPGrenade') || Self.IsA('WeaponGasGrenade'))
				{
					if ( Role == ROLE_Authority )
					{
						proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
						if (proj != None)
						{
							// AugCombat increases our damage as well
								proj.Damage *= mult;
							// send the targetting information to the projectile
							if (bCanTrack && (LockTarget != None) && (LockMode == LOCK_Locked))
							{
								proj.Target = LockTarget;
								proj.bTracking = True;
							}
						}
					}
				}
				else
				{
					proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
					if (proj != None)
					{
						proj.RemoteRole = ROLE_None;
						// AugCombat increases our damage as well
						if ( Role == ROLE_Authority )
							proj.Damage *= mult;
						else
							proj.Damage = 0;
					}
					if ( Role == ROLE_Authority )
					{
						for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
						{
							if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(aPawn) != DeusExPlayer(Owner) ))
								DeusExPlayer(aPawn).ClientSpawnProjectile( ProjClass, Owner, Start, AdjustedAim );
						}
					}
				}
			}
		}

	}
	return proj;
}

//
// copied from Weapon.uc so we can add range information
//
//== Here for calls from other mods and the like.  Internally we only reference the new DoTraceFire function
simulated function TraceFire( float Accuracy )
{
	DoTraceFire(Accuracy);
}

simulated function DoTraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
	local Rotator rot;
	local actor Other;
	local float dist, alpha, degrade;
	local int i, numSlugs;
	local float volume, radius;
	local actor splash;
	local ParticleGenerator waterGen;
	local ZoneInfo TestZone;
	local string detLevel;
	//G-Flex: for new, better hitscan angles and spread
	local float pi;
	local float fireAngle, fireRotationAngle, spreadAccuracy;
	local Rotator aimRot;
	pi = 3.1415926535897932;
	
	// make noise if we are not silenced
	if (!bHasSilencer && !bHandToHand)
	{
		GetAIVolume(volume, radius);
		Owner.AISendEvent('WeaponFire', EAITYPE_Audio, volume, radius);
		Owner.AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			Owner.AISendEvent('Distress', EAITYPE_Audio, volume, radius);
	}

	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	StartTrace = ComputeProjectileStart(X, Y, Z);
	AdjustedAim = pawn(owner).AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);

	// check to see if we are a shotgun-type weapon
	if (AreaOfEffect == AOE_Cone)
	{
		//G-Flex: kludge to give the DTS 3 hits, not 5
		if (Self.IsA('WeaponNanoSword'))
			numSlugs = 2;
		else
			numSlugs = 5;
	}
	else
		numSlugs = 1;

	// if there is a scope, but the player isn't using it, decrease the accuracy
	// so there is an advantage to using the scope
	// BUT ONLY WHEN THEY DON'T HAVE A LASER SIGHT -- Y|yukichigai
	//if (bHasScope && !bZoomed && !bLasing)
	//	Accuracy += 0.2; //now handled in CalculateAccuracy
	// if the laser sight is on, make this shot dead on
	// also, if the scope is on, zero the accuracy so the shake makes the shot inaccurate
	//else 
	if (bLasing || bZoomed)
		Accuracy = 0.0;

	if(DeusExPlayer(GetPlayerPawn()) != None)
		detLevel = DeusExPlayer(GetPlayerPawn()).ConsoleCommand("get ini:Engine.Engine.ViewportManager TextureDetail");

	//G-Flex: calculate spread for multishot weapons
	//G-Flex: make sabot pellets all hit the same location (TERRIBLE!)
	spreadAccuracy = 0.0;
	if (AmmoType != None)
	{
		if (!AmmoType.IsA('AmmoSabot'))
		{
			if ((Owner.IsA('PlayerPawn')) && (numSlugs > 1) && !(bHandToHand))
				spreadAccuracy = MinSpreadAcc;
			else if ((numSlugs > 1) && !(bHandToHand) && (Accuracy < minSpreadAcc))
			{
				Accuracy = MinSpreadAcc;
			}
		}
	}
	
	//G-Flex: determine angle and direction of fire
	aimRot = AdjustedAim;
	if(bLasing && (Emitter != None))
	{
		aimRot = Emitter.Rotation;
	}
	else if (Accuracy > 0.0)
	{		
		//== Use a new, consistent method for calculating aim offsets.  Works just like the laser sight
		//G-Flex: use that method to make realistic bullet spread. Wow!
		//G-Flex: calculate angle from center
		fireAngle = Accuracy * (Rand(3072) - 1536);
		//G-Flex: calculate direction from center
		fireRotationAngle = FRand() * 2 * pi;
		aimRot.Yaw += 10430.3783505 * atan(tan(fireAngle * 0.000095873799) * cos(fireRotationAngle));//fireAngle * Cos(fireRotationAngle);
		aimRot.Pitch += 10430.3783505 * atan(tan(fireAngle * 0.000095873799) * sin(fireRotationAngle));//fireangle * Sin(fireRotationAngle);
	}
	
	//G-Flex: now determine where all the shots hit
	for (i=0; i<numSlugs; i++)
	{
      // If we have multiple slugs, then lower our accuracy a bit after the first slug so the slugs DON'T all go to the same place
      //G-Flex: also do this for single player, but to a lesser degree
	  //G-Flex: in SP, minimum is half the min spread accuracy

      // Let handtohand weapons have a better swing
      if ((bHandToHand) && (NumSlugs > 1) && (Level.NetMode != NM_Standalone))
      {
         StartTrace = ComputeProjectileStart(X,Y,Z);
         StartTrace = StartTrace + (numSlugs/2 - i) * SwingOffset;
      }
	      if(Owner.IsA('PlayerPawn') && !bHandToHand)
	      {
		rot = aimRot;
		if(spreadAccuracy > 0.0)
		{
		fireAngle = spreadAccuracy * (Rand(3072) - 1536);
		fireRotationAngle = FRand() * 2 * pi;
		rot.Yaw += 10430.3783505 * atan(tan(fireAngle * 0.000095873799) * cos(fireRotationAngle));//fireAngle * Cos(fireRotationAngle);
		rot.Pitch += 10430.3783505 * atan(tan(fireAngle * 0.000095873799) * sin(fireRotationAngle));//fireangle * Sin(fireRotationAngle);
		}
		EndTrace = StartTrace + ( FMax(1024.0, MaxRange) * vector(rot) );
	      }
	      else
	      {

		//== This is the old method.  It works in theory, but the spread is different than what the reticle shows.
		//==  We need to use it for hand to hand weapons and NPC weapons (otherwise NPCs suck)
		EndTrace = StartTrace + Accuracy * (FRand()-0.5)*Y*1000 + Accuracy * (FRand()-0.5)*Z*1000 ;
		EndTrace += (FMax(1024.0, MaxRange) * vector(AdjustedAim));
	      }
      
      Other = Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);

		rot = Rotator(EndTrace - StartTrace);

		// randomly draw a tracer for relevant ammo types
		// don't draw tracers if we're zoomed in with a scope - looks stupid
      // DEUS_EX AMSD In multiplayer, draw tracers all the time.
		if ( ((Level.NetMode == NM_Standalone) && (!bZoomed && (numSlugs == 1) && (FRand() < 0.5))) ||
           ((Level.NetMode != NM_Standalone) && (Role == ROLE_Authority) && (numSlugs == 1)) )
		{
			if ((AmmoName == Class'Ammo10mm') || (AmmoName == Class'Ammo3006') ||
				(AmmoName == Class'Ammo762mm'))
			{
				if (VSize(HitLocation - StartTrace) > 250)
				{
               //if ((Level.NetMode != NM_Standalone) && (Self.IsA('WeaponRifle')))
                  Spawn(class'SniperTracer',,, StartTrace + 96 * Vector(rot), rot);
               //else
                  //Spawn(class'Tracer',,, StartTrace + 96 * Vector(rot), rot);
				}
			}
		}

		if(detLevel != "Low" && !bHandToHand)
			splash = Spawn(class'LaserSpot',,, HitLocation, rot);

		//== Draw a pretty pretty splash effect
		if(splash != None)
		{
			TestZone = splash.Region.Zone;
			splash.Destroy();

			if(TestZone.bWaterZone != Region.Zone.bWaterZone && i < 6)
			{
				if(TestZone.bWaterZone)
				{
					if(!WaterZone(TestZone).bSurfaceLevelKnown && i < 1)
					{
						Spawn(class'Tracer',,, StartTrace, rot);
					}
					else if(WaterZone(TestZone).bSurfaceLevelKnown && TestZone.EntryActor != None)
					{
						EndTrace.Z = WaterZone(TestZone).SurfaceLevel;
						EndTrace.X = StartTrace.X + (Vector(rot).X * Abs( (EndTrace.Z - StartTrace.Z)/Vector(rot).Z ) );
						EndTrace.Y = StartTrace.Y + (Vector(rot).Y * Abs( (EndTrace.Z - StartTrace.Z)/Vector(rot).Z ) );
	
						splash = Spawn(TestZone.EntryActor,,, EndTrace); 
						if ( splash != None )
						{
							splash.DrawScale = 0.00001;
							splash.LifeSpan = 0.60;
							if(WaterRing(splash) != None)
								WaterRing(splash).bNoExtraRings = True;

							if(detLevel == "High")
							{
								waterGen = Spawn(class'ParticleGenerator', splash,, splash.Location, rot(16384,0,0));
								if (waterGen != None)
								{
									waterGen.bHighDetail = True; //Only render on high detail level
									waterGen.particleDrawScale = 0.2;
									waterGen.checkTime = 0.05;
									waterGen.frequency = 1.0;
									waterGen.bGravity = True;
									waterGen.bScale = False;
									waterGen.bFade = True;
									waterGen.ejectSpeed = 75.0;
									waterGen.particleLifeSpan = 0.60;
									waterGen.numPerSpawn = 15;
									waterGen.bRandomEject = True;
									waterGen.particleTexture = Texture'Effects.Generated.WtrDrpSmall';
									waterGen.bTriggered = True;
									waterGen.bInitiallyOn = True;
									waterGen.LifeSpan = 1.1;
									waterGen.SetBase(splash);
								}
							}
						}
					}
	
				}

				else if(Region.Zone.bWaterZone)
				{
					if(!WaterZone(Region.Zone).bSurfaceLevelKnown && i < 1)
					{
						Spawn(class'Tracer',,, StartTrace, rot);
					}
					else if(WaterZone(Region.Zone).bSurfaceLevelKnown && Region.Zone.ExitActor != None)
					{
						EndTrace.Z = WaterZone(Region.Zone).SurfaceLevel;
						EndTrace.X = StartTrace.X + (Vector(rot).X * Abs( (EndTrace.Z - StartTrace.Z)/Vector(rot).Z ) );
						EndTrace.Y = StartTrace.Y + (Vector(rot).Y * Abs( (EndTrace.Z - StartTrace.Z)/Vector(rot).Z ) );
	
						splash = Spawn(Region.Zone.ExitActor,,, EndTrace); 
						if ( splash != None )
						{
							splash.DrawScale = 0.00001;
							splash.LifeSpan = 0.60;
							if(WaterRing(splash) != None)
								WaterRing(splash).bNoExtraRings = True;

							if(detLevel == "High")
							{
								waterGen = Spawn(class'ParticleGenerator', splash,, splash.Location, rot(16384,0,0));
								if (waterGen != None)
								{
									waterGen.particleDrawScale = 0.2;
									waterGen.checkTime = 0.05;
									waterGen.frequency = 1.0;
									waterGen.bGravity = True;
									waterGen.bScale = False;
									waterGen.bFade = True;
									waterGen.ejectSpeed = 75.0;
									waterGen.particleLifeSpan = 0.60;
									waterGen.numPerSpawn = 15;
									waterGen.bRandomEject = True;
									waterGen.particleTexture = Texture'Effects.Generated.WtrDrpSmall';
									waterGen.bTriggered = True;
									waterGen.bInitiallyOn = True;
									waterGen.LifeSpan = 1.1;
									waterGen.SetBase(splash);
								}
							}
						}	
					}
				}
			}
		}

		// check our range
		dist = Abs(VSize(HitLocation - Owner.Location));

		if (dist <= AccurateRange)		// we hit just fine
			ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
		else if (dist <= MaxRange)
		{
			// simulate gravity by lowering the bullet's hit point
			// based on the owner's distance from the ground
			alpha = (dist - AccurateRange) / (MaxRange - AccurateRange);
			degrade = 0.5 * Square(alpha);
			HitLocation.Z += degrade * (Owner.Location.Z - Owner.CollisionHeight);
			ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
		}
	}

	//== Make the laser sight jump a little so it moves from a different location
	ResetShake();

	// otherwise we don't hit the target at all
}

simulated function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local float        mult;
	local name         damageType;
	local DeusExPlayer dxPlayer;

	if (Other != None)
	{
		// AugCombat increases our damage if hand to hand
		mult = 1.0;
		if (bHandToHand && (DeusExPlayer(Owner) != None))
		{
			mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
			if (mult == -1.0)
				mult = 1.0;
		}

		// skill also affects our damage
		// GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
		mult += -2.0 * GetWeaponSkill();

		// Determine damage type
		damageType = WeaponDamageType();

		if(damageType == 'ShotSoft')
		{
			damageType = 'Shot';
			X = vect(0,0,0);
		}
		
		if (Other != None)
		{
			if (Other.bOwned)
			{
				dxPlayer = DeusExPlayer(Owner);
				if (dxPlayer != None)
					dxPlayer.AISendEvent('Futz', EAITYPE_Visual);
			}
		}
		if ((Other == Level) || (Other.IsA('Mover')))
		{
			if ( Role == ROLE_Authority )
				Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);

			SelectiveSpawnEffects( HitLocation, HitNormal, Other, HitDamage * mult);
		}
		else if ((Other != self) && (Other != Owner))
		{
			if ( Role == ROLE_Authority )
				Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);
			//if (bHandToHand) //Lork: Enable spawn effects for ranged weapons so we can hear the missing armor ricochet sound
				SelectiveSpawnEffects( HitLocation, HitNormal, Other, HitDamage * mult);

			if (bPenetrating && Other.IsA('Pawn') && !Other.IsA('Robot'))
				SpawnBlood(HitLocation, HitNormal);
		}
	}
   if (DeusExMPGame(Level.Game) != None)
   {
      if (DeusExPlayer(Other) != None)
         DeusExMPGame(Level.Game).TrackWeapon(self,HitDamage * mult);
      else
         DeusExMPGame(Level.Game).TrackWeapon(self,0);
   }
}

simulated function IdleFunction()
{
	PlayIdleAnim();
	bInProcess = False;
	if ( bFlameOn )
	{
		StopFlame();
		bFlameOn = False;
	}
}

simulated function SimFinish()
{
	ServerGotoFinishFire();

	bInProcess = False;
	bFiring = False;

	if ( bFlameOn )
	{
		StopFlame();
		bFlameOn = False;
	}

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
	{
		if ( (SimClipCount >= ReloadCount) && CanReload() )
		{
			SimClipCount = 0;
			bClientReadyToFire = False;
			bInProcess = False;
			if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
				CycleAmmo();
			ReloadAmmo();
		}
	}

	if (Pawn(Owner) == None)
	{
		GotoState('SimIdle');
		return;
	}
	if ( PlayerPawn(Owner) == None )
	{
		if ( (Pawn(Owner).bFire != 0) && (FRand() < RefireRate) )
			ClientReFire(0);
		else
			GotoState('SimIdle');
		return;
	}
	if ( Pawn(Owner).bFire != 0 )
		ClientReFire(0);
	else
		GotoState('SimIdle');
}

// Finish a firing sequence (ripped off and modified from Engine\Weapon.uc)
function Finish()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( True );
	
	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
		return;
	}

	if (( Level.NetMode != NM_Standalone ) && IsInState('Active'))
	{
		GotoState('Idle');
		return;
	}

	if (Pawn(Owner) == None)
	{
		GotoState('Idle');
		return;
	}
	if ( PlayerPawn(Owner) == None )
	{
		//bFireMem = false;
		//bAltFireMem = false;
		if ( ((AmmoType==None) || (AmmoType.AmmoAmount<=0)) && ReloadCount!=0 )
		{
			Pawn(Owner).StopFiring();
			Pawn(Owner).SwitchToBestWeapon();
		}
		else if ( (Pawn(Owner).bFire != 0) && (FRand() < RefireRate) )
			Global.Fire(0);
		else if ( (Pawn(Owner).bAltFire != 0) && (FRand() < AltRefireRate) )
			Global.AltFire(0);	
		else 
		{
			Pawn(Owner).StopFiring();
			GotoState('Idle');
		}
		return;
	}

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
		GotoState('Idle');
		return;
	}

	if ( ((AmmoType==None) || (AmmoType.AmmoAmount<=0)) || (Pawn(Owner).Weapon != self) )
		GotoState('Idle');
	else if ( /*bFireMem ||*/ Pawn(Owner).bFire!=0 )
		Global.Fire(0);
	else if ( /*bAltFireMem ||*/ Pawn(Owner).bAltFire!=0 )
		Global.AltFire(0);
	else 
		GotoState('Idle');
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInventoryInfoWindow winInfo;
	local string str;
	local int i, dmg;
	local float mod;
	local bool bHasAmmo;
	local bool bAmmoAvailable;
	local class<DeusExAmmo> ammoClass;
	local Pawn P;
	local Ammo weaponAmmo;
	local int  ammoAmount;
	
	//G-Flex: storing this makes the DTS change easier to manage here
	local int numSlugs;

	P = Pawn(Owner);
	if (P == None)
		return False;

	winInfo = PersonaInventoryInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
	winInfo.SetText(msgInfoWeaponStats);
	winInfo.AddLine();

	// Create the ammo buttons.  Start with the AmmoNames[] array,
	// which is used for weapons that can use more than one 
	// type of ammo.

	if (AmmoNames[0] != None)
	{
		for (i=0; i<ArrayCount(AmmoNames); i++)
		{
			if (AmmoNames[i] != None) 
			{
				// Check to make sure the player has this ammo type
				// *and* that the ammo isn't empty
				weaponAmmo = Ammo(P.FindInventoryType(AmmoNames[i]));

				if (weaponAmmo != None)
				{
					ammoAmount = weaponAmmo.AmmoAmount;
					bHasAmmo = (weaponAmmo.AmmoAmount > 0);
				}
				else
				{
					ammoAmount = 0;
					bHasAmmo = False;
				}

				winInfo.AddAmmo(AmmoNames[i], bHasAmmo, ammoAmount);
				bAmmoAvailable = True;

				if (AmmoNames[i] == AmmoName)
				{
					winInfo.SetLoaded(AmmoName);
					ammoClass = class<DeusExAmmo>(AmmoName);
				}
			}
		}
	}
	else
	{
		// Now peer at the AmmoName variable, but only if the AmmoNames[] 
		// array is empty
		if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		{	
			weaponAmmo = Ammo(P.FindInventoryType(AmmoName));

			if (weaponAmmo != None)
			{
				ammoAmount = weaponAmmo.AmmoAmount;
				bHasAmmo = (weaponAmmo.AmmoAmount > 0);
			}
			else
			{
				ammoAmount = 0;
				bHasAmmo = False;
			}

			winInfo.AddAmmo(AmmoName, bHasAmmo, ammoAmount);
			winInfo.SetLoaded(AmmoName);
			ammoClass = class<DeusExAmmo>(AmmoName);
			bAmmoAvailable = True;
		}
	}

	// Only draw another line if we actually displayed ammo.
	if (bAmmoAvailable)
		winInfo.AddLine();	

	// Ammo loaded
	if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		winInfo.AddAmmoLoadedItem(msgInfoAmmoLoaded, AmmoType.itemName);

	// ammo info
	if ((AmmoName == class'AmmoNone') || bHandToHand || (ReloadCount == 0))
		str = msgInfoNA;
	else
		str = AmmoName.Default.ItemName;
	for (i=0; i<ArrayCount(AmmoNames); i++)
		if ((AmmoNames[i] != None) && (AmmoNames[i] != AmmoName))
			str = str $ "|n" $ AmmoNames[i].Default.ItemName;

	winInfo.AddAmmoTypesItem(msgInfoAmmo, str);

	// base damage
	//G-Flex: account for change to number of DTS "slugs"
	//G-Flex: also clean up the code a bit in light of this
	if (AreaOfEffect == AOE_Cone)
	{
		if (bInstantHit)
		{
			if (String(Class.Name) == "WeaponNanoSword")
				numSlugs = 2;
			else
				numSlugs = 5;
		}
		else
		{
			numSlugs = 3;
		}
	}
	else
	{
		numSlugs = 1;
	}
	
	if (Level.NetMode != NM_Standalone)
		dmg = Default.mpHitDamage * numSlugs;
	else
		dmg = Default.HitDamage * numSlugs;

	str = String(dmg);
	mod = 1.0 - GetWeaponSkill();
	if (mod != 1.0)
	{
		str = str @ BuildPercentString(mod - 1.0);
		str = str @ "=" @ FormatFloatString(dmg * mod, 1.0);
	}

	winInfo.AddInfoItem(msgInfoDamage, str, (mod != 1.0));

	// clip size
	if ((Default.ReloadCount == 0) || bHandToHand)
		str = msgInfoNA;
	else
	{
		if ( Level.NetMode != NM_Standalone )
			str = Default.mpReloadCount @ msgInfoRounds;
		else
			str = Default.ReloadCount @ msgInfoRounds;
	}

	if (HasClipMod())
	{
		str = str @ BuildPercentString(ModReloadCount);
		str = str @ "=" @ ReloadCount @ msgInfoRounds;
	}

	winInfo.AddInfoItem(msgInfoClip, str, HasClipMod());

	// rate of fire
	if ((Default.ReloadCount == 0) || bHandToHand)
	{
		str = msgInfoNA;
	}
	else
	{
		if (bAutomatic)
			str = msgInfoAuto;
		else
			str = msgInfoSingle;

		str = str $ "," @ FormatFloatString(1.0/Default.ShotTime, 0.1) @ msgInfoRoundsPerSec;
	}
	winInfo.AddInfoItem(msgInfoROF, str);

	// reload time
	if ((Default.ReloadCount == 0) || bHandToHand)
		str = msgInfoNA;
	else
	{
		if (Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpReloadTime, 0.1) @ msgTimeUnit;
		else
			str = FormatFloatString(Default.ReloadTime, 0.1) @ msgTimeUnit;
	}

	if (HasReloadMod() || (GetWeaponSkill() < 0.0 && str != msgInfoNA))
	{
		str = str @ BuildPercentString(ModReloadTime + (GetWeaponSkill() * ReloadTime/Default.ReloadTime));
		str = str @ "=" @ FormatFloatString(ReloadTime * (1.0 + GetWeaponSkill()), 0.1) @ msgTimeUnit;
	}

	winInfo.AddInfoItem(msgInfoReload, str, (HasReloadMod() || (GetWeaponSkill() < 0.0 && (Default.ReloadCount > 0 && !bHandToHand))));

	// recoil
	str = FormatFloatString(Default.recoilStrength, 0.01);
	if (HasRecoilMod() || (GetWeaponSkill() < 0.0 && Default.recoilStrength > 0.0))
	{
		str = str @ BuildPercentString(ModRecoilStrength + (GetWeaponSkill() * 2.0 * recoilStrength/Default.recoilStrength));
		str = str @ "=" @ FormatFloatString(recoilStrength * (1.0 + (GetWeaponSkill() * 2.0)), 0.01);
	}

	winInfo.AddInfoItem(msgInfoRecoil, str, (HasRecoilMod() || (GetWeaponSkill() < 0.0 && Default.recoilStrength > 0.0)));

	// base accuracy (2.0 = 0%, 0.0 = 100%)
	if ( Level.NetMode != NM_Standalone )
	{
		str = Int((2.0 - Default.mpBaseAccuracy)*50.0) $ "%";
		mod = (Default.mpBaseAccuracy - (BaseAccuracy + GetWeaponSkill())) * 0.5;
		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - Default.mpBaseAccuracy)*50.0)) $ "%";
		}
	}
	else
	{
		str = Int((2.0 - Default.BaseAccuracy)*50.0) $ "%";
		mod = (Default.BaseAccuracy - (BaseAccuracy + GetWeaponSkill())) * 0.5;
		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - Default.BaseAccuracy)*50.0)) $ "%";
		}
	}
	winInfo.AddInfoItem(msgInfoAccuracy, str, (mod != 0.0));

	// accurate range
	if (bHandToHand)
		str = msgInfoNA;
	else
	{
		if ( Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpAccurateRange/16.0, 1.0) @ msgRangeUnit;
		else
			str = FormatFloatString(Default.AccurateRange/16.0, 1.0) @ msgRangeUnit;
	}

	if (HasRangeMod())
	{
		str = str @ BuildPercentString(ModAccurateRange);
		str = str @ "=" @ FormatFloatString(AccurateRange/16.0, 1.0) @ msgRangeUnit;
	}
	winInfo.AddInfoItem(msgInfoAccRange, str, HasRangeMod());

	// max range
	if (bHandToHand)
		str = msgInfoNA;
	else
	{
		if ( Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpMaxRange/16.0, 1.0) @ msgRangeUnit;
		else
			str = FormatFloatString(Default.MaxRange/16.0, 1.0) @ msgRangeUnit;
	}
	winInfo.AddInfoItem(msgInfoMaxRange, str);

	// mass
	winInfo.AddInfoItem(msgInfoMass, FormatFloatString(Default.Mass, 1.0) @ msgMassUnit);

	// laser mod
	if (bCanHaveLaser)
	{
		if (bHasLaser)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	winInfo.AddInfoItem(msgInfoLaser, str, bCanHaveLaser && bHasLaser && (Default.bHasLaser != bHasLaser));

	// scope mod
	if (bCanHaveScope)
	{
		if (bHasScope)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	winInfo.AddInfoItem(msgInfoScope, str, bCanHaveScope && bHasScope && (Default.bHasScope != bHasScope));

	// silencer mod
	if (bCanHaveSilencer)
	{
		if (bHasSilencer)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	winInfo.AddInfoItem(msgInfoSilencer, str, bCanHaveSilencer && bHasSilencer && (Default.bHasSilencer != bHasSilencer));

	// Governing Skill
	winInfo.AddInfoItem(msgInfoSkill, GoverningSkill.default.SkillName);

	winInfo.AddLine();
	winInfo.SetText(Description);

	// If this weapon has ammo info, display it here
	if (ammoClass != None)
	{
		winInfo.AddLine();
		winInfo.AddAmmoDescription(ammoClass.Default.ItemName $ "|n" $ ammoClass.Default.description);
	}

	return True;
}

// ----------------------------------------------------------------------
// UpdateAmmoInfo()
// ----------------------------------------------------------------------

simulated function UpdateAmmoInfo(Object winObject, Class<DeusExAmmo> ammoClass)
{
	local PersonaInventoryInfoWindow winInfo;
	local string str;
	local int i;

	winInfo = PersonaInventoryInfoWindow(winObject);
	if (winInfo == None)
		return;

	// Ammo loaded
	if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		winInfo.UpdateAmmoLoaded(AmmoType.itemName);

	// ammo info
	if ((AmmoName == class'AmmoNone') || bHandToHand || (ReloadCount == 0))
		str = msgInfoNA;
	else
		str = AmmoName.Default.ItemName;
	for (i=0; i<ArrayCount(AmmoNames); i++)
		if ((AmmoNames[i] != None) && (AmmoNames[i] != AmmoName))
			str = str $ "|n" $ AmmoNames[i].Default.ItemName;

	winInfo.UpdateAmmoTypes(str);

	// If this weapon has ammo info, display it here
	if (ammoClass != None)
		winInfo.UpdateAmmoDescription(ammoClass.Default.ItemName $ "|n" $ ammoClass.Default.description);
}

// ----------------------------------------------------------------------
// BuildPercentString()
// ----------------------------------------------------------------------

simulated final function String BuildPercentString(Float value)
{
	local string str;

	str = String(Int(Abs(value * 100.0)));
	if (value < 0.0)
		str = "-" $ str;
	else
		str = "+" $ str;

	return ("(" $ str $ "%)");
}

// ----------------------------------------------------------------------
// FormatFloatString()
// ----------------------------------------------------------------------

simulated function String FormatFloatString(float value, float precision)
{
	local string str;

	if (precision == 0.0)
		return "ERR";

	// build integer part
	str = String(Int(value));

	// build decimal part
	if (precision < 1.0)
	{
		value -= Int(value);
		str = str $ "." $ String(Int((0.5 * precision) + value * (1.0 / precision)));
	}

	return str;
}

// ----------------------------------------------------------------------
// CR()
// ----------------------------------------------------------------------

simulated function String CR()
{
	return Chr(13) $ Chr(10);
}

// ----------------------------------------------------------------------
// HasReloadMod()
// ----------------------------------------------------------------------

simulated function bool HasReloadMod()
{
	return (ModReloadTime != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxReloadMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxReloadMod()
{
	return (ModReloadTime == -0.5);
}

// ----------------------------------------------------------------------
// HasClipMod()
// ----------------------------------------------------------------------

simulated function bool HasClipMod()
{
	return (ModReloadCount != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxClipMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxClipMod()
{
	return (ModReloadCount == 0.5);
}

// ----------------------------------------------------------------------
// HasRangeMod()
// ----------------------------------------------------------------------

simulated function bool HasRangeMod()
{
	return (ModAccurateRange != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxRangeMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxRangeMod()
{
	return (ModAccurateRange == 0.5);
}

// ----------------------------------------------------------------------
// HasAccuracyMod()
// ----------------------------------------------------------------------

simulated function bool HasAccuracyMod()
{
	return (ModBaseAccuracy != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxAccuracyMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxAccuracyMod()
{
	return (ModBaseAccuracy == 0.5);
}

// ----------------------------------------------------------------------
// HasRecoilMod()
// ----------------------------------------------------------------------

simulated function bool HasRecoilMod()
{
	return (ModRecoilStrength != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxRecoilMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxRecoilMod()
{
	return (ModRecoilStrength == -0.5);
}

// ----------------------------------------------------------------------
// ClientDownWeapon()
// ----------------------------------------------------------------------

simulated function ClientDownWeapon()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimDownWeapon');
}

simulated function ClientActive()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimActive');
}

simulated function ClientReload()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimReload');
}

//
// weapon states
//

state NormalFire
{
	function AnimEnd()
	{
		if (bAutomatic)
		{
			if ((Pawn(Owner).bFire != 0) && (AmmoType.AmmoAmount > 0))
			{
				if (PlayerPawn(Owner) != None)
					Global.Fire(0);
				else 
					GotoState('FinishFire');
			}
			else 
				GotoState('FinishFire');
		}
		else
		{
			// if we are a thrown weapon and we run out of ammo, destroy the weapon
			if (bHandToHand && (ReloadCount > 0) && (AmmoType.AmmoAmount <= 0))
				Destroy();
		}
	}
	function float GetShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
			}
			sTime = ShotTime * mult;
			return (sTime);
		}
	}

Begin:
	//G-Flex: lower standing timer to compensate for gain during fire
	if (Owner.IsA('DeusExPlayer'))
		StandingTimer = FMax(0,StandingTimer - GetShotTime());
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		if (!bAutomatic)
		{
			bFiring = False;
			FinishAnim();
		}

		if (Owner != None)
		{
			if (Owner.IsA('DeusExPlayer'))
			{
				bFiring = False;

				// should we autoreload?
				if (DeusExPlayer(Owner).bAutoReload)
				{
					// auto switch ammo if we're out of ammo and
					// we're not using the primary ammo
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();
					ReloadAmmo();
				}
				else
				{
					if (bHasMuzzleFlash)
						EraseMuzzleFlashTexture();
					GotoState('Idle');
				}
			}
			else if (Owner.IsA('ScriptedPawn'))
			{
				bFiring = False;
				ReloadAmmo();
			}
		}
		else
		{
			if (bHasMuzzleFlash)
				EraseMuzzleFlashTexture();
			GotoState('Idle');
		}
	}
	if ( bAutomatic && (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient())))
		GotoState('Idle');

	Sleep(GetShotTime());
	if (bAutomatic)
	{
		GenerateBullet();	// In multiplayer bullets are generated by the client which will let the server know when
		Goto('Begin');
	}
	bFiring = False;
	FinishAnim();

	// if ReloadCount is 0 and we're not hand to hand, then this is a
	// single-use weapon so destroy it after firing once
	if ((ReloadCount == 0) && !bHandToHand)
	{
		if (DeusExPlayer(Owner) != None)
			DeusExPlayer(Owner).RemoveItemFromSlot(Self);   // remove it from the inventory grid
		Destroy();
	}
	ReadyToFire();
Done:
	bFiring = False;
	Finish();
}

state FinishFire
{
Begin:
	bFiring = False;
	if ( bDestroyOnFinish )
		Destroy();
	else
		Finish();
}

state Pickup
{
	function BeginState()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);

		Super.BeginState();
	}
}

state Reload
{
ignores Fire, AltFire;

	function float GetReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player
			val = GetWeaponSkill();
			val = ReloadTime + (val*ReloadTime);
		}

		return val;
	}

	function NotifyOwner(bool bStart)
	{
		local DeusExPlayer player;
		local ScriptedPawn pawn;

		player = DeusExPlayer(Owner);
		pawn   = ScriptedPawn(Owner);

		if (player != None)
		{
			if (bStart)
				player.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
			{
				player.DoneReloading(self);
			}
		}
		else if (pawn != None)
		{
			if (bStart)
				pawn.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
				pawn.DoneReloading(self);
		}
	}

Begin:
	FinishAnim();

	// only reload if we have ammo left
	if (AmmoType.AmmoAmount > 0)
	{
		if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		{
			ClientReload();
			Sleep(GetReloadTime());
			ReadyClientToFire( True );
		}
		else
		{
			//G-Flex: modified as in shifter
			bWasZoomed = False;
			if (bZoomed)
			{
				ScopeOff();
				bWasZoomed = True;
			}
			//G-Flex: lower standing timer when reloading
			//if (Owner.IsA('DeusExPlayer'))
			//	StandingTimer *= 0.5;
			Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin
			PlayAnim('ReloadBegin');
			NotifyOwner(True);
			FinishAnim();
			LoopAnim('Reload');
			Sleep(GetReloadTime());
			Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
			PlayAnim('ReloadEnd');
			FinishAnim();
			NotifyOwner(False);

			if (bWasZoomed)
				ScopeOn();
			ResetShake();

			ClipCount = 0;
		}
	}
	GotoState('Idle');
}

simulated state ClientFiring
{
	simulated function AnimEnd()
	{
		bInProcess = False;

		if (bAutomatic)
		{
			if ((Pawn(Owner).bFire != 0) && (AmmoType.AmmoAmount > 0))
			{
				if (PlayerPawn(Owner) != None)
					ClientReFire(0);
				else
					GotoState('SimFinishFire');
			}
			else 
				GotoState('SimFinishFire');
		}
	}
	simulated function float GetSimShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
			}
			sTime = ShotTime * mult;
			return (sTime);
		}
	}
Begin:
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		if (!bAutomatic)
		{
			bFiring = False;
			FinishAnim();
		}
		if (Owner != None)
		{
			if (Owner.IsA('DeusExPlayer'))
			{
				bFiring = False;
				if (DeusExPlayer(Owner).bAutoReload)
				{
					bClientReadyToFire = False;
					bInProcess = False;
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();
					ReloadAmmo();
					GotoState('SimQuickFinish');
				}
				else
				{
					if (bHasMuzzleFlash)
						EraseMuzzleFlashTexture();
					IdleFunction();
					GotoState('SimQuickFinish');
				}
			}
			else if (Owner.IsA('ScriptedPawn'))
			{
				bFiring = False;
			}
		}
		else
		{
			if (bHasMuzzleFlash)
				EraseMuzzleFlashTexture();
			IdleFunction();
			GotoState('SimQuickFinish');
		}
	}
	Sleep(GetSimShotTime());
	if (bAutomatic)
	{
		SimGenerateBullet();
		Goto('Begin');
	}
	bFiring = False;
	FinishAnim();
	bInProcess = False;
Done:
	bInProcess = False;
	bFiring = False;
	SimFinish();
}

simulated state SimQuickFinish
{
Begin:
	if ( IsAnimating() && (AnimSequence == 'Shoot') )
		FinishAnim();

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	bInProcess = False;
	bFiring=False;
}

simulated state SimIdle
{
	function Timer()
	{
		PlayIdleAnim();
	}
Begin:
	bInProcess = False;
	bFiring = False;
	if (!bNearWall)
		PlayAnim('Idle1',,0.1);
	SetTimer(3.0, True);
}


simulated state SimFinishFire
{
Begin:
	FinishAnim();

	if ( PlayerPawn(Owner) != None )
		PlayerPawn(Owner).FinishAnim();

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	bInProcess = False;
	bFiring=False;
	SimFinish();
}

simulated state SimDownweapon
{
ignores Fire, AltFire, ClientFire, ClientReFire;

Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;
	TweenDown();
	FinishAnim();
}

simulated state SimActive
{
Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;
	PlayAnim('Select',1.0,0.0);
	FinishAnim();
	SimFinish();
}

simulated state SimReload
{
ignores Fire, AltFire, ClientFire, ClientReFire;

	simulated function float GetSimReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player
			val = GetWeaponSkill();
			val = ReloadTime + (val*ReloadTime);
		}
		return val;
	}
Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;

	bWasZoomed = False;
	if (bZoomed)
	{
		ScopeOff();
		bWasZoomed = True;
	}

	Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin
	PlayAnim('ReloadBegin');
	FinishAnim();
	LoopAnim('Reload');
	Sleep(GetSimReloadTime());
	Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
	ServerDoneReloading();
	PlayAnim('ReloadEnd');
	FinishAnim();

	if (bWasZoomed)
		ScopeOn();

	GotoState('SimIdle');
}


state Idle
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);

		return Super.PutDown();
	}

	function AnimEnd()
	{
	}

	function Timer()
	{
		PlayIdleAnim();
	}

Begin:
	bFiring = False;
	ReadyToFire();

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
	}
	else
	{
		if (!bNearWall)
			PlayAnim('Idle1',,0.1);
		SetTimer(3.0, True);
	}
}

state FlameThrowerOn
{
	function float GetShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
			}
			sTime = ShotTime * mult;
			return (sTime);
		}
	}
Begin:
	if ( (DeusExPlayer(Owner).Health > 0) && bFlameOn && (ClipCount < ReloadCount))
	{
		if (( flameShotCount == 0 ) && (Owner != None))
		{
			PlayerPawn(Owner).PlayFiring();
			PlaySelectiveFiring();
			PlayFiringSound();
			flameShotCount = 6;
		}
		else
			flameShotCount--;

		Sleep( GetShotTime() );
		GenerateBullet();
		goto('Begin');
	}
Done:
	bFlameOn = False;
	GotoState('FinishFire');
}

state Active
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		return Super.PutDown();
	}

Begin:
	// Rely on client to fire if we are a multiplayer client

	if ( (Level.NetMode==NM_Standalone) || (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
		bClientReady = True;
	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
		ClientActive();
		bClientReady = False;
	}

	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();
	if ( bChangeWeapon )
		GotoState('DownWeapon');

	bWeaponUp = True;
	PlayPostSelect();
	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();
	// reload the weapon if it's empty and autoreload is true
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		if (Owner.IsA('ScriptedPawn') || ((DeusExPlayer(Owner) != None) && DeusExPlayer(Owner).bAutoReload))
			ReloadAmmo();
	}
	Finish();
}


state DownWeapon
{
ignores Fire, AltFire;

	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		return Super.PutDown();
	}

Begin:
   ScopeOff();
	LaserOff();

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		ClientDownWeapon();

	TweenDown();
	FinishAnim();

	if ( Level.NetMode != NM_Standalone )
	{
		ClipCount = 0;	// Auto-reload in multiplayer (when putting away)
	}
	bOnlyOwnerSee = false;
	if (Pawn(Owner) != None)
		Pawn(Owner).ChangedWeapon();
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return ((BeltSpot <= 3) && (BeltSpot >= 1));
}

defaultproperties
{
     bReadyToFire=True
     LowAmmoWaterMark=10
     NoiseLevel=1.000000
     ShotTime=0.500000
     reloadTime=1.000000
     HitDamage=10
     maxRange=9600
     AccurateRange=4800
     BaseAccuracy=0.500000
     ScopeFOV=10
     MaintainLockTimer=1.000000
     bPenetrating=True
     bHasMuzzleFlash=True
     bEmitWeaponDrawn=True
     bUseWhileCrouched=True
     bUseAsDrawnWeapon=True
     MinSpreadAcc=0.250000
     MinProjSpreadAcc=1.000000
     bNeedToSetMPPickupAmmo=True
     msgCannotBeReloaded="This weapon can't be reloaded"
     msgOutOf="Out of %s"
     msgNowHas="%s now has %s loaded"
     msgAlreadyHas="%s already has %s loaded"
     msgNone="NONE"
     msgLockInvalid="INVALID"
     msgLockRange="RANGE"
     msgLockAcquire="ACQUIRE"
     msgLockLocked="LOCKED"
     msgRangeUnit="FT"
     msgTimeUnit="SEC"
     msgMassUnit="LBS"
     msgNotWorking="This weapon doesn't work underwater"
     msgInfoAmmoLoaded="Ammo loaded:"
     msgInfoAmmo="Ammo type(s):"
     msgInfoDamage="Base damage:"
     msgInfoClip="Clip size:"
     msgInfoROF="Rate of fire:"
     msgInfoReload="Reload time:"
     msgInfoRecoil="Recoil:"
     msgInfoAccuracy="Base Accuracy:"
     msgInfoAccRange="Acc. range:"
     msgInfoMaxRange="Max. range:"
     msgInfoMass="Mass:"
     msgInfoLaser="Laser sight:"
     msgInfoScope="Scope:"
     msgInfoSilencer="Silencer:"
     msgInfoNA="N/A"
     msgInfoYes="YES"
     msgInfoNo="NO"
     msgInfoAuto="AUTO"
     msgInfoSingle="SINGLE"
     msgInfoRounds="RDS"
     msgInfoRoundsPerSec="RDS/SEC"
     msgInfoSkill="Skill:"
     msgInfoWeaponStats="Weapon Stats:"
     ReloadCount=10
     shakevert=10.000000
     Misc1Sound=Sound'DeusExSounds.Generic.DryFire'
     AutoSwitchPriority=0
     bRotatingPickup=False
     PickupMessage="You found"
     ItemName="DEFAULT WEAPON NAME - REPORT THIS AS A BUG"
     LandSound=Sound'DeusExSounds.Generic.DropSmallWeapon'
     bNoSmooth=False
     Mass=10.000000
     Buoyancy=5.000000
}
