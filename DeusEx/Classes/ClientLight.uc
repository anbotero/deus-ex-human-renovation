//=============================================================================
// ClientLight
//=============================================================================
class ClientLight extends Light;

defaultproperties
{
     RemoteRole=ROLE_None
	 bOnlyOwnerSee=True
	 //G-Flex: rest mostly from Beam.uc
	 bStatic=False
     bHidden=False
     bNoDelete=False
     bMovable=True
     LightEffect=LE_NonIncidence
     LightBrightness=250
     LightHue=70
     LightSaturation=1
     LightRadius=7
     LightPeriod=0
}