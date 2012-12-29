//=============================================================================
// AnnaNavarre.
// G-Flex: altered to use ShieldDamage()
//=============================================================================
class AnnaNavarre extends HumanMilitary;

function AdjustProperties()
{
	//1.200000 instead of 2.000000
	SurprisePeriod *= 0.600000;
	//0.300000 instead of 0.500000
	attackPeriod *= 0.600000;
	//2.700000 instead of 4.500000
	maxAttackPeriod *= 0.600000;
	//0.007500 instead of 0.010000
	VisibilityThreshold *= 0.750000;
	//0.112500 instead of 0.150000
	HearingThreshold *= 0.750000;
	
	GroundSpeed *= 1.15;
	
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

function Bool HasTwoHandedWeapon()
{
	return False;
}

// ----------------------------------------------------------------------
// UpdateFire()
// G-Flex: overloaded so she takes less damage from being on fire
// ----------------------------------------------------------------------

function UpdateFire()
{
	// continually burn and do damage
	HealthTorso -= 3;
	GenerateTotalHealth();
	if (Health <= 0)
	{
		TakeDamage(10, None, Location, vect(0,0,0), 'Burned');
		ExtinguishFire();
	}
}

function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation,
                            Vector offset, Name damageType)
{
	if ((damageType == 'Stunned') || (damageType == 'KnockedOut') || (damageType == 'Poison') || (damageType == 'PoisonEffect'))
		return 0;
	//G-Flex: take half-damage from energy sources
	else if ((damageType == 'Flamed') || (damageType == 'Burned') || (damageType == 'Shocked') || (damageType == 'Radiation'))
		return Super.ModifyDamage((0.5 * Damage), instigatedBy, hitLocation, offset, damageType);
	//G-Flex: and some damage reduction from explosions
	else if (damageType == 'Exploded')
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
     CarcassType=Class'DeusEx.AnnaNavarreCarcass'
     WalkingSpeed=0.280000
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     BaseAssHeight=-18.000000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
	 BurnPeriod=5.000000
     bHasCloak=True
     CloakThreshold=100
     walkAnimMult=1.000000
     bIsFemale=True
     GroundSpeed=220.000000
     BaseEyeHeight=38.000000
     Health=300
     HealthHead=400
     HealthTorso=300
     HealthLegLeft=300
     HealthLegRight=300
     HealthArmLeft=300
     HealthArmRight=300
     Mesh=LodMesh'DeusExCharacters.GFM_TShirtPants'
     DrawScale=1.100000
     MultiSkins(0)=Texture'DeusExCharacters.Skins.AnnaNavarreTex0'
     MultiSkins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(2)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(3)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(4)=Texture'DeusExItems.Skins.BlackMaskTex'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.AnnaNavarreTex0'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.PantsTex9'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.AnnaNavarreTex1'
     CollisionHeight=47.299999
	 //G-Flex: a little heavier
	 Mass=175
	 bExplodeOnDeath=True
     BindName="AnnaNavarre"
     FamiliarName="Anna Navarre"
     UnfamiliarName="Anna Navarre"
}
