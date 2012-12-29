//=============================================================================
// WIB.
//=============================================================================
class WIB extends HumanMilitary;

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
     CarcassType=Class'DeusEx.WIBCarcass'
     WalkingSpeed=0.296000
     CloseCombatMult=0.500000
     BaseAssHeight=-18.000000
     walkAnimMult=0.870000
     bIsFemale=True
     GroundSpeed=200.000000
     Health=300
     HealthHead=300
     HealthTorso=300
     HealthLegLeft=300
     HealthLegRight=300
     HealthArmLeft=300
     HealthArmRight=300
     Mesh=LodMesh'DeusExCharacters.GFM_SuitSkirt'
     DrawScale=1.100000
     MultiSkins(0)=Texture'DeusExCharacters.Skins.WIBTex0'
     MultiSkins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.WIBTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.LegsTex2'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.WIBTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.WIBTex1'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.FramesTex2'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.LensesTex3'
     CollisionHeight=47.299999
	 //G-Flex: a little heavier
	 Mass=170
	 bExplodeOnDeath=True
     BindName="WIB"
     FamiliarName="Woman In Black"
     UnfamiliarName="Woman In Black"
}
