::MSU.HooksHelper.addBaseItemToNamedItem("scripts/items/helmets/named/named_helmet");

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
