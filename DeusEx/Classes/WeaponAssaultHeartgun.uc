//=============================================================================
// WeaponAssaultHeartgun.
//=============================================================================
class WeaponAssaultHeartgun extends DeusExWeapon;

function name WeaponDamageType()
{
	if (FRand() < 0.05)
		return 'TearGas';
	else
		return 'KnockedOut';
}

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

	numSlugs = 12;
	
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
		//fireAccuracy = Accuracy * (Rand(3072) - 1536);
		fireAccuracy = Accuracy * 1920;
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
		aimRot.Pitch += firePitch;
		
		rot = aimRot;
		
		EndTrace = StartTrace + ( FMax(1024.0, MaxRange) * vector(rot) );
		
		Other = Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);

		rot = Rotator(EndTrace - StartTrace);

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

state NormalFire
{
	function AnimEnd()
	{
		if (bAutomatic)
		{
			if (Pawn(Owner).bFire != 0)
			{
				if (PlayerPawn(Owner) != None)
					Global.Fire(0);
				else 
					GotoState('FinishFire');
			}
			else 
				GotoState('FinishFire');
		}
	}
}

defaultproperties
{
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     EnviroEffective=ENVEFF_Air
     bAutomatic=True
     ShotTime=0.700000
     reloadTime=4.500000
     HitDamage=1
     maxRange=4800
     AccurateRange=2400
     BaseAccuracy=0.550000
     //AmmoNames(0)=Class'DeusEx.AmmoShell'
     //AmmoNames(1)=Class'DeusEx.AmmoSabot'
	 AmmoName=Class'DeusEx.AmmoNone'
     AreaOfEffect=AOE_Cone
     recoilStrength=0.000000
     //mpReloadTime=0.500000
     //mpHitDamage=5
     //mpBaseAccuracy=0.200000
     //mpAccurateRange=1800
     //mpMaxRange=1800
     //mpReloadCount=12
     //bCanHaveModReloadCount=True
     //bCanHaveModReloadTime=True
     //bCanHaveModRecoilStrength=True
     //AmmoName=Class'DeusEx.AmmoShell'
     //ReloadCount=12
     //PickupAmmoCount=12
	 ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-30.000000,Y=10.000000,Z=12.000000)
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Weapons.AssaultShotgunFire'
     AltFireSound=Sound'DeusExSounds.Weapons.AssaultShotgunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.AssaultShotgunReload'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultShotgunSelect'
     InventoryGroup=7
     ItemName="Assault Heartgun"
     ItemArticle="the one-of-a-kind"
     PlayerViewOffset=(Y=-10.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.AssaultShotgun'
     PickupViewMesh=LodMesh'DeusExItems.AssaultShotgunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.AssaultShotgun3rd'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconAssaultShotgun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAssaultShotgun'
     largeIconWidth=99
     largeIconHeight=55
     invSlotsX=2
     invSlotsY=2
     Description="When a man's an empty kettle|nHe should be on his mettle|nAnd yet I'm torn apart|nJust because I'm presumin'|nThat I could be a human|nIf I only had a heart"
     beltDescription="HEARTGUN"
     Mesh=LodMesh'DeusExItems.AssaultShotgunPickup'
     CollisionRadius=15.000000
     CollisionHeight=8.000000
     Mass=15.000000
	 LightType=LT_Pulse
     LightEffect=LE_WateryShimmer
     LightBrightness=224
     LightHue=240
     LightSaturation=130
     LightRadius=4
}
