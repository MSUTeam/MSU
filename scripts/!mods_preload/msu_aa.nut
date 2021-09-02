local gt = this.getroottable();

::mods_registerMod("mod_MSU", 1.0, "Modding Standards and Utils 0.6.3");

gt.Const.MSU <- {};

gt.MSU <- {};

::mods_queue(null, null, function()
{
	gt.Const.FactionRelation <- {
		Any = 0,
		SameFaction = 1,
		Allied = 2,
		Enemy = 3
	}

	gt.Const.MSU.modInjuries();
	delete gt.Const.MSU.modInjuries;
	gt.Const.MSU.setupDamageTypeSystem();
	delete gt.Const.MSU.setupDamageTypeSystem;
	gt.Const.MSU.setupTileUtils();
	delete gt.Const.MSU.setupTileUtils;
	gt.MSU.setupLoggingUtils();
	delete gt.MSU.setupLoggingUtils;
	gt.MSU.setupStringUtils();
	delete gt.MSU.setupStringUtils;

	gt.Const.MSU.modActor();
	delete gt.Const.MSU.modActor;
	gt.Const.MSU.modSkillContainer();
	delete gt.Const.MSU.modSkillContainer;
	gt.Const.MSU.modSkill();
	delete gt.Const.MSU.modSkill;
	gt.Const.MSU.modWeapon();
	delete gt.Const.MSU.modWeapon;
	
});
