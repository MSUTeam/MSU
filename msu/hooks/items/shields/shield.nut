::MSU.MH.hook("scripts/items/shields/shield", function(q) {
	q.addSkill = @(__original) function( _skill )
	{
		__original(_skill);
		if (_skill.isType(::Const.SkillType.Active))
		{
			// We reset the FatigueCost so any modifications to it from other skills is reverted
			// the latter part is a copy of the vanilla code applying FatigueOnSkillUse
			// which we then include in the skill's base fatigue cost
			_skill.resetField("FatigueCost");
			local fatigueOnSkillUse = this.getContainer().getActor().getCurrentProperties().IsProficientWithHeavyWeapons && this.m.FatigueOnSkillUse > 0 ? 0 : this.m.FatigueOnSkillUse;
			local fatCost = ::Math.max(0, _skill.getFatigueCostRaw() + fatigueOnSkillUse);
			_skill.setFatigueCost(::Math.max(0, fatCost));
			_skill.setBaseValue("FatigueCost", fatCost);
			this.getContainer().getActor().getSkills().update();
		}
	}
});
