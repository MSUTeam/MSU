::mods_hookExactClass("entity/tactical/player", function(o) {
	local updateLevel = o.updateLevel;
	o.updateLevel = function()
	{
		while (this.m.Level < ::Const.LevelXP.len() && this.m.XP >= ::Const.LevelXP[this.m.Level])
		{
			++this.m.Level;
			++this.m.LevelUps;

			if (this.m.Level <= ::Const.XP.MaxLevelWithPerkpoints)
			{
				++this.m.PerkPoints;
			}

			if ((this.m.Level == 11 || this.m.Level == 7 && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && this.getBackground().getID() == "background.slave") && this.m.Skills.hasSkill("perk.student"))
			{
				++this.m.PerkPoints;
			}

			this.m.Skills.onUpdateLevel();

			if (this.m.Level == 11)
			{
				this.updateAchievement("OldAndWise", 1, 1);
			}

			if (this.m.Level == 11 && this.m.Skills.hasSkill("trait.player"))
			{
				this.updateAchievement("TooStubbornToDie", 1, 1);
			}
		}
	}
});
