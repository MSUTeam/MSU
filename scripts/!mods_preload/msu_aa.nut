local gt = this.getroottable();

local modID = "mod_MSU";
::mods_registerMod(modID, 1.0, "Modding Standards and Utils 0.6.0");

gt.Const.MSU <- {};

::mods_queue(modID, null, function()
{
	gt.Const.FactionRelation <- {
		Any = 0,
		SameFaction = 1,
		Allied = 2,
		Enemy = 3
	}

	gt.Const.MSU.modInjuries();
	gt.Const.MSU.setupDamageTypeSystem();

	gt.Const.MSU.modActor();
	gt.Const.MSU.modSkillContainer();
	gt.Const.MSU.modSkill();
	gt.Const.MSU.modWeapon();
});
