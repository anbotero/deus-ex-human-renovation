//=============================================================================
// AugSpeed.
//=============================================================================
class AugSpeed extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
	Player.GroundSpeed *= LevelValues[CurrentLevel];

	//G-Flex: to take SkillSwimming into account
	Player.CalcJumpZ();

	if ( Level.NetMode != NM_Standalone )
	{
		if ( Human(Player) != None )
			Human(Player).UpdateAnimRate( LevelValues[CurrentLevel] );
	}
}

function Deactivate()
{
	Super.Deactivate();

	if (( Level.NetMode != NM_Standalone ) && Player.IsA('Human') )
		Player.GroundSpeed = Human(Player).Default.mpGroundSpeed;
	else
		Player.GroundSpeed = Player.Default.GroundSpeed;

	//G-Flex: to take SkillSwimming into account
	Player.CalcJumpZ();

	if ( Level.NetMode != NM_Standalone )
	{
		if ( Human(Player) != None )
			Human(Player).UpdateAnimRate( -1.0 );
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
      AugmentationLocation = LOC_Torso;
	}
}

defaultproperties
{
     mpAugValue=2.000000
     mpEnergyDrain=180.000000
     EnergyRate=40.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconSpeedJump'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconSpeedJump_Small'
     AugmentationName="Speed Enhancement"
     Description="Ionic polymeric gel myofibrils are woven into the leg muscles, increasing the speed at which an agent can run and climb, the height they can jump, and reducing the damage they receive from falls.|n|nTECH ONE: Speed and jumping are increased slightly, while falling damage is reduced.|n|nTECH TWO: Speed and jumping are increased moderately, while falling damage is further reduced.|n|nTECH THREE: Speed and jumping are increased significantly, while falling damage is substantially reduced.|n|nTECH FOUR: An agent can run like the wind and leap from the tallest building."
     MPInfo="When active, you move twice as fast and jump twice as high.  Energy Drain: Very High"
	 //G-Flex: slightly nerf effect to account for Athletics skill
     LevelValues(0)=1.200000 //1.2
     LevelValues(1)=1.350000 //1.4
     LevelValues(2)=1.525000 //1.6
     LevelValues(3)=1.700000 //1.8
     AugmentationLocation=LOC_Leg
     MPConflictSlot=5
}
