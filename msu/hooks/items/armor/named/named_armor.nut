::MSU.HooksMod.hook("scripts/items/armor/named/named_armor", function(q) {
	q.m.BaseItemScript <- null;

	q.getFieldsForRandomize <- function()
	{
		return [
			"Condition",
			"ConditionMax",
			"StaminaModifier"
		];
	}

	q.setValuesBeforeRandomize <- function()
	{
		if (this.m.BaseItemScript == null)
			return;

		local baseM = ::new(this.m.BaseItemScript).m;
		foreach (field in this.getFieldsForRandomize())
		{
			this.m[field] = baseM[field];
		}
	}

	q.randomizeValues = @(__original) function()
	{
		this.setValuesBeforeRandomize();
		return __original();
	}
});
