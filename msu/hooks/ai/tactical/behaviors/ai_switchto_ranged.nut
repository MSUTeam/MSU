::mods_hookExactClass("ai/tactical/behaviors/ai_switchto_ranged", function(o) {
	local onExecute = o.onExecute;
	o.onExecute = function( _entity )
	{
		local items = [_entity.getMainhandItem(), this.m.WeaponToEquip];
		local ret = onExecute(_entity);
		if (ret) _entity.getItems().payForAction(items);
		return ret;
	}
});
