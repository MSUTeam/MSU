::MSU.HooksHelper.addBaseItemToNamedItem("scripts/items/shields/named/named_shield");

::MSU.HooksMod.hook("scripts/items/shields/named/named_shield", function(q) {
	q.m.BaseItemFields = [
		"Condition",
		"ConditionMax",
		"MeleeDefense",
		"RangedDefense",
		"StaminaModifier"
	];
});
