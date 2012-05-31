//=============================================================================
// AugMuscle.
//=============================================================================
class AugMuscle extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
}

//G-Flex: we need a way to get the player to actually drop the damn item when possible if he can't initially
//G-Flex: this should fix the bug where you can carry around large items with the aug inactive
state DropPending
{
	Begin:
		Player.DropDecoration();
		if (Player.CarriedDecoration == None)
			GoToState('Inactive');
		//G-Flex: don't attempt to drop it every frame
		Sleep(0.25);
		GoTo('Begin');
}

function Deactivate()
{
	Super.Deactivate();

	// check to see if the player is carrying something too heavy for him
	if (Player.CarriedDecoration != None)
		if (!Player.CanBeLifted(Player.CarriedDecoration))
		{
			//G-Flex: drastic measures in case they can't drop it
			GoToState('DropPending');
		}
}

//G-Flex: override to account for new state
function Activate()
{
	// can't do anything if we don't have it
	if (!bHasIt)
		return;

	if (IsInState('Inactive') || IsInState('DropPending'))
	{
		// this block needs to be before bIsActive is set to True, otherwise
		// NumAugsActive counts incorrectly and the sound won't work
		Player.PlaySound(ActivateSound, SLOT_None);
		if (Player.AugmentationSystem.NumAugsActive() == 0)
			Player.AmbientSound = LoopSound;

		bIsActive = True;

		Player.ClientMessage(Sprintf(AugActivated, AugmentationName));

		if (Player.bHUDShowAllAugs)
			Player.UpdateAugmentationDisplayStatus(Self);
		else
			Player.AddAugmentationDisplay(Self);

		GotoState('Active');
	}
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
      //Lift with your legs, not with your back.
      AugmentationLocation = LOC_Leg;
	}
}

defaultproperties
{
     mpAugValue=2.000000
     mpEnergyDrain=20.000000
     EnergyRate=20.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconMuscle'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconMuscle_Small'
     AugmentationName="Microfibral Muscle"
     Description="Muscle strength is amplified with ionic polymeric gel myofibrils that allow the agent to push and lift extraordinarily heavy objects.|n|nTECH ONE: Strength is increased slightly.|n|nTECH TWO: Strength is increased moderately.|n|nTECH THREE: Strength is increased significantly.|n|nTECH FOUR: An agent is inhumanly strong."
     MPInfo="When active, you can pick up large crates.  Energy Drain: Low"
     LevelValues(0)=1.250000
     LevelValues(1)=1.500000
     LevelValues(2)=1.750000
     LevelValues(3)=2.000000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=8
}
