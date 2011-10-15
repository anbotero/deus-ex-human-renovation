//=============================================================================
// AugEMP.
//=============================================================================

//G-Flex: modified to be passive in SP (always on, no energy drain)

class AugEMP extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
}

function Deactivate()
{
	Super.Deactivate();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
		bAlwaysActive = False;
	}
}

defaultproperties
{
     mpAugValue=0.050000
     mpEnergyDrain=5.000000
     EnergyRate=0.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconEMP'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEMP_Small'
     AugmentationName="EMP Shield"
     Description="Nanoscale EMP shielding partially protects individual nanites and reduces bioelectrical drain from incoming pulses. At higher levels, it also protects against direct electrical damage. This augmentation does not consume bioelectrical energy.|n|nTECH ONE: Damage from EMP attacks is reduced slightly.|n|nTECH TWO: Damage from EMP attacks is reduced moderately.|n|nTECH THREE: Damage from EMP attacks is reduced significantly, and electrical damage is reduced slightly.|n|nTECH FOUR: An agent is invulnerable to damage from EMP attacks, and electrical damage is reduced moderately."
     MPInfo="When active, you only take 5% damage from EMP attacks.  Energy Drain: Very Low"
     LevelValues(0)=0.750000
     LevelValues(1)=0.500000
     LevelValues(2)=0.250000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=3
	 bAlwaysActive=True
}
