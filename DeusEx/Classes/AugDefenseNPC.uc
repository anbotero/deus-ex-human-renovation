//=============================================================================
// AugDefenseNPC.
// G-Flex: Terrible hack so that Walton Simons can get his Aggressive Defense
// G-Flex: mostly just a simplified version of the parent class
//=============================================================================
class AugDefenseNPC extends AugDefense;

//G-Flex: Active should be the default state since we're on an NPC
auto state Active
{
	function Timer()
	{
		local DeusExProjectile minproj;
		local float mindist;

		minproj = None;

		//G-Flex: sanity checks I guess
		if ((Owner == None) || (!Owner.IsA('ScriptedPawn')))
		{
		 Destroy();
		 return;
		}

		//G-Flex: don't bother playing sounds at all
		//if ( (Level.NetMode != NM_Standalone) && ( Level.Timeseconds > defenseSoundTime ))
		//{
		//	Player.PlaySound(Sound'AugDefenseOn', SLOT_Interact, 1.0, ,(LevelValues[CurrentLevel]*1.33), 0.75);
		//	defenseSoundTime = Level.Timeseconds + defenseSoundDelay;
		//}

		//DEUS_EX AMSD Exported to function call for duplication in multiplayer.
		minproj = FindNearestProjectile();

		// if we have a valid projectile, send it to the aug display window
		if (minproj != None)
		{
			mindist = VSize(Owner.Location - minproj.Location);

			// play a warning sound
			Owner.PlaySound(sound'GEPGunLock', SLOT_None,,,, 2.0);

			if (mindist < LevelValues[CurrentLevel])
			{
            	minproj.bAggressiveExploded=True;
				minproj.Explode(minproj.Location, vect(0,0,1));
				minproj.PlaySound(sound'ProdFire', SLOT_None,,,, 2.0);
			}
		}
	}

Begin:
	//G-Flex: don't check quite as often for NPCs
	SetTimer(0.15, True);
}

function Deactivate()
{
	//G-Flex: should never be deactivated
}

function Activate()
{
	//G-Flex: should never have to do this either
}

// ------------------------------------------------------------------------------
// FindNearestProjectile()
// DEUS_EX AMSD Exported to a function since it also needs to exist in the client
// TriggerDefenseAugHUD;
// ------------------------------------------------------------------------------

simulated function DeusExProjectile FindNearestProjectile()
{
   local DeusExProjectile proj, minproj;
   local float dist, mindist, checkdist;
   local bool bValidProj;

   minproj = None;
   //G-Flex: lower this so stuff really far away won't be tracked
   //G-Flex: don't check as far as players do
   mindist = LevelValues[CurrentLevel] * 5.0;
   checkdist = mindist;
   //G-Flex: use RadiusActors instead of AllActors
   foreach RadiusActors(class'DeusExProjectile', proj, checkdist, Owner.Location)
   {

	//== Y|y: Don't overcomplicate things.  The bIgnoresNanoDefense variable does a fine and dandy job in singleplayer too
	//==  We also should ignore placed grenades, indicated by the bStuck variable
//      if (Level.NetMode != NM_Standalone)
         bValidProj = !proj.bIgnoresNanoDefense && !proj.bStuck;
//      else
//         bValidProj = (!proj.IsA('Cloud') && !proj.IsA('Tracer') && !proj.IsA('GreaselSpit') && !proj.IsA('GraySpit'));

      if (bValidProj)
      {
         // make sure we don't own it
		 //G-Flex: and that it's owned by something, and that something is someone
         if ((proj.Owner != None) && (proj.Owner != Owner) && (proj.Owner.IsA('Pawn')))
         {
			//G-Flex: make sure the owner is a valid enemy
			if (ScriptedPawn(Owner).IsValidEnemy(Pawn(proj.Owner)))
			{
				// make sure it's moving fast enough
				if (VSize(proj.Velocity) > 100)
				{
				   dist = VSize(Owner.Location - proj.Location);
				   //G-Flex: also make sure there isn't level geometry in the way
				   //G-Flex: do this check after the others because it's slow
				   if ((dist < mindist) && FastTrace(proj.Location, Owner.Location))
				   {
					  mindist = dist;
					  minproj = proj;
				   }
				}
			}
         }
      }
   }

   return minproj;
}

/*// ------------------------------------------------------------------------------
// TriggerDefenseAugHUD()
// ------------------------------------------------------------------------------

simulated function TriggerDefenseAugHUD()
{
   local DeusExProjectile minproj;
   
   minproj = None;
      
   minproj = FindNearestProjectile();
   
   // if we have a valid projectile, send it to the aug display window
   // That's all we do.
   if (minproj != None)
   {
      SetDefenseAugStatus(True,CurrentLevel,minproj);      
   }
}

simulated function Tick(float DeltaTime)
{
   Super.Tick(DeltaTime);

   // DEUS_EX AMSD Make sure it gets turned off in multiplayer.
   if (Level.NetMode == NM_Client)
   {
      if (!bDefenseActive)
         SetDefenseAugStatus(False,CurrentLevel,None);
   }
}

// ------------------------------------------------------------------------------
// SetDefenseAugStatus()
// ------------------------------------------------------------------------------
simulated function SetDefenseAugStatus(bool bDefenseActive, int defenseLevel, DeusExProjectile defenseTarget)
{
   if (Player == None)
      return;
   if (Player.rootWindow == None)
      return;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.bDefenseActive = bDefenseActive;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.defenseLevel = defenseLevel;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.defenseTarget = defenseTarget;

}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
		defenseSoundTime=0;
	}
}*/

defaultproperties
{
     LevelValues(0)=160.000000
     LevelValues(1)=320.000000
     LevelValues(2)=480.000000
     LevelValues(3)=800.000000
}
