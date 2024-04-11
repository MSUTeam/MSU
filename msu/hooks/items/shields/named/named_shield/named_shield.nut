::MSU.HooksMod.hook("scripts/items/shields/named/named_shield", function(q) {
	q.getFieldsForRandomize <- function()
	{
		return [
			"Condition",
			"ConditionMax",
			"MeleeDefense",
			"RangedDefense",
			"StaminaModifier"
		];
	}
});

::MSU.HooksMod.hookTree("scripts/items/shields/named/named_shield", function(q) {
	::MSU.HooksHelper.addBaseItemToNamedItem(q);
});
