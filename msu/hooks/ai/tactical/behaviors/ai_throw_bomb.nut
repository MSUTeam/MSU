::mods_hookExactClass("ai/tactical/behaviors/ai_throw_bomb", function(o) {
	local onExecute = o.onExecute;
	o.onExecute = function( _entity )
	{
		local ret = onExecute(_entity);
		if (ret && this.m.Skill == null)
		{
			_entity.getItems().payForAction([_entity.getOffhandItem()]);
		}
		return ret;
	}
});
