::MSU.HooksHelper.addBaseItemToNamedItem("scripts/items/armor/named/named_armor");

::MSU.HooksMod.hook("scripts/items/armor/named/named_armor", function(q) {
	q.m.BaseItemFields = [
		"Condition",
		"ConditionMax",
		"StaminaModifier"
	];
});
