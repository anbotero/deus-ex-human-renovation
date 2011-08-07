//=============================================================================
// Rip and Tear!!!
// Summoned by RipAndTear() cheat
//=============================================================================
class RipTearLauncher extends Actor;

//G-Flex: some of this copied from Tantalus()
var() int damage;
var() float killRadius;
var() float beamSpeed;

var() float TimeToLive;
var int cycleCount;

var Actor hitActor;
var ScriptedPawn hitPawn;
var DeusExMover hitMover;
var DeusExDecoration hitDecoration;
var DeusExCarcass hitCarcass;
var DeusExPickup hitPickup;
var LaserEmitter hitLaserEmitter;
var bool bTakeDamage;
var() name DamageType;

var Vector beamPosition;
var Vector beamDirection;
var Rotator beamRotation;
var() bool bFirstFragment;

var UnholyFleshFragment frag;
var Vector ChunkPosition;
var MeatRay ray;
var ShockRing ring;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	bTakeDamage = False;
	
	cycleCount = 0;
	
	beamRotation = Rotation;
	beamDirection = Vector(Rotation);
	beamPosition = Location + (beamDirection * 512);
	
	SetTimer(0.12, True);
	
	GetRay();
	
	ring = Spawn(class'ShockRing',,, beamPosition, beamRotation);
	if (ring != None)
	{
		ring.Size = 15;
		ring.Skin = Texture'DeusExItems.FlatFXTex43';
	}
	
	KillEverything();
}

function Timer()
{
	local int i;
	
	cycleCount++;

	//G-Flex: spawn a bunch of weird chunks
	for (i=0; i<3; i++)
	{
		if (bFirstFragment)
		{
			ChunkPosition = beamPosition;
			frag = Spawn(class'UnholyFleshFragment',,, ChunkPosition, beamRotation);
			if (frag != None)
			{
				//frag.Velocity -= (beamDirection * (beamSpeed / 50));
				//frag.AmbientSound = Sound'Ambient.Ambient.Electricity2';
				//frag.SoundRadius = 18;
				//frag.SoundVolume = 200;
				//frag.SoundPitch = 40;
				bFirstFragment = False;
			}
		}
		if (FRand()<0.15)
		{
			//G-Flex: randomize the location of each a little
			ChunkPosition = beamPosition;
			frag = Spawn(class'UnholyFleshFragment',,, ChunkPosition, beamRotation);
			if (frag != None)
			{
				frag.Velocity -= (beamDirection * (beamSpeed / 50));
			}
		}
	}
	
	if (cycleCount >= 2)
	{
		ring = Spawn(class'ShockRing',,, beamPosition, beamRotation);
		if (ring != None)
			ring.Skin=Texture'DeusExItems.FlatFXTex46';
		KillEverything();
		AISendEvent('LoudNoise', EAITYPE_Audio, , (killRadius*4));
		cycleCount = 0;
		if (ray == None)
			GetRay();
	}
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);
	if (TimeToLive <= 0)
	{
		CleanUp();
	}
	else
	{
		//G-Flex: move the beam's position forward a bit
		beamPosition += (beamDirection * (beamSpeed * deltaTime));
		TimeToLive -= deltaTime;
	}
}

function GetRay()
{
	ray = Spawn(Class'MeatRay',,, (beamPosition - (beamDirection * 384)), beamRotation);
	if (ray != None)
	{
		ray.Speed = beamSpeed;
		ray.MaxSpeed = beamSpeed;
	}
}

//=============================================================================
// KillEverything()
//
// Like Tantalus(), but in a radius and it tries to
// damage absolutely everything if at all possible.
// Unfortunately, it can't deal with static objects,
// so you can't blow up Lady Liberty.
//=============================================================================

