::MSU.AI <- {
	BehaviorIDToScriptMap = {}, // Is populated during root_state.onInit function

	function getBehaviorScriptFromID( _id )
	{
		if (this.m.BehaviorIDToScriptMap.len() == 0)
		{
			throw "This function cannot be used before the root_state.onInit function has run";
		}
		if (!(_id in this.m.BehaviorIDToScriptMap))
		{
			::logError("Invalid behavior id '" + _id + "' and/or the associated script file is not located in \'scripts/ai/tactical/behaviors\'");
			throw ::MSU.Exception.KeyNotFound(_id);
		}

		return this.m.BehaviorIDToScriptMap[_id];
	}

	function addBehavior ( _id, _name, _order, _score )
	{
		if (_id in ::Const.AI.Behavior.ID) throw ::MSU.Exception.DuplicateKey(_id);

		::Const.AI.Behavior.ID[_id] <- ::Const.AI.Behavior.ID.COUNT;
		::Const.AI.Behavior.ID.COUNT += 1;

		::Const.AI.Behavior.Name.push(_name);
		::Const.AI.Behavior.Order[_id] <- _order;
		::Const.AI.Behavior.Score[_id] <- _score;
	}
}
