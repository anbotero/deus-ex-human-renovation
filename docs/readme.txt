﻿╒═════════════════════════════════════════════════════╕

               Deus Ex: HUMAN RENOVATION

                         v1.0

   http://code.google.com/p/deus-ex-human-renovation
╘═════════════════════════════════════════════════════╛

╒────────────╕
│INTRODUCTION│
╘────────────╛
	Hello, friends! Recently, I, like some of you, decided to play Deus Ex again afters years of having not touched it. As with most easily-modded (and not so easily-modded!) games of similar age, there have been several people who have worked on improving, fixing, buffing, delousing, upgrading, and reworking various aspects of the game. Unfortunately, there was nothing close to an "unofficial patch" (that is, one which fixes problems with the game without making many changes to content) except for "Deus Ex 2.0", a project which was, unfortunately, seeing little work. I downloaded its source, learned how to compile it, and started to figure out how to implement other bugfixes and changes as I saw fit. I ended up noticing many, many, many more issues, mostly minor, as I went along, and attempted to fix them as I saw them.
	In short, this mod fixes many strange bugs, quirks, and balance issues in Deus Ex, many of which have been fixed in other mods and many of which have not, without significantly altering much of the game's content. The goal is to improve upon the original game without changing its flavor much. Much of the new code is mine, and much of it comes from Shifter and Deus Ex 2.0.
	Special thanks to Y|yukichigai and Lork for their work on Shifter and Deus Ex 2.0, to Kentie for his DX10 renderer and replacement DeusEx.exe, to whoever is responsible for Deus Ex Enhanced (judging by code comments, he's "DJ", so let's go with that), to all those responsible for creating Deus Ex in the first place, and to the players who still care about this game. Extra special thanks to my girlfriend for putting up with me futzing around with this at 5:30 AM instead of going to bed. Extra super special thanks to Corporal Collins on the Liberty Island dock, for being such an incredibly good sport no matter how many times he was shot, stabbed, set on fire, bludgeoned, blown up, drowned, shocked, burnt, erased from existence, knocked out, poisoned, killed, or otherwise inconvenienced by me in order to ensure the proper functioning of this mod.

╒────────────╕
│INSTALLATION│
╘────────────╛
	First, make sure you have the Deus Ex v1112fm patch installed. This is very important, and make sure you install the right one! v1112fm is the multiplayer patch; the singleplayer-only patch won't work.
	Second, install Kentie's new Deus Ex executable (http://kentie.net/article/dxguide/) from which to run the game. This isn't strictly necessary, but you'll need it for the widescreen fixes to work or make sense, and to have the proper field-of-vision, plus it fixes other problems and there's just no reason not to. You might also want to check out his DirectX 10 renderer, if you're on Windows Vista or Windows 7, but it's in no way necessary to run this mod.
	Third, go to the "System" folder of your Deus Ex install directory (most likely C:\DeusEx\System, but may be elsewhere; if you have the Steam version it's probably in "C:\Program Files\Steam\steamapps\common\deusex\System"). Back up the files "DeusEx.u" and "DeusEx.int" (that's ".int", not ".ini"), and replace them with the ones in this package. I recommend backing up the originals in case you want to play original Deus Ex, which would require swapping the files back in and replacing those of this package.

╒────────────────╕
│SOURCE/COMPILING│
╘────────────────╛
	I give permission to use any of my code in other projects so long as this readme file is included and you specify, at least to some degree, how much of my code you used and which parts. Bear in mind that this mod has some code from both Deus Ex 2.0 and Shifter, which may have other stipulations regarding the use of their code.
	The source code itself may be found on the same Google Code project site as given at the top of this file. I've also included Shifter's compile instructions file; the instructions in it should work fine for this mod as well.



╒─────────────────────────────────────────╕
│                                         │
│           SUMMARY OF CHANGES            │
│                                         │
╘─────────────────────────────────────────╛

