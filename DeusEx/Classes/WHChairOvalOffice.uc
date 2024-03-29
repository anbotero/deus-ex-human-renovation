//=============================================================================
// WHChairOvalOffice.
//=============================================================================
class WHChairOvalOffice extends Seat;

function bool Facelift(bool bOn)
{
	if(!Super.Facelift(bOn))
		return false;

	if(bOn)
		Mesh = mesh(DynamicLoadObject("HDTPDecos.HDTPWHChairOvalOffice", class'mesh', True));

	if(Mesh == None || !bOn)
		Mesh = Default.Mesh;

	return true;
}

defaultproperties
{
     bFlammable=false
     sitPoint(0)=(X=0.000000,Y=0.000000,Z=0.000000)
     ItemName="Leather Chair"
     Mesh=LodMesh'DeusExDeco.WHChairOvalOffice'
     CollisionRadius=29.000000
     CollisionHeight=33.810001
     Mass=40.000000
     Buoyancy=20.000000
}
