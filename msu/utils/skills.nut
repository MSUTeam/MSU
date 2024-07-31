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
		::MSU.MH.hook("scripts/skills/skill", function(q) {
			q[_name] <- _function == null ? function() {} : _function;
		});

		::MSU.MH.hook("scripts/skills/skill_container", function(q) {
			if (_function == null || _function.getinfos().parameters.len() == 1) // for parameterless functions it should be a len 1 array containing "this"
			{
				q[_name] <- @() this.callSkillsFunction(_name, null, _update, _aliveOnly);
			}
			else
			{
				local info = _function.getinfos();
				foreach (p in info.defparams)
				{
					local t = typeof p;
					if (t == "array" || t == "table" || t == "instance" || t == "class")
					{
						::logError("addEvent cannot be used to add functions with reference type defparams");
						throw ::MSU.Exception.InvalidValue(t);
					}
				}
				local declarationParams = clone info.parameters; // used in compilestring for function declaration
				declarationParams.remove(0) // remove "this"
				local wrappedParams = clone declarationParams; // used in compilestring to call skills function

				if (declarationParams[declarationParams.len() - 1] == "...")
				{
					declarationParams.remove(declarationParams.len() - 2); // remove "vargv"
					wrappedParams.remove(wrappedParams.len() - 1); // remove "..."
				}
				else // function with vargv cannot have defparams
				{
					foreach (i, defparam in info.defparams)
					{
						if (defparam == null)
							defparam = "null";

						declarationParams[declarationParams.len() - info.defparams.len() + i] += " = " + defparam;
					}
				}

				q[_name] <- compilestring(format("return function (%s) { return this.callSkillsFunction(\"%s\", [%s], %s, %s); }", declarationParams.reduce(@(a, b) a + ", " + b), _name, wrappedParams.reduce(@(a, b) a + ", " + b), _update + "", _aliveOnly + ""))();
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
