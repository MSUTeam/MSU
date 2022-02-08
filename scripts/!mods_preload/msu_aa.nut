local gt = this.getroottable();
local MSUModName = "mod_MSU"
::mods_registerMod(MSUModName, 1.0, "Modding Standards and Utils 0.6.27");

gt.MSU <- {};
gt.MSU.MSUModName <- MSUModName;


::mods_queue(null, null, function()
{
	
	gt.MSU.setupUtils();
	delete gt.MSU.setupUtils;
	gt.MSU.setupDebuggingUtils();
	delete gt.MSU.setupDebuggingUtils;
	gt.MSU.defineClasses();
	delete gt.MSU.defineClasses;
	gt.MSU.setupUI();
	delete gt.MSU.setupUI;
	gt.MSU.setupSystems();
	delete gt.MSU.setupSystems;

	gt.MSU.setupModRegistry();
	delete gt.MSU.setupModRegistry;
	gt.MSU.setupCustomKeybinds();
	delete gt.MSU.setupCustomKeybinds;
	gt.MSU.setupSettingsSystem();
	delete gt.MSU.setupSettingsSystem;

	gt.MSU.defineThrowables();
	delete gt.MSU.defineThrowables;


	gt.MSU.modInjuries();
	delete gt.MSU.modInjuries;
	gt.MSU.setupDamageTypeSystem();
	delete gt.MSU.setupDamageTypeSystem;
	gt.MSU.setupTileUtils();
	delete gt.MSU.setupTileUtils;	
	gt.MSU.setupSaveVersionSystem();
	delete gt.MSU.setupSaveVersionSystem;


	gt.MSU.modItemContainer();
	delete gt.MSU.modItemContainer;

	gt.MSU.modSkills();
	delete gt.MSU.modSkills;

	gt.MSU.modAssetManager();
	delete gt.MSU.modAssetManager;
	gt.MSU.modTacticalEntityManager();
	delete gt.MSU.modTacticalEntityManager;

	gt.MSU.modActor();
	delete gt.MSU.modActor;
	gt.MSU.modPlayer();
	delete gt.MSU.modPlayer;
	gt.MSU.modSkillContainer();
	delete gt.MSU.modSkillContainer;
	gt.MSU.modSkill();
	delete gt.MSU.modSkill;
	gt.MSU.modItem();
	delete gt.MSU.modItem;
	gt.MSU.modWeapon();
	delete gt.MSU.modWeapon;
	gt.MSU.modWeapons();
	delete gt.MSU.modWeapons;

	gt.MSU.modTooltipEvents();
	delete gt.MSU.modTooltipEvents;

	gt.MSU.modAI();
	delete gt.MSU.modAI;	

	gt.MSU.modMisc();
	delete gt.MSU.modMisc;

	gt.MSU.modParty();
	delete gt.MSU.modParty;
	gt.MSU.modPlayerParty();
	delete gt.MSU.modPlayerParty;
	gt.MSU.modOrigins();
	delete gt.MSU.modOrigins;
});
