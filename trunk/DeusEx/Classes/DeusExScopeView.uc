//=============================================================================
// DeusExScopeView.
//=============================================================================
class DeusExScopeView expands Window;

#exec TEXTURE IMPORT FILE="Textures\newbin1.pcx"		NAME="newbin1"		GROUP="UserInterface" MIPS=Off

var bool bActive;		// is this view actually active?

var DeusExPlayer player;
var Color colLines;
var Bool  bBinocs;
var Bool  bViewVisible;
var int   desiredFOV;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	
	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	bTickEnabled = true;

	StyleChanged();
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	local Crosshair        cross;
	local DeusExRootWindow dxRoot;

	dxRoot = DeusExRootWindow(GetRootWindow());
	/*if (dxRoot != None)
	{
		cross = dxRoot.hud.cross;

		if (bActive)
			cross.SetCrosshair(false);
		else
			cross.SetCrosshair(player.bCrosshairVisible);
	}*/
}

// ----------------------------------------------------------------------
// ActivateView()
// ----------------------------------------------------------------------

function ActivateView(int newFOV, bool bNewBinocs, bool bInstant)
{
	local float desiredVFOV;
	
	desiredFOV = newFOV;

	bBinocs = bNewBinocs;

	if (player != None)
	{
		//G-Flex: we want to correct for aspect ratio here
		desiredFOV = class'Tools'.static.AspectCorrectHFOV(desiredFOV, 4.0000/3.0000,
			player.rootWindow.width/player.rootWindow.height);
		if (bInstant)
			player.SetFOVAngle(desiredFOV);
		else
			player.desiredFOV = desiredFOV;

		bViewVisible = True;
		Show();
	}
}

// ----------------------------------------------------------------------
// DeactivateView()
// ----------------------------------------------------------------------

function DeactivateView()
{
	if (player != None)
	{
		Player.DesiredFOV = Player.Default.DefaultFOV;
		bViewVisible = False;
		Hide();
	}
}

// ----------------------------------------------------------------------
// HideView()
// ----------------------------------------------------------------------

function HideView()
{
	if (bViewVisible)
	{
		Hide();
		Player.SetFOVAngle(Player.Default.DefaultFOV);
	}
}

// ----------------------------------------------------------------------
// ShowView()
// ----------------------------------------------------------------------

