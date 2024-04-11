::MSU.HooksMod.hook("scripts/items/helmets/named/named_helmet", function(q) {
	q.getFieldsForRandomize <- function()
	{
		return [
			"Condition",
			"ConditionMax",
			"StaminaModifier"
		];
	}
});

::MSU.HooksMod.hookTree("scripts/items/helmets/named/named_helmet", function(q) {
	::MSU.HooksHelper.addBaseItemToNamedItem(q);
});
