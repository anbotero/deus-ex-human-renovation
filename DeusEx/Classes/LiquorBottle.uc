//=============================================================================
// LiquorBottle.
//=============================================================================
class LiquorBottle extends DeusExPickup;

function bool Facelift(bool bOn)
{
	if(!Super.Facelift(bOn))
		return false;

	if(bOn)
		Mesh = mesh(DynamicLoadObject("HDTPItems.HDTPLiquorBottle", class'mesh', True));

	if(Mesh == None || !bOn)
	{
		Texture = None;
		Mesh = Default.Mesh;
		PlayerViewMesh = Default.PlayerViewMesh;
		PickupViewMesh = Default.PickupViewMesh;
		ThirdPersonMesh = Default.ThirdPersonMesh;
	}
	else
	{
		PlayerViewMesh = Mesh;
		PickupViewMesh = Mesh;
		ThirdPersonMesh = Mesh;
		Texture = Texture(DynamicLoadObject("HDTPItems.Skins.HDTPLiquorBottletex2", class'Texture'));
	}

	return true;
}

state Activated
{
	function Activate()
	{
		// can't turn it off

	}

	function BeginState()
	{
		local DeusExPlayer player;
		
		Super.BeginState();

		player = DeusExPlayer(Owner);
		if (player != None)
		{
			player.HealPlayer(2, False);
			player.drugEffectTimer += 5.0;
		}

		UseOnce();
	}
Begin:
}

defaultproperties
{


     bBreakable=True
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Liquor"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.LiquorBottle'
     PickupViewMesh=LodMesh'DeusExItems.LiquorBottle'
     ThirdPersonMesh=LodMesh'DeusExItems.LiquorBottle'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconLiquorBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconLiquorBottle'
     largeIconWidth=20
     largeIconHeight=48
     Description="The label is torn off, but it looks like some of the good stuff."
     beltDescription="LIQUOR"
     Mesh=LodMesh'DeusExItems.LiquorBottle'
     CollisionRadius=4.620000
     CollisionHeight=12.500000
     Mass=10.000000
     Buoyancy=8.000000
}
