//=============================================================================
// Tools
// (by G-Flex)
//
// For functions used by multiple classes
// note: this should ideally stay abstract with static functions only
//=============================================================================
class Tools extends ExtensionObject
	abstract;

const ModVersion = "Day Mon DD YYYY Human Renovation v3.0b";
const DegreeToRadian = 0.017453292519943;
const RadianToDegree = 57.29577951308232;
const URotToRadian = 0;//fill in later
const RadianToURot = 0;//fill in later
const DegreeToURot = 0;//fill in later
const URotToDegree = 0;//fill in later
const DefaultHFOV = 75.0000000000000; //at 4:3
const DefaultVFOV = 59.8404440089854335; //should always be this!
const DefaultAspect = 1.3333333333333333; //4:3

// ----------------------------------------------------------------------
// GetDeusExModVersion()
//
// Like DeusExPlayer.GetDeusExVersion(), but for the mod package used
// Please update the string if you make your own changes!!
// ----------------------------------------------------------------------

final static function string GetDeusExModVersion()
{
	//G-Flex: find a way to get the compile date/time?
	return(ModVersion);
}

// ----------------------------------------------------------------------
// Ceiling()
//
// Rounds up to the nearest integer
// ----------------------------------------------------------------------

final static function int Ceiling(float num)
{
	if (int(num) < num)
		return(int(num) + 1);
	else
		return(int(num));
}

// ----------------------------------------------------------------------
// Floor()
//
// Rounds down to the nearest integer
// ----------------------------------------------------------------------

final static function int Floor(float num)
{
	return(int(num));
}

// ----------------------------------------------------------------------
// ScaledSoundRadius()
//
// For scaling a sound's radius with difficulty
// ----------------------------------------------------------------------

final static function float ScaledSoundRadius(float radius, float diff)
{
	diff = sqrt(diff);
	
	//1.0500, 1.2073, 1.3399, 1.7500 
	radius *= (0.500000 + diff)*0.700000;
	
	return(radius);
}

// ----------------------------------------------------------------------
// VFOVtoHFOV()
//
// Determines horizontal FOV angle from vertical angle and aspect ratio
// Parameters and return value are in degrees
// ----------------------------------------------------------------------

final static function float VFOVtoHFOV(float vFOV, float aspect)
{
	if ((vFOV >= 180.0) || (aspect <= 0.0))
	{
		log("Invalid parameters passed to VFOVtoHFOV()",'ScriptWarning');
		return -1;
	}
	return(RadianToDegree * 2.00 * atan(tan(DegreeToRadian * vFOV/2.00) * aspect));	
}

// ----------------------------------------------------------------------
// HFOVtoVFOV()
//
// G-Flex: Other way around now.
// ----------------------------------------------------------------------

final static function float HFOVtoVFOV(float hFOV, float aspect)
{
	if ((hFOV >= 180.0) || (aspect <= 0.0))
	{
		log("Invalid parameters passed to HFOVtoVFOV()",'ScriptWarning');
		return -1;
	}
	return(RadianToDegree * 2.00 * atan(tan(DegreeToRadian * hFOV/2.00) / aspect));	
}

// ----------------------------------------------------------------------
// AspectCorrectHFOV()
//
// Takes a given hFOV and current aspect ratio
// and returns an hFOV in a new aspect ratio with equivalent vFOV
// ----------------------------------------------------------------------

final static function float AspectCorrectHFOV(float hFOV, float oldAspect, float newAspect)
{
	if ((hFOV >= 180.0) || (oldAspect <= 0.0) || (newAspect <= 0.0))
	{
		log("Invalid parameters passed to AspectCorrectHFOV()",'ScriptWarning');
		return -1;
	}

	//unsimplified: 2.00 * atan(tan((2.00 * atan(tan(hFOV/2.00) / oldAspect))/2.00) * newAspect);
	return(RadianToDegree * 2.00 * atan(tan(DegreeToRadian * hFOV/2.00) * newAspect/oldAspect));
}

