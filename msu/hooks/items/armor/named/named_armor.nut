::MSU.HooksHelper.addBaseItemToNamedItem("scripts/items/armor/named/named_armor");

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
