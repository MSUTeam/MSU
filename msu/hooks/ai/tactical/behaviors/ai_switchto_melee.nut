::mods_hookExactClass("ai/tactical/behaviors/ai_switchto_melee", function(o) {
	local onExecute = o.onExecute;
	o.onExecute = function( _entity )
	{
		local items = this.m.IsNegatingDisarm ? [_entity.getMainhandItem()] : [_entity.getMainhandItem(), this.m.WeaponToEquip];
		local ret = onExecute(_entity);
		if (ret) _entity.getItems().payForAction(items);
		return ret;
	}
});
