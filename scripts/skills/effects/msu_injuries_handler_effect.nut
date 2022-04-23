this.msu_injuries_handler_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.msu_injuries_handler";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (!_skill.isAttack())
		{
			return;
		}

		_hitInfo.DamageType = _skill.getDamageType().roll();

		// Can also pull the Damage Weight of that Damage Type in this skill and do cool things with
		// that e.g. make some perks which only work if the used skill has 60% or more Blunt damage
		// and here we can pull the Damage Weight of the Damage Type that was rolled and use it!
		
		_hitInfo.DamageTypeProbability = _skill.getDamageType().getProbability(_hitInfo.DamageType);

		if (::MSU.isIn(_targetEntity.m, "IsHeadless", true) && _targetEntity.m.IsHeadless)
		{
			_hitInfo.BodyPart = ::Const.BodyPart.Body;
		}

		local injuries = ::Const.Damage.getApplicableInjuries(_hitInfo.DamageType, _hitInfo.BodyPart, _targetEntity);

		if (injuries.len() > 0)
		{
			_hitInfo.Injuries = injuries;
		}
	}
});
