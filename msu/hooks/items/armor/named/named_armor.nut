::MSU.HooksMod.hook("scripts/items/armor/named/named_armor", function(q) {
	q.getFieldsForRandomize <- function()
	{
		return [
			"Condition",
			"ConditionMax",
			"StaminaModifier"
		];
	}
});

::MSU.HooksMod.hookTree("scripts/items/armor/named/named_armor", function(q) {
	::MSU.HooksHelper.addBaseItemToNamedItem(q);
});
