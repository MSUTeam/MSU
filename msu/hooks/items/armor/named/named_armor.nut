::MSU.HooksHelper.addBaseItemToNamedItem("scripts/items/armor/named/named_armor");

::MSU.MH.hook("scripts/items/armor/named/named_armor", function(q) {
	q.getBaseItemFields = @() function()
	{
		return [
			// The following fields are used in vanilla randomizeValues()
			"Condition",
			"ConditionMax",
			"StaminaModifier",

			// The following fields aren't used in vanilla randomizeValues() but we copy them
			// for the sake of completion so that named items can be based on base items properly
			// -- No such fields for this particular named item type --
		];
	}
});
