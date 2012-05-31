//=============================================================================
// WeaponShrinkGun.
//=============================================================================
class WeaponShrinkGun extends DeusExWeapon;

//G-Flex: constant accuracy
simulated function float CalculateAccuracy()
{
	return BaseAccuracy;
}

//G-Flex: overloaded for heart-shaped spread
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
	local float firePitch, fireYaw, fireRotationAngle, fireAccuracy;
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

	numSlugs = 1;
	
	if (bLasing || bZoomed)
		Accuracy = 0.0;
		
	if(DeusExPlayer(GetPlayerPawn()) != None)
		detLevel = DeusExPlayer(GetPlayerPawn()).ConsoleCommand("get ini:Engine.Engine.ViewportManager TextureDetail");

	if(bLasing && (Emitter != None))
	{
		aimRot = Emitter.Rotation;
	}
	
	//G-Flex: now determine where all the shots hit
	for (i=0; i<numSlugs; i++)
	{
		aimRot = AdjustedAim;
		/*//fireAccuracy = Accuracy * (Rand(3072) - 1536);
		fireAccuracy = Accuracy * 1536;
		fireRotationAngle = FRand() * 2.0 * pi;
		//G-Flex: use parametric equations for heart shape, normalize radius
		fireYaw = 16.0*(sin(fireRotationAngle)**3);
		//DeusExPlayer(GetPlayerPawn()).ClientMessage(Sprintf("Yaw: ",fireYaw));
		fireYaw *= fireAccuracy / 16.0;
		fireYaw *= 1 + (0.2 * (FRand() - 0.5));
		firePitch = 13*cos(fireRotationAngle) - 5.0*cos(2.0*fireRotationAngle) - 2.0*cos(3.0*fireRotationAngle) - cos(4.0*fireRotationAngle);
		//DeusExPlayer(GetPlayerPawn()).ClientMessage(Sprintf("Pitch: ",firePitch));
		firePitch *= fireAccuracy / 15.0;
		firePitch *= 1 + (0.2 * (FRand() - 0.5));
		
		aimRot.Yaw += fireYaw;
		aimRot.Pitch += firePitch;*/
		
		rot = aimRot;
		
		EndTrace = StartTrace + ( FMax(1024.0, MaxRange) * vector(rot) );
		
		Other = Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
		
		ShrinkIt(Other);

		rot = Rotator(EndTrace - StartTrace);

		// check our range
		dist = Abs(VSize(HitLocation - Owner.Location));

		if (dist <= MaxRange)		// we hit just fine
			ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
	}

	//== Make the laser sight jump a little so it moves from a different location
	ResetShake();

	// otherwise we don't hit the target at all
}

function ShrinkIt(actor Other)
{
	local EllipseEffect shield;
	
	if (Other == None)
		return;

	
	if(Other != Level && !Other.bStatic && !Other.IsA('DeusExMover') && ((Other.Default.CollisionRadius / Other.CollisionRadius) <= 3.9))
	{
		shield = Spawn(class'EllipseEffect', Other,, Other.Location, Other.Rotation);
		if (shield != None)
			shield.SetBase(Other);
		Other.SetCollisionSize(Other.CollisionRadius / 2.0, Other.CollisionHeight / 2.0);
		//Other.CollisionRadius = (Other.CollisionRadius / 2.0);
		//Other.CollisionHeight = (Other.CollisionHeight / 2.0);
		Other.DrawScale = (Other.DrawScale / 2.0);
		Other.Mass = (Other.Mass / 8.0);
		SetPhysics(PHYS_Falling);
		
		if (Other.IsA('Pawn'))
		{
			Pawn(Other).BaseEyeHeight = (Pawn(Other).BaseEyeHeight / 2.0);
			if (Other.IsA('ScriptedPawn'))
			{
				ScriptedPawn(Other).JumpZ = (ScriptedPawn(Other).JumpZ / 1.25);
				ScriptedPawn(Other).GroundSpeed = (ScriptedPawn(Other).GroundSpeed / 1.25);
				ScriptedPawn(Other).WalkingSpeed = (ScriptedPawn(Other).WalkingSpeed / 1.25);
				ScriptedPawn(Other).bCanSit = False;
				ScriptedPawn(Other).bCanCrouch = False;
			}
		}
		//Other.Move(vect(0,0,-1) * Other.CollisionHeight);
	}
	
}

defaultproperties
{
     StunDuration=10.000000
     bInstantHit=True
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.010000
     Concealability=CONC_All
     ShotTime=0.300000
     HitDamage=1
     maxRange=24000
     AccurateRange=14400
     BaseAccuracy=0.000000
     bHasMuzzleFlash=False
     bEmitWeaponDrawn=False
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
	 bAutomatic=True
     //PickupAmmoCount=0
	 reloadTime=4.500000
     FireOffset=(X=-20.000000,Y=10.000000,Z=16.000000)
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Generic.BioElectricHiss'
     SelectSound=Sound'DeusExSounds.Weapons.HideAGunSelect'
	 ItemArticle="the incredible"
     ItemName="Shrinking Ray"
     PlayerViewOffset=(X=20.000000,Y=-10.000000,Z=-16.000000)
     PlayerViewMesh=LodMesh'DeusExItems.HideAGun'
     PickupViewMesh=LodMesh'DeusExItems.HideAGunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.HideAGun3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconHideAGun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconHideAGun'
     largeIconWidth=29
     largeIconHeight=47
     Description="Back off! I've got a shrink gun. Who touched my ankle? Gun! Do you think I don't see? You don't think I feel your eyes like grubby little fingers, little children's fingers on my body? Back off! I will make you teensy."
     beltDescription="SHRINKRAY"
     Mesh=LodMesh'DeusExItems.HideAGunPickup'
     CollisionRadius=3.300000
     CollisionHeight=0.600000
     Mass=5.000000
     Buoyancy=2.000000
}
