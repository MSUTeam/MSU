::mods_hookNewObject("ui/global/data_helper", function (o) {

	local oldAddCharacterToUIData = o.addCharacterToUIData;
	o.addCharacterToUIData = function( _entity, _target )
	{
		oldAddCharacterToUIData( _entity, _target );
		_target.paragonLevel <- _entity.m.ParagonLevel;
	}
});
