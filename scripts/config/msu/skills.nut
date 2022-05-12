::MSU.Skills <- {
	EventsToAdd = [],
	PreviewApplicableFunctions = [
		"getActionPointCost",
		"getFatigueCost"
	],
	SoftResetFields = [
		"ActionPointCost",
		"FatigueCost",
		"FatigueCostMult",
		"MinRange",
		"MaxRange"
	],
	AutoTooltipProperties = {
		MeleeSkill = "ui/icons/melee_skill.png",
		MeleeSkillMult = "ui/icons/melee_skill.png",
		RangedSkill = "ui/icons/ranged_skill.png",
		RangedSkillMult = "ui/icons/ranged_skill.png",
		MeleeDefense = "ui/icons/melee_defense.png",
		MeleeDefenseMult = "ui/icons/melee_defense.png",
		RangedDefense  = "ui/icons/ranged_defense.png",
		RangedDefenseMult =  = "ui/icons/ranged_defense.png",
		Bravery =  = "ui/icons/bravery.png",
		BraveryMult = "ui/icons/bravery.png",
		Initiative = "ui/icons/initiative.png",
		InitiativeMult = "ui/icons/initiative.png",
		Stamina = "ui/icons/fatigue.png",
		StaminaMult = "ui/icons/fatigue.png",
	},

	function addEvent( _name, _function = null, _update = true, _aliveOnly = false )
	{
		this.EventsToAdd.push({
			Name = _name,
			Update = _update,
			AliveOnly = _aliveOnly
		});

		::mods_hookBaseClass("skills/skill", function(o) {
			o = o[o.SuperName];
			o[_name] <- _function == null ? function() {} : _function;
		});
	}

	function addPreviewApplicableFunction( _name )
	{
		::MSU.requireString(_name);
		if (this.PreviewApplicableFunctions.find(_name) == null) this.PreviewApplicableFunctions.push(_name);
	}

	function addToSoftReset( _field )
	{
		if (this.SoftResetFields.find(_field) == null) this.SoftResetFields.push(_field);
	}

	function removeFromSoftReset( _field )
	{
		local idx = this.SoftResetFields.find(_field);
		if (idx != null) this.SoftResetFields.remove(idx); 
	}

	// Private
	function modifyPreview( _sourceTable, _previewTable, _field, _currChange, _newChange, _multiplicative )
	{
		_previewTable[_field] <- _sourceTable[_field];

		if (_multiplicative)
		{
			_previewTable[_field] /= _currChange;
			_previewTable[_field] *= _newChange;
		}
		else if (typeof _newChange == "boolean")
		{
			_previewTable[_field] = _newChange;
		}
		else
		{
			_previewTable[_field] -= _currChange;
			_previewTable[_field] += _newChange;
		}
	}
}
