//=============================================================================
// SkillSwimming.
//=============================================================================
class SkillSwimming extends Skill;

var int mpCost1;
var int mpCost2;
var int mpCost3;
var float mpLevel0;
var float mpLevel1;
var float mpLevel2;
var float mpLevel3;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		cost[0] = mpCost1;
		cost[1] = mpCost2;
		cost[2] = mpCost3;
		LevelValues[0] = mpLevel0;
		LevelValues[1] = mpLevel1;
		LevelValues[2] = mpLevel2;
		LevelValues[3] = mpLevel3;
	}
}

//G-Flex: overridden from Skill to change JumpZ
function bool IncLevel(optional DeusExPlayer usePlayer)
{
	local DeusExPlayer localPlayer;

	//G-Flex: For the speed aug level
	local float speedLevel;

	// First make sure we're not maxed out
	if (CurrentLevel < 3)
	{
		// If "usePlayer" is passed in, then we want to use this 
		// as the basis for making our calculations, temporarily
		// overriding whatever this skill's player is set to.

		if (usePlayer != None)
			localPlayer = usePlayer;
		else
			localPlayer = Player;

		// Now, if a player is defined, then check to see if there enough
		// skill points available.  If no player is defined, just do it.
		if (localPlayer != None) 
		{
			if ((localPlayer.SkillPointsAvail >= Cost[CurrentLevel]))
			{
				// decrement the cost and increment the current skill level
				localPlayer.SkillPointsAvail -= GetCost();
				CurrentLevel++;

				//G-Flex: This is an awful hack.
				if (localPlayer.AugmentationSystem != None)
				{
					speedLevel = FMax(1.0,localPlayer.AugmentationSystem.GetAugLevelValue(class'AugSpeed'));
				}
				else
				{
					speedLevel = 1.0;
				}

				localPlayer.JumpZ = localPlayer.Default.JumpZ * (0.20 * LevelValues[currentLevel] - 0.20 + speedLevel);
				return True;
			}
		}
		else
		{
			CurrentLevel++;
			return True;
		}
	}

	return False;
}

defaultproperties
{
     mpCost1=1000
     mpCost2=1000
     mpCost3=1000
     mpLevel0=1.000000
     mpLevel1=1.250000
     mpLevel2=1.500000
     mpLevel3=2.250000
     SkillName="Athletics"
     Description="Urban operations require agents to maintain peak physical condition in order to maneuver effectively, even underwater, and to prevent injury.|n|nUNTRAINED: An agent can run, jump, and swim normally.|n|nTRAINED: The speed, lung capacity, jumping height and ability of an agent to withstand falls increases slightly.|n|nADVANCED: The maneuverability and lung capacity of an agent increases moderately.|n|nMASTER: An agent moves like a dolphin underwater and a cat on land."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconSwimming'
     bAutomatic=True
	 //G-Flex: was 675,1350,2250
     cost(0)=900
     cost(1)=1800
     cost(2)=3000
     LevelValues(0)=1.000000
     LevelValues(1)=1.500000
     LevelValues(2)=2.000000
     LevelValues(3)=2.500000
}
