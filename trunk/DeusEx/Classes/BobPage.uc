//=============================================================================
// BobPage.
//=============================================================================
class BobPage extends HumanMilitary;

function AdjustProperties()
{
	//G-Flex: as if it matters

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
}

function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation,
                            Vector offset, Name damageType)
{
	if ((damageType == 'Stunned') || (damageType == 'KnockedOut'))
		return 0;
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
     CarcassType=Class'DeusEx.BobPageCarcass'
     WalkingSpeed=0.213333
     bImportant=True
     GroundSpeed=180.000000
     Mesh=LodMesh'DeusExCharacters.GM_Suit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.BobPageTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.BobPageTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.BobPageTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.BobPageTex1'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.BobPageTex1'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'DeusExItems.Skins.BlackMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="BobPage"
     FamiliarName="Bob Page"
     UnfamiliarName="Bob Page"
}
