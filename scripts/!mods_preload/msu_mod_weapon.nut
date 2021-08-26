local gt = this.getroottable();

gt.Const.MSU.modWeapon <- function ()
{		
	::mods_hookExactClass("items/weapons/weapon", function(o) {		
		local addSkill = o.addSkill;
		o.addSkill = function(_skill)
		{
			if (_skill.isType(this.Const.SkillType.Active))
			{
				_skill.setFatigueCost(this.Math.max(0, _skill.getFatigueCostRaw() + this.m.FatigueOnSkillUse));
			}
			
			addSkill(_skill);
		}
	});
}
