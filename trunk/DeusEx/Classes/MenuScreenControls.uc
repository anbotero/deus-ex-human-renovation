//=============================================================================
// MenuScreenControls
// modified for new Autosave option by DX_Blaster
// initial version: 1.0 Aug 12, 2011 
// latest version: 1.02 Aug 21, 2011
//=============================================================================

class MenuScreenControls expands MenuUIScreenWindow;

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	Super.SaveSettings();
	player.SaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
//	 new Autosave option
     choices(0)=Class'DeusEx.MenuChoice_AutoSave'
	 choices(1)=Class'DeusEx.MenuChoice_AlwaysRun'
     choices(2)=Class'DeusEx.MenuChoice_ToggleCrouch'
     choices(3)=Class'DeusEx.MenuChoice_InvertMouse'
     choices(4)=Class'DeusEx.MenuChoice_MouseSensitivity'
	 actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Controls"
     ClientWidth=537
//	 ClientHeight=228	
// 	 DX_BLaster: new Windows dimension [ClientHight +36]
	 ClientHeight=264
     
//	 clientTextures(0)=Texture'DeusExUI.UserInterface.MenuControlsBackground_1'
//	 clientTextures(1)=Texture'DeusExUI.UserInterface.MenuControlsBackground_2'
//	 clientTextures(2)=Texture'DeusExUI.UserInterface.MenuControlsBackground_3'
	
//	 DX_Blaster: new Menu Contols UI has now 6 parts
	 clientTextures(0)=Texture'DeusEx.UserInterface.NewMenuControlsBackground_1'		
     clientTextures(1)=Texture'DeusEx.UserInterface.NewMenuControlsBackground_2'		
     clientTextures(2)=Texture'DeusEx.UserInterface.NewMenuControlsBackground_3'		
	 clientTextures(3)=Texture'DeusEx.UserInterface.NewMenuControlsBackground_4'		
     clientTextures(4)=Texture'DeusEx.UserInterface.NewMenuControlsBackground_5'		
     clientTextures(5)=Texture'DeusEx.UserInterface.NewMenuControlsBackground_6'		
     
//	 textureRows=1 
// 	 DX_BLaster: additional row for new UI
	 textureRows=2
     
//	 helpPosY=174	
//	 DX_Blaster: lowerd helptext line [helpPosY +54]
	 helpPosY=210
}