╒─────────╕
│BUG-FIXES│
╘─────────╛
(present in Deus Ex, Deus Ex 2.0, Deus Ex Enhanced, and/or Shifter)
+ The only-one-of-each melee weapon code was letting you have two at once if the first was from a corpse, because the game tried to give you ammo for it and that screwed up the conditionals. Fixed by making it not set the ammo pickup to a positive number unless the default ammo pickup for that weapon is above zero.
+ Stopped fire extinguishers from continuing to spray even if you've dropped it or taken it out of your hand. Now, no matter why the extinguisher gets deactivated (or leaves your hand), it disappears as if it had run down, and the spray stops. Also, Shifter increased the lifespan of the extinguisher when active, but forgot to increase the spray generator lifespan as well, so it didn't work right (I fixed it so it works more or less as Shifter intended). I also made the spray actually face where you're pointed, instead of always straight forward.
+ Fixed a divide-by-zero issue and an probably-accidental rounding-to-integer in the standing-still accuracy-bonus code. Having Master skill no longer drops your reticle down to the minimum value after a literal instant of standing still.
+ Fixed a minor off-by-one-pixel problem in the targeting reticle drawing code, and cast a certain variable to an integer instead of a float so it gives more consistent results. This is something you probably would have never noticed.
+ Decorations no longer take damage from the HalonGas damage type. Not that it ever really matters, since fire extinguishers don't cause damage, but asphyxiating vapors probably shouldn't break crates or blow up TNT.
+ The vision augmentation and tech goggles would attempt to overwrite each other's effects. You now get the best effects from either if both are on, and the other still functions if you shut one off.
+ Fixed another vision aug/goggles where traveling between missions wouldn't properly keep track of whether or not your vision enhancements should be on, leading to situations such as the aug being made completely nonfunctional if you travel while it's activated.
+ Fixed a bug caused by Shifter's drug-timer travel-persistence fix where it wouldn't be properly reset when starting a new game.
+ Fixed Shifter's "idle drain" for the healing aug. It was supposed to reduce the energy drain of the aug by 90%, but due to a problem with integer division, it didn't work, but it does now.
+ Plasma bolt projectiles are no longer affected by Aggressive Defense. This seems to have been fixed in Deus Ex 2.0 but isn't part of their fixes file.
+ No more bullet sparks on people or animals (or precisely: Any ScriptedPawns except Robots).
+ A Deus Ex 2.0 change that allowed on-hit effects (like ricochet sparks) caused rock chips to spawn when shooting things like animals, people, robots, computers, etc. Now it only affects level geometry.
+ Decorations no longer take damage from the riot prod unless they're explosive. Yes, I consider zapping a wooden crate until it explodes a "bug".
+ Used a new method for DXE's aspect-ratio correction, because DXE's doesn't account for ratios that aren't exactly the common ones it expects, and is otherwise inefficient and overcomplicated.
+ Fixed bug where activating an aug from a custom key would turn the aug on even if your power was already depleted. The aug would still deactivate a frame or two later because you're out of energy, but you could still, say, get a quick flash of light out of your light aug.

╒───────╕
│CORPSES│
╘───────╛
+ Bodies of those who burn to death get only roughly 3/4 of their corpse-health knocked off instead of all but a single point (instagibbing burnt bodies with the crowbar is weird, if funny). Also, this drop doesn't occur unless they were already on fire or killed by something that would set them on fire, so killing someone with a flare dart no longer turns their bodies all dark and burnt and easily gibbed.
+ If you KO an NPC while he's on fire, he'll be dead instead of unconscious now.
+ Weapons on corpses used to give you 1-4 ammo no matter the weapon. Now they give between 1 and either 4 or half the standard ammo pickup for the weapon, whichever is higher (so weapons with a default pickup of 8 or below are unaffected). This most importantly affects the high-capacity weapons like pepper guns, assault rifles, and flamethrowers.
+ Removed NPC death sounds for unconscious enemies that were implemented by Lork for Deus Ex 2.0. It seemed silly to me that an unconscious enemy would scream when killed or drowned, especially since they don't make sounds when damaged. Unconscious dudes don't scream.

