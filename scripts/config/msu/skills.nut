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
