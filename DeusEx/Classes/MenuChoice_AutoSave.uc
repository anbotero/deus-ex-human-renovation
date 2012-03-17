//=============================================================================
// Total new Autosave Option by DX_Blaster 
// initial version: 1.0 Aug 12 2011
// 'bAutoSave' is a new Global variable, stored in the User.ini
//=============================================================================

//=============================================================================
// MenuChoice_AutoSave
//=============================================================================

class MenuChoice_AutoSave extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bAutoSave));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bAutoSave = !bool(GetValue());
}

// ----------------------------------------------------------------------
// -------------------------------	---------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bAutoSave));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If set to Enabled, the game will be saved each time the player travels to another map."
     actionText="Autosave |&Game"
}