╒─────────────╕
│HEALTH/DAMAGE│
╘─────────────╛
+ For some bizarre reason, headshots (normally four times the damage of torso/limb shots) were treated as HALF the damage of torso/limb shots if the damage type is nonlethal ("Stunned" and "KnockedOut"). Changed it so these attacks are 150% the damage of torso/limb shots, so it's actually preferable to baton the guys in the head instead of vice-versa, but the bonus isn't quite as great as lethal headshots.
+ Very low head health impacts accuracy more, starting at 25% health with another penalty at 10%. These penalties are equal to the low-but-still-intact arm health penalties (but at lower health thresholds), so they aren't a huge deal. I just found it strange that having massive, near-death head wounds didn't seriously impact your ability to aim a firearm.
+ Very low torso health (<25%) impacts movement speed more, but not nearly as much as low leg health. Again, this shouldn't be a very significant change, but at least now you might notice it.

╒───────────────╕
│MISSION SCRIPTS│
╘───────────────╛
+ One of the terrorists wasn't being counted as relevant in the street battle outside the hotel, and now the check only requires 2 kills instead of 3 to not be considered a worthless coward (the distinction the game makes is whether or not the player helped out, so it's ridiculous that you can kill 2-3 of the 6 bad guys and still have people saying "I'm sure you had other priorities" even though you've done well over what anybody else has; due to the dialogue I would personally like to remove the stipulation that you have to kill and not KO them as well, because it makes sense either way, but I don't know what other implications the flag might have, so I won't)
+ Remove reliance on "Unconscious" name check to see if those terrorists are actually dead, as was done in Mission 1.

╒──────╕
│SKILLS│
╘──────╛
+ Swimming skill renamed to "Athletics", and also affects walk/run speed (including while crouched, unlike the new speed aug), jumping height, and fall damage but to a lesser degree than the aug (See "Falling Damage Calculation"). To compensate a bit for the new Athletics skill, default ground speed is 95% what it used to be, default jumping velocity is 90%, and and falling damage increased a little (both in terms of safe falling distance and how much damage per unit of falling speed). This isn't a huge penalty, and "Trained" skill is more than enough to make up for it. The increase to falling damage affects the legs a little more than the torso. Proper feedback is probably necessary to balance this.

╒─────────────╕
│AUGMENTATIONS│
╘─────────────╛
+ The Speed aug now only provides 25% its usual bonus when you're crouched, as an indirect improvement to Run Silent and an incentive to get Athletics. The falling damage reduction is also calculated differently (see "Falling Damage Calculation").
+ Regeneration provides less health now, because previously you could regenerate an entire body part in 2.5 seconds, and were almost stupid not to take it. Now, instead of 5/15/25/40 health per second, it's 4/8/13/20. This should still be very nice to have.
+ The Targeting aug no longer affects melee weapons. Like me, you probably didn't even think it did, but it does. It makes little sense, and melee already has Combat Strength.
+ The Targeting aug also lets you look at bodies now. Why not, if you can look at crates?
+ The Targeting aug no longer dislays a health reading for invincible decorations (or corpses), and decorations that are both invincible and can't be highlighted can't be targeted at all.

