::MSU.HooksMod.hook("scripts/items/shields/named/named_shield", function(q) {
	::MSU.HooksHelper.addBaseItemToNamedItem(q);

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

::MSU.QueueBucket.VeryLate.push(function() {
	::MSU.HooksMod.hook("scripts/items/shields/named/named_shield", function(q) {
		::MSU.HooksHelper.addBaseItemToNamedItemVeryLate(q);
	});
});
