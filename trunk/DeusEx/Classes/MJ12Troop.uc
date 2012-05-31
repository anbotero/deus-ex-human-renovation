//=============================================================================
// MJ12Troop.
//=============================================================================
class MJ12Troop extends HumanMilitary;

function AdjustProperties()
{
	//1.600000 instead of 2.000000
	SurprisePeriod *= 0.800000;
	//0.400000 instead of 0.500000
	attackPeriod *= 0.800000;
	//3.600000 instead of 4.500000
	maxAttackPeriod *= 0.800000;
	//0.008000 instead of 0.010000
	VisibilityThreshold *= 0.800000;
	//0.120000 instead of 0.150000
	HearingThreshold *= 0.800000;
}

defaultproperties
{
     CarcassType=Class'DeusEx.MJ12TroopCarcass'
     WalkingSpeed=0.296000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     walkAnimMult=0.780000
     GroundSpeed=200.000000
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.SkinTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.MJ12TroopTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MJ12TroopTex2'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.SkinTex1'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.MJ12TroopTex3'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.MJ12TroopTex4'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="MJ12Troop"
     FamiliarName="MJ12 Troop"
     UnfamiliarName="MJ12 Troop"
}
