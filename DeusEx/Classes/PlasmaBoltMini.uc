//=============================================================================
// PlasmaBoltMini.
//=============================================================================
class PlasmaBoltMini extends PlasmaBolt;

simulated function SpawnPlasmaEffects()
{
	Super.SpawnPlasmaEffects();

	if (pGen2 != None)
	{
		pGen2.particleDrawScale *= 0.4;
		pGen2.checkTime *= 1.75;
		pGen2.particleLifeSpan *= 0.7;
	}
   
}

defaultproperties
{
     bExplodes=false
     ItemName="Mini Plasma Bolt"
	 //G-Flex: slightly faster
     speed=1700.000000
     MaxSpeed=1700.000000
	 //G-Flex: direct damage, no explosion
     Damage=30.000000
     MomentumTransfer=800
	 //G-Flex: Smaller
     DrawScale=0.750000
	 //G-Flex: less bright
     LightBrightness=64
     LightRadius=2
	 ExplosionDecal=None
}