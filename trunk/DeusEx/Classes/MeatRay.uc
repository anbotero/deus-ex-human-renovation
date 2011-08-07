//=============================================================================
// Meat Ray
// Tracer-like thing for RipTearLauncher
//=============================================================================
class MeatRay extends DeusExProjectile;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetCollision(false, false, false);
}

auto simulated state Flying
{/*
ignores Bump;

	//do nothing
	simulated function HitWall(vector HitNormal, actor Wall)
	{
	return;
	}
	
	simulated singular function Touch(Actor Other)
	{
	return;
	}
	
	simulated function ProcessTouch(Actor Other, Vector HitLocation)
	{
	return;
	}
	
	event bool EncroachingOn(actor Other)
	{
	return false;
	}
	
	event EncroachedBy(actor Other)
	{
	return;
	}*/
}

defaultproperties
{
     CollisionHeight=0
	 CollisionRadius=0
     bCollideWorld=False
	 bCollideActors=False
     bIgnoresNanoDefense=True
     DamageType=Tantalus
     AccurateRange=500000 //inf
     maxRange=500000 //inf
     ItemName="horrifying entity tearing through space"
     ItemArticle="a"
     speed=2000.000000
     MaxSpeed=3000.000000
     Damage=5000.000000 //a lot
     MomentumTransfer=10000
	 Mass=2000 //a lot
     SpawnSound=None
     Mesh=LodMesh'DeusExItems.Tracer'
	 Skin=Texture'Virus_SFX'
     DrawScale=6.000000
	 ScaleGlow=3.000000
	 LightType=LT_Steady
     LightEffect=LE_None
     LightBrightness=196
     LightHue=32
     LightSaturation=16
     LightRadius=64
     AmbientSound=Sound'Ambient.Ambient.Electricity2'
     SpawnSound=Sound'DeusExSounds.Generic.SmallExplosion2'
	 SoundRadius=128
	 SoundVolume=64
	 SoundPitch=32
     RotationRate=(Pitch=32768,Yaw=32768)
}
