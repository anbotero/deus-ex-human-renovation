//=============================================================================
// GuntherHermann.
//=============================================================================
class GuntherHermann extends HumanMilitary;

function AdjustProperties()
{
	//1.200000 instead of 2.000000
	SurprisePeriod *= 0.600000;
	//0.300000 instead of 0.500000
	attackPeriod *= 0.600000;
	//2.700000 instead of 4.500000
	maxAttackPeriod *= 0.600000;
	//0.006000 instead of 0.010000
	VisibilityThreshold *= 0.600000;
	//0.090000 instead of 0.150000
	HearingThreshold *= 0.600000;
	
	//G-Flex: make more accurate than HumanMilitary parent class (0.200000 -> 0.100000)
	BaseAccuracy /= 2.000000;
	
	DamageBonus = 0.075000;
}

function AdjustDifficulty(float diff)
{
	Super.AdjustDifficulty(diff);
	
	//G-Flex: 0.10, 0.07, 0.05, 0.03
	BaseAccuracy /= diff;
	//G-Flex: 0.08, 0.11, 0.15, 0.30
	DamageBonus *= diff;
}

//G-Flex: changed to make him a little tougher
//
// Damage type table for Gunther Hermann:
//
// Shot			- 66% (was 100%)
// Sabot		- 66% (was 100%)
// Exploded		- 33% (was 100%)
// TearGas		- 10%
// PoisonGas	- 10%
// Poison		- 10%
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
		return 0.33;
	else
		return Super.ShieldDamage(damageType);
}

function bool Facelift(bool bOn)
{
	local int i;

	if(!Super.Facelift(bOn))
		return false;

	if(bOn)
		Mesh = mesh(DynamicLoadObject("HDTPcharacters.HDTPGunther", class'mesh', True));

	if(Mesh == None || !bOn)
	{
		Texture = Default.Texture;
		Mesh = Default.Mesh;
		for(i = 0; i < 8; i++)
		{
			MultiSkins[i] = Default.MultiSkins[i];
		}
	}
	else
	{
		Texture = None;
		for(i = 0; i < 8; i++)
		{
			MultiSkins[i] = None;
		}
	}

	return true;
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

//
// special Gunther killswitch animation state
//
state KillswitchActivated
{
	function BeginState()
	{
		StandUp();
		LastPainTime = Level.TimeSeconds;
		LastPainAnim = AnimSequence;
		bInterruptState = false;
		BlockReactions();
		bCanConverse = False;
		bStasis = False;
		SetDistress(true);
		TakeHitTimer = 2.0;
		EnemyReadiness = 1.0;
		ReactionLevel  = 1.0;
		bInTransientState = true;
	}

Begin:
	FinishAnim();
	PlayAnim('HitTorso', 2.0, 0.1);
	FinishAnim();
	PlayAnim('HitHead', 2.0, 0.1);
	FinishAnim();
	PlayAnim('HitTorsoBack', 2.0, 0.1);
	FinishAnim();
	PlayAnim('HitHeadBack', 2.0, 0.1);
	FinishAnim();
	PlayAnim('HitHead', 3.0, 0.1);
	FinishAnim();
	PlayAnim('HitHeadBack', 3.0, 0.1);
	FinishAnim();
	PlayAnim('HitHead', 5.0, 0.1);
	FinishAnim();
	PlayAnim('HitHeadBack', 5.0, 0.1);
	FinishAnim();
	Explode();
	Destroy();
}

defaultproperties
{
     CarcassType=Class'DeusEx.GuntherHermannCarcass'
     WalkingSpeed=0.350000
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     InitialInventory(3)=(Inventory=Class'DeusEx.WeaponFlamethrower')
     InitialInventory(4)=(Inventory=Class'DeusEx.AmmoNapalm',Count=2)
     BurnPeriod=0.000000
     walkAnimMult=0.750000
     GroundSpeed=210.000000
     BaseEyeHeight=44.000000
     Health=400
     HealthHead=600
     HealthTorso=400
     HealthLegLeft=400
     HealthLegRight=400
     HealthArmLeft=400
     HealthArmRight=400
     Texture=Texture'DeusExItems.Skins.BlackMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_DressShirt_B'
     DrawScale=1.100000
     MultiSkins(0)=Texture'DeusExCharacters.Skins.GuntherHermannTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.PantsTex9'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.GuntherHermannTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.GuntherHermannTex0'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'DeusExItems.Skins.BlackMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=24.200001
     CollisionHeight=55.660000
	 //G-Flex: a little heavier
	 Mass=200
	 bExplodeOnDeath=True
     BindName="GuntherHermann"
     FamiliarName="Gunther Hermann"
     UnfamiliarName="Gunther Hermann"
}
