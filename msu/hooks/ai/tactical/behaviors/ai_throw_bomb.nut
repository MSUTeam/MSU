::mods_hookExactClass("ai/tactical/behaviors/ai_throw_bomb", function(o) {
	local onExecute = o.onExecute;
	o.onExecute = function( _entity )
	{
		local itemsBefore = _entity.getItems().getAllItems();
		local ret = onExecute(_entity);
		if (ret && this.m.Skill == null)
		{
			this.getItems().payForAction(_entity.getItems().getAllItems().filter(@(idx, item) itemsBefore.find(item) == null));
		}
		return ret;
	}
});
