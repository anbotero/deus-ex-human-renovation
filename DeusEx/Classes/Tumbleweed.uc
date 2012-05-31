//=============================================================================
// Tumbleweed.
//=============================================================================
class Tumbleweed extends Trash;

function bool Facelift(bool bOn)
{
	if(!Super.Facelift(bOn))
		return false;

	if(bOn)
		Mesh = mesh(DynamicLoadObject("HDTPDecos.HDTPTumbleWeed", class'mesh', True));

	if(Mesh == None || !bOn)
		Mesh = Default.Mesh;

	return true;
}

defaultproperties
{
     //G-Flex: so it doesn't burn as quickly, was default of 20
     HitPoints=10
     bFlammable=true
     ItemName="Tumbleweed"
     Mesh=LodMesh'DeusExDeco.Tumbleweed'
     CollisionRadius=33.000000
     CollisionHeight=21.570000
}
