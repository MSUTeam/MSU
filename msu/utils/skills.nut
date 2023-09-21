::MSU.Skills <- {
	PreviewApplicableFunctions = [
		"getActionPointCost",
		"getFatigueCost"
	],
	QueuedPreviewChanges = {},
	SoftResetFields = [
		"ActionPointCost",
		"FatigueCost",
		"FatigueCostMult",
		"MinRange",
		"MaxRange"
	],

	function addEvent( _name, _function = null, _update = true, _aliveOnly = false )
	{
		::MSU.HooksMod.hook("scripts/skills/skill", function(q) {
			q[_name] <- _function == null ? function() {} : _function;
		});

		::MSU.HooksMod.hook("scripts/skills/skill_container", function(q) {
			if (_function == null || _function.getinfos().parameters.len() == 0)
			{
				q[_name] <- @() this.callSkillsFunction(_name, null, _update, _aliveOnly);
			}
			else
			{
				local info = _function.getinfos();
				info.parameters.remove(0); // remove "this"
				local params = clone info.parameters;
				foreach (i, defparam in info.defparams)
				{
					params[params.len() - info.defparams.len() + i] += " = " + defparam;
				}

				q[_name] <- compilestring("return function (" + params.reduce(@(a, b) a + ", " + b) + ") { return this.callSkillsFunction(" + _name + ", [" + info.parameters.reduce(@(a, b) a + ", " + b) + "], " + _update + ", " + _aliveOnly + "); }")();
			}
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
	function modifyPreview( _caller, _targetSkill, _field, _newChange, _multiplicative )
	{
		if (!(_caller in this.QueuedPreviewChanges)) this.QueuedPreviewChanges[_caller] <- [];
		this.QueuedPreviewChanges[_caller].push({
			TargetSkill = _targetSkill,
			Field = _field,
			ValueBefore = 0,
			CurrChange = _multiplicative ? 1 : 0,
			NewChange = _newChange,
			Multiplicative = _multiplicative
		});
	}
}
