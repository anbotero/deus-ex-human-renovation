//=============================================================================
// TechGoggles.
//=============================================================================
class TechGoggles extends ChargedPickup;

var int augLevel;
var float augLevelValue;
var() int visionLevel;
var() float visionLevelValue;

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------

function ChargedPickupBegin(DeusExPlayer Player)
{
	Super.ChargedPickupBegin(Player);

	UpdateHUDDisplay(Player);
}

// ----------------------------------------------------------------------
// UpdateHUDDisplay()
// ----------------------------------------------------------------------

function UpdateHUDDisplay(DeusExPlayer Player)
{
	UpdateAugValues(Player);
	if (IsActive())
	{
		if (++DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount >= 1)      
			DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = True;
	}
	
	//G-Flex: set player vision to the best of either source, if vision aug active
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel = Max(augLevel, visionLevel);
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue = FMax(augLevelValue, visionLevelValue);
	Player.RelevantRadius = FMax(augLevelValue, visionLevelValue);
}

// ----------------------------------------------------------------------
// ChargedPickupEnd()
// ----------------------------------------------------------------------

function ChargedPickupEnd(DeusExPlayer Player)
{
	local bool wasActive;
	wasActive = IsActive();
	
	Super.ChargedPickupEnd(Player);
	
	//G-Flex: we need to check to see if the thing's already off
	//G-Flex: because sometimes the game shuts a pickup off twice
	if (!wasActive)
		return;
	
	UpdateAugValues(Player);
	
	if (--DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount <= 0)
	{
		DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = False;
		DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionBlinder = None;
		Player.RelevantRadius = 0;
	}
	else if (DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount == 1)
	{
		//G-Flex: either the aug is active or another pair of goggles is
		//G-Flex: don't need to do anything if it's goggles
		if (augLevel > 0)
		{
			//we know it's just the aug;
			DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue = augLevelValue;
			DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel = augLevel;
			Player.RelevantRadius = augLevelValue;
		}
	}
	else if (DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount > 1)
	{
		//G-Flex: player must have at least one other pair of goggles on
		//G-Flex: might have the aug on too
		//G-Flex: you aren't the guy from System Shock 2, cut it out
		DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel = Max(augLevel, visionLevel);
		DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue = FMax(augLevelValue, visionLevelValue);
		Player.RelevantRadius = FMax(augLevelValue, visionLevelValue);
	}
}

// ----------------------------------------------------------------------
// UpdateAugValues()
// ----------------------------------------------------------------------

function UpdateAugValues(DeusExPlayer Player)
{
	if (Player.AugmentationSystem != None)
	{
		augLevelValue = Player.AugmentationSystem.GetAugLevelValue(class'AugVision');
		if (augLevelValue != -1)
		{
			augLevel = Player.AugmentationSystem.GetClassLevel(class'AugVision');
		}
		else
		{
			augLevel = 0;
			augLevelValue = 0;
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     LoopSound=Sound'DeusExSounds.Pickup.TechGogglesLoop'
     ChargedIcon=Texture'DeusExUI.Icons.ChargedIconGoggles'
     ExpireMessage="TechGoggles power supply used up"
     ItemName="Tech Goggles"
     ItemArticle="some"
     PlayerViewOffset=(X=20.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.GogglesIR'
     PickupViewMesh=LodMesh'DeusExItems.GogglesIR'
     ThirdPersonMesh=LodMesh'DeusExItems.GogglesIR'
     Charge=500
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconTechGoggles'
     largeIcon=Texture'DeusExUI.Icons.LargeIconTechGoggles'
     largeIconWidth=49
     largeIconHeight=36
     Description="Tech goggles are used by many special ops forces throughout the world under a number of different brand names. These provide portable light amplification, infrared vision, and limited penetrating sonar in a disposable package."
     beltDescription="GOGGLES"
     Mesh=LodMesh'DeusExItems.GogglesIR'
     CollisionRadius=8.000000
     CollisionHeight=2.800000
     Mass=10.000000
     Buoyancy=5.000000
     visionLevel=3
     visionLevelValue=300.000000
}
