//=============================================================================
// Cart.
//=============================================================================
class Cart extends DeusExDecoration;

//var float rollTimer;
var float pushTimer;
var vector pushVel;
var bool bJustPushed;
//G-Flex: don't calculate VSize so often because it's slow
var float velMagnitude;
//G-Flex: keep track of times to multiply the velocity by a slowing factor
var float updateTimer;

//== Unlike everything else, once the cart lands it rolls a bit
  function Landed(vector HitNormal)
  {
  	Super.Landed(HitNormal);

	//G-Flex: take away some momentum upon landing
	StartRolling(Velocity / 2);
  }

function StartRolling(vector vel)
{
	// Transfer momentum
	SetPhysics(PHYS_Rolling);
	pushVel = vel;
	pushVel.Z = 0;
	Velocity = pushVel;
	//G-Flex: instead of timing it, keep track of how fast it's going
	velMagnitude = VSize(pushVel);
	updateTimer = 0;
	bJustPushed = True;
	pushTimer = 0.5;
	AmbientSound = Sound'UtilityCart';
}

//
// give us velocity in the direction of the push
//
function Bump(actor Other)
{
	if (bJustPushed)
		return;

	if ((Other != None) && (Physics != PHYS_Falling))
		if (abs(Location.Z-Other.Location.Z) < (CollisionHeight+Other.CollisionHeight-1))  // no bump if landing on cart
			StartRolling(0.25*Other.Velocity*Other.Mass/Mass);
}

//
// simulate less friction (wheels)
//
function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (Physics == PHYS_Rolling)
	{
		//G-Flex: let cart abruptly when it gets too slow
		if (velMagnitude > 20.0)
		{
		
			updateTimer += deltaTime;
			//== Perhaps a slightly more realisitc interpretation of physics, mm?
			pushVel -= ((pushVel/velMagnitude) * 16.000 * deltaTime);
			//G-Flex: lose a percentage of velocity in addition to flat decrease
			//G-Flex: keep track of discrete time intervals here
			while (updateTimer > 0.2)
			{
				pushVel *= 0.925;
				updateTimer -= 0.2;
			}
			Velocity = pushVel;
			velMagnitude = VSize(pushVel);
			// make the sound pitch depend on the velocity
			SoundPitch = Clamp(2*velMagnitude, 32, 64);
		}
		else
		{
			AmbientSound = None;
			SoundPitch = Default.SoundPitch;
		}
	}
	//G-Flex: also stop the ambient sound if we get picked up or otherwise change physics
	else
	{
		AmbientSound = None;
		SoundPitch = Default.SoundPitch;
	}
	
	
	if (bJustPushed)
	{
		if (pushTimer > 0)
			pushTimer -= deltaTime;
		else
			bJustPushed = False;
	}

	// make the sound pitch depend on the velocity
	//if (velMagnitude > 1)
	//{
	//	SoundPitch = Clamp(2*velMagnitude, 32, 64);
	//}
	//else
	//{
	//	// turn off the sound when it stops
	//	AmbientSound = None;
	//	SoundPitch = Default.SoundPitch;
	//}
}

defaultproperties
{
     bCanBeBase=True
     ItemName="Utility Push-Cart"
     Mesh=LodMesh'DeusExDeco.Cart'
     SoundRadius=16
     CollisionRadius=28.000000
     CollisionHeight=26.780001
     Mass=40.000000
     Buoyancy=45.000000
}
