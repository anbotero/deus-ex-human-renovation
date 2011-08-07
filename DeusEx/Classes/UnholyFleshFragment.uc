//=============================================================================
// UnholyFleshFragment.
// For use with "ripandtear" cheat, spawned by RipTearLauncher
//=============================================================================
class UnholyFleshFragment expands FleshFragment;

var float roll;

auto state Flying
{
	function BeginState()
	{
		Super.BeginState();
		roll = FRand();
		//G-Flex: chance of smoke
		DrawScale += 0.25;
		if (roll<0.20)
		{
			bSmoking = true;
		}
		//G-Flex: make translucent
		if (Style != STY_Translucent)
			Style = STY_Translucent;
		//G-Flex: slower than normal flesh
		Velocity *= 0.75;
		//G-Flex: random sounds
		roll = FRand();
		if (roll<0.05)
		{
			AmbientSound = Sound'Ambient.Ambient.Electricity2';
			SoundRadius = 18;
			SoundVolume = 200;
			SoundPitch = 40;
		}
		else if (roll<0.10)
		{
			AmbientSound = Sound'Ambient.Ambient.GeigerLoop';
			soundRadius = 12;
			soundVolume = 128;
		}
		else if (roll<0.15)
		{
			AmbientSound = Sound'DeusExSounds.Pickup.RebreatherLoop';
			soundRadius = 16;
			soundVolume = 96;
		}
		//G-Flex: adjust lights based on drawscale
		LightRadius += (((DrawScale/1.5) - 1.5) * 16);
		LightBrightness += (((DrawScale/1.5) - 1.5) * 48);
		//G-Flex: slightly random hue
		LightHue += Rand(35);
	}
}

defaultproperties
{
     LifeSpan=12.500000
     CollisionHeight=4.800000
	 CollisionRadius=4.800000
	 LightType=LT_Steady
     LightEffect=LE_TorchWaver
     LightBrightness=196
     LightHue=255
     LightSaturation=0
     LightRadius=18
}
