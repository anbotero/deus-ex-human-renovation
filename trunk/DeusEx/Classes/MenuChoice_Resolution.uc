//=============================================================================
// MenuChoice_Resolution
//=============================================================================

class MenuChoice_Resolution extends MenuUIChoiceEnum;

var string CurrentRes;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	// Get a pointer to the player.  Need to do this here since we 
	// need access to player in GetScreenResolutions() before 
	// we can call Super.InitWindow().

	player = DeusExPlayer(GetRootWindow().parentPawn);

	GetScreenResolutions();

	Super.InitWindow();
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	local int choiceIndex;
	local int currentChoice;

	currentChoice = 0;

	for(choiceIndex=0; choiceIndex<arrayCount(enumText); choiceIndex++)
	{
		if (enumText[choiceIndex] == "")	
			break;

		if (enumText[choiceIndex] == CurrentRes)
		{
			currentChoice = choiceIndex;
			break;
		}
	}

	SetValue(currentChoice);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------
//G-Flex: modified to change FOV
function SaveSetting()
{
	local String resText;
	local float oldFOV, newFOV, oldDefaultFOV, newDefaultFOV, oldAspect, newAspect;

	// Only attempt to change resolutions if the resolution has 
	// actually changed.
	resText = enumText[GetValue()];

	if ( resText != player.ConsoleCommand("GetCurrentRes") )
	{
		oldFOV = player.DesiredFOV;
		oldDefaultFOV = player.Default.DefaultFOV;
		oldAspect = player.rootWindow.width/player.rootWindow.height;
		player.ConsoleCommand("SetRes " $ resText);

		newAspect = player.rootWindow.width/player.rootWindow.height;
		newFOV = class'Tools'.static.AspectCorrectHFOV(oldFOV, oldAspect, newAspect);
		newDefaultFOV = class'Tools'.static.AspectCorrectHFOV(oldDefaultFOV, oldAspect, newAspect);
		
		player.DefaultFOV = newDefaultFOV;
		player.DesiredFOV = newFOV;
		player.SetFOVAngle(newFOV);
		player.default.DefaultFOV = newDefaultFOV;
		player.default.desiredFOV = newDefaultFOV;
	}
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	// Reset to the current resolution
	LoadSetting();
}

// ----------------------------------------------------------------------
// GetScreenResolutions()
//
// Called when the user selects a new rendering device.  Looks
// through the list of rendering devices and updates the 
// MenuChoices[] array with the available resolutions.
//
// Does not allow resolutions under 640x480 to be selected.
// ----------------------------------------------------------------------

function GetScreenResolutions()
{
	local int p;
	local int resX;
	local int resWidth, resHeight;
	local int choiceCount;
	local string ParseString;
	local string Resolutions[48];
	local string AvailableRes;
	local string resString;
	local int resNum;

	CurrentRes   = player.ConsoleCommand("GetCurrentRes");
	AvailableRes = player.ConsoleCommand("GetRes");

	resNum = 0;
	choiceCount = 0;
	ParseString = AvailableRes;

	p = InStr(ParseString, " ");
	resString = Left(ParseString, p);

	while ( ResNum < ArrayCount(Resolutions) ) 
	{
		// Only support resolutions >= 640x480
		resX = InStr(resString,"x");
		resWidth = int(Left(resString, resX));
		//G-Flex: make sure it's at least as tall as 480 too, dummy
		resHeight = int(Right(resString, (Len(resString) - resX - 1)));

		if (( resWidth >= 640 ) && ( resHeight >= 480 ))
		{
			enumText[choiceCount] = resString;
			choiceCount++;
		}
		if ( p == -1 ) 
			break;

		ParseString = Right(ParseString, Len(ParseString) - p - 1);
		p = InStr(ParseString, " ");

		if ( p != -1 )
			resString = Left(ParseString, p);
		else
			resString = ParseString;

		ResNum++;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="Change the video resolution"
     actionText="|&Screen Resolution"
}
