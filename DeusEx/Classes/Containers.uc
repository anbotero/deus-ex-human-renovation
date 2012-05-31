//=============================================================================
// Containers.
//G-Flex: modified so that map transitions won't dump contents
//=============================================================================
class Containers extends DeusExDecoration
	abstract;

var() travel int numThings;
var() travel bool bGenerateTrash;
//G-Flex: we need to use contents/content2/content3 to represent items
//G-Flex: but we can't make those travel vars
var() travel string contentsBackup;
var() travel string content2Backup;
var() travel string content3Backup;

function PreTravel()
{
	//G-Flex: back up the classes of the contents, including package
	if (contents != None)
		contentsBackup = string(contents);
	if (content2 != None)
		content2Backup = string(content2);
	if (content3 != None)
		content3Backup = string(content3);
}

function TravelPostAccept()
{
	local class<inventory> tempClass;

	Super.TravelPostAccept();

	//G-Flex: restore contents from backed-up names
	if (contentsBackup != "")
	{
		tempClass = class<inventory>(DynamicLoadObject(contentsBackup, class'Class'));
		contents = tempClass;
		contentsBackup = "";
	}
	if (content2Backup != "")
	{
		tempClass = class<inventory>(DynamicLoadObject(content2Backup, class'Class'));
		content2 = tempClass;
		content2Backup = "";
	}
	if (content3Backup != "")
	{
		tempClass = class<inventory>(DynamicLoadObject(content3Backup, class'Class'));
		content3 = tempClass;
		content3Backup = "";
	}
}

//
// copied from Engine.Decoration
//
function Destroyed()
{
	/*local actor dropped;
	local class<actor> tempClass;
	local int i;
	local Rotator rot;
	local Vector loc;
	local TrashPaper trash;
	local Rat vermin;

	// trace down to see if we are sitting on the ground
	loc = vect(0,0,0);
	loc.Z -= CollisionHeight + 8.0;
	loc += Location;

	// only generate trash if we are on the ground
	if (!FastTrace(loc) && bGenerateTrash)
	{
		// maybe spawn some paper
		for (i=0; i<4; i++)
		{
			if (FRand() < 0.75)
			{
				loc = Location;
				loc.X += (CollisionRadius / 2) - FRand() * CollisionRadius;
				loc.Y += (CollisionRadius / 2) - FRand() * CollisionRadius;
				loc.Z += (CollisionHeight / 2) - FRand() * CollisionHeight;
				trash = Spawn(class'TrashPaper',,, loc);
				if (trash != None)
				{
					trash.SetPhysics(PHYS_Rolling);
					trash.rot = RotRand(True);
					trash.rot.Yaw = 0;
					trash.dir = VRand() * 20 + vect(20,20,0);
					trash.dir.Z = 0;
				}
			}
		}

		// maybe spawn a rat
		if (FRand() < 0.5)
		{
			loc = Location;
			loc.Z -= CollisionHeight;
			vermin = Spawn(class'Rat',,, loc);
			if (vermin != None)
				vermin.bTransient = true;
		}
	}*/

	if( (Pawn(Base) != None) && (Pawn(Base).CarriedDecoration == self) )
		Pawn(Base).DropDecoration();
	/*if( (Contents!=None) && !Level.bStartup )
	{
		tempClass = Contents;
		if (Content2!=None && FRand()<0.3) tempClass = Content2;
		if (Content3!=None && FRand()<0.3) tempClass = Content3;

		for (i=0; i<numThings; i++)
		{
			loc = Location+VRand()*CollisionRadius;
			loc.Z = Location.Z;
			rot = rot(0,0,0);
			rot.Yaw = FRand() * 65535;
			dropped = Spawn(tempClass,,, loc, rot);
			if (dropped != None)
			{
				dropped.RemoteRole = ROLE_DumbProxy;
				dropped.SetPhysics(PHYS_Falling);
				dropped.bCollideWorld = true;
				dropped.Velocity = VRand() * 50;
				if ( inventory(dropped) != None )
					inventory(dropped).GotoState('Pickup', 'Dropped');
			}
		}
	}*/

	Super.Destroyed();
}

//G-Flex: drop stuff here instead of Destroyed() so it won't happen on map transitions
simulated function Frag(class<fragment> FragType, vector Momentum, float DSize, int NumFrags) 
{
	local actor dropped;
	local class<actor> tempClass;
	local int i;
	local Rotator rot;
	local Vector loc;
	local TrashPaper trash;
	local Rat vermin;

	if ( Role == ROLE_Authority )
	{
		// trace down to see if we are sitting on the ground
		loc = vect(0,0,0);
		loc.Z -= CollisionHeight + 8.0;
		loc += Location;

		// only generate trash if we are on the ground
		if (!FastTrace(loc) && bGenerateTrash)
		{
			// maybe spawn some paper
			for (i=0; i<4; i++)
			{
				if (FRand() < 0.75)
				{
					loc = Location;
					loc.X += (CollisionRadius / 2) - FRand() * CollisionRadius;
					loc.Y += (CollisionRadius / 2) - FRand() * CollisionRadius;
					loc.Z += (CollisionHeight / 2) - FRand() * CollisionHeight;
					trash = Spawn(class'TrashPaper',,, loc);
					if (trash != None)
					{
						trash.SetPhysics(PHYS_Rolling);
						trash.rot = RotRand(True);
						trash.rot.Yaw = 0;
						trash.dir = VRand() * 20 + vect(20,20,0);
						trash.dir.Z = 0;
					}
				}
			}

			// maybe spawn a rat
			if (FRand() < 0.5)
			{
				loc = Location;
				loc.Z -= CollisionHeight;
				vermin = Spawn(class'Rat',,, loc);
				if (vermin != None)
					vermin.bTransient = true;
			}
		}
		
		if( (Contents!=None) && !Level.bStartup )
		{
			tempClass = Contents;
			if (Content2!=None && FRand()<0.3) tempClass = Content2;
			if (Content3!=None && FRand()<0.3) tempClass = Content3;

			for (i=0; i<numThings; i++)
			{
				loc = Location+VRand()*CollisionRadius;
				loc.Z = Location.Z;
				rot = rot(0,0,0);
				rot.Yaw = FRand() * 65535;
				dropped = Spawn(tempClass,,, loc, rot);
				if (dropped != None)
				{
					dropped.RemoteRole = ROLE_DumbProxy;
					dropped.SetPhysics(PHYS_Falling);
					dropped.bCollideWorld = true;
					dropped.Velocity = VRand() * 50;
					if ( inventory(dropped) != None )
						inventory(dropped).GotoState('Pickup', 'Dropped');
				}
			}
		}
	}
	
	Super.Frag(FragType, Momentum, DSize, NumFrags);
}

defaultproperties
{
     numThings=1
     bFlammable=True
     bCanBeBase=True
}
