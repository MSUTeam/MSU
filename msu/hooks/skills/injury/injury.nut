::MSU.HooksMod.hookTree("scripts/skills/injury/injury", function(q) {
	if (q.ClassName == "injury")
		return;

	q.onUpdate = @(__original) function( _properties )
	{
		local isAffectedByInjuries = _properties.IsAffectedByInjuries;		
		_properties.IsAffectedByInjuries = _properties.CanReceiveTemporaryInjuries;

		__original(_properties);

		_properties.IsAffectedByInjuries = isAffectedByInjuries;
	}
});
