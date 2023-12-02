::MSU.HooksMod.hook("scripts/items/helmets/named/named_helmet", function(q) {
	q.m.BaseItemScript <- null;

	q.getValuesForRandomize <- function()
	{
		if (this.m.BaseItemScript == null)
			return {};

		local baseItem = ::new(this.m.BaseItemScript);
		return {
			Condition = baseItem.m.Condition,
			ConditionMax = baseItem.m.ConditionMax,
			StaminaModifier = baseItem.m.StaminaModifier
		};
	}

	q.setValuesBeforeRandomize <- function( _values )
	{
		foreach (key, value in _values)
		{
			this.m[key] = value;
		}
	}

	q.randomizeValues = @(__original) function()
	{
		this.setValuesBeforeRandomize(this.getValuesForRandomize());
		return __original();
	}
});
