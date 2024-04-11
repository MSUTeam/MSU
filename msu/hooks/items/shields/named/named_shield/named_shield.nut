::MSU.HooksHelper.addBaseItemToNamedItem("scripts/items/shields/named/named_shield");

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