╒──────────────╕
│FALLING DAMAGE│
╘──────────────╛
+ Athletics reduces falling damage by a flat amount (10 per level, max 30), similar to the old Speed Aug (was 15 per level, max 60). The Speed Aug now provides a percentage reduction instead (15% per level, max 60%), which is less powerful for short falls but potentially much more powerful for very long ones. Also, since flat damage reductions are doubled for torso damage (since all damage to the torso is doubled, so is any flat reduction to that damage before it's applied), the new Speed Aug is slightly less useful than the old one for keeping your torso healthy (it used to reduce torso damage by up to 120!). I did add a very small (2 per level, 8 max) flat damage reduction to the Speed Aug as well, just so it actually still matters for very short but still damaging falls. Some other rather minor tweaks were made to the formula as well, if you care to dive into the source.
+ I need feedback on this! Balancing it might take some effort.

╒───────╕
│WEAPONS│
╘───────╛
+ The Assault Rifle does 4 damage per shot (20 per burst) instead of 3 (15). This might not be enough to make it much better, but the 1/3 damage increase should at least help.
+ Regular minicrossbow darts do 10 damage instead of 15, which was worse than getting shot with the pistol.
+ The (regular) Sword oes 15 damage (one more than a pistol shot) instead of 10. It's a clumsy weapon that doesn't stay relevant for long anyway, so it deserves to do about as much damage as the pistol, at least. The range is also increased to that of the nanosword (it used to be even shorter-range than other melee weapons, including the baton/knife/prod).
+ The Dragon's Tooth Sword does 36 damage (18 damage times 2 hits) instead of 100 (20 times 5). Yes, this significantly changes the weapon, but I prefer its purpose as an interesting weapon and plot device to its purpose as a Jedi lawnmower that can smash open bank vaults. It's still a good weapon, but it's no longer completely ridiculous. To implement the damage change, a kludge in DeusExWeapon was needed to make the DTS hit 2 times instead of 5. Why the devs didn't make number of "slugs" a per-weapon variable is beyond me.
+ Throwing Knife pickup count changed from 5 to 15 and max number held from 25 to 50, since pickups are so rare.
+ Lowered the Stealth Pistol's accurate and maximum ranges (they were identical to the regular pistol), decreased firing speed (it's still significantly faster than the pistol), and increased damage from 8 to 10. It's still vaguely the same, but now weird powergamers on the Internet can't talk about its "DPS" with as much gusto.
+ Plasma bolts (from the rifle and the PS20) now do 50 damage each instead of 40, so both weapons do more damage. The visible but mechanically-meaningless "damage" property on those weapons has been changed to reflect reality.
+ The PS20's accuracy is now no longer 100%, but is still rather high.
+ Scramble grenades now work on human targets in addition to robots. Just kidding, that's dumb as hell.
+ All breakable scenery items (e.g. doors and breakable walls, NOT turrets and cameras or other decorations) now have a 33% damage reduction applied except from explosions and sabot rounds. This is prior to the damage threshold check, because busting open doors with a gun shouldn't work quite so well as weapons more expressly designed for the task.
+ Bullet spread is circular now instead of square. Yes, seriously, firing patterns were square. Previously, even with Shifter's fixes, if you were to fire a bunch of rounds at a wall, the pattern emerging would be square, not circular, because of how the vertical and horizontal angles were randomized separately. Now, the angle you're "off" by is evenly distributed, as is the direction.
+ Multi-shot projectile weapons (e.g. plasma rifle, basically nothing else) have a bit of minimum spread in single-player as well as multiplayer, similarly to multiplayer but not nearly as severe. This basically just means the plasma rifle's bursts won't all overlap at 100% accuracy, but the gameplay impact isn't very serious. You might not get as many triple-headshots with it now, I guess.
+ Projectile weapons (e.g. throwing knives, plasma rifle, GEP gun) previously used some bizarre accuracy calculation totally distinct from that used by regular guns, and Shifter never touched it. Now, for players, it uses the same circular spread as other weapons.
+ Multi-shot spread (for e.g. shotguns) is no longer tied to your weapon accuracy at all. Instead, after the game decides the direction you shoot in (within your normal angle of accuracy), the pellets cluster around that spot with a given accuracy of their own. No longer does having poor accuracy mean buckshot pellets spread out in a huge arc, nor can you snipe with the shotgun across the room and have all the pellets hit the exact same location at 100% accuracy.
+ Sabot rounds no longer have pellet spread like buckshot, because they're supposed to be a single, solid round. It's still technically firing five pellets, but practically speaking it doesn't matter because they all hit the same location.
+ Made the scope and laser wandering less predictable by slightly randomizing how often it changes speed/direction. The laser also wanders via a completely different method that hopefully feels much, much more natural than it does in Shifter (it doesn't really work as intended at all in the original game).
+ Ricochet noises only happen 33% of the time (as compared to 100% of the time in Deus Ex 2.0). I'd like to restrict bullet ricochet noises and sparks to "hard" textures, or otherwise prevent them from occurring on things like grass, but I'm not sure how to do that at the moment, so this is the best we have for now.
+ Firing a gun lowers your "standing still" accuracy bonus timer a bit, depending mostly on how strong the recoil is. Also, that timer doesn't increase while you're reloading, reloading decreases it by half, and you can't stack the timer as high. However, it decreases at 2/3 the former rate when you move.

╒───────────────────╕
│MISCELLANEOUS ITEMS│
╘───────────────────╛
+ You can put activated charged items back in your hand now. This is preferable now that they aren't single-use, because you might want to cycle to them to shut them off, or something like that.
+ Removed the usage of extra soda/candy textures implemented in Deus Ex 2.0. In my opinion, they look clearly worse than the ones used in the default game, and it's entirely possible that's why they weren't used. More importantly, their behavior when you have multiple kinds in your inventory is slightly buggy in my experience, so I'd rather leave them out entirely. I think Shifter made them work better, but I don't think the quality is worth the effort.

╒────────────────╕
│POINTLESS CHEATS│
╘────────────────╛
+ Added a new cheat command. Here's a hint: Think of the "Doom" comic, and things that are huge.
+ Also implemented some really stupid and mostly useless cheat codes based on the more popular quote-memes from the game. So far, they involve: The Renton situation, why JC can wear sunglasses at night, Russian sailors, explosive sabotage, and dancing businessmen in Paris. Those are your hints. Development note: To make one of those cheats work a little better, I added a check in ScriptedPawn to see if a dancing NPC actually has the dancing animation. Otherwise, the use the panic animation. Don't worry, this never affects the game except in bizarre scenarios like that, wherein it is hilarious.




╒─────────────────────────────────────────╕
│                                         │
│              KNOWN  ISSUES              │
│                                         │
╘─────────────────────────────────────────╛

* Sometimes the game might still have trouble clearing your inventory of certain items when starting a new game during play. I have no idea why, but it might be correlated with the use of weapon mods.
* As stated above, I need to find a way to stop bullet ricocheting/sparks on level textures that are soft, like grass.
* Some of these changes are probably not multiplayer-safe, because I'm not very clear on how all that works or what would be necessary to ensure that.
* I can't confirm that this is compatible with The Nameless Mod, at all, because I haven't played that before, so if you can confirm/deny, let me know.
* This almost certainly IS NOT COMPATIBLE WITH HDTP. In the future, I can probably implement Shifter's method of doing this.
* I did not implement Deus Ex Enhanced's special GUI scaling method, or its other changes that require DirectX 10, both because I'm not entirely sure how to merge those changes, and I'd rather keep the mod safe for older/lower-end computers and Windows XP.




╒─────────────────────────────────────────╕
│                                         │
│            FIXES FROM SHIFTER           │
│                                         │
╘─────────────────────────────────────────╛

I've incorporated the following Shifter fixes, none of which are mine (although my implementation might be different, especially where noted). The readme file for Shifter has been included in this package for reference, but much of it will not apply to this mod.

+ Charged pickups (HazMat suits, etc.) can be turned off and saved for later. Hazmat suits now have lower total charge to compensate a bit. Let me know if that's bad.
+ Improved Tech Goggles vision bonus to that of a lower-range Level 3/4 vision aug.
+ Power Recirculator is always active whenever it would decrease power consumption and inactive whenever it wouldn't, so the player doesn't have to do anything for it to work optimally.
+ Healing augmentation now only drains at an "idle" 10% pace when your health is full (fixed; see above).
+ You can toggle scope zoom even when the weapon isn't in the idle state. Unlike in Shifter, you can't remain zoomed in while reloading, although hitting the button will affect zoom status once reloading is done.
+ Difficulty above Easy penalizes how much time you get to disable/avoid planted bombs, but only gives you half the penalty as Shifter.
+ Code preventing NPCs from attempting (and failing) to lock on with GEP guns.
+ Glass can be broken by projectiles.
+ Used Shifter implementation of UC keypad fix, along with keypad class changes.
+ Fish have corpses.
+ Cats hunt/eat rats and birds. They don't have any real animations for attacking/eating, so it looks bad, but hey, it gives cats something to do. If someone gives me $150 I'll get them to chase laser dots too!
+ Animals check for animations in conversations before attempting to play them.
+ Moved murdered mechanic's body in Everett's helipad.
+ Paul Denton's inventory replaced with non-lethal weaponry for the first mission, so he doesn't start blasting apart NSF members with a plasma rifle after telling you to go easy on them.
+ Paul Denton conversation fix (location restriction so conversation won't start until you're actually next to him).
+ Made drug/drunkenness effect persistent across maps.
+ Air bubbles make ripples when they pop.
+ Carts roll more realistically, and will roll a bit upon landing. Improved upon the Shifter script, which resulted in somewhat strange/crude behavior, so they decelerate smoothly now while still feeling "clunky". Also optimized the script a bit.
+ Projectiles/bullets entering water have ripple/splash effects.
+ Flares last five minutes.
+ Fire extinguishers last four seconds (up from 3 by default and down from 5 in Shifter). Also fixed bug with Shifter's fire extinguisher timer.
+ Unconscious bodies and animal carcasses get names, and FamiliarName is used instead of ItemName for this (so some mission scripts don't break).
+ Gibbed NPCs have some of their velocity applied to their chunks (fixed so that it adds to their normal velocity instead of replacing it).
+ NPCs afraid of bodies will get afraid if fleshy chunks bump into them.
+ Patrol point and spawn point functions in missionscript.uc now function properly.
+ NPCs get a standing accuracy bonus like the player, but not as much (same as in Shifter).
+ Incorporated various, mostly small Shifter changes to DeusExWeapon.uc, and used most of Shifter's version of that file as the basis for many of my changes.
+ Weapon tracers move faster.
+ Added "cleanshot" console command (Screenshot without GUI/HUD, doesn't need cheats enabled).




╒─────────────────────────────────────────╕
│                                         │
│       FIXES FROM DEUS EX ENHANCED       │
│                                         │
╘─────────────────────────────────────────╛

I've incorporated the following Deus Ex Enhanced fixes, none of which are mine (although my implementation might be different, especially where noted). The readme file for Deus Ex Enhanced has been included in this package for reference, but much of it will not apply to this mod.

+ Aspect ratio fixes for weapon accuracy/targeting squares (this ismy own implementation; see my bugfixes list).
+ Finer control over brightness in-game.



╒─────────────────────────────────────────╕
│                                         │
│         FIXES FROM DEUS EX 2.0          │
│                                         │
╘─────────────────────────────────────────╛

Also included are all Deus Ex 2.0 fixes as of the Google Code repository in July 2011, none of these are mine.

Since Deus Ex 2.0 was used as the reference implementation from which I started, I have included in this package a verbatim copy of that mod's Fixes.txt file; note that some of those changes may be affected by my changes stated above, and I can't vouch for that file's completeness or accuracy. "+" indicates a fix, "/" indicates a partial fix, "-" indicates something that wasn't fixed, and "?" indicates something they didn't fix yet and were unsure about, because consensus had not been established concerning whether or not it should be.