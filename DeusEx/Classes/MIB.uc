//=============================================================================
// MIB.
//=============================================================================
class MIB extends HumanMilitary;

function AdjustProperties()
{
	//1.400000 instead of 2.000000
	SurprisePeriod *= 0.700000;
	//0.350000 instead of 0.500000
	attackPeriod *= 0.700000;
	//3.150000 instead of 4.500000
	maxAttackPeriod *= 0.700000;
	//0.007500 instead of 0.010000
	VisibilityThreshold *= 0.750000;
	//0.112500 instead of 0.150000
	HearingThreshold *= 0.750000;
}

defaultproperties
{
     MinHealth=0.000000
     CarcassType=Class'DeusEx.MIBCarcass'
     WalkingSpeed=0.213333
     CloseCombatMult=0.500000
     GroundSpeed=180.000000
     Health=350
     HealthHead=350
     HealthTorso=350
     HealthLegLeft=350
     HealthLegRight=350
     HealthArmLeft=350
     HealthArmRight=350
     Mesh=LodMesh'DeusExCharacters.GM_Suit'
     DrawScale=1.100000
     MultiSkins(0)=Texture'DeusExCharacters.Skins.MIBTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.PantsTex5'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MIBTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.MIBTex1'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.MIBTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.FramesTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.LensesTex3'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionHeight=52.250000
	 //G-Flex: a little heavier
	 Mass=180.000000
	 bExplodeOnDeath=True
     BindName="MIB"
     FamiliarName="Man In Black"
     UnfamiliarName="Man In Black"
}