// ----------------------------------------------------------------------
// AspectCorrectVFOV()
//
// Like above but for vertical FOV angles
// note that you probably will not need this one.
// ----------------------------------------------------------------------

final static function float AspectCorrectVFOV(float vFOV, float oldAspect, float newAspect)
{
	if ((vFOV >= 180.0) || (oldAspect <= 0.0) || (newAspect <= 0.0))
	{
		log("Invalid parameters passed to AspectCorrectVFOV()",'ScriptWarning');
		return -1;
	}
	return(RadianToDegree * 2.00 * atan(tan(DegreeToRadian * vFOV/2.00) * oldAspect/newAspect));
}

// ----------------------------------------------------------------------
// TraceBox()
//
// Trace a cube's center and a point on each corner/edge/face
// and return true if any isn't impeded by actors that aren't the target
// ----------------------------------------------------------------------

final static function bool TraceBox(actor Target, vector StartTrace, vector EndOrigin, float dist)
{
	local vector HitLocation, HitNormal, EndDir;
	local actor Actor;
	local int x, y, z;

	EndDir = Vect(0,0,0);
	for (x = -1; x < 2; x++)
	{
		EndDir.X = x;
		for (y = -1; y < 2; y++)
		{
			EndDir.Y = y;
			for (z = -1; z < 2; z++)
			{
				EndDir.Z = z;
				Actor = Target.Trace(HitLocation, HitNormal, EndOrigin + (dist * EndDir), StartTrace);
				if ((Actor == None) || (Actor == Target))
					return(true);
			}
		}
	}
	return(false);
}

// ----------------------------------------------------------------------
// FastTraceBox()
//
// Like TraceBox(), but uses FastTrace() instead
// so it's a bit simpler and faster
// ----------------------------------------------------------------------

final static function bool FastTraceBox(actor Target, vector StartTrace, vector EndOrigin, float dist)
{
	local vector EndDir;
	local int x, y, z;

	EndDir = Vect(0,0,0);
	for (x = -1; x < 2; x++)
	{
		EndDir.X = x;
		for (y = -1; y < 2; y++)
		{
			EndDir.Y = y;
			for (z = -1; z < 2; z++)
			{
				EndDir.Z = z;
				if (Target.FastTrace(EndOrigin + (dist * EndDir), StartTrace));
					return(true);
			}
		}
	}
	return(false);
}

// ----------------------------------------------------------------------
// NewHurtRadius()
//
// Like HurtRadius() but with special modifications. Wow!
// Movers no longer get hurt through solid walls
// both movers and other things get hurt around corners and stuff
// breakable pickups like beer bottles also can break now
// ----------------------------------------------------------------------

