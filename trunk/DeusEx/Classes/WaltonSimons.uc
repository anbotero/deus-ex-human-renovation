//=============================================================================
// WaltonSimons.
//=============================================================================
class WaltonSimons extends HumanMilitary;

var AugDefenseNPC DefenseAug;

function AdjustProperties()
{
	//1.600000 instead of 2.000000
	SurprisePeriod *= 0.800000;
	//0.400000 instead of 0.500000
	attackPeriod *= 0.800000;
	//3.600000 instead of 4.500000
	maxAttackPeriod *= 0.800000;
	//0.007000 instead of 0.010000
	VisibilityThreshold *= 0.700000;
	//0.195000 instead of 0.150000
	HearingThreshold *= 0.700000;
	
	//G-Flex: he's augmented, he should move faster than normal
	GroundSpeed *= 1.400000;
	
	//G-Flex: try to give him his aggressive defense aug
	//G-Flex: but not if he's a hologram
	if (!((Style != STY_Masked) && (Style != STY_Normal)))
		DefenseAug = Spawn(class'AugDefenseNPC', Self);
	
	//G-Flex: make more accurate than HumanMilitary parent class (0.200000 -> 0.100000)
	BaseAccuracy /= 2.000000;
	
	DamageBonus = 0.100000;
}

function AdjustDifficulty(float diff)
{
	Super.AdjustDifficulty(diff);
	
	//G-Flex: make his aug better on higher difficulties
	if (DefenseAug != None)
	{
		if (diff > 3.0)
			DefenseAug.CurrentLevel = 2;
		else if (diff > 1.5)
			DefenseAug.CurrentLevel = 1;
		else
			DefenseAug.CurrentLevel = 0;
	}
	
	//G-Flex: 0.10, 0.07, 0.05, 0.03
	BaseAccuracy /= diff;
	//G-Flex: 0.10, 0.15, 0.20, 0.40
	DamageBonus *= diff;
}

function Carcass SpawnCarcass()
{
	//G-Flex: get rid of defense aug
	if (DefenseAug != None)
		DefenseAug.Destroy();
	
	Super.SpawnCarcass();
}

//G-Flex: changed, datavault image says he has ballistic defenses
//
// Damage type table for Walton Simons:
//
// Shot			- 66% (was 100%)
// Sabot		- 66% (was 100%)
// Exploded		- 40% (was 100%)
// TearGas		- 10%
// PoisonGas	- 10%
// Poison		- 10%
// PoisonEffect	- 10%
// HalonGas		- 10%
// Radiation	- 10%
// Shocked		- 10%
// Stunned		- 0%
// KnockedOut   - 0%
// Flamed		- 0%
// Burned		- 0%
// NanoVirus	- 0%
// EMP			- 0%
//

function float ShieldDamage(name damageType)
{
	//G-Flex: shot/sabot handled in ModifyDamage() so the shield effect isn't drawn
	// handle special damage types
	if ((damageType == 'Flamed') || (damageType == 'Burned') || (damageType == 'Stunned') ||
	    (damageType == 'KnockedOut'))
		return 0.0;
	else if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas') ||
			(damageType == 'Radiation') || (damageType == 'Shocked') || (damageType == 'Poison') ||
	        (damageType == 'PoisonEffect'))
		return 0.1;
	else if (damageType == 'Exploded')
		return 0.4;
	else
		return Super.ShieldDamage(damageType);
}

//G-Flex: shot/sabot reduction done here
function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation,
                            Vector offset, Name damageType)
{
	if ((damageType == 'Shot') || (damageType == 'Sabot'))
		return Super.ModifyDamage((0.66 * Damage), instigatedBy, hitLocation, offset, damageType);
	else
		return Super.ModifyDamage(Damage, instigatedBy, hitLocation, offset, damageType);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

defaultproperties
{
     CarcassType=Class'DeusEx.WaltonSimonsCarcass'
	 //G-Flex: WalkingSpeed=0.333333
     WalkingSpeed=0.250000
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     BaseAssHeight=-23.000000
     BurnPeriod=0.000000
     bHasCloak=True
     CloakThreshold=150
     walkAnimMult=1.400000
     GroundSpeed=240.000000
     Health=600
     HealthHead=900
     HealthTorso=600
     HealthLegLeft=600
     HealthLegRight=600
     HealthArmLeft=600
     HealthArmRight=600
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.PantsTex5'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.WaltonSimonsTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
	 //G-Flex: a little heavier
	 Mass=175
     BindName="WaltonSimons"
     FamiliarName="Walton Simons"
     UnfamiliarName="Walton Simons"
}
