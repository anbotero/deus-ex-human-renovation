//=============================================================================
// Mission11.
//=============================================================================
class Mission11 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local Mechanic mech;

	Super.FirstFrame();

	if (localURL == "11_PARIS_EVERETT")
	{
		if (!flags.GetBool('Ray_Neutral') && !flags.GetBool('Ray_Dead'))
		{
			foreach AllActors(class'Mechanic', mech)
			{
				mech.bLikesNeutral = False;
				flags.SetBool('Ray_Neutral', True);
			}
		}
	}
	
	//DX_Blaster: only Autosave if intended (->check User.ini setting)
	if (Player.bAutoSave)
	{
		if (dxInfo != None && !(player.IsInState('Dying')) && !(player.IsInState('Paralyzed')) && !(player.IsInState('Interpolating')) && 
		player.dataLinkPlay == None && Level.Netmode == NM_Standalone)
			player.SaveGame(-3, "Auto Save"); //Lork: Autosave after loading a new map... this saves lives!
	}
}

// ----------------------------------------------------------------------
// PreTravel()
// 
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------

function PreTravel()
{
	Super.PreTravel();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	local TobyAtanwe toby;
	local GuntherHermann gunther;
	local BlackHelicopter chopper;
	local AlexJacobson alex;
	local WaltonSimons walton;
	local Mechanic mech;
	local MechanicCarcass mechcarc;
	local Barrel1 barrel;
	local Rotator rot;
	local int i;
	
	Super.Timer();

	if (localURL == "11_PARIS_UNDERGROUND")
	{
		// unhide Toby Atanwe
		if (flags.GetBool('templar_upload') &&
			!flags.GetBool('MS_TobyUnhidden'))
		{
			foreach AllActors(class'TobyAtanwe', toby)
				toby.EnterWorld();

			flags.SetBool('MS_TobyUnhidden', True,, 12);
		}

		// knock out the player and teleport him after this convo
		if (flags.GetBool('MeetTobyAtanwe_Played') &&
			!flags.GetBool('MS_PlayerTeleported'))
		{
			flags.SetBool('MS_PlayerTeleported', True,, 12);
			Level.Game.SendPlayer(Player, "11_PARIS_EVERETT?Difficulty="$Player.combatDifficulty);
		}
	}
	else if (localURL == "11_PARIS_EVERETT")
	{
		// unhide the helicopter
		if (flags.GetBool('MeetEverett_Played') &&
			!flags.GetBool('MS_ChopperUnhidden'))
		{
			foreach AllActors(class'BlackHelicopter', chopper)
				chopper.EnterWorld();

			flags.SetBool('MS_ChopperUnhidden', True,, 12);
		}

		// unhide Alex Jacobson
		if (flags.GetBool('AtanweAtEveretts_Played') &&
			!flags.GetBool('MS_AlexUnhidden'))
		{
			foreach AllActors(class'AlexJacobson', alex)
				alex.EnterWorld();

			flags.SetBool('MS_AlexUnhidden', True,, 12);
		}
		
		//G-Flex: move mechanic body as in Shifter
		if(!flags.GetBool('Mechanic_Body_Moved') && !flags.GetBool('Ray_Dead'))
		{
			foreach AllActors(class'MechanicCarcass', mechcarc)
			{
				mechcarc.SetLocation(vect(964.80, 2535.09, 1083.10));
				rot.Yaw = 16383;
				mechcarc.SetRotation(rot);
				flags.SetBool('Mechanic_Body_Moved',True);
			}

			//== After we've moved the body, let's give it some cover
			barrel = Spawn(class'Barrel1',,, vect(924.90, 2482.466, 1103.00));
			barrel.SkinColor = SC_FlammableLiquid;

			barrel = Spawn(class'Barrel1',,, vect(885.90, 2482.466, 1103.00));
			barrel.SkinColor = SC_FlammableLiquid;

			barrel = Spawn(class'Barrel1',,, vect(970.38, 2462.466, 1103.00));
			barrel.SkinColor = SC_FlammableLiquid;
			
		}		

		// set a flag
		if (flags.GetBool('Ray_Dead') &&
			!flags.GetBool('MS_RayDead'))
		{
			Player.GoalCompleted('KillMechanic');
			flags.SetBool('MS_RayDead', True,, 12);
		}
	}
	else if (localURL == "11_PARIS_CATHEDRAL")
	{
		// kill Gunther after a convo
		if (flags.GetBool('M11MeetGunther_Played') &&
			flags.GetBool('KillGunther') &&
			!flags.GetBool('MS_GuntherKilled'))
		{
			foreach AllActors(class'GuntherHermann', gunther)
			{
				gunther.bInvincible = False;
				gunther.HealthTorso = 0;
				gunther.Health = 0;
				gunther.GotoState('KillswitchActivated');
				flags.SetBool('GuntherHermann_Dead', True,, 0);
				flags.SetBool('MS_GuntherKilled', True,, 12);
			}
		}

		// unhide Walton Simons
		if (flags.GetBool('templar_upload') &&
			flags.GetBool('M11NearWalt') &&
			!flags.GetBool('MS_M11WaltAppeared'))
		{
			foreach AllActors(class'WaltonSimons', walton)
				walton.EnterWorld();

			flags.SetBool('MS_M11WaltAppeared', True,, 12);
		}

		// hide Walton Simons
		if (flags.GetBool('M11WaltonHolo_Played') &&
			!flags.GetBool('MS_M11WaltRemoved'))
		{
			foreach AllActors(class'WaltonSimons', walton)
				walton.LeaveWorld();

			flags.SetBool('MS_M11WaltRemoved', True,, 12);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