final static function NewHurtRadius(actor CallingActor, float DamageAmount, float DamageRadius, name DamageName, float Momentum, vector HitLocation, vector HitNormal, optional bool bIgnoreLOS )
{
	local actor Victims, otherVictim;
	local float damageScale, dist;
	local vector dir;

	//G-Flex: for new checks
	local bool bHurtIt;
	local Vector HitLoc, HitNorm, StartTrace, EndTrace, CheckPoint;
	local int i, j, x, y, z, iterations;
	local float DamageRadiusAdj, DistanceMult;
	
	if(CallingActor.bHurtEntry)
		return;

	CallingActor.bHurtEntry = true;
   if (bIgnoreLOS)
   {
      foreach CallingActor.RadiusActors(class 'Actor', Victims, DamageRadius, HitLocation )
      {
		 if (Victims.bHidden || Victims.bStatic || Victims.bDeleteMe
		  || Victims.IsA('Decal') || Victims.IsA('Effects')
		  || (Victims.IsA('DeusExFragment') && DeusExFragment(Victims).bInvincible)
		  || (Victims.IsA('DeusExDecoration') && DeusExDecoration(Victims).bInvincible)
		  || Victims.IsA('Weapon') || Victims.IsA('Ammo')
		  || (Victims.IsA('DeusExMover') && !DeusExMover(Victims).bBreakable)
		  || (Victims.IsA('DeusExPickup') && !DeusExPickup(Victims).bBreakable))
			continue;
         if(Victims != CallingActor)
         {
			if (Victims.IsA('DeusExPickup'))
			{
				DeusExPickup(Victims).BreakItSmashIt(DeusExPickup(Victims).fragType,
				 (DeusExPickup(Victims).CollisionRadius + DeusExPickup(Victims).CollisionHeight) / 2);
			}
            else
			{
				dir = Victims.Location - HitLocation;
				dist = FMax(1,VSize(dir));
				dir = dir/dist; 
				damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
				Victims.TakeDamage
				(
				   damageScale * DamageAmount,
				   CallingActor.Instigator, 
				   Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				   (damageScale * Momentum * dir),
				   DamageName
				);
			}
         } 
      }
   }
 
   else
   {
		//G-Flex: debug debug
		if (CallingActor == None)
			log("NO CALLING ACTOR!");
		foreach CallingActor.RadiusActors(class 'Actor', Victims, DamageRadius, HitLocation)
		{
			if(Victims != CallingActor)
			{
				//G-Flex: don't bother with things that can't be harmed anyway
				if (Victims.bHidden || Victims.bStatic || Victims.bDeleteMe
				 || Victims.IsA('Decal') || Victims.IsA('Effects')
				 || (Victims.IsA('DeusExFragment') && DeusExFragment(Victims).bInvincible)
				 || (Victims.IsA('DeusExDecoration') && DeusExDecoration(Victims).bInvincible)
				 || Victims.IsA('Weapon') || Victims.IsA('Ammo')
				 || (Victims.IsA('DeusExMover') && !DeusExMover(Victims).bBreakable)
				 || (Victims.IsA('DeusExPickup') && !DeusExPickup(Victims).bBreakable))
					continue;
				bHurtIt = false;
				//G-Flex: try to trace out to multiple spots near the actor's origin
				//G-Flex: also smash some bottles and stuff through walls to start
				if ((Victims.IsA('DeusExPickup') && (FRand() < 0.4))
				 || TraceBox(Victims, HitLocation, Victims.Location, (2.0 * iterations)))
					bHurtIt = true;
				//G-Flex: if that doesn't work, do more traces
				else
				{
					//G-Flex: be more permissive with movers since the game was already
					if (Victims.IsA('Mover'))
						iterations = 4;
					else
						iterations = 2;
					for (i = 0; i < iterations; i++)
					{
						if (bHurtIt)
							break;
						//G-Flex: 1.5, 3.0, 7.5
						if (i < 3)
							DistanceMult = 1.5 + (i^2);
						else
							DistanceMult = 7.5;
						CheckPoint = HitLocation;
					
						for (j = 0; j < 10; j++)
						{
							if (bHurtIt)
								break;
							DamageRadiusAdj = DamageRadius;
							StartTrace = HitLocation;
							if (j > 0)
							{
								StartTrace += HitNormal * (2.5 * sqrt(DistanceMult) * sqrt(DamageRadius));
								DamageRadiusAdj *= 2.0;
								if (j > 1)
								{
									if (j == 2)
									{
										StartTrace += ((DistanceMult*sqrt(DamageRadius)) * Vect(0.0,1.0,0.0)) << Rotator(HitNormal);
									}
									else if (j == 3)
									{
										StartTrace += ((DistanceMult*sqrt(DamageRadius)) * Vect(0.0,-1.0,0.0)) << Rotator(HitNormal);
									}
									else if (j == 4)
									{
										StartTrace += ((DistanceMult*sqrt(DamageRadius)) * Vect(0.0,0.0,1.0)) << Rotator(HitNormal);
									}
									else if (j == 5)
									{
										StartTrace += ((DistanceMult*sqrt(DamageRadius)) * Vect(0.0,0.0,-1.0)) << Rotator(HitNormal);
									}
									else if (j == 6)
									{
										StartTrace += ((DistanceMult*sqrt(DamageRadius)) * Vect(0.0,1.0,1.0)) << Rotator(HitNormal);
									}
									else if (j == 7)
									{
										StartTrace += ((DistanceMult*sqrt(DamageRadius)) * Vect(0.0,1.0,-1.0)) << Rotator(HitNormal);
									}
									else if (j == 8)
									{
										StartTrace += ((DistanceMult*sqrt(DamageRadius)) * Vect(0.0,-1.0,1.0)) << Rotator(HitNormal);
									}
									else if (j == 9)
									{
										StartTrace += ((DistanceMult*sqrt(DamageRadius)) * Vect(0.0,-1.0,-1.0)) << Rotator(HitNormal);
									}
								}
								if (!CallingActor.FastTrace(CheckPoint, StartTrace))
									continue;
								if (j == 1)
									CheckPoint = StartTrace;
							}
							//G-Flex: TraceBox() is expensive, do it for movers only
							if (Victims.IsA('Mover'))
							{
								if (TraceBox(Victims, StartTrace, Victims.Location, 2.0 * iterations))
									bHurtIt = true;
							}
							else
							{
								otherVictim = CallingActor.Trace(HitLoc, HitNorm, Victims.Location, StartTrace);
								if ((otherVictim == None) || (otherVictim == Victims))
									bHurtIt = true;
								else if (Victims.IsA('Pawn'))
								{
									otherVictim = CallingActor.Trace(HitLoc, HitNorm,
									 Victims.Location + (Pawn(Victims).BaseEyeHeight * Vect(0,0,1)), StartTrace);
									if ((otherVictim == None) || (otherVictim == Victims))
										bHurtIt = true;
								}
							}
							//G-Flex: only do this check for movers; it's really slow and horrible
							if (Victims.IsA('Mover'))
							{
								for (x = -1; x < 2; x++)
								{
									if (bHurtIt)
										break;
									for (y = -1; y < 2; y++)
									{
										if (bHurtIt)
											break;
										for (z = -1; z < 2; z++)
										{
											EndTrace.X = x;
											EndTrace.Y = y;
											EndTrace.Z = z;
											if (EndTrace == Vect(0,0,0))
												continue;
											EndTrace *= DamageRadiusAdj;
											EndTrace += StartTrace;
											otherVictim = CallingActor.Trace(HitLoc, HitNorm, EndTrace, StartTrace);
											if (otherVictim == Victims)
											{
												bHurtIt = true;
												break;
											}
											//G-Flex: sometimes mover surfaces trace as level geometry
											else if ((otherVictim != None) && otherVictim.IsA('LevelInfo'))
											{
												otherVictim = CallingActor.Trace(HitLoc,
												HitNorm,
												StartTrace, 
												HitLoc + (HitNorm * -1.0));
												if ((otherVictim != None) && otherVictim == Victims)
												{
													bHurtit = true;
													break;
												}
											}
										}
									}
								}
							}
						}
					}					
				}
				
				if (bHurtIt)
				{
					//G-Flex: smash beer bottles and stuff
					if (Victims.IsA('DeusExPickup'))
					{
						DeusExPickup(Victims).BreakItSmashIt(DeusExPickup(Victims).fragType,
						 (DeusExPickup(Victims).CollisionRadius + DeusExPickup(Victims).CollisionHeight) / 2);
					}
					else
					{
						dir = Victims.Location - HitLocation;
						dist = FMax(1,VSize(dir));
						dir = dir/dist; 
						damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
						Victims.TakeDamage
						(
							damageScale * DamageAmount,
							CallingActor.Instigator, 
							Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
							(damageScale * Momentum * dir),
							DamageName
						);
					}
				}
			}
		}
	}
	CallingActor.bHurtEntry = false;
}