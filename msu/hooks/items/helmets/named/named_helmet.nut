::MSU.HooksMod.hook("scripts/items/helmets/named/named_helmet", function(q) {
	::MSU.HooksHelper.addBaseItemToNamedItem(q);

	q.getFieldsForRandomize <- function()
	{
		return [
			"Condition",
			"ConditionMax",
			"StaminaModifier"
		];
	}
});

::MSU.QueueBucket.VeryLate.push(function() {
	::MSU.HooksMod.hook("scripts/items/helmets/named/named_helmet", function(q) {
		::MSU.HooksHelper.addBaseItemToNamedItemVeryLate(q);
	});
});