function KillEverything()
{
	foreach RadiusActors(Class'Actor', hitActor, killRadius, beamPosition)
	{	DamageType = 'Tantalus';
		hitMover = DeusExMover(hitActor);
		hitPawn = ScriptedPawn(hitActor);
		hitDecoration = DeusExDecoration(hitActor);
		hitCarcass = DeusExCarcass(hitActor);
		hitPickup = DeusExPickup(hitActor);
		hitLaserEmitter = LaserEmitter(hitActor);
		if (hitLaserEmitter != None)
		{
			hitLaserEmitter.Destroy();
		}
		else if (hitMover != None)
		{
			hitMover.bBreakable = true;
			hitMover.minDamageThreshold = 1;
			//hitMover.bStatic = false;
			if (hitMover.bBreakable && (hitMover.doorStrength > 0))
			{
				hitMover.doorStrength = 0;
				bTakeDamage = true;
			}
		}
		else if (hitPawn != None)
		{
			hitPawn.bInvincible = false;
			//hitPawn.bStatic = false;
			if (!hitPawn.bInvincible && (hitPawn.Health > 0))
			{
				hitPawn.HealthHead     = 1;
				hitPawn.HealthTorso    = 1;
				hitPawn.HealthLegLeft  = 1;
				hitPawn.HealthLegRight = 1;
				hitPawn.HealthArmLeft  = 1;
				hitPawn.HealthArmRight = 1;
				hitPawn.Health         = 1;
				bTakeDamage = true;
				//G-Flex: 'Exploded' so it can gib
				DamageType = 'Exploded';
			}
		}
		else if (hitCarcass != None)
		{
			//hitCarcass.bStatic = false;
			if (hitCarcass.CumulativeDamage < hitCarcass.MaxDamage)
				bTakeDamage = true;
		}
		else if (hitDecoration != None)
		{
			hitDecoration.bInvincible = false;
			hitDecoration.minDamageThreshold = 1;
			//G-Flex: without these checks, things get blown up multiple times
			if (!hitDecoration.bInvincible && (hitDecoration.HitPoints > 0))
			{
				if (!hitDecoration.IsInState('Active') && !hitDecoration.bDeleteMe && !hitDecoration.IsInState('Dying'))
					hitDecoration.GoToState('Active');
				hitDecoration.HitPoints = 0;
				bTakeDamage = true;
			}
		}
		else if (hitPickup != None)
		{
			hitPickup.bBreakable = true;
			hitPickup.BreakItSmashIt(hitPickup.fragType, (hitPickup.CollisionRadius + hitPickup.CollisionHeight) / 2);
		}
		else if (hitActor != Level)
		{
			bTakeDamage = true;
		}
		if ((bTakeDamage) && (hitActor != None) && (hitActor != Owner))
			hitActor.TakeDamage(damage, Pawn(Owner), hitActor.Location, (beamDirection * damage), DamageType);
	}
}

function CleanUp()
{
	//G-Flex: stuff to do before we're destroyed
	local int i;
	ring = Spawn(class'ShockRing',,, beamPosition, beamRotation);
	if (ring != None)
	{
		ring.Size = 20;
		ring.Skin=Texture'DeusExItems.FlatFXTex46';
	}
	for (i=0; i<6; i++)
	{
		ChunkPosition.X = beamPosition.X + Rand(8) - 4;
		ChunkPosition.Y = beamPosition.Y + Rand(8) - 4;
		ChunkPosition.Z = beamPosition.Z + Rand(8) - 4;
		frag = Spawn(class'UnholyFleshFragment',,, ChunkPosition, beamRotation);
		if (frag != None)
		{
			frag.Velocity -= (beamDirection * (beamSpeed / 50));
			frag.bSmoking = true;
		}
	}
	
	if (ray != None)
	{
		ray.Destroy();
		ray = None;
	}
	
	Destroy();
}
	

defaultproperties
{
     DamageType='Tantalus'
     damage=5000.000000
     beamSpeed=1200.000000
	 killRadius=256.000000
	 bFirstFragment=True
     DrawType=DT_None
     bGameRelevant=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
	 TimeToLive=5.000000
}
