local gt = this.getroottable();

::mods_registerMod("mod_MSU", 1.0, "Modding Standards and Utils 0.6.11");

gt.MSU <- {};

::mods_queue(null, null, function()
{
	gt.Const.FactionRelation <- {
		Any = 0,
		SameFaction = 1,
		Allied = 2,
		Enemy = 3
	}

	gt.MSU.modInjuries();
	delete gt.MSU.modInjuries;
	gt.MSU.setupDamageTypeSystem();
	delete gt.MSU.setupDamageTypeSystem;
	gt.MSU.setupTileUtils();
	delete gt.MSU.setupTileUtils;
	gt.MSU.setupLoggingUtils();
	delete gt.MSU.setupLoggingUtils;
	gt.MSU.setupStringUtils();
	delete gt.MSU.setupStringUtils;
	gt.MSU.setupMathUtils();
	delete gt.MSU.setupMathUtils;

	gt.MSU.modItemContainer();
	delete gt.MSU.modItemContainer;

	gt.MSU.modSkills();
	delete gt.MSU.modSkills;

	gt.MSU.modAssetManager();
	delete gt.MSU.modAssetManager;

	gt.MSU.modActor();
	delete gt.MSU.modActor;
	gt.MSU.modSkillContainer();
	delete gt.MSU.modSkillContainer;
	gt.MSU.modSkill();
	delete gt.MSU.modSkill;
	gt.MSU.modWeapon();
	delete gt.MSU.modWeapon;
	gt.MSU.modWeapons();
	delete gt.MSU.modWeapons;
});