function ShowView()
{
	if (bViewVisible)
	{
		Player.SetFOVAngle(desiredFOV);
		Show();
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	local float			fromX, toX;
	local float			fromY, toY;
	local float			scopeWidth, scopeHeight;
	local float         mult, offsetX, offsetY, centerX, centerY, boxTop, boxRight, boxBottom, boxLeft;

	Super.DrawWindow(gc);

	if (GetRootWindow().parentPawn != None)
	{
		if (player.IsInState('Dying'))
			return;
	}

	//G-Flex: scale view size with resolution
	mult = height / 480.0;
	offsetX = 0.0;
	offsetY = 0.0;
	//G-Flex: consistency with AugmentationDisplayWindow's crosshair display
	centerX = int(width * 0.5)-1;
	centerY = int(height * 0.5)-1;
	// Figure out where to put everything
	if (bBinocs)
		scopeWidth  = class'Tools'.static.ceiling(512 * mult);
	else
		scopeWidth  = class'Tools'.static.ceiling(256 * mult);

	scopeHeight = class'Tools'.static.ceiling(256 * mult);
	
	fromX = class'Tools'.static.ceiling((width-scopeWidth)/2.0);
	fromY = class'Tools'.static.ceiling((height-scopeHeight)/2.0);
	
	toX   = fromX + scopeWidth;
	toY   = fromY + scopeHeight;

	// Draw the black borders
	gc.SetTileColorRGB(0, 0, 0);
	gc.SetStyle(DSTY_Normal);

	// Draw the center scope bitmap
	// Use the Header Text color 
//	gc.SetStyle(DSTY_Masked);
	if (bBinocs)
	{
		//G-Flex: Binocular crosshairs are one pixel over from the scope ones
		//G-Flex: because the original devs hate me
		offsetX = -1.0;
		offsetY = -1.0;
		
		if ( Player.Level.NetMode == NM_Standalone )	// Only block out screen real estate in single player
		{
			//G-Flex: changed a bit to account for buggy behavior of binoc view textures
			gc.DrawPattern(0, 0, width, fromY, 0, 0, Texture'Solid');
			gc.DrawPattern(0, toY + (offsetY*2), width, fromY - (offsetY*2), 0, 0, Texture'Solid');
			gc.DrawPattern(0, fromY + offsetY, fromX, scopeHeight, 0, 0, Texture'Solid');
			gc.DrawPattern(toX + (offsetX*2), fromY + offsetY, fromX - (offsetX*2), scopeHeight, 0, 0, Texture'Solid');
		}
		Player.ClientMessage(int(scopeWidth/2.0) $ " x " $ scopeHeight);
		gc.SetStyle(DSTY_Modulated);
		//G-Flex: Stretch it!
		//G-Flex: Note that this texture acts slightly bugged-out when stretched if using the game's original D3D renderer
		//G-Flex: some offsets changed below to account for this when noted, so the black bars will overlap slightly
		gc.DrawStretchedTexture(fromX + offsetX,
		 fromY + offsetY, int(scopeWidth / 2.0), scopeHeight, 0, 0, 256, 256, Texture'HUDBinocularView_1');
		gc.DrawStretchedTexture(fromX + offsetX + int(scopeWidth / 2.0),
		 fromY + offsetY, int(scopeWidth / 2.0), scopeHeight, 0, 0, 256, 256, Texture'HUDBinocularView_2');
		gc.SetTileColor(colLines);
		gc.SetStyle(DSTY_Masked);		
		//G-Flex: I'M SORRY
		//G-Flex: I'M SO VERY SORRY FOR THIS ;_____;
		//G-Flex: replicate a scaled 1px-wide version of the binocular crosshair texture
		//G-Flex: scaling the texture itself looks really really bad, and also awful
		//gc.DrawTexture(fromX,       fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularCrosshair_1');
		//gc.DrawTexture(fromX + 256, fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularCrosshair_2');
		boxTop = centerY-int(29*mult);
		boxBottom = centerY+int(29*mult);
		boxLeft = centerX-int(57*mult);
		boxRight = centerX+int(57*mult);
		//G-Flex: center box
		gc.DrawBox(boxLeft, boxTop, int(57*mult)*2.0 + 1, int(29*mult)*2.0 + 1, 0, 0, 1, Texture'Solid');
		//G-Flex: thing at left side of box
		gc.DrawBox(boxLeft+2, boxTop+2, 1, (boxBottom-centerY-2) * 2.0 + 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft+2, boxTop+2, 3, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft+2, centerY-int(14*mult), 2, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft+2, centerY, 2, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft+2, centerY+int(15*mult), 2, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft+2, boxBottom-2, 3, 1, 0, 0, 1, Texture'Solid');
		//G-Flex: top vertical thing
		gc.DrawBox(centerX-1, boxTop - int(61*mult), 3, int(32*mult), 0, 0, 1, Texture'Solid');
		gc.DrawBox(centerX, boxTop - int(61*mult), 1, int(61*mult), 0, 0, 1, Texture'Solid');
		gc.DrawBox(centerX-1, boxTop - int(20*mult), 3, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(centerX-1, boxTop - int(11*mult), 3, 1, 0, 0, 1, Texture'Solid');
		//G-Flex: bottom vertical thing
		gc.DrawBox(centerX-1, boxBottom + int(29*mult), 3, int(28*mult), 0, 0, 1, Texture'Solid');
		gc.DrawBox(centerX, boxBottom, 1, int(56*mult), 0, 0, 1, Texture'Solid');
		gc.DrawBox(centerX-1, boxBottom + int(11*mult), 3, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(centerX-1, boxBottom + int(19*mult), 3, 1, 0, 0, 1, Texture'Solid');
		//G-Flex: left horizontal thing
		gc.DrawBox(boxLeft-int(176*mult), centerY-1, int(98*mult), 3, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft-int(176*mult), centerY, int(176*mult), 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft-int(62*mult), centerY-1, 1, 3, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft-int(46*mult), centerY-1, 1, 3, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft-int(31*mult), centerY-1, 1, 3, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxLeft-int(16*mult), centerY-1, 1, 3, 0, 0, 1, Texture'Solid');
		//G-Flex: right horizontal thing
		gc.DrawBox(boxRight+int(176*mult) - int(98*mult)+1, centerY-1, int(98*mult), 3, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxRight+1, centerY, int(176*mult), 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxRight+int(16*mult), centerY - 1, 1, 3, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxRight+int(31*mult), centerY - 1, 1, 3, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxRight+int(46*mult), centerY - 1, 1, 3, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxRight+int(62*mult), centerY - 1, 1, 3, 0, 0, 1, Texture'Solid');
	}
	else
	{
		// Crosshairs - Use new scope in multiplayer, keep the old in single player
		if ( Player.Level.NetMode == NM_Standalone )
		{
			gc.DrawPattern(0, 0, width, fromY + offsetY, 0, 0, Texture'Solid');
			gc.DrawPattern(0, toY + offsetY, width, fromY - offsetY, 0, 0, Texture'Solid');
			gc.DrawPattern(0, fromY + offsetY, fromX + offsetX, scopeHeight, 0, 0, Texture'Solid');
			gc.DrawPattern(toX + offsetX, fromY + offsetY, fromX - offsetX, scopeHeight, 0, 0, Texture'Solid');

			//G-Flex: same stuff as with the binoculars, although this one's texture doesn't appear buggy
			gc.SetStyle(DSTY_Modulated);
			//gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView');
			gc.DrawStretchedTexture(fromX + offsetX, fromY + offsetY, scopeWidth, scopeHeight,
			 0, 0, 256, 256, Texture'HUDScopeView');
			gc.SetTileColor(colLines);
			gc.SetStyle(DSTY_Masked);
			//gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeCrosshair');
			gc.DrawStretchedTexture(fromX, fromY, scopeWidth, scopeHeight,
			 0, 0, 256, 256, Texture'HUDScopeCrosshair');
		}
		else
		{
			if ( WeaponRifle(Player.inHand) != None )
			{
				gc.SetStyle(DSTY_Modulated);
				gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView3');
			}
			else
			{
				gc.SetStyle(DSTY_Modulated);
				gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView2');
			}
		}
	}
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colLines = theme.GetColorFromName('HUDColor_HeaderText');
}

defaultproperties
{
}
