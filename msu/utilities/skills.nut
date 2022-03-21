::MSU.Skills <- {
	EventsToAdd = [],

	function addEvent( _name, _function = null, _update = false, _aliveOnly = false )
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
}
